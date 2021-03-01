class LayerEditor {

	/**
	 * Function: constructor
	 * @param () none
	 * @returns () nothing
	 * Function that initializes the class
	 */
	constructor() {
		this.name = "LayerEditor";
		this.version = 1.0;
		this.author = "Volker Schunicht";
		this.pcfg = getPluginConfig(this.name);
		this.tabName = (this.pcfg.tabName) ? this.pcfg.tabName : "Layer Editor";
		this.tabContentFile = "application/plugins/LayerEditor/tab-content.html";
		this.tabNav; // jQuery element
		this.tabContent; // jQuery element
		this.interactions = new Object();
		this.editableLayer;
		this.addPlugin(); // Initializes the plugin
	}


	/**
	 * Function: turnIdentOff
	 * @param () none
	 * @returns () nothing
	 * Turn the global identication off, only if it is on.
	 */
	turnIdentOff() {
		if (app.eventKeys.singleClick) {
			ol.Observable.unByKey(app.eventKeys.singleClick);
		}
	}

	/**
	 * Function: turnDrawOff
	 * @param () none
	 * @returns () nothing
	 * Turn any drawing events off
	 */
	turnDrawOff() {
		if (this.draw) {
			app.map.removeInteraction(this.draw);
		}
		if (this.snap) {
			app.map.removeInteraction(this.snap);
		}
	}


	/**
	 * Function: turnModifyOff
	 * @param () none
	 * @returns () nothing
	 * Turn any modifying events off.
	 * No snapping for now.
	 */
	turnModifyOff() {
		if (this.modify) {
			app.map.removeInteraction(this.modify);
		}
	}

	/**
	 * Function: turnDeleteOff
	 * @param () none
	 * @returns () nothing
	 * Turn any delete interactions off
	 */
	turnDeleteOff() {
		if (this.delete) {
			app.map.removeInteraction(this.delete);
		}
	}

	changeEditing (action,acetate) {

		const addIdentify = () => {
			this.turnDrawOff();
			this.turnModifyOff();
			this.turnDeleteOff();
			resetDefaultMapSingleClickFunction();
		};


		// Need to be able to turn this stuff on and off
		const addDrawing = (feature) => {
			this.turnIdentOff();
			this.turnDrawOff();
			this.turnModifyOff();
			this.turnDeleteOff();

			this.draw = new ol.interaction.Draw({
				source: this.source,
				type: feature
			});

			this.draw.on('drawend', (e) => {
				let feature = e.feature;
				feature.setProperties({
					name: 'blah',
					type: 'plastic',
					payload: 'lemonade',
					last_insp: '2021-02-17T10:34:32Z',
					next_insp: '2021-02-17T10:34:32Z',
					valume: 1200,
					diameter: 1.34,
					above_grnd: 1
				});

				const addition = this.format.writeTransaction([feature],null,null,{
					gmlOptions: {
						srsName: 'EPSG:3857'
					},
					featureNS: 'cite',
					featureType: 'pipelines'
				})
				const data = new XMLSerializer().serializeToString(addition);
				$.ajax({
					type: 'POST',
					url: 'http://localhost:8080/geoserver/wfs',
					data: data,
					contentType: 'text/xml',
					success: res => console.log(this.format.readTransactionResponse(res))
				})
			});

			app.map.addInteraction(this.draw);

			this.snap = new ol.interaction.Snap({source:this.source});
			app.map.addInteraction(this.snap);
		};

		// Modify features
		const addModifying = () => {
			this.turnIdentOff();
			this.turnDrawOff();
			this.turnDeleteOff();
			this.modify = new ol.interaction.Modify({source:this.source});
			app.map.addInteraction(this.modify);

			this.modify.on('modifyend', (e) => {
				console.log('modify end', e.features);
			});
		};

		// Remove features
		const addRemoving = () => {
			this.turnIdentOff();
			this.turnDrawOff();
			this.turnModifyOff();
			this.delete = new ol.interaction.Select({layers: [acetate]});
			app.map.addInteraction(this.delete);
			this.delete.getFeatures().on('add', (f) => {
				this.source.removeFeature(f.element);
				console.log('delete',f.element)
			});
		};

		switch (action) {
			case 'Polygon': // Fall-through for all feature additions
			case 'Point':
			case 'LineString':
			case 'Circle':
				addDrawing(action);
				break;
			case 'Identify': // Turn the default Identify back on
				addIdentify();
				break;
			case 'Delete':
				addRemoving(); // Deleting features
				break;
			case 'Modify':
				addModifying(); // Modifying features
				break;
			default:
				addIdentify(); // Turn the default Identify back on
		};

	}
	
	/**
	 * Function: populateEditableLayerSelect
	 * @param () none
	 * @returns () nothing
	 * Function that populates the editable layer select control with editable layers
	 */
	populateEditableLayerSelect() {

		/*********************/
		/* Jamie's new stuff */
		/*********************/
		// this.source = new ol.source.Vector;
		this.source = new ol.source.Vector({
			format: new ol.format.GeoJSON,
			url: () => {
				return (`
				http://localhost:8080/geoserver/wfs?service=WFS&version=1.1.1&request=GetFeature&typename=cite:pipelines&outputFormat=application/json&srsname=EPSG:4326&bbox=-140,45,-112,60,EPSG:4326
				`);
			},
			strategy: ol.loadingstrategy.bboxStrategy
		});

		const acetate = new ol.layer.Vector({
			source: this.source,
			style: new ol.style.Style({
				fill: new ol.style.Fill({
					color: 'rgba(255, 255, 255, 0.3)'
				}),
				stroke: new ol.style.Stroke({
					color: '#38afff',
					width: 2
				}),
				image: new ol.style.Circle({
					radius: 7,
					stroke: new ol.style.Stroke({
						color: 'white',
						width: 2
					}),
					fill: new ol.style.Fill({
						color: '#38afff'
					})
				})
			})
		});

		acetate.setZIndex(500);

		this.format = new ol.format.WFS({
			featureNS: 'cite',
			featureType: 'pipelines'
		})

		app.map.addLayer(acetate);


		$('.form-check').change((e) => {
			this.changeEditing(e.target.value,acetate);
		});

		/****************************/
		/* End of Jamie's new stuff */
		/****************************/


		// Empty the select control
		$("#le-editable-layer-select").empty();
		
		// Add default no editable layer option
		$("#le-editable-layer-select").append(new Option("No Editable Layer", -1));
		
		// loop through the map layers
		var layerId;
		$.each(app.map.getLayers().getArray(), function(index, layer) {
			
			// If the layer is editable
			if (layer.get("editable")) {
				// Get the layer ID
				layerId = ol.util.getUid(layer);
				
				// Add it as an option
				$("#le-editable-layer-select").append(new Option(layer.get("title"), layerId));
			}				
		});
	}
	
	/**
	 * Function: setEditableLayer
	 * @param (integer) layerId
	 * @returns () nothing
	 * Function that sets the editable layer
	 */
	setEditableLayer(layerId) {
		// Set the editable layer
		$.each(app.map.getLayers().getArray(), function(index, layer) {
			if (ol.util.getUid(layer) == layerId) {
				app.plugins.LayerEditor.editableLayer = layer;
			}
		});
		
		// Redirect the default single click function
		//redirectMapSingleClickFunction("pointer", function(){});
		
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
				logger("ERROR", app.plugins.LayerEditor.name + ": Plugin failed to initialize");
				return;
			}
			
			// Set class variables
			app.plugins.LayerEditor.tabNav = tabNav;
			app.plugins.LayerEditor.tabContent = tabContent;
			
			// Populate the editable layer select
			app.plugins.LayerEditor.populateEditableLayerSelect();
			
			// Register the editable layer change handler
			$("#le-editable-layer-select").on('change', function(e){
				var selectedLayerId = $("#le-editable-layer-select option:selected").val();
				app.plugins.LayerEditor.setEditableLayer(selectedLayerId);
			});
			
			// Log success
			logger("INFO", app.plugins.LayerEditor.name + ": Plugin successfully loaded");
		}
		
		// Add the tab
		addSideBarTab(this.tabName, this.tabContentFile, callback);
	}
}

// Class initialization
app.plugins.LayerEditor = new LayerEditor();