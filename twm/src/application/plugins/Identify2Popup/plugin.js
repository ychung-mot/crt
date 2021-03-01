class Identify2Popup {

	/**
	 * Function: constructor
	 * @param () none
	 * @returns () nothing
	 * Function that initializes the class
	 */
	constructor() {
		this.name = "Identify2Popup";
		this.version = 1.0;
		this.author = "Volker Schunicht";
		this.pcfg = getPluginConfig(this.name);
		this.featureTemplateFile = "application/plugins/Identify2Popup/feature-template.html";
		this.featureTemplate = "";
		this.featureStore = [];
		this.popupContent = $("<div></div>");
		this.addPlugin();
	}
	
	/**
	 * Function: resultsAggregator
	 * @param (object) layer
	 * @param (object) features
	 * @returns () nothing
	 * Function that aggregates the results from each layer searched
	 */
	resultsAggregator(layer, features) {
		
		// Iterate through features
		$.each(features, function(index, feature) {
			
			// Get the geometry field name
			var geometryFieldName = (feature.hasOwnProperty("geometry_name")) ? feature.geometry_name : "";
			
			// Create and add the feature to the feature store
			var olFeature = convertToOpenLayersFeature("GeoJSON", feature);
			app.plugins.Identify2Popup.featureStore.push(olFeature);
			var featureStoreId = app.plugins.Identify2Popup.featureStore.length - 1;
			
			// Build the feature title and append the keyField value if configured and it exists
			var featureTitle = layer.get("title");
			if (layer.get("fields")) {
				$.each(layer.get("fields"), function(index, configField) {
					if (configField.name) {
						$.each(feature.properties, function(fieldName, fieldValue) {
							if (configField.name == fieldName) {
								if (configField.title) {
									featureTitle += " - <i>"+fieldValue+"</i>";
								} 
							}
						});
					}
				});
			} else {
				featureTitle += " [" + (index + 1) + "]";
			}

			// Make a clone of the feature template
			var clone = app.plugins.Identify2Popup.featureTemplate.clone(true);
			
			// Link (attribute) the feature ID to the table
			clone.attr("featureStoreId", featureStoreId);
			
			// Insert feature title into the clone
			clone.find(".i2p-feature-title").append(featureTitle);
			
			// Hide feature table (clone) if its not the first one
			if (featureStoreId > 0 ) clone.hide();
			
			// Enable the navigate to button if the plugin exists
			if (app.plugins.DynamicRouter) clone.find(".Identify2PopupNavigateTo").show();

			// If the layer fields ARE NOT configured, add them in raw
			if (!layer.get("fields")) {
				$.each(feature.properties, function(fieldName, fieldValue) {
					if (!["BBOX", geometryFieldName.toUpperCase()].includes(fieldName.toUpperCase())) { 
						clone.find("tbody").first().append("<tr><td class='i2p-feature-field-name'>"+fieldName+":</td><td>"+fieldValue+"</td></tr>");
					}
				});
			}
			
			// If the layer fields ARE configured, honour the settings
			if (layer.get("fields")) {
				$.each(layer.get("fields"), function(index, configField) {
					
					// Only process field if found
					if (feature.properties.hasOwnProperty(configField.name) === false) return;
					
					// Build the fieldIndex
					var fieldValueIndex = featureStoreId + "-" + configField.name + "-value";
					
					// Get the field name and field value
					var fieldName = configField.name;
					var fieldValue = feature.properties[configField.name];
					
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
							clone.find("tbody").first().append("<tr><td class='i2p-feature-field-name'>"+fieldName+"</td><td fieldIndex='"+fieldValueIndex+"'>"+fieldValue+"</td></tr>");
						}
					}
				
				});
			}
			
			// Append clone to the popup content
			app.plugins.Identify2Popup.popupContent.append(clone);
		});
	}

	/**
	 * Function: registerResultEventHandlers
	 * @param () none
	 * @returns () nothing
	 * Function that registers each result's event handlers
	 */
	registerResultEventHandlers() {
		// Register all of the navigate to click event handlers
		$(".Identify2PopupNavigateTo").on("click", function(e) {
			// Remove all pre existing way points
			$(".dr-way-point").remove();
			
			// Add device current location into the start locinput
			var locationStartInput = $(".dr-start-point .dr-location-input");
			app.plugins.DynamicRouter.registerDeviceLocation(locationStartInput);
			
			// Add current feature location into the end location input
			var featureStoreId = $(this).closest("table").attr("featureStoreId");
			var locationEndInput = $(".dr-end-point .dr-location-input");
			app.plugins.DynamicRouter.registerFeatureLocation(locationEndInput, app.plugins.Identify2Popup.featureStore[featureStoreId]);
		});
		
	}
	
	/**
	 * Function: showResult
	 * @param () none
	 * @returns () nothing
	 * Function that shows the result (in a paginated popup if required)
	 */
	showResult() {
		// Bail if no results
		if (app.plugins.Identify2Popup.featureStore.length == 0) return;
				
		// Add paging div if required	
		if (app.plugins.Identify2Popup.featureStore.length > 1) {
			var pager = $("<div></div>");
			pager.attr("id", "i2p-paging");
			pager.attr("currentFeatureStoreId", 0);
			pager.attr("maxFeatureStoreId", (app.plugins.Identify2Popup.featureStore.length - 1));
			pager.append("<span class='oi oi-chevron-left' title='Previous' onclick='app.plugins.Identify2Popup.switchPage(-1)'></span>");
			pager.append("<span id='i2p-paging-text'>1 of " + app.plugins.Identify2Popup.featureStore.length + "</span>");
			pager.append("<span class='oi oi-chevron-right' title='Next' onclick='app.plugins.Identify2Popup.switchPage(1)'></span>");
			app.plugins.Identify2Popup.popupContent.append(pager);
		}
		
		// Get the feature
		var feature = app.plugins.Identify2Popup.featureStore[0];
		
		// Get the feature centre
		var featureCentre = getFeatureCentre(feature);
		
		// Highlight the current feature
		highlightFeature(feature);
		
		// Show the popup
		showPopup(featureCentre, app.plugins.Identify2Popup.popupContent);
		
		// Register button handlers
		app.plugins.Identify2Popup.registerResultEventHandlers();
	}
	
	/**
	 * Function: switchPage
	 * @param (integer) direction
	 * @returns () nothing
	 * Function that switches
	 */
	switchPage(direction) {
		// Determine which record to switch to
		var currentFeatureStoreId = parseInt($("#i2p-paging").attr("currentFeatureStoreId"));
		var maxFeatureStoreId = parseInt($("#i2p-paging").attr("maxFeatureStoreId"));
		var newCurrentFeatureStoreId = currentFeatureStoreId + direction;
		if (newCurrentFeatureStoreId > maxFeatureStoreId) newCurrentFeatureStoreId = 0;
		if (newCurrentFeatureStoreId < 0) newCurrentFeatureStoreId = (app.plugins.Identify2Popup.featureStore.length - 1);
		
		// Update the new current record
		$("#i2p-paging").attr("currentFeatureStoreId", newCurrentFeatureStoreId);
		
		// Update display
		$("#i2p-paging-text").html((newCurrentFeatureStoreId + 1) + " of " + app.plugins.Identify2Popup.featureStore.length);
		
		// Get the feature
		var feature = app.plugins.Identify2Popup.featureStore[newCurrentFeatureStoreId];
		
		// Get the feature centre
		var featureCentre = getFeatureCentre(feature);
		
		// Highlight the current feature
		highlightFeature(feature);
		
		// Reposition popup to feature center
		setTimeout(function(){
			app.popupOverlay.setPosition(featureCentre);
			doLayout();
		}, 50);
		
		// Loop through all of the feature tables.  Show the active one, hide the rest.
		$.each($('.i2p-feature-table'), function(index, element) { 
			if ($(element).attr("featureStoreId") == newCurrentFeatureStoreId) {
				$(element).show();
			} else {
				$(element).hide();
			}
		});
	}
	
	/**
	 * Function: identify
	 * @param (object) event
	 * @returns () nothing
	 * Function that adds the plugin tab to the sidebar
	 */
	identify(event) {
		// Reset the popup content
		app.plugins.Identify2Popup.popupContent = $("<div></div>");
		
		// Reset the feature store
		app.plugins.Identify2Popup.featureStore = [];
		
		// Define misc variables
		var layersToSearchCount = 0;
		var layerSearchCompletedCount = 0;
		
		// Define the callback function that runs the aggregator after each layer returns a result
		var callback = function(layer, features){
			layerSearchCompletedCount++;
			if (features.length > 0) app.plugins.Identify2Popup.resultsAggregator(layer, features);
			if (layerSearchCompletedCount >= layersToSearchCount) app.plugins.Identify2Popup.showResult();
		}
		
		// Determine how many layers there are to search
		$.each(app.map.getLayers().getArray(), function(index, layer) {
			// Count Vector layers
			if (layer.get("visible") === true && layer.get("title") && layer instanceof ol.layer.Vector) {
				layersToSearchCount++;
			}
			
			// Count WMS layers
			if (layer.get("visible") === true && typeof layer.getSource().getFeatureInfoUrl == "function") {
				layersToSearchCount++;
			}
		});
		
		// If there are no layers to search, run the result compiler to show no results
		if (layersToSearchCount == 0) callback({}, []);

		// Loop through all of the map layers
		$.each(app.map.getLayers().getArray(), function(index, layer) {
			
			// Vector :: Perform a GetFeature
			if (layer.get("visible") === true && layer.get("title") && layer instanceof ol.layer.Vector) {
				// Get all vector features close to click
				var pixel = app.map.getEventPixel(event.originalEvent);
				var foundFeatures = app.map.getFeaturesAtPixel(pixel,{
					hitTolerance: 10, 
					layerFilter: function(l) { 
						if (ol.util.getUid(l) == ol.util.getUid(layer)) return true; else return false;
					}
				});
				
				// Convert returned features into a format similar to what GetFeatureInfo returns (so we can use the same aggregator function)
				var cf = [];
				$.each(foundFeatures, function(index, feature) {
					var f = {};
					f.type = "Feature";
					f.id = feature.getId();
					f.geometry_name = feature.getGeometryName();
					f.geometry = {};
					f.geometry.type = feature.getGeometry().getType();
					f.geometry.coordinates = feature.getGeometry().getCoordinates();
					f.properties = feature.getProperties();
					cf.push(f);
				});
				callback(layer, cf);
			}
			
			// WMS :: Perform a GetFeatureInfo
			if (layer.get("visible") === true && typeof layer.getSource().getFeatureInfoUrl == "function") {
				// Build the request url
				var gfiUrl = layer.getSource().getFeatureInfoUrl(
					event.coordinate,
					app.map.getView().getResolution(),
					app.map.getView().getProjection().getCode(),
					{
						"INFO_FORMAT": "application/json",
						"FEATURE_COUNT": app.plugins.Identify2Popup.pcfg.maxResults
					}
				);
								
				// Issue the request
				$.ajax({
					type: "GET",
					url: gfiUrl,
					dataType: "json",
					timeout: 5000
				})
				
				// Handle the response
				.done(function(response) {
					callback(layer, response.features);
				})
				
				// Handle a failure
				.fail(function(jqxhr, settings, exception) {
					callback(layer, []);
					logger("ERROR", "I2P: Error querying " + layer.get("title"));
				});
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
		var callback = function(success, content){
			// Bail if failed
			if (!success) {
				logger("ERROR", app.plugins.Identify2Popup.name + ": Plugin failed to initialize");
				return;
			}
			
			// Set the feature template variable to the returned html content
			app.plugins.Identify2Popup.featureTemplate = $(content);
	
			// Register this plugin as the default map single click function
			app.defaultMapSingleClickFunction = app.plugins.Identify2Popup.identify;

			// Log success
			logger("INFO", app.plugins.Identify2Popup.name + ": Plugin successfully loaded");
		}
		
		// Load the feature template
		loadTemplate(this.featureTemplateFile, callback);
	}
}

// Class initialization
app.plugins.Identify2Popup = new Identify2Popup();