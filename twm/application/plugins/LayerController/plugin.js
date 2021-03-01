class LayerController {
	
	/**
	 * Function: constructor
	 * @param () none
	 * @returns () nothing
	 * Function that initializes the class
	 */
	constructor() {
		this.name = "LayerController";
		this.version = 1.0;
		this.author = "Volker Schunicht";
		this.pcfg = getPluginConfig(this.name);
		this.tabName = (this.pcfg.tabName) ? this.pcfg.tabName : "Layers";
		this.tabContentFile = "application/plugins/LayerController/tab-content.html";
		this.layerEditorContentFile = "application/plugins/LayerController/layer-editor.html"
		this.layerDownloaderContentFile = "application/plugins/LayerController/downloader.html"
		this.tabNav; // jQuery element
		this.tabContent // jQuery element
		this.searchTimer;
		this.getCapabilitiesCache = [];
		this.filteredLayerStore = [];
		this.maxCacheAttempts = 3;
		this.addPlugin();
	}
	
	/**
	 * Function: cacheGetCapabilities
	 * @param () none
	 * @returns () nothing
	 * Function that caches the 
	 */
	cacheGetCapabilities() {		
		// Show spinner if it's not already running
		var spinner = new Spinner(app.spinnerOptionsMedium).spin($("#lc-matching-layers-ig")[0]);
		
		// Setup misc variables
		var additionalSourceCompleteCounter = 0;
		
		// Define aggregator function
		var aggregator = function(source, gcJson) {
			additionalSourceCompleteCounter++;
			
			// Add capabilites result to runtime array
			if (gcJson)	app.plugins.LayerController.getCapabilitiesCache[source.url] = gcJson; 
			
			// Add timestamped result to local storage (if available)
			if (gcJson && lsIsAvailable) lsStoreItem("lc-gc-cache-"+md5(source.url), {timestamp:Date.now(), data:gcJson}); 

			// Kill spinner if done
			if (additionalSourceCompleteCounter >= app.plugins.LayerController.pcfg.additionalSources.length) spinner.stop();
		}
		
		// Loop through the configured sources
		$.each(app.plugins.LayerController.pcfg.additionalSources, function(index, source) {

			// Used recent cached local storage version (if available) to populate runtime array (i.e. less than 48 hours old
			if (lsIsAvailable) {
				var cachedCapability = lsRetrieveObject("lc-gc-cache-"+md5(source.url));
				if (cachedCapability) {
					var cacheAge = Date.now() - cachedCapability.timestamp;
					if (cacheAge < 1000 * 60 * 60 * 48) {
						logger("INFO", app.plugins.LayerController.name + ": Using cached GetCapabilities version of "+ source.url + " ("+convertDuration(cacheAge)+" old)");
						aggregator(source, cachedCapability.data);
					}
				}
			}

			// Only perform the GetCapabilities request if it does not already exist
			if (typeof app.plugins.LayerController.getCapabilitiesCache[source.url] === "undefined") {
				// Issue GetCapabilities request
				$.ajax({
					type: "GET",
					data: {
						SERVICE: "WMS",
						VERSION: "1.3.0",
						REQUEST: "GetCapabilities"
					},
					dataType: "xml",
					url: source.url
				})
				
				// Handle success
				.done(function(xml) {
					var parser = new ol.format.WMSCapabilities();
					var gcJson = parser.read(xml);
					if (gcJson.Capability) {
						logger("INFO", app.plugins.LayerController.name + ": Retrieved live GetCapabilities version of " + source.url);
						aggregator(source, gcJson);
					} else {
						aggregator(source, null);
					}
				})
				
				// Handle failure
				.fail(function(jqXHR, textStatus){
					logger("ERROR", app.plugins.LayerController.name + ": Error getting GetCapabilities from " + source.url + " " + textStatus);
					aggregator(source, null);
				});
			}
		});
	}
	
	/**
	 * Function: toggleLayerVisibility
	 * @param (sting) visible (true/false)
	 * @param (integer) layerId (ol_uid)
	 * @returns () nothing
	 * Function that toggles a layer's visibility
	 */
	toggleLayerVisibility(visible, layerId) {
		$.each(app.map.getLayers().getArray(), function(index, layer) {
			if (layer.get("type") != "base") {
				if (ol.util.getUid(layer) == layerId) { 
					layer.setVisible(visible);
					rememberState();
				}
			}
		});
	}
	
	/**
	 * Function: switchBaseMap
	 * @param (integer) layerId (ol_uid)
	 * @returns () nothing
	 * Function that switches which basemap is turned on
	 */
	switchBaseMap(layerId) {
		$.each(app.map.getLayers().getArray(), function(index, layer) {
			if (layer.get("type") == "base") {
				if (ol.util.getUid(layer) == layerId) { 
					layer.setVisible(true);
				} else {
					layer.setVisible(false);
				}
				rememberState();
			}
		});
	}
	
	/**
	 * Function: showOverlayLegend
	 * @param (integer) layerId (ol_uid)
	 * @returns () nothing
	 * Function that switches which basemap is turned on
	 */
	showOverlayLegend(layerId) {
		// Toggle legend visibility for this layer
		if ($("#lc-legend-div-" + layerId).css("display") == "none") {
			$("#lc-legend-div-" + layerId).show();
		} else {
			$("#lc-legend-div-" + layerId).hide();
		}
	}
	
	/**
	 * Function: openModifyOverlayDialog
	 * @param (integer) layerId (ol_uid)
	 * @returns () nothing
	 * Function that ...
	 */
	openModifyOverlayDialog(layerId) {
		// Get the referenced layer
		var subjectLayer;
		$.each(app.map.getLayers().getArray(), function(index, layer) {
			if (ol.util.getUid(layer) == layerId) { 
				subjectLayer = layer;
			} 
		});
		
		// Get layer details
		var title = subjectLayer.get("title");
		var opacity = subjectLayer.get("opacity");

		// Load the form
		$.ajax({
			type: "GET",
			url: app.plugins.LayerController.layerEditorContentFile
		}).done(function(response) {
			// Get the form from the response
			var lForm = $(response);
			
			// Setup the layer opacity control
			lForm.find("#lc-overlay-transparency").val((1 - opacity));

			// Setup the layer filter control (WMS only)
			if (subjectLayer.get("attributes")) {
				$.each(subjectLayer.get("attributes"), function(index, attribute) {
					// Define default field display name and whether to show it
					var fieldName = attribute.name;
					var showField = false;
					
					// If this layer has configured fields, respect their field name transforms and visibility
					if (subjectLayer.get("fields")) {
						$.each(subjectLayer.get("fields"), function(index2, configuredField) {
							if (configuredField.name == attribute.name) {
								if (typeof configuredField.nameTransform === "function") {
									if (configuredField.nameTransform() !== false) fieldName = configuredField.nameTransform();
									showField = true;
								}
								if (configuredField.appendToField) {
									fieldName = attribute.name;
									showField = true;
								}
							} 
						});
					
					// Layer has no field configuration, show field by default
					} else {
						showField = true;	
					}
					
					// Hide field if its of type geometry
					if (attribute.type.startsWith("gml:")) showField = false;
					
					// Add the field as an option
					if (showField) {
						lForm.find("#lc-overlay-filter-field").append("<option value='"+attribute.name+"'>"+fieldName+"</option>");
					}					
					
				});
				lForm.find("#lc-overlay-filter-field").val(subjectLayer.get("filterField"));
				lForm.find("#lc-overlay-filter-operator").val(subjectLayer.get("filterOperator"));
				lForm.find("#lc-overlay-filter-value").val(subjectLayer.get("filterValue"));
				lForm.find("#lc-overlay-filter-clear").click(function(){
					$("#lc-overlay-filter-field").val("");
					$("#lc-overlay-filter-operator").val("");
					$("#lc-overlay-filter-value").val("");
				});
				lForm.find("#lc-overlay-filter").show();
			}

			// Show stylizer dialog (CAN DO MORE HERE IN THE FUTURE.....)
			bootbox.dialog({
				title: title,
				message: lForm,
				buttons: {
					cancel: {
						label: "Cancel",
						className: "btn-secondary"
					},
					ok: {
						label: "OK",
						className: "btn-primary",
						callback: function(result){
							// Get and set opacity
							var newTransparency = $("#lc-overlay-transparency").val();
							subjectLayer.setOpacity((1 - newTransparency));
							
							// Get and set CQL filter
							if (subjectLayer.get("attributes")) {
								var filterField = $("#lc-overlay-filter-field").val();
								var filterOperator = $("#lc-overlay-filter-operator").val();
								var filterValue = $("#lc-overlay-filter-value").val();
								var userFilter = null;
								if (filterField && filterOperator && filterValue) {
									var valuePrefix = "";
									var valuePostfix = "";
									$.each(subjectLayer.get("attributes"), function(index, attribute) {
										if (attribute.name == filterField) {
											switch (attribute.localType) {
												case "string":
													if (filterOperator == "LIKE") {
														valuePrefix = "'%";
														valuePostfix = "%'";
													} else {
														valuePrefix = "'";
														valuePostfix = "'";
													}
													break;
												case "date-time":
													valuePrefix = "'";
													valuePostfix = "'";
													break;
											}
										}
									});
									userFilter = filterField + " " + filterOperator + " " + valuePrefix + filterValue + valuePostfix;
								}
								setCqlFilter(subjectLayer, app.plugins.LayerController.name, userFilter);
								
								// Remember filter details by setting them to the layer
								subjectLayer.set("filterField", filterField);
								subjectLayer.set("filterOperator", filterOperator);
								subjectLayer.set("filterValue", filterValue);
							}
							
							// Refresh the layer
							subjectLayer.getSource().refresh();
							
							// Remember application state if available and configured
							rememberState();
						}
					}
				}
			});
		});
	}
	
	/**
	 * Function: searchForLayers
	 * @param (string) search term
	 * @returns () nothing
	 * Function that searches the configured additional sources using a keyword
	 */
	searchForLayers(searchTerm) {
		// Clear filtered layer store
		app.plugins.LayerController.filteredLayerStore = [];

		// For each additional source configured, get it's list of available layers
		$.each(app.plugins.LayerController.pcfg.additionalSources, function(index, source) {
			if (app.plugins.LayerController.getCapabilitiesCache[source.url]) {
				// Get the cached result
				var gcJson = app.plugins.LayerController.getCapabilitiesCache[source.url];
				
				// Get the available layers
				var availableLayers = [];
				if (gcJson.Capability.Layer.Layer && gcJson.Capability.Layer.Layer.length > 0) availableLayers = gcJson.Capability.Layer.Layer;
				
				// Use search term to find matching layers
				var matchedLayers = [];
				$.each(availableLayers, function(index, layer) {
					var match = false;
					if (layer.Name.toUpperCase().indexOf(searchTerm.toUpperCase()) != -1) match = true;
					if (layer.Title.toUpperCase().indexOf(searchTerm.toUpperCase()) != -1) match = true;
					if (layer.Abstract.toUpperCase().indexOf(searchTerm.toUpperCase()) != -1) match = true;
					if (match === true) {
						layer.sourceUrl = source.url;
						layer.sourceName = (source.name) ? source.name + ": " : "";
						matchedLayers.push(layer);
					}
				});

				// Merge matchedLayers from this source with all matched layers list
				$.merge(app.plugins.LayerController.filteredLayerStore, matchedLayers);
			}
		});
		
		// Add results to select control
		$.each(app.plugins.LayerController.filteredLayerStore, function(index, layer) {
			$("#lc-matching-layers").append(new Option(layer.sourceName + layer.Title, index));
		});
		
		// Sort the results (and add "name" tooltip to each option)
		var options = $("#lc-matching-layers option");         
		options.detach().sort(function(a,b) {
			var at = $(a).text();
			var bt = $(b).text();         
			return (at > bt)?1:((at < bt)?-1:0);
		});
		options.each(function(){
			$(this).attr("title", $(this).text());
		});
		options.appendTo("#lc-matching-layers");
	}
	
	/**
	 * Function: addBaseLayerControl
	 * @param (object) layer
	 * @param (boolean) allowLayerRemoval
	 * @returns () nothing
	 * Function that adds a base layer control to the layer control tab
	 */
	addBaseLayerControl(layer, allowLayerRemoval) {
		// Get the template and clone it
		var clone = $(".lc-baselayer-template").clone(true);
		
		// Remove template class
		clone.removeClass("lc-baselayer-template");
		
		// Configure and show baselayer control
		clone.find("input").attr("layerId", ol.util.getUid(layer));
		clone.find("span").attr("layerId", ol.util.getUid(layer)); // Stored here for tools to access
		if (layer.get("visible")) clone.find("input").prop("checked", true);
		clone.find(".title").html(layer.get("title"));
		clone.show();
		
		// Show layer remove button if requested
		if (allowLayerRemoval) clone.find(".lc-remove-baselayer-btn").show();
		
		// Add baselayer control event handlers
		clone.find(".lc-baselayer-radio").change(function() {
			var layerId = $(this).attr("layerId");
			app.plugins.LayerController.switchBaseMap(layerId);
		});
		
		// Register layer remove event handler if requested
		if (allowLayerRemoval) {
			clone.find(".lc-remove-baselayer-btn").click(function() {
				var layerId = $(this).attr("layerId");
				app.plugins.LayerController.removeLayer(layerId);
			});
		}
		
		// Add (prepend) control to fieldset
		app.plugins.LayerController.tabContent.find(".lc-fs-baselayers .lc-fs-content").prepend(clone);
	}
	
	/**
	 * Function: addOverlayLayerControl
	 * @param (object) layer
	 * @param (boolean) allowLayerRemoval
	 * @returns () nothing
	 * Function that adds a overlay layer control to the layer control tab
	 */
	addOverlayLayerControl(layer, allowLayerRemoval) {
		// Get the template and clone it
		var clone = $(".lc-overlay-template").clone(true);
		
		// Remove template class
		clone.removeClass("lc-overlay-template");
		
		// Configure and show overlay control
		clone.find("input").attr("layerId", ol.util.getUid(layer));
		clone.find("span").attr("layerId", ol.util.getUid(layer)); // Stored here for tools to access
		if (layer.get("visible")) clone.find("input").prop("checked", true);
		clone.find(".title").html(layer.get("title"));
		clone.find(".title").attr("id", "lc-ol-title-"+ol.util.getUid(layer));
		clone.find(".lc-layer-toolbox").attr("id", "lc-layer-toolbox-"+ol.util.getUid(layer));
		clone.find(".lc-legend").attr("id", "lc-legend-div-"+ol.util.getUid(layer));
		clone.show();
		
		// Define and apply the layer legend (if available)
		if (typeof layer.getSource().getLegendUrl == "function") {
			var layerStyle = "";
			if (layer.getSource().getParams().STYLES) layerStyle = layer.getSource().getParams().STYLES; 
			var legendUrl = layer.getSource().getLegendUrl(
				app.map.getView().getResolution(),
				{legend_options: "fontName:Arial;fontAntiAliasing:true;fontColor:0x000033;fontSize:7;dpi:140", style: layerStyle}
			);
			clone.find("img").attr("src", legendUrl);
		}
		
		// Add overlay control event handlers
		clone.find(".lc-overlay-chkbox").change(function() {
			var layerId = $(this).attr("layerId");
			app.plugins.LayerController.toggleLayerVisibility(this.checked, layerId);
		});
		clone.find(".lc-overlay-legend-btn").click(function() {
			var layerId = $(this).attr("layerId");
			app.plugins.LayerController.showOverlayLegend(layerId);
		});
		clone.find(".lc-modify-overlay-btn").click(function() {
			var layerId = $(this).attr("layerId");
			app.plugins.LayerController.openModifyOverlayDialog(layerId);
		});
		clone.find(".lc-overlay-zoom2visible-btn").click(function() {
			var layerId = $(this).attr("layerId");
			app.plugins.LayerController.zoomToOverlaysVisibleRange(layerId);
		});
		
		// Show and register layer remove button requested
		if (allowLayerRemoval) {
			clone.find(".lc-remove-overlay-btn").show();
			clone.find(".lc-remove-overlay-btn").click(function() {
				var layerId = $(this).attr("layerId");
				app.plugins.LayerController.removeLayer(layerId);
			});
		}
		
		// Show & register layer download button if configured
		if (app.plugins.LayerController.pcfg.layerDownloads && app.plugins.LayerController.pcfg.layerDownloads.enabled) {
			clone.find(".lc-download-overlay-btn").show();
			clone.find(".lc-download-overlay-btn").click(function() {
				var layerId = $(this).attr("layerId");
				app.plugins.LayerController.downloadOverlayLayer(layerId);
			});
		}
		
		// Register layer error handler (WMS only for now)
		if (typeof layer.getSource().getLegendUrl == "function") {
			layer.getSource().addEventListener("tileloaderror", function(e){
				var layerId = ol.util.getUid(layer);
				app.plugins.LayerController.handleLayerLoadError(layerId, "Tile Load Error");
			});
			layer.getSource().addEventListener("imageloaderror", function(e){
				var layerId = ol.util.getUid(layer);
				app.plugins.LayerController.handleLayerLoadError(layerId, "Image Load Error");
			});
		}
		
		// Show overlays fieldset
		app.plugins.LayerController.tabContent.find(".lc-fs-overlays").show();
		
		// Add (prepend) control to overlays fieldset
		app.plugins.LayerController.tabContent.find(".lc-fs-overlays .lc-fs-content").prepend(clone);
		
		// Attach layer metadata (if it does not already exist)
		if (!layer.get("attributes")) attachMetaDataToLayer(layer, app.plugins.LayerController.honourLayerVisibility);
	}
	
	/**
	 * Function: addOverlayLayer
	 * @param () none
	 * @returns () nothing
	 * Function that adds the selected layer to the map
	 */
	addOverlayLayer() {
		// Get the selected layer detail
		var selectedLayerIndex = $("#lc-matching-layers option:selected").val();
		var selectedLayer = app.plugins.LayerController.filteredLayerStore[selectedLayerIndex];

		// Contruct the layer
		var layer = new ol.layer.Tile({
			title: selectedLayer.Title,
			type: "overlay",
			visible: true,
			source: new ol.source.TileWMS({ // Wonder if we should add a ImageWMS instead?
				url: selectedLayer.sourceUrl,
				params: {
					LAYERS: selectedLayer.Name
				},
				transition: 0
			})
		});
		
		// Add the layer to the map
		app.map.addLayer(layer);
		
		// Figure out the next available zIndex is
		var highestZIndex = 500; // Overlay layers are zIndexes 500 to 599
		$.each(app.map.getLayers().getArray(), function(i, l) {
			if (l.get("type") == "overlay") {
				if (l.getZIndex() > highestZIndex) highestZIndex = l.getZIndex();
			}
		});
		var nextZIndex = highestZIndex + 1;
		
		// Set the layer zIndex
		layer.setZIndex(nextZIndex);
		
		// Add layer as control to layer switcher
		app.plugins.LayerController.addOverlayLayerControl(layer, true);
		
		// Remember application state if available and configured
		rememberState();
	}
	
	/**
	 * Function: removeLayer
	 * @param (integer) layerId
	 * @returns () nothing
	 * Function that removes a layer from the map
	 */
	removeLayer(layerId) {
		// Find the layer to remove (by it's ID)
		var layerToRemove;
		$.each(app.map.getLayers().getArray(), function(index, layer) {
			if (ol.util.getUid(layer) == layerId) { 
				layerToRemove = layer;
			}
		});
		
		// Remove the layer from the overlay fieldset (if exists)
		$(".lc-fs-overlays .lc-fs-content").children("div").each(function () {
			if ($(this).find("input").attr("layerId") == layerId) {
				$(this).remove();
			}
		});
		
		// Remove the layer from the baselayer fieldset (if exists)
		$(".lc-fs-baselayers .lc-fs-content").children("div").each(function () {
			if ($(this).find("input").attr("layerId") == layerId) {
				$(this).remove();
			}
		});
		
		// If the base layer is turned on when its removed, try to turn on some other base layer
		if (layerToRemove.getVisible() === true) {
			if ($(".lc-fs-baselayers .lc-fs-content").children("div").length > 0) {
				$(".lc-fs-baselayers .lc-fs-content").children("div").first().find("input").prop("checked", true);
				$(".lc-fs-baselayers .lc-fs-content").children("div").first().find("input").change()
			}
		}
		
		// Hide overlays fieldset if empty
		if ($(".lc-fs-overlays .lc-fs-content").children("div").length == 0) {
			app.plugins.LayerController.tabContent.find(".lc-fs-overlays").hide();
		}
		
		// Remove the layer from the map
		if (layerToRemove) app.map.removeLayer(layerToRemove);
		
		// Remember application state if available and configured
		rememberState();
	}
	
	/**
	 * Function: downloadOverlayLayer
	 * @param (integer) layerId
	 * @returns () nothing
	 * Function that issues a request to download an overlay layer
	 */
	downloadOverlayLayer(layerId) {
		// Find the layer to remove
		var layerToDownload;
		$.each(app.map.getLayers().getArray(), function(index, layer) {
			if (layer.get("type") != "base") {
				if (ol.util.getUid(layer) == layerId) { 
					layerToDownload = layer;
				}
			}
		});
		
		// Define the max features that can be downloaded (defaults to 500)
		var maxFeatures = 500;
		if (app.plugins.LayerController.pcfg.layerDownloads && app.plugins.LayerController.pcfg.layerDownloads.maxFeatures) {
			maxFeatures = app.plugins.LayerController.pcfg.layerDownloads.maxFeatures;
		} 
		
		// Continue if a valid layer was found
		if (layerToDownload) {
			
			// ImageWMS layers have a single url in their source, TileWMS have multiple
			var layerUrl = "";
			if (layerToDownload.get("source").urls) {
				layerUrl = layerToDownload.getSource().getUrls()[0];
			} else {
				layerUrl = layerToDownload.getSource().getUrl();
			}
			
			// Get layer details
			var layers;
			$.each(layerToDownload.getSource().getParams(), function(parameterName, parameterValue) {
				if (parameterName.toUpperCase() == "LAYERS") layers = parameterValue;
			});
			
			// Get the WFS output formats and output projections for this layer
			var exportOutputFormats = layerToDownload.get("exportOutputFormats");
			var exportOutputProjections = layerToDownload.get("exportOutputProjections");
						
			// Load the form
			$.ajax({
				type: "GET",
				url: app.plugins.LayerController.layerDownloaderContentFile
			}).done(function(response) {
				// Get the form from the response
				var lForm = $(response);
				
				// Populate the export layer input (readonly)
				lForm.find("#lc-output-layer").val(layerToDownload.get("title"));
				
				// Populate the export output formats select box
				$.each(exportOutputFormats, function(exportOutputFormatId, exportOutputFormat) {
					lForm.find("#lc-output-format").append("<option value='"+exportOutputFormatId+"'>"+exportOutputFormat.name+"</option>");
				});
				
				// Populate the export output projections select box
				$.each(exportOutputProjections, function(index, exportOutputProjection) {
					lForm.find("#lc-output-projection").append("<option value='"+exportOutputProjection.value+"'>"+exportOutputProjection.name+"</option>");
				});
				
				// Register the output format change listener
				lForm.find("#lc-output-format").on("change", function(e){
					lForm.find("#lc-output-projection").prop("disabled", false);
					var outputFormatId = $(this).val();
					var outputFormat = exportOutputFormats[outputFormatId];
					if (outputFormat.requiredSrs) {
						lForm.find("#lc-output-projection").val(outputFormat.requiredSrs)
						lForm.find("#lc-output-projection").prop("disabled", true);
					}
				});
				lForm.find("#lc-output-format").change();
				
				// Define and option the downloader dialog
				bootbox.dialog({
					title: "Download Layer",
					message: lForm,
					buttons: {
						download: {
							label: "Download",
							className: "btn-primary",
							callback: function(result){
								// Get the selected output format
								var outputFormatId = $("#lc-output-format").val();
								var outputFormat = exportOutputFormats[outputFormatId];
								
								// Formulate the request parameters (WFS)
								if (outputFormat.service.toUpperCase() == "WFS") {
									// Get selected output projection
									var outputProjection = $("#lc-output-projection").val();
									
									// Get the current map extent (in bbox format for selected output projection)
									var bbox = app.map.getView().calculateExtent(app.map.getSize());
									var outputBbox = ol.proj.transformExtent(bbox, app.map.getView().getProjection().getCode(), outputProjection);
									
									// Define URL query parameters
									var urlParameters = {
										service: "WFS",
										version: outputFormat.version,
										request: outputFormat.request,
										typeNames: layers,
										outputFormat: outputFormat.format,
										srsName: outputProjection,
										count: maxFeatures, // may be over-ridden by server
										bbox: outputBbox.join(",") + "," + outputProjection
									}
								
								// Formulate the request parameters (WMS)
								} else if (outputFormat.service.toUpperCase() == "WMS") {
									// Get selected output projection
									var outputProjection = "EPSG:4326";
									
									// Get the current map extent (in bbox format for selected output projection)
									var bbox = app.map.getView().calculateExtent(app.map.getSize());
									var outputBbox = ol.proj.transformExtent(bbox, app.map.getView().getProjection().getCode(), outputProjection);
									
									// Define URL query parameters
									var urlParameters = {
										service: "WMS",
										version: outputFormat.version,
										request: outputFormat.request,
										layers: layers,
										format: outputFormat.format,
										width: 1024,
										height: 1024,
										maxFeatures: maxFeatures, // may be over-ridden by server
										bbox: outputBbox.join(",") + "," + outputProjection
									}
								} else {
									logger("ERROR", "LayerController: Unknown Export Type");
									return;
								}
								
								// Add propertyNames option if it exists
								if (outputFormat.propertyName) {
									urlParameters.propertyName = outputFormat.propertyName;
								}
								
								// Build the request URL (append parameters)
								var downloadUrl = layerUrl.replace(/\?.*$/, "") + "?" + $.param(urlParameters);
								
								// Download the file
								downloadFile(downloadUrl);
							}
						}
					}
				});
				
			});
			
		}
	}
	
	/**
	 * Function: handleLayerLoadError
	 * @param (integer) layerId
	 * @param (stringr) message
	 * @returns () nothing
	 * Function that handles a layer loading issue
	 */
	handleLayerLoadError(layerId, message) {
		$("#lc-layer-toolbox-" + layerId + " .lc-overlay-error").show();
		logger("ERROR", $("#lc-ol-title-"+layerId).html() + " - " + message);
	}
	
	/**
	 * Function: reorderOverlayLayers
	 * @param () none
	 * @returns () nothing
	 * Function that stacks the overlay layers in the map in accordance to the layer controller order
	 */
	reorderOverlayLayers() {
		// Get the number of managed overlay layers
		var managedOverlayLayerCount = $(".lc-fs-overlays .lc-fs-content").children("div").length;

		// Calculate the starting point for the zIndex
		var zIndex = app.StartIndexForOverlayLayers + managedOverlayLayerCount;
			
		
		// Loop through the list of overlay layer controls to determine new order
		$(".lc-fs-overlays .lc-fs-content").children("div").each(function () {
			// Get layerId from control
			var layerId = $(this).find("input").attr("layerId");
			
			// Find that layer in the map and set it's new zIndex
			$.each(app.map.getLayers().getArray(), function(index, layer) {
				if (ol.util.getUid(layer) == layerId) {
					layer.setZIndex(zIndex);
				}
			});
			
			// Deincrement the zIndex
			zIndex--;
		});
		
		// Remember application state if available and configured
		rememberState();
	}
	
	/**
	 * Function: zoomToOverlaysVisibleRange
	 * @param (integer) layerId
	 * @returns () nothing
	 * Function that zooms to an overlay's visible range
	 */
	zoomToOverlaysVisibleRange(layerId) {
		// Find the layer by its ID
		var overlay;
		$.each(app.map.getLayers().getArray(), function(index, layer) {
			if (layer.get("type") != "base") {
				if (ol.util.getUid(layer) == layerId) { 
					overlay = layer;
				}
			}
		});
		
		// Get the current map scale
		var currentMapScale = getCurrentMapScale();
		
		// Determine preferred min and max scales
		var preferredMaxScale = 0;
		if (overlay.get("maxScaleDenominator")) {
			preferredMaxScale = overlay.get("maxScaleDenominator") - (overlay.get("maxScaleDenominator") * 0.1);
		}
		var preferredMinScale = 0;
		if (overlay.get("minScaleDenominator")) {
			preferredMinScale = overlay.get("minScaleDenominator") + (overlay.get("minScaleDenominator") * 0.1);
		}
		
		// Determine what target scale to zoom to (if too low go up or if too high come down)
		var targetScale = 0;
		if (currentMapScale < preferredMinScale) {
			targetScale = preferredMinScale;
		} else if (currentMapScale > preferredMaxScale) {
			targetScale = preferredMaxScale;
		}
		
		// Zoom to the determined scale
		zoomToScale(targetScale);	
	}
	
	/**
	 * Function: honourLayerVisibility
	 * @param () none
	 * @returns () nothing
	 * Function that enables/disables layer controls based on their min/max scale settings
	 */
	honourLayerVisibility() {
		// Get the current map scale
		var currentMapScale = getCurrentMapScale();
		
		// Loop through each overlay
		$(".lc-fs-overlays .lc-fs-content").children("div").each(function () {
			
			// Get misc controls
			var layerChkBox = $(this).find("input");
			var zoomToVisibleBtn = $(this).find(".lc-overlay-zoom2visible-btn");
			
			// Get layerId
			var layerId = layerChkBox.attr("layerId");
			
			// Find that layer in the map
			var overlay;
			$.each(app.map.getLayers().getArray(), function(index, layer) {
				if (ol.util.getUid(layer) == layerId) {
					overlay = layer;
				}
			});
			
			// Disable/enable layer controller if current map scale is outside of the layer's min/max scales
			if (overlay.get("maxScaleDenominator")) {
				if (currentMapScale > overlay.get("maxScaleDenominator")) {
					// Disable the layer control
					$("#lc-ol-title-"+layerId).css("color", "silver");
					layerChkBox.prop("disabled", true);
					
					// Turn the layer off (this is done to handle slight visibility descrepancies between map scale and layer scale)
					overlay.setVisible(false);
					
					// Show the zoom to visible button
					zoomToVisibleBtn.show();
					
				} else {
					// Enable the layer control
					$("#lc-ol-title-"+layerId).css("color", "black");
					layerChkBox.prop("disabled", false);
					
					// Reset layer visibility to match layer control
					if (layerChkBox.prop("checked") === true) {
						overlay.setVisible(true);
					} else {
						overlay.setVisible(false);	
					}
					
					// Hide the zoom to visible button
					zoomToVisibleBtn.hide();
				}
			}
			if (overlay.get("minScaleDenominator")) {
				if (currentMapScale < overlay.get("minScaleDenominator")) {
					// Disable the layer control
					$("#lc-ol-title-"+layerId).css("color", "silver");
					layerChkBox.prop("disabled", true);
					
					// Turn the layer off (this is done to handle slight visibility descrepancies between map scale and layer scale)
					overlay.setVisible(false);
					
					// Show the zoom to visible button
					zoomToVisibleBtn.show();
					
				} else {
					// Enable the layer control
					$("#lc-ol-title-"+layerId).css("color", "black");
					layerChkBox.prop("disabled", false);
					
					// Reset layer visibility to match layer control
					if (layerChkBox.prop("checked") === true) {
						overlay.setVisible(true);
					} else {
						overlay.setVisible(false);	
					}
					
					// Hide the zoom to visible button
					zoomToVisibleBtn.hide();
				}
			}
			
		});
	}
		
	/**
	 * Function: addPlugin
	 * @param () none
	 * @returns () nothing
	 * Function that adds the plugin tab to the sidebar
	 */
	addPlugin() {
		// Define Callback
		var callback = function(success, tabNav, tabContent){
			// Bail if failed
			if (!success) {
				logger("ERROR", app.plugins.LayerController.name + ": Plugin failed to initialize");
				return;
			}
			
			// Set class variables
			app.plugins.LayerController.tabNav = tabNav;
			app.plugins.LayerController.tabContent = tabContent;
					
			// Add the base layers in the map to the layer switcher (by zIndex order)
			var zIndexes = [];
			$.each(app.map.getLayers().getArray(), function(index, layer) {
				if (layer.get("title") && layer.get("type") == "base") {
					zIndexes.push(layer.getZIndex());
				}
			});
			zIndexes.sort();
			$.each(zIndexes, function(index, zIndex) {
				$.each(app.map.getLayers().getArray(), function(index, layer) {
					if (zIndex == layer.getZIndex()) {
						if (layer.get("removable") === true) {
							app.plugins.LayerController.addBaseLayerControl(layer, true);
						} else {
							app.plugins.LayerController.addBaseLayerControl(layer, false);
						}
					}
				});
			});
			
			// Add the overlay layers in the map to the layer switcher (by zIndex order)
			var zIndexes = [];
			$.each(app.map.getLayers().getArray(), function(index, layer) {
				if (layer.get("title") && layer.get("type") == "overlay") {
					zIndexes.push(layer.getZIndex());
				}
			});
			zIndexes.sort();
			$.each(zIndexes, function(index, zIndex) {
				$.each(app.map.getLayers().getArray(), function(index, layer) {
					if (zIndex == layer.getZIndex()) {
						if (layer.get("removable") === true) {
							app.plugins.LayerController.addOverlayLayerControl(layer, true);
						} else {
							app.plugins.LayerController.addOverlayLayerControl(layer, false);
						}
					}
				});
			});
			
			// Make the overlay layers sortable (so user can change stack order)
			$(".lc-fs-overlays .lc-fs-content").sortable({
				update: function(event, ui) {
					app.plugins.LayerController.reorderOverlayLayers();
				}
			});
						
			// If "additionalSources" is configured, show and register the dynamic layer adder fieldset
			if (app.plugins.LayerController.pcfg.additionalSources) {
				
				// Show the fieldset
				app.plugins.LayerController.tabContent.find(".lc-fs-layer-adder").show();
								
				// Register the search input
				$("#lc-search-input").keyup(function(){
					// Clear an existing search if another is issued soon after
					if (app.plugins.LayerController.searchTimer) clearTimeout(app.plugins.LayerController.searchTimer);
					
					// Disable add layer button
					$("#lc-add-layer-btn").prop("disabled", true);
					
					// Wait a tick before doing anything
					app.plugins.LayerController.searchTimer = setTimeout(function(){
						// Empty matching layers selectbox
						$("#lc-matching-layers").empty();
						
						// Execute the search only when 3 characters are entered
						if ($("#lc-search-input").val().length > 2) {
							app.plugins.LayerController.searchForLayers($("#lc-search-input").val());
						}
					}, 250);
				});
				
				// Register the selection change
				$("#lc-matching-layers").on("change", function(){
					$("#lc-add-layer-btn").prop("disabled", false);
				});
				
				// Register the add layer button
				$("#lc-add-layer-btn").on("click", function() {
					app.plugins.LayerController.addOverlayLayer();
				});
				
				// Pre-cache all of the GetCapabilities 
				app.plugins.LayerController.cacheGetCapabilities();
				
				// Register map moveend listener
				$(app.map).on("moveend", function(e) {
					app.plugins.LayerController.honourLayerVisibility();
				});
				
				// Log success
				logger("INFO", app.plugins.LayerController.name + ": Plugin successfully loaded");
			}
			
		}
		
		// Add the tab
		addSideBarTab(this.tabName, this.tabContentFile, callback);
	}
}

// Class initialization
app.plugins.LayerController = new LayerController();