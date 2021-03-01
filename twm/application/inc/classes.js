/**
 * ##############################################################################
 * ------------------------------------------------------------------------------
 * ------------------------------------------------------------------------------
 * ------------------------------------------------------------------------------
 *
 *          File: classes.js
 *       Creator: Volker Schunicht
 *       Purpose: 
 *	    Required: 
 *       Changes: 
 *		   Notes: 
 *
 * ------------------------------------------------------------------------------
 * ------------------------------------------------------------------------------
 * ------------------------------------------------------------------------------
 * ##############################################################################
 */

/**
 * Class: UberSearch
 * @param () none
 * @returns () nothing
 * Class responsbile for instantiating and executing an uber search
 */
class UberSearch {

	/**
	 * Function: constructor
	 * @param () none
	 * @returns () nothing
	 * Function that initializes the class
	 */
	constructor() {
		// Prevent the default submit for the uberSearch form
		$("#frmUberSearch").on('submit',function(e){
			e.preventDefault();
		});
		
		// Register input category autocomplete
		$("#uberSearch").catcomplete({
			minLength: 3,
			source: this.execute,
			select: function(event, selection) {
				// Get the selected item data
				var data = selection.item.data;
				
				// If the selection has geometry
				if (data.geometry && data.geometry.type && data.geometry.coordinates) {
					
					// Convert to an Openlayers feature
					var olFeature = convertToOpenLayersFeature("GeoJSON", data);
					
					// Highlight and zoom to feature
					highlightFeature(olFeature);
					zoomToFeature(olFeature);
				}	
			}
		});
		
		// Instantiate the available search engines
		this.searchEngines = [];
	}
	
	/**
	 * Function: search
	 * @param () none
	 * @returns () nothing
	 * Function that executes the search
	 */
	execute(request, callback, options) {
		// Define the variables that will track/accumulate the results
		var completeList = [];
		var completedCount = 0;
		
		// Add the ubersearch spinner
		var spinner = new Spinner(app.spinnerOptionsTextInput).spin($("#frmUberSearch")[0]);
		
		// Define the call back function for each individal search engine
		var accumulator = function(list) {
			completeList = completeList.concat(list);
			completedCount++;
			if (completedCount >= app.uberSearch.searchEngines.length) {
				callback(completeList);
				spinner.stop();
			}
		}
		
		// Call each identified query function
		$.each(app.uberSearch.searchEngines, function(index, searchEngine) {
			searchEngine(request, accumulator, options);
		});
	}
}