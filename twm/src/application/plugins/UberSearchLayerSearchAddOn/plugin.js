class UberSearchLayerSearchAddOn {
	
	/**
	 * Function: constructor
	 * @param () none
	 * @returns () nothing
	 * Function that initializes the class
	 */
	constructor() {
		this.name = "UberSearchLayerSearchAddOn";
		this.version = 1.0;
		this.author = "Volker Schunicht";
		this.pcfg = getPluginConfig(this.name);
		this.addPlugin();
	}
	
	/**
	 * Function: search
	 * @param (string) request
	 * @param (function) callback
	 * @param (array) options
	 * @returns (array) results
	 * Function that executes the search
	 */
	search(request, callback, options) {
		// Setup variables
		var completeList = [];
		var layersToSearchCount = 0;
		var layerSearchCompletedCount = 0;
		
		// Define the callback function that will handle all of the layer search results
		var resultsAggregator = function(list) {
			// Merge result to master list
			$.merge(completeList, list);
			
			// Increment the completion count
			layerSearchCompletedCount++;

			// Return complete list if all layers have completed
			if (layerSearchCompletedCount >= layersToSearchCount) {
				callback(completeList);
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
					count: app.plugins.UberSearchLayerSearchAddOn.pcfg.maxResults,
					srsName: app.map.getView().getProjection().getCode(),
					cql_filter: cqlFilter
				};
				$.extend(params, options);
								
				// Issue the request (async)
				$.ajax({
					type: "GET",
					url: url,
					timeout: 15000,
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
					resultsAggregator(list);
				})
				
				// Handle a failure
				.fail(function(jqxhr, settings, exception) {
					resultsAggregator([]);
				}); 

			}
		});
		
		// If no searchable layers are configured or visible, return an empty result
		if (layerSearchCompletedCount >= layersToSearchCount) {
			callback(completeList);
		}
	}
	
	/**
	 * Function: addPlugin
	 * @param () none
	 * @returns () nothing
	 * Function that adds the plugin
	 */
	addPlugin() {
		// Extend ubersearch
		app.uberSearch.searchEngines.push(this.search);
		
		// Show the uberseach input if not already
		$("#frmUberSearch").show();
		
		// Log success
		logger("INFO", this.name + ": Plugin successfully loaded");
	}
	
}

// Class initialization
app.plugins.UberSearchLayerSearchAddOn = new UberSearchLayerSearchAddOn();