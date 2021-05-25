class FeatureProximity {
	
	/**
	 * Function: constructor
	 * @param () none
	 * @returns () nothing
	 * Function that initializes the class
	 */
	constructor() {
		this.name = "FeatureProximity";
		this.version = 1.0;
		this.author = "Volker Schunicht";
		this.pcfg = getPluginConfig(this.name);
		this.tabName = (this.pcfg.tabName) ? this.pcfg.tabName : "Find Closest";
		this.tabContentFile = "application/plugins/FeatureProximity/tab-content.html";
		this.featureTemplateFile = "application/plugins/FeatureProximity/feature-template.html";
		this.featureTemplate = "";
		this.resultsTreeData = [];
		this.tabNav; // jQuery element
		this.tabContent // jQuery element
		this.featureStore = [];  // Used to store all of the features and attributes
		this.searchRadiusFeature = new ol.Feature();
		this.searchRadiusLayer = new ol.layer.Vector({
			source: new ol.source.Vector({}),
			style: new ol.style.Style({
				stroke: new ol.style.Stroke({
					color: "rgba(255, 255, 0, 0.5)",
					width: 8
				}),
					fill: new ol.style.Fill({
					color: "rgba(255, 255, 0, 0.2)"
				})
			})
		});
		this.searchRadiusLayer.setZIndex(604);
		app.map.addLayer(this.searchRadiusLayer);
		this.addPlugin();
	}
	
	/**
	 * Function: search
	 * @param (string) request
	 * @param (function) callback
	 * @param (array) options
	 * @returns (array) results
	 * Function that executes the search (may use several providers)
	 */
	search(request, callback, options) {
		// Setup variables
		var completeResultsList = [];
		var providersToSearchCount = 0;
		var providerSearchCompletedCount = 0;
		
		// Define the callback function that will handle all of the search results
		var overallResultsAggregator = function(list) {
			// Merge result to master list
			$.merge(completeResultsList, list);
			
			// Increment the completion count
			providerSearchCompletedCount++;

			// Return complete list if all providers have completed
			if (providerSearchCompletedCount >= providersToSearchCount) {
				callback(completeResultsList);
			}
		}
		
		// Search for a "coordinate pattern" within user input
		var outputSRS = app.map.getView().getProjection().getCode().split(":")[1];
		var location = convertStringToCoordinate(request.term, outputSRS);
		if (location.hasOwnProperty("category")) {
			overallResultsAggregator([{
				value: request.term,
				category: location.category,
				data: {
					type: "Feature",
					geometry: {
						type: "Point",
						crs: {
							type: "EPSG",
							properties: {
								code: location.epsg
							}
						},
						coordinates: location.coordinate
					}
				}
			}]);
		} else {
			overallResultsAggregator([]);
		}
		
		// Search BC GeoCoder if configured
		if (app.plugins.FeatureProximity.pcfg.geoCoderEnabled) {
			providersToSearchCount++;
			app.plugins.FeatureProximity.searchBcGeoCoder(request, overallResultsAggregator, options);
		}
		
		// Search visible (and configured) layers if configured
		if (app.plugins.FeatureProximity.pcfg.visibleLayerSearchEnabled) {
			providersToSearchCount++;
			app.plugins.FeatureProximity.searchLayers(request, overallResultsAggregator, options);
		}
	}
	
	/**
	 * Function: searchBcGeoCoder
	 * @param (string) request
	 * @param (function) callback
	 * @param (array) options
	 * @returns (array) results
	 * Function that executes the search agains the BC geoCoder
	 */
	searchBcGeoCoder(request, callback, options) {
		// Get the map's projection 
		var outputSRS = app.map.getView().getProjection().getCode().split(":")[1];
		
		// Define the parameters
		var params = {
			minScore: 50,
			maxResults: app.plugins.FeatureProximity.pcfg.geoCoderMaxResults,
			echo: 'false',
			brief: true,
			autoComplete: true,
			outputSRS: outputSRS,
			addressString: request.term,
			apikey: app.plugins.FeatureProximity.pcfg.geoCoderApiKey
		};
		$.extend(params, options);
		
		// Query the DataBC GeoCoder
		$.ajax({
			url: "https://geocoder.api.gov.bc.ca/addresses.json",
			data: params,
			timeout: 7500
		})
		
		// Handle a successful result
		.done(function(data) {
			var list = [];
			if(data.features && data.features.length > 0) {
				list = data.features.map(function(item) {
					return {
						value: item.properties.fullAddress,
						category: "BC Places",
						data: item
					}
				});
			}
			callback(list);
		})
		
		// Handle a failure
		.fail(function(jqxhr, settings, exception) {
			callback([]);
		}); 
	}
	
	/**
	 * Function: searchLayers
	 * @param (string) request
	 * @param (function) callback
	 * @param (array) options
	 * @returns (array) results
	 * Function that executes the search on layers
	 */
	searchLayers(request, callback, options) {
		// Setup variables
		var completeLayerResultsList = [];
		var layersToSearchCount = 0;
		var layerSearchCompletedCount = 0;
		
		// Define the callback function that will handle all of the layer search results
		var layerResultsAggregator = function(list) {
			// Merge result to master list
			$.merge(completeLayerResultsList, list);
			
			// Increment the completion count
			layerSearchCompletedCount++;

			// Return complete list if all layers have completed
			if (layerSearchCompletedCount >= layersToSearchCount) {
				callback(completeLayerResultsList);
			}
		}
		
		// Determine how many layers will be searched
		$.each(app.map.getLayers().getArray(), function(index, layer) {
			// Skip layer if not a WMS layer
			if (typeof layer.getSource().getFeatureInfoUrl != "function") return true;
			
			var layerIsSearchable = false;
			if (layer.get("visible")) {
				if (layer.get("fields")) {
					$.each(layer.get("fields"), function(index, configField) {
						if (configField.searchable) {
							layerIsSearchable = true;
						}
					});
				}
			}
			if (layerIsSearchable) layersToSearchCount++;
		});
		
		// Iterate through each map layer
		$.each(app.map.getLayers().getArray(), function(index, layer) {
			
			// Skip layer if not a WMS layer
			if (typeof layer.getSource().getFeatureInfoUrl != "function") return true; 	
			
			// Get the searchable fields and the fields that make up the title for this layer
			var searchableFields = [];
			var titleFields = [];
			if (layer.get("fields")) {
				$.each(layer.get("fields"), function(index, configField) {
					if (configField.searchable) {
						searchableFields.push(configField.name);
					}
					if (configField.title) {
						titleFields.push(configField.name);
					}
				});
			}			
			
			// If the layer is visible and has search fields, query it
			if (layer.get("visible") && searchableFields.length > 0) {			

				// ImageWMS layers have a single url in their source, TileWMS have multiple
				var url = "";
				if (layer.get("source").urls) {
					url = layer.getSource().getUrls()[0];
				} else {
					url = layer.getSource().getUrl();
				}
				
				// Get layer details
				var layers;
				$.each(layer.getSource().getParams(), function(parameterName, parameterValue) {
					if (parameterName.toUpperCase() == "LAYERS") layers = parameterValue;
				});
				
				// Build the CQL filter statement
				var cqlFilter = "";
				$.each(searchableFields, function(index, searchField) {
					if (cqlFilter != "") cqlFilter += " OR ";
					cqlFilter += searchField + " ilike '%" + request.term + "%'";
				});
	
				// Define the parameters
				var params = {
					service: "WFS",
					version: "2.0.0",
					request: "GetFeature",
					typeNames: layers,
					outputFormat: "json",
					count: app.plugins.FeatureProximity.pcfg.visibleLayerSearchMaxResults,
					srsName: app.map.getView().getProjection().getCode(),
					cql_filter: cqlFilter
				};
				$.extend(params, options);
								
				// Issue the request (async)
				$.ajax({
					type: "GET",
					url: url,
					timeout: 7500,
					data: params
				})
				
				// Handle the response
				.done(function(data) {
					// Define an empty list
					var list = [];
					
					// Process results if any
					if(data.features && data.features.length > 0) {
						
						// Map results
						list = data.features.map(function(item) {
							
							// Build the title (value)
							var value = "";
							$.each(titleFields, function(index, titleField) {
								if (value != "") value += " - ";
								value += item.properties[titleField];
							});
							
							// Map
							return {
								value: value,
								category: layer.get("title"),
								data: item
							}
						});
					}
					
					// Send to aggregator
					layerResultsAggregator(list);
				})
				
				// Handle a failure
				.fail(function(jqxhr, settings, exception) {
					layerResultsAggregator([]);
				}); 
			}
		});
		
		// If no searchable layers are configured or visible, return an empty result
		if (layerSearchCompletedCount >= layersToSearchCount) {
			callback(completeLayerResultsList);
		}
	}
	
	/**
	 * Function: registerFeatureLocation
	 * @param (object) target
	 * @param (object) feature
	 * @returns () nothing
	 * Function that gets and registers a features location
	 */
	registerFeatureLocation(target, feature) {
		// Get the feature's centre in Lon/Lat
		var feature4326 = transformFeature(feature, "EPSG:3857", "EPSG:4326"); // Assume feature was delivered in 3857
		var centreLL = getFeatureCentre(feature4326);
		
		// Set the input's lon/lat attributes based on user selection
		target.val(formatCoordinateAsString(centreLL, 4326));
		target.attr("longitude", centreLL[0]);
		target.attr("latitude", centreLL[1]);
		
		// Register the search radius
		app.plugins.FeatureProximity.registerSearchRadius();
	}
	
	/**
	 * Function: registerMapClickLocation
	 * @param (object) target
	 * @returns () nothing
	 * Function that gets and registers where the user clicked on the map
	 */
	registerMapClickLocation(target) {
		// Define function that handles the get map click location
		var mapClickFunction = function(e){
			// Get the click coordinate in EPSG:4326
			var centreLL = ol.proj.transform(e.coordinate, app.map.getView().getProjection(), "EPSG:4326");
			
			// Reset the map's single click function to default
			resetDefaultMapSingleClickFunction();
			
			// Set the input's lon/lat attributes (and display value)
			target.val(formatCoordinateAsString(centreLL, 4326));
			target.attr("longitude", centreLL[0]);
			target.attr("latitude", centreLL[1]);
			
			// Show the search point
			app.plugins.FeatureProximity.registerSearchRadius();
			
			// If mobile, show sidebar
			if (isMobile()) showSidebar();
		}
		
		// Redirect the map's single click function to this mapClickFunction (temporary)
		redirectMapSingleClickFunction("crosshair", mapClickFunction);
		
		// If mobile, hide sidebar
		if (isMobile()) hideSidebar();
	}
	
	/**
	 * Function: registerDeviceLocation
	 * @param (object) target
	 * @returns () nothing
	 * Function that gets and registers the user's device location
	 */
	registerDeviceLocation(target) {
		// Get current location if possible
		if (navigator.geolocation) {
			var options = {
				enableHighAccuracy: true,
				timeout: 5000,
				maximumAge: 0
			};
			var geoLocationSuccess = function(position) {
				// Set the input's lon/lat attributes (and display value) based on geolocation
				target.val(formatCoordinateAsString([position.coords.longitude,position.coords.latitude], 4326));
				target.attr("longitude", position.coords.longitude);
				target.attr("latitude", position.coords.latitude);
				
				// Register the search radius
				app.plugins.FeatureProximity.registerSearchRadius();
			}
			var geoLocationError = function(error) {
				// Display error/suggestion
				var errorNotice = bootbox.dialog({
					title: "Error",
					message: "<p class='text-center'>Cannot determine your current location.<br><br>Please turn on location services.<br></p>",
					closeButton: true
				});
			}
			navigator.geolocation.getCurrentPosition(geoLocationSuccess, geoLocationError, options);
		}
	}
	
	/**
	 * Function: registerSearchSelectionLocation
	 * @param (object) target
	 * @param (object) selection
	 * @returns () nothing
	 * Function that registers the user's search selection
	 */
	registerSearchSelectionLocation(target, selection) {
		// Transform the selection into a feature and get it's centre in Lon/Lat
		var olFeature = convertToOpenLayersFeature("GeoJSON", selection.data);
		var olFeature4326 = transformFeature(olFeature, "EPSG:3857", "EPSG:4326"); // Assume feature was delivered in 3857
		var centreLL = getFeatureCentre(olFeature4326);
		
		// Set the input's lon/lat attributes based on user selection
		target.attr("longitude", centreLL[0]);
		target.attr("latitude", centreLL[1]);
		
		// Register the search radius
		app.plugins.FeatureProximity.registerSearchRadius();
	}
	
	/**
	 * Function: registerSearchRadius
	 * @param () none
	 * @returns () nothing
	 * Function that registers the search radius
	 */
	registerSearchRadius() {
		// Disable search button
		$("#fp-overlay-search-btn").prop('disabled', true);
		
		// Clear results
		$("#fp-results").empty();
		$("#fp-no-results").hide();
		
		// Clear existing search radius
		app.plugins.FeatureProximity.searchRadiusLayer.getSource().clear();
		
		// Get the search from "lat/lon".  Bail if empty.
		var sLongitude = $(".fp-search-point .fp-location-input").attr("longitude");
		var sLatitude = $(".fp-search-point .fp-location-input").attr("latitude");
		if (!sLongitude || !sLatitude) return;
		
		// Get the search distance in metres
		var sDistanceMetres = $("#fp-search-distance-input").val() * 1000;

		// Adjust radius for current projection (important especially for 3857)
		var radius = sDistanceMetres / ol.proj.getPointResolution(app.map.getView().getProjection(), 1, ol.proj.transform([sLongitude, sLatitude], "EPSG:4326", app.map.getView().getProjection()));
		
		// Build a search radius feature using the search from location and the specified radius (in map projection)
		var searchCircle = new ol.geom.Circle(ol.proj.transform([sLongitude, sLatitude], "EPSG:4326", app.map.getView().getProjection()), radius);
		var searchPolygon = ol.geom.Polygon.fromCircle(searchCircle, 24); // Use 24 sides to reduce the length of the search query string later on
		app.plugins.FeatureProximity.searchRadiusFeature = new ol.Feature(searchPolygon);
		
		// Show that search radius polygon (if configured for app)
		if (app.plugins.FeatureProximity.pcfg.showSearchRadiusOnMap) {
			app.plugins.FeatureProximity.searchRadiusLayer.getSource().addFeature(app.plugins.FeatureProximity.searchRadiusFeature);
		}
		
		// Zoom to that search radius feature
		zoomToFeature(app.plugins.FeatureProximity.searchRadiusFeature);
		
		// Enable search button
		$("#fp-overlay-search-btn").prop('disabled', false);
	}
	
	/**
	 * Function: findFeatures
	 * @param () none
	 * @returns () nothing
	 * Function finds features using the specified search parameters
	 */
	findFeatures() {
		// Get the search distance in metres and alert if <= 0
		var sDistanceMetres = $("#fp-search-distance-input").val() * 1000;
		if (sDistanceMetres <= 0) {
			var errorNotice = bootbox.dialog({
				title: "Error",
				message: "<p class='text-center'>Search Distance must be greater than 0<br></p>",
				closeButton: true
			});
			return;
		}
		
		// Clear the results tree and feature store
		app.plugins.FeatureProximity.featureStore = [];
		app.plugins.FeatureProximity.resultsTreeData = [];
		
		// Clear results
		$("#fp-results").empty();
		$("#fp-no-results").hide();
				
		// Add the tab spinner
		var spinner = new Spinner(app.spinnerOptionsMedium).spin($(app.plugins.FeatureProximity.tabContent)[0]);
		
		// Define misc variables
		var layersToSearchCount = 0;
		var layerSearchCompletedCount = 0;
		
		// Define the callback function that runs the aggregator after each layer returns a result
		var callback = function(layer, features){
			// Only add results to results tree array if a valid layer
			if (layer) app.plugins.FeatureProximity.addToResultsTreeData(layer, features);

			// Increment the counter
			layerSearchCompletedCount++;

			if (layerSearchCompletedCount >= layersToSearchCount) {
				// Show results
				app.plugins.FeatureProximity.showResults();
				
				// Hide the search radius if present
				app.plugins.FeatureProximity.searchRadiusLayer.getSource().clear();
				
				spinner.stop();
			}
		}
		
		// Determine how many layers there are to search
		$.each(app.map.getLayers().getArray(), function(index, layer) {
			// Count WMS layers
			if (layer.get("visible") === true && typeof layer.getSource().getFeatureInfoUrl == "function") {
				layersToSearchCount++;
			}
		});
		
		// If there are no layers to search, run the result compiler to show no results
		if (layersToSearchCount == 0) callback(null, []);

		// Loop through all of the map layers
		$.each(app.map.getLayers().getArray(), function(index, layer) {
			
			// Only process WMS layers (Tile or Image)
			if (layer.get("visible") === true && typeof layer.getSource().getFeatureInfoUrl == "function") {
		
				// Define the search url (modify to point to WFS if required)
				if (layer.getSource() instanceof ol.source.TileWMS) {
					var searchUrl = layer.getSource().getUrls()[0]; // TileWMS
				} else if (layer.getSource() instanceof ol.source.ImageWMS) {
					var searchUrl = layer.getSource().getUrl(); // ImageWMS
				} else {
					logger("WARN", "Could not determine search url for layer " + layer.get("title"));
					return;
				}
				var searchUrl = searchUrl.replace(new RegExp("/ows", "ig"), "/wfs");
				
				// Define the layer(s), and pre-existing CQL filters
				var searchLayerName;
				var existingCqlFilter;
				$.each(layer.getSource().getParams(), function(parameterName, parameterValue) {
					if (parameterName.toUpperCase() == "LAYERS") searchLayerName = parameterValue;
					if (parameterName.toUpperCase() == "CQL_FILTER") existingCqlFilter = parameterValue;
				});
				
				// Get the name of the geometry column
				var geometryField;
				$.each(layer.get("attributes"), function(index, attribute) {
					if (attribute.type.startsWith("gml:")) {
						geometryField = attribute.name;
					}
				});

				// Skip current layer if native projection is not defined
				if (layer.get("nativeProjection") == null) callback(layer, []);
				
				// Transform the search polygon (circle) into the current layer's native projection and then convert into WKT
				var searchPolygonInLayerNativeProj = transformFeature(app.plugins.FeatureProximity.searchRadiusFeature, app.map.getView().getProjection().getCode(), layer.get("nativeProjection"));
				var wktFormat = new ol.format.WKT();
				var searchPolygonWKT = wktFormat.writeGeometry(searchPolygonInLayerNativeProj.getGeometry());
				
				// Build the CQL_FILTER statement 
				var cqlFilter = "INTERSECTS("+geometryField+", "+searchPolygonWKT+")";
				
				// Honour an existing CQL filter if need be
				if (existingCqlFilter) cqlFilter = "(" + cqlFilter + ") AND (" + existingCqlFilter + ")";
				
				// Build the request options
				var options = {
					service: "WFS",
					version: "2.0.0",
					request: "GetFeature", 
					typeNames: searchLayerName,
					outputFormat: "application/json",
					count: app.plugins.FeatureProximity.pcfg.proximitySearchMaxResults,
					srsName: app.map.getView().getProjection().getCode(),
					cql_filter: cqlFilter
				}

				// Issue the request
				$.ajax({
					type: "GET",
					url: searchUrl,
					dataType: "json",
					data: options
				})
				
				// Handle the response
				.done(function(response) {
					callback(layer, response.features);
				})
				
				// Handle a failure
				.fail(function(jqxhr, settings, exception) {
					logger("ERROR", app.plugins.FeatureProximity.name + ": Error querying " + layer.get("title"));
				}); 	
			}
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
		parentNode.class = "fp-treeview-layer";
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
			app.plugins.FeatureProximity.featureStore.push(olFeature);
			
			// Build the child (feature) node
			var childNode = new Object();
			childNode.id = "fp-feature-" + (app.plugins.FeatureProximity.featureStore.length - 1);
			childNode.text = featureTitle;
			childNode.icon = "oi oi-map";
			childNode.class = "fp-treeview-feature";
			
			// Add child node to parent (layer) node
			parentNode.nodes.push(childNode);
		});
		
		// Add the parent to the results tree data array
		app.plugins.FeatureProximity.resultsTreeData.push(parentNode);
	}
	
	/**
	 * Function: showResults
	 * @param () none
	 * @returns () nothing
	 * Function that show the results in a tree view
	 */
	showResults() {	
		// Show tree if there are results
		if (app.plugins.FeatureProximity.resultsTreeData.length > 0) {
			// Add a tree view div
			$("#fp-results").append("<div id='fp-tree'></div>");
			
			// Register and build the treeview
			$("#fp-tree").bstreeview({
				data: app.plugins.FeatureProximity.resultsTreeData,
				expandIcon: 'oi oi-minus',
				collapseIcon: 'oi oi-plus',
				indent: 1.6,
				openNodeLinkOnNewTab: true
			});
			
			// Add click event handlers to all of the features
			$(".fp-treeview-feature").click(function(){
				var featureStoreId = this.id.replace("fp-feature-", "");
				app.plugins.FeatureProximity.showFeaturePopup(featureStoreId);
			});
			
			// Add hover event handlers to all of the features
			$(".fp-treeview-feature").hover(
				function(){
					var featureStoreId = this.id.replace("fp-feature-", "");
					highlightFeature(app.plugins.FeatureProximity.featureStore[featureStoreId]);
				},
				function(){
					clearHighlightedFeatures();
				}
			);
			
		// Show no results
		} else {
			$("#fp-no-results").show();
		}
	}
	
	/**
	 * Function: showFeaturePopup
	 * @param (integer) featureStoreId
	 * @returns () nothing
	 * Function that populates and shows a feature popup
	 */
	showFeaturePopup(featureStoreId) {
		// Get the feature
		var feature = app.plugins.FeatureProximity.featureStore[featureStoreId];
		
		// Make a clone of the feature template
		var clone = app.plugins.FeatureProximity.featureTemplate.clone(true);
		
		// Link (attribute) the feature store ID to the table
		clone.attr("featureStoreId", featureStoreId);
		
		// Insert feature title into the clone
		clone.find(".fp-feature-title").append(feature.get("title"));
		
		// Enable the navigate to button if the plugin exists
		if (app.plugins.DynamicRouter) clone.find(".FeatureProximityNavigateTo").show();
		
		// Register the navigate to click event handler if the plugin exists
		if (app.plugins.DynamicRouter) {
			clone.find(".FeatureProximityNavigateTo").on("click", function(e) {
				// Remove all pre existing way points
				$(".dr-way-point").remove();
				
				// Get the search location details
				var sLongitude = $(".fp-search-point .fp-location-input").attr("longitude");
				var sLatitude = $(".fp-search-point .fp-location-input").attr("latitude");
				var sText = $(".fp-search-point .fp-location-input").val();
				if (!sLongitude || !sLatitude) return;
				
				// Set the router's start location equal to the search location
				$(".dr-start-point .dr-location-input").attr("longitude", sLongitude);
				$(".dr-start-point .dr-location-input").attr("latitude", sLatitude);
				$(".dr-start-point .dr-location-input").val(sText);
				
				// Add current feature location into the end location input
				var featureStoreId = $(this).closest("table").attr("featureStoreId");
				var locationEndInput = $(".dr-end-point .dr-location-input");
				app.plugins.DynamicRouter.registerFeatureLocation(locationEndInput, app.plugins.FeatureProximity.featureStore[featureStoreId]);
				
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
					clone.find("tbody").first().append("<tr><td class='fp-feature-field-name'>"+fieldName+":</td><td>"+fieldValue+"</td></tr>");
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
						clone.find("tbody").first().append("<tr><td class='fp-feature-field-name'>"+fieldName+"</td><td fieldIndex='"+fieldValueIndex+"'>"+fieldValue+"</td></tr>");
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
				logger("ERROR", app.plugins.FeatureProximity.name + ": Plugin failed to initialize");
				return;
			}
			
			// Set class variables
			app.plugins.FeatureProximity.tabNav = tabNav;
			app.plugins.FeatureProximity.tabContent = tabContent;
			
			// Register the get location from map buttons
			$(".fp-search-point .fp-get-location-from-map-btn").click(function(){ 
				var associatedInput = $(this).parent().siblings(".fp-location-input");
				app.plugins.FeatureProximity.registerMapClickLocation(associatedInput);
			});
			
			// Register the category autocompletes
			$(".fp-search-point .fp-location-input").catcomplete({
				minLength: 3,
				source: app.plugins.FeatureProximity.search,
				select: function(event, selection) {
					app.plugins.FeatureProximity.registerSearchSelectionLocation($(this), selection.item);
				}
			});
			
			// Register the geolocator buttons
			$(".fp-search-point .fp-get-geolocation-btn").click(function(){ 
				var associatedInput = $(this).parent().siblings(".fp-location-input");
				app.plugins.FeatureProximity.registerDeviceLocation(associatedInput);
			});

			// Register the clear input buttons
			$(".fp-search-point .fp-clear-input-btn").click(function(){ 
				var associatedInput = $(this).parent().siblings(".fp-location-input");
				associatedInput.val("");
				associatedInput.attr("longitude", null);
				associatedInput.attr("latitude", null);
				app.plugins.FeatureProximity.searchRadiusLayer.getSource().clear();
				$("#fp-overlay-search-btn").prop('disabled', true);
				
				// Clear results
				$("#fp-results").empty();
				$("#fp-no-results").hide();
			});
			
			// Set the default search distance as per the application configuration
			$("#fp-search-distance-input").val(app.plugins.FeatureProximity.pcfg.defaultSearchRadiusKm);
			
			// Enable/disable the search distance input as per the application configuration
			$("#fp-search-distance-input").prop("disabled", !app.plugins.FeatureProximity.pcfg.searchRadiusEditable);
			
			// Constrain the search distance input to numbers within a range
			$("#fp-search-distance-input").on("input", function() {
				this.value = this.value.replace(/[^0-9.]/g,'').replace(/(\..*)\./g, '$1');
				app.plugins.FeatureProximity.registerSearchRadius();
			});
			
			// Register search button
			$("#fp-overlay-search-btn").click(function(){
				app.plugins.FeatureProximity.findFeatures();
			});
			
			// Load the feature template
			loadTemplate(app.plugins.FeatureProximity.featureTemplateFile, function(success, content){
				app.plugins.FeatureProximity.featureTemplate = $(content);
			});
			
			// Log success
			logger("INFO", app.plugins.FeatureProximity.name + ": Plugin successfully loaded");
		}
		
		// Add the tab
		addSideBarTab(this.tabName, this.tabContentFile, callback);
	}
}

// Class initialization
app.plugins.FeatureProximity = new FeatureProximity();
