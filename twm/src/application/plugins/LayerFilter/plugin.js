class LayerFilter {
	
	/**
	 * Function: constructor
	 * @param () none
	 * @returns () nothing
	 * Function that initializes the class
	 */
	constructor() {
		this.name = "LayerFilter";
		this.version = 1.0;
		this.author = "Volker Schunicht";
		this.pcfg = getPluginConfig(this.name);
		this.tabName = (this.pcfg.tabName) ? this.pcfg.tabName : "Layer Filter";
		this.tabContentFile = "application/plugins/LayerFilter/tab-content.html";
		this.featureTemplateFile = "application/plugins/LayerFilter/feature-template.html";
		this.featureTemplate = "";
		this.filterLayer;
		this.resultsTreeData = [];
		this.tabNav; // jQuery element
		this.tabContent // jQuery element
		this.featureStore = [];  // Used to store all of the features and attributes
		this.searchInProgress = false;
		this.addPlugin();
	}
	
	/**
	 * Function: addFilterableLayersToSelectControl
	 * @param () none
	 * @returns () nothing
	 * Function to add layers configured to filterable to the layer filter select control
	 */
	addFilterableLayersToSelectControl() {
		// Empty the layer select control
		$("#lf-filter-layer-select").empty();
		
		// Loop through all of the map layers looking for ones that are configured for filtering
		$.each(app.map.getLayers().getArray(), function(index, layer) {
			// Get the layer ID
			var layerId = ol.util.getUid(layer);
			
			// Determine if its configured for filtering
			var addAsFilterLayer = false;
			var fields = layer.get("fields");
			if (fields) {
				$.each(fields, function(index2, field) {
					if (field.filter) {
						addAsFilterLayer = true;
					}
				});
			}

			// Add as filter layer if configured
			if (addAsFilterLayer === true) {
				$("#lf-filter-layer-select").prepend(new Option(layer.get("title"), layerId));
			}
		});
		
		// Register select change handler
		$("#lf-filter-layer-select").on("change", function(e){
			// Clear existng results/errors
			app.plugins.LayerFilter.clearResults();
			
			// Reset any applied CQL filters
			if (app.plugins.LayerFilter.filterLayer) {
				setCqlFilter(app.plugins.LayerFilter.filterLayer, app.plugins.LayerFilter.name, null);
			}
			
			// Build filter controls
			var selectedLayerId = $("#lf-filter-layer-select option:selected").val();
			app.plugins.LayerFilter.addFilterControls(selectedLayerId);
		});

		// Only show layer select control if more than one layer
		if ($("#lf-filter-layer-select option").length > 1) $("#lf-filter-layer-select-container").show();
		
		// Set selection to first option and trigger change
		$("#lf-filter-layer-select").val($("#lf-filter-layer-select option:first").val());
		$("#lf-filter-layer-select").trigger("change");
	}
	
	/**
	 * Function: addFilterControls
	 * @param (int) layerId
	 * @returns () nothing
	 * Function to filter controls specific to the layer
	 */
	addFilterControls(layerId) {
		// Remove existing filters and hide fieldset
		$("#lf-filter-controls").empty();
		$("#lf-fs-filter-controls").hide();
		
		// Get the filter layer
		$.each(app.map.getLayers().getArray(), function(index, layer) {
			if (ol.util.getUid(layer) == layerId) {
				app.plugins.LayerFilter.filterLayer = layer;
			}
		});
		
		// Bail if not found
		if (!app.plugins.LayerFilter.filterLayer) return;
		
		// Get the filter layer attributes (if present)
		var attributes = app.plugins.LayerFilter.filterLayer.get("attributes");

		// Add each filter control (based on configured type)
		var fields = app.plugins.LayerFilter.filterLayer.get("fields");
		$.each(fields, function(fieldIndex, field) {
			if (field.filter && field.filter.name && field.filter.type && field.filter.cql) {
				// Define the control
				var control;

				// Build the control specific to field filter type
				switch (field.filter.type) {
					case "boolean":
						control = $(".lf-checkbox-template").clone(true);
						control.removeClass("lf-checkbox-template");
						control.find(".title").html(field.filter.name);
						control.find("input").change(function(){
							if (this.checked === true) {
								var cql = field.filter.cql;
								cql = cql.replace("{{field}}", field.name);
								cql = cql.replace("{{value}}", 1);
								$(this).attr("userFilter", cql);
							} else {
								$(this).attr("userFilter", null);
							}
							app.plugins.LayerFilter.findFeatures();
						});
						break;
					case "string":
						control = $(".lf-textfield-template").clone(true);
						control.removeClass("lf-textfield-template");
						control.find(".input-group-text").html(field.filter.name);
						control.find("input").keyup(function(){
							if ($(this).val() != "") {
								var cql = field.filter.cql;
								cql = cql.replace("{{field}}", field.name);
								cql = cql.replace("{{value}}", $(this).val());
								$(this).attr("userFilter", cql);
							} else {
								$(this).attr("userFilter", null);
							}
							app.plugins.LayerFilter.findFeatures();
						});
						break;
					case "number":
						control = $(".lf-numberfield-template").clone(true);
						control.removeClass("lf-numberfield-template");
						control.find(".input-group-text").html(field.filter.name);
						control.find("input").keyup(function(){
							if ($(this).val() != "") {
								var cql = field.filter.cql;
								cql = cql.replace("{{field}}", field.name);
								cql = cql.replace("{{value}}", $(this).val());
								$(this).attr("userFilter", cql);
							} else {
								$(this).attr("userFilter", null);
							}
							app.plugins.LayerFilter.findFeatures();
						});
						break;
				}
				
				// If a control was built, add it to the UX
				if (control) {
					$("#lf-filter-controls").append(control);
					control.show();
				}

			}
		});
		
		// Turn on spatial filter if configured
		if (app.plugins.LayerFilter.pcfg.allowFilterByMapExtent) {
			$("#lf-spatial-filter").find("input").change(function(){
				if (this.checked === true) {
					$(app.map).on("moveend", app.plugins.LayerFilter.findFeatures);
				} else {
					$(app.map).off("moveend", app.plugins.LayerFilter.findFeatures);
				}
				app.plugins.LayerFilter.findFeatures();
			});
			$("#lf-fs-spatial-filter").show();
		}
		
		// Show the filter fieldset
		$("#lf-fs-filter-controls").show();	
	}
	
	/**
	 * Function: clearResults
	 * @param () none
	 * @returns () nothing
	 * Function that clears any results
	 */
	clearResults() {
		app.plugins.LayerFilter.featureStore = [];
		app.plugins.LayerFilter.resultsTreeData = [];
		$("#lf-results").empty();
		$("#lf-error").hide();
	}
	
	/**
	 * Function: findFeatures
	 * @param () none
	 * @returns () nothing
	 * Function finds features using the specified search parameters
	 */
	findFeatures() {
		// Bail if there is already a search happening
		if (app.plugins.LayerFilter.searchInProgress === true) return;
		
		// Toggle searchInProgress
		app.plugins.LayerFilter.searchInProgress = true;
		
		// Clear results
		app.plugins.LayerFilter.clearResults();
		
		// Add the tab spinner
		var spinner = new Spinner(app.spinnerOptionsMedium).spin($(app.plugins.LayerFilter.tabContent)[0]);

		// Define the search layer url (modify to point to WFS if required)
		if (app.plugins.LayerFilter.filterLayer.getSource() instanceof ol.source.TileWMS) {
			var searchUrl = app.plugins.LayerFilter.filterLayer.getSource().getUrls()[0]; // TileWMS
		} else if (app.plugins.LayerFilter.filterLayer.getSource() instanceof ol.source.ImageWMS) {
			var searchUrl = app.plugins.LayerFilter.filterLayer.getSource().getUrl(); // ImageWMS
		} else {
			logger("WARN", "Could not determine search url for layer " + app.plugins.LayerFilter.filterLayer.get("title"));
			spinner.stop();
			$("#lf-error").show();
			$("#lf-fs-filter-results").show();
			return;
		}
		var searchUrl = searchUrl.replace(new RegExp("/ows", "ig"), "/wfs");
			
		// Define the search layer name
		var searchLayerName;
		$.each(app.plugins.LayerFilter.filterLayer.getSource().getParams(), function(parameterName, parameterValue) {
			if (parameterName.toUpperCase() == "LAYERS") searchLayerName = parameterValue;
		});
		
		// Define the CQL Filter array
		var cqlFilterArray = [];
		
		// Apply spatial filter if present and on
		var spatialFilter;
		if($("#lf-spatial-filter").find("input").is(":checked")) {
			// Get the name of the geometry column name
			var geometryField;
			$.each(app.plugins.LayerFilter.filterLayer.get("attributes"), function(index, attribute) {
				if (attribute.type.startsWith("gml:")) {
					geometryField = attribute.name;
				}
			});

			// Bail if current layer has no geometry field defined
			if (geometryField == null) {
				logger("ERROR", app.plugins.LayerFilter.name + ": "+app.plugins.LayerFilter.filterLayer.get("title")+" does not have a geometry field defined");
				spinner.stop();
				$("#lf-error").show();
				$("#lf-fs-filter-results").show();
				return;
			}

			// Bail if current layer has no native projection defined
			if (app.plugins.LayerFilter.filterLayer.get("nativeProjection") == null) {
				logger("ERROR", app.plugins.LayerFilter.name + ": "+app.plugins.LayerFilter.filterLayer.get("title")+" does not have a native projection defined");
				spinner.stop();
				$("#lf-error").show();
				$("#lf-fs-filter-results").show();
				return;
			}
			
			// Get current map extent
			var mapExtent = app.map.getView().calculateExtent(app.map.getSize());
			
			// Transform map extent to the layers native projection if required
			if (app.map.getView().getProjection().getCode() != app.plugins.LayerFilter.filterLayer.get("nativeProjection")) {
				var mapExtent = ol.proj.transformExtent(mapExtent, app.map.getView().getProjection().getCode(), app.plugins.LayerFilter.filterLayer.get("nativeProjection"));
			}
			
			// Build the spatial filter (if requested) and add it to the CQL Filter array
			spatialFilter = "BBOX("+geometryField+","+mapExtent[0]+","+mapExtent[1]+","+mapExtent[2]+","+mapExtent[3]+")";
		}

		// Add user defined filters
		$("#lf-filter-controls").find("input").each(function() {
			var currentFilterControlFilter = $(this).attr("userFilter");
			if (currentFilterControlFilter) cqlFilterArray.push(currentFilterControlFilter);
		});
		
		// Convert CQL filter array to a string
		var cqlFilter = "";
		if (cqlFilterArray.length > 0) {
			cqlFilter = cqlFilterArray.join(" AND ");
		}

		// Apply the CQL filter to the map layer (it gets a modified CQL filter back - one that has pre-existing CQL filters applied)
		var modifiedCqlFilter = setCqlFilter(app.plugins.LayerFilter.filterLayer, app.plugins.LayerFilter.name, cqlFilter);
		
		// Now add the spatial portion to the query (if present)
		if (spatialFilter) {
			if (modifiedCqlFilter == null || modifiedCqlFilter == "") {
				modifiedCqlFilter = spatialFilter;
			} else {
				modifiedCqlFilter = modifiedCqlFilter + " AND " + spatialFilter;
			}
		}
		
		// Do not execute a search if cql filter is empty
		if (modifiedCqlFilter == null || modifiedCqlFilter == "") {
			app.plugins.LayerFilter.addToResultsTreeData(app.plugins.LayerFilter.filterLayer, []);
			app.plugins.LayerFilter.showResults();
			app.plugins.LayerFilter.searchInProgress = false;
			spinner.stop();
			return;
		}

		// Build the request options
		var options = {
			service: "WFS",
			version: "2.0.0",
			request: "GetFeature", 
			typeNames: searchLayerName,
			outputFormat: "application/json",
			count: app.plugins.LayerFilter.pcfg.proximitySearchMaxResults,
			srsName: app.map.getView().getProjection().getCode(),
			cql_filter: modifiedCqlFilter
		}
		
		// Issue the request
		$.ajax({
			type: "GET",
			url: searchUrl,
			dataType: "json",
			timeout: 5000,
			data: options
		})
		
		// Handle the response
		.done(function(response) {
			if (response.features) {
				app.plugins.LayerFilter.addToResultsTreeData(app.plugins.LayerFilter.filterLayer, response.features);
				app.plugins.LayerFilter.showResults();
			}
			app.plugins.LayerFilter.searchInProgress = false;
			spinner.stop();
		})
		
		// Handle a failure
		.fail(function(jqxhr, settings, exception) {
			logger("ERROR", app.plugins.LayerFilter.name + ": Error querying " + app.plugins.LayerFilter.filterLayer.get("title"));
			app.plugins.LayerFilter.searchInProgress = false;
			$("#lf-error").show();
			$("#lf-fs-filter-results").show();
			spinner.stop();
		}); 	

	}
	
	/**
	 * Function: addToResultsTreeData
	 * @param (object) layer
	 * @param (object) features
	 * @returns () nothing
	 * Function that adds a result set to the tree view data array
	 */
	addToResultsTreeData(layer, features) {	
		// Build the parent (layer) node
		var parentNode = new Object();
		parentNode.text = layer.get("title") + " (" + features.length + ")";
		parentNode.icon = "oi oi-folder";
		parentNode.class = "lf-treeview-layer";
		parentNode.expanded = true;
		parentNode.nodes = [];
		
		// Add each feature found as a child to the parent
		$.each(features, function(index, feature) {
			// Convert to Openlayers feature
			var olFeature = convertToOpenLayersFeature("GeoJSON", feature);
			
			// Skip if returned feature is not valid
			if (!olFeature) return true;
			
			// Build the feature title (configured or not)
			var featureTitle = "";
			if (typeof layer.get("fields") !== "undefined") {
				$.each(layer.get("fields"), function(index, configField) {
					if (configField.name) {
						$.each(feature.properties, function(fieldName, fieldValue) {
							if (configField.name == fieldName) {
								if (configField.title) {
									if (featureTitle != "") featureTitle += " - ";
									featureTitle += "<i>"+fieldValue+"</i>";
								} 
							}
						});
					}
				});
			} else {
				featureTitle += layer.get("title") + " [" + (index + 1) + "]";
			}
			
			// Add feature title to feature
			olFeature.set("title", featureTitle);
			
			// If the layer has a field configuration, append it to the feature
			if (layer.get("fields")) olFeature.set("fields", layer.get("fields"));
			
			// Add feature to feature store
			app.plugins.LayerFilter.featureStore.push(olFeature);
			
			// Build the child (feature) node
			var childNode = new Object();
			childNode.id = "lf-feature-" + (app.plugins.LayerFilter.featureStore.length - 1);
			childNode.text = featureTitle;
			childNode.icon = "oi oi-map";
			childNode.class = "lf-treeview-feature";
			
			// Add child node to parent (layer) node
			parentNode.nodes.push(childNode);
		});
		
		// Add the parent to the results tree data array
		app.plugins.LayerFilter.resultsTreeData.push(parentNode);
	}
	
	/**
	 * Function: showResults
	 * @param () none
	 * @returns () nothing
	 * Function that show the results in a tree view
	 */
	showResults() {	
		// Add a tree view div
		$("#lf-results").append("<div id='lf-tree'></div>");
		
		// Register and build the treeview
		$("#lf-tree").bstreeview({
			data: app.plugins.LayerFilter.resultsTreeData,
			expandIcon: 'oi oi-minus',
			collapseIcon: 'oi oi-plus',
			indent: 1.6,
			openNodeLinkOnNewTab: true
		});
		
		// Expand the parent by default
		$(".lf-treeview-layer").click();
		
		// Add click event handlers to all of the features
		$(".lf-treeview-feature").click(function(){
			var featureStoreId = this.id.replace("lf-feature-", "");
			app.plugins.LayerFilter.showFeaturePopup(featureStoreId);
		});
		
		// Add hover event handlers to all of the features
		$(".lf-treeview-feature").hover(
			function(){
				var featureStoreId = this.id.replace("lf-feature-", "");
				highlightFeature(app.plugins.LayerFilter.featureStore[featureStoreId]);
			},
			function(){
				clearHighlightedFeatures();
			}
		);
		
		$("#lf-fs-filter-results").show();
	}
	
	/**
	 * Function: showFeaturePopup
	 * @param (integer) featureStoreId
	 * @returns () nothing
	 * Function that populates and shows a feature popup
	 */
	showFeaturePopup(featureStoreId) {
		// Get the feature
		var feature = app.plugins.LayerFilter.featureStore[featureStoreId];
		
		// Make a clone of the feature template
		var clone = app.plugins.LayerFilter.featureTemplate.clone(true);
		
		// Link (attribute) the feature store ID to the table
		clone.attr("featureStoreId", featureStoreId);
		
		// Insert feature title into the clone
		clone.find(".lf-feature-title").append(feature.get("title"));
		
		// Enable the navigate to button if the plugin exists
		if (app.plugins.DynamicRouter) clone.find(".LayerFilterNavigateTo").show();
		
		// Register the navigate to click event handler if the plugin exists
		if (app.plugins.DynamicRouter) {
			clone.find(".LayerFilterNavigateTo").on("click", function(e) {
				// Remove all pre existing way points
				$(".dr-way-point").remove();
				
				// Get the search location details
				var sLongitude = $(".lf-search-point .lf-location-input").attr("longitude");
				var sLatitude = $(".lf-search-point .lf-location-input").attr("latitude");
				var sText = $(".lf-search-point .lf-location-input").val();
				if (!sLongitude || !sLatitude) return;
				
				// Set the router's start location equal to the search location
				$(".dr-start-point .dr-location-input").attr("longitude", sLongitude);
				$(".dr-start-point .dr-location-input").attr("latitude", sLatitude);
				$(".dr-start-point .dr-location-input").val(sText);
				
				// Add current feature location into the end location input
				var featureStoreId = $(this).closest("table").attr("featureStoreId");
				var locationEndInput = $(".dr-end-point .dr-location-input");
				app.plugins.DynamicRouter.registerFeatureLocation(locationEndInput, app.plugins.LayerFilter.featureStore[featureStoreId]);
				
				// Show the router tab
				app.plugins.DynamicRouter.tabNav.tab("show");
				
				// Close the popup
				closePopup();

				// Show sidebar immediately if desktop
				if (!isMobile()) showSidebar();
			});
		}
		
		// If the layer fields ARE NOT configured, add them in raw
		if (typeof feature.get("fields") === "undefined") {
			$.each(feature.get("properties"), function(fieldName, fieldValue) {
				if (!["BBOX"].includes(fieldName.toUpperCase())) { 
					clone.find("tbody").first().append("<tr><td class='lf-feature-field-name'>"+fieldName+":</td><td>"+fieldValue+"</td></tr>");
				}
			});
		}
		
		// If the layer fields ARE configured, honour the settings
		if (typeof feature.get("fields") !== "undefined") {
			$.each(feature.get("fields"), function(index, configField) {

				// Only process field if found
				if (feature.get("properties").hasOwnProperty(configField.name) === false) return;
				
				// Build the fieldIndex
				var fieldValueIndex = featureStoreId + "-" + configField.name + "-value";
				
				// Get the field name and field value
				var fieldName = configField.name;
				var fieldValue = feature.get("properties")[configField.name];
				
				// Apply custom field name and field value transforms (if configured)
				if (configField.nameTransform) fieldName = configField.nameTransform(fieldName);
				if (configField.valueTransform) fieldValue = configField.valueTransform(fieldValue);
	
				// If fieldValue is a boolean false, then don't show field record at all
				if (fieldValue === false) return;
					
				// Append field value to existing field record (if configured)
				if (configField.appendToField) {
					var appendToFieldIndex = featureStoreId + "-" + configField.appendToField + "-value";
					var target = clone.find("[fieldIndex='"+appendToFieldIndex+"']")
					target.append(fieldValue);
				
				// Add field name and/or value as configured
				} else {
					// If fieldName is a boolean false, then don't show field name
					if (fieldName === false) {
						clone.find("tbody").first().append("<tr><td fieldIndex='"+fieldValueIndex+"' colspan='2'>"+fieldValue+"</td></tr>");
					} else {
						clone.find("tbody").first().append("<tr><td class='lf-feature-field-name'>"+fieldName+"</td><td fieldIndex='"+fieldValueIndex+"'>"+fieldValue+"</td></tr>");
					}
				}
			
			});
		}
		
		// Show the popup
		showPopup(ol.extent.getCenter(feature.getGeometry().getExtent()), clone);
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
				logger("ERROR", app.plugins.LayerFilter.name + ": Plugin failed to initialize");
				return;
			}
			
			// Set class variables
			app.plugins.LayerFilter.tabNav = tabNav;
			app.plugins.LayerFilter.tabContent = tabContent;
			
			// Load the feature template
			loadTemplate(app.plugins.LayerFilter.featureTemplateFile, function(success, content){
				app.plugins.LayerFilter.featureTemplate = $(content);
			});
			
			// Add filterable layers to filter layer selector
			app.plugins.LayerFilter.addFilterableLayersToSelectControl();
				
			// Log success
			logger("INFO", app.plugins.LayerFilter.name + ": Plugin successfully loaded");
		}
		
		// Add the tab
		addSideBarTab(this.tabName, this.tabContentFile, callback);
	}
}

// Class initialization
app.plugins.LayerFilter = new LayerFilter();
