class CRTsegmentCreator {
  /**
   * Function: constructor
   * @param () none
   * @returns () nothing
   * Function that initializes the class
   */
  constructor() {
    this.name = "CRTsegmentCreator";
    this.version = 1.0;
    this.author = "Volker Schunicht, modified by Peter Spry";
    this.pcfg = getPluginConfig(this.name);
    this.tabName = this.pcfg.tabName ? this.pcfg.tabName : "Define Segments";
    this.tabContentFile =
      "application/plugins/CRTsegmentCreator/tab-content.html";
    this.tabNav; // jQuery element
    this.tabContent; // jQuery element
    this.points = [];
    this.currentTarget;

    // Define some point styleSheets
    this.pointStyles = {
      start: new ol.style.Style({
        image: new ol.style.Circle({
          radius: 5,
          stroke: new ol.style.Stroke({
            color: "rgba(35, 119, 16, 1)",
            width: 2,
          }),
          fill: new ol.style.Fill({
            color: "rgba(255, 255, 255, 1)",
          }),
        }),
      }),
      waypoint: new ol.style.Style({
        image: new ol.style.Circle({
          radius: 5,
          stroke: new ol.style.Stroke({
            color: "rgba(0, 0, 255, 1)",
            width: 2,
          }),
          fill: new ol.style.Fill({
            color: "rgba(255, 255, 255, 1)",
          }),
        }),
      }),
      end: new ol.style.Style({
        image: new ol.style.Circle({
          radius: 5,
          stroke: new ol.style.Stroke({
            color: "rgba(255, 0, 0, 1)",
            width: 2,
          }),
          fill: new ol.style.Fill({
            color: "rgba(255, 255, 255, 1)",
          }),
        }),
      }),
    };

    // Define and add the points layer
    var source = new ol.source.Vector({}); // new for draggable
    this.pointsLayer = new ol.layer.Vector({
      source: source,
      style: this.getPointStyle,
    });
    this.pointsLayer.setZIndex(606);
    app.map.addLayer(this.pointsLayer);

    // Make route points draggable
    var modify = new ol.interaction.Modify({
      source: source,
      deleteCondition: function () {
        return false;
      },
      insertVertexCondition: function () {
        return false;
      },
    });
    modify.on("modifyend", function (evt) {
      // We don't know which point was moved, so update everything
      for (var i = 0; i < evt.features.getLength(); i++) {
        var feature = evt.features.getArray()[i];
        $("#simple-router-form")
          .find(".dr-location-input")
          .each(function (index) {
            if (index == feature.get("order")) {
              var centreLL = ol.proj.transform(
                feature.getGeometry().getCoordinates(),
                app.map.getView().getProjection(),
                "EPSG:4326"
              );
              var feature4326 = transformFeature(
                feature,
                "EPSG:3857",
                "EPSG:4326"
              );
              var centreLL = getFeatureCentre(feature4326);
              if (
                $(this).attr("longitude") != centreLL[0] ||
                $(this).attr("latitude") != centreLL[1]
              ) {
                $(this).val(
                  centreLL[0].toString().slice(0, 11) +
                    ", " +
                    centreLL[1].toString().slice(0, 9)
                );
              }
              $(this).attr("longitude", centreLL[0]);
              $(this).attr("latitude", centreLL[1]);
            }
          });
      }

      app.plugins.CRTsegmentCreator.findRoute();
    });
    app.map.addInteraction(modify);
    // end new draggable changes

    // Define and add the route layer
    this.routeLayer = new ol.layer.Vector({
      source: new ol.source.Vector({}),
      style: [
        new ol.style.Style({
          stroke: new ol.style.Stroke({
            color: "rgba(43, 115, 218, 1)",
            width: 6,
          }),
        }),
        new ol.style.Style({
          stroke: new ol.style.Stroke({
            color: "rgba(102, 157, 246, 1)",
            width: 2,
          }),
        }),
      ],
    });
    this.routeLayer.setZIndex(605);
    app.map.addLayer(this.routeLayer);

    // Add the plugin
    this.addPlugin();
  }

  /**
   * Function: getPointStyle
   * @param (object) feature
   * @returns (object) style
   * Function that returns a style based on the passed feature's point type.
   */
  getPointStyle(feature) {
    return app.plugins.CRTsegmentCreator.pointStyles[feature.get("pointStyle")];
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
    var overallResultsAggregator = function (list) {
      // Merge result to master list
      $.merge(completeResultsList, list);

      // Increment the completion count
      providerSearchCompletedCount++;

      // Return complete list if all providers have completed
      if (providerSearchCompletedCount >= providersToSearchCount) {
        callback(completeResultsList);
      }
    };

    // Search for a "coordinate pattern" within user input
    var outputSRS = app.map.getView().getProjection().getCode().split(":")[1];
    var location = convertStringToCoordinate(request.term, outputSRS);
    if (location.hasOwnProperty("category")) {
      overallResultsAggregator([
        {
          value: request.term,
          category: location.category,
          data: {
            type: "Feature",
            geometry: {
              type: "Point",
              crs: {
                type: "EPSG",
                properties: {
                  code: location.epsg,
                },
              },
              coordinates: location.coordinate,
            },
          },
        },
      ]);
    } else {
      overallResultsAggregator([]);
    }

    // Search BC GeoCoder if configured
    if (app.plugins.CRTsegmentCreator.pcfg.geoCoderEnabled) {
      providersToSearchCount++;
      app.plugins.CRTsegmentCreator.searchBcGeoCoder(
        request,
        overallResultsAggregator,
        options
      );
    }

    // Search visible (and configured) layers if configured
    if (app.plugins.CRTsegmentCreator.pcfg.visibleLayerSearchEnabled) {
      providersToSearchCount++;
      app.plugins.CRTsegmentCreator.searchLayers(
        request,
        overallResultsAggregator,
        options
      );
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
      maxResults: app.plugins.CRTsegmentCreator.pcfg.geoCoderMaxResults,
      echo: "false",
      brief: true,
      autoComplete: true,
      outputSRS: outputSRS,
      addressString: request.term,
      apikey: app.plugins.CRTsegmentCreator.pcfg.geoCoderApiKey,
    };
    $.extend(params, options);

    // Query the DataBC GeoCoder
    $.ajax({
      url: "api/spatial/geocoder",
      headers: {
        "Access-Control-Allow-Origin": "*",
        Pragma: "no-cache",
        Authorization: "Bearer " + keycloak.token,
      },
      data: params,
    })

      // Handle a successful result
      .done(function (data) {
        keycloak.updateToken(5);
        var list = [];
        if (data.features && data.features.length > 0) {
          list = data.features.map(function (item) {
            return {
              value: item.properties.fullAddress,
              category: "BC Places",
              data: item,
            };
          });
        }
        callback(list);
      })

      // Handle a failure
      .fail(function (jqxhr, settings, exception) {
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
    var layerResultsAggregator = function (list) {
      // Merge result to master list
      $.merge(completeLayerResultsList, list);

      // Increment the completion count
      layerSearchCompletedCount++;

      // Return complete list if all layers have completed
      if (layerSearchCompletedCount >= layersToSearchCount) {
        callback(completeLayerResultsList);
      }
    };

    // Determine how many layers will be searched
    $.each(app.map.getLayers().getArray(), function (index, layer) {
      // Skip layer if not a WMS layer
      if (typeof layer.getSource().getFeatureInfoUrl != "function") return true;

      var layerIsSearchable = false;
      if (layer.get("visible")) {
        if (layer.get("fields")) {
          $.each(layer.get("fields"), function (index, configField) {
            if (configField.searchable) {
              layerIsSearchable = true;
            }
          });
        }
      }
      if (layerIsSearchable) layersToSearchCount++;
    });

    // Iterate through each map layer
    $.each(app.map.getLayers().getArray(), function (index, layer) {
      // Skip layer if not a WMS layer
      if (typeof layer.getSource().getFeatureInfoUrl != "function") return true;

      // Get the searchable fields and the fields that make up the title for this layer
      var searchableFields = [];
      var titleFields = [];
      if (layer.get("fields")) {
        $.each(layer.get("fields"), function (index, configField) {
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
        $.each(
          layer.getSource().getParams(),
          function (parameterName, parameterValue) {
            if (parameterName.toUpperCase() == "LAYERS")
              layers = parameterValue;
          }
        );

        // Build the CQL filter statement
        var cqlFilter = "";
        $.each(searchableFields, function (index, searchField) {
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
          count:
            app.plugins.CRTsegmentCreator.pcfg.visibleLayerSearchMaxResults,
          srsName: app.map.getView().getProjection().getCode(),
          cql_filter: cqlFilter,
        };
        $.extend(params, options);

        // Issue the request (async)
        $.ajax({
          type: "GET",
          url: url,
          timeout: 5000,
          data: params,
        })

          // Handle the response
          .done(function (data) {
            // Define an empty list
            var list = [];

            // Process results if any
            if (data.features && data.features.length > 0) {
              // Map results
              list = data.features.map(function (item) {
                // Build the title (value)
                var value = "";
                $.each(titleFields, function (index, titleField) {
                  if (value != "") value += " - ";
                  value += item.properties[titleField];
                });

                // Map
                return {
                  value: value,
                  category: layer.get("title"),
                  data: item,
                };
              });
            }

            // Send to aggregator
            layerResultsAggregator(list);
          })

          // Handle a failure
          .fail(function (jqxhr, settings, exception) {
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
    var feature4326 = transformFeature(feature, "EPSG:3857", "EPSG:4326");
    var centreLL = getFeatureCentre(feature4326);

    // Set the input's lon/lat attributes based on user selection
    target.val(formatCoordinateAsString(centreLL, 4326));
    target.attr("longitude", centreLL[0]);
    target.attr("latitude", centreLL[1]);

    // Find Route
    app.plugins.CRTsegmentCreator.findRoute();
  }

  /**
   * Function: registerMapClickLocation
   * @param (object) target
   * @returns () nothing
   * Function that gets and registers where the user clicked on the map
   */
  registerMapClickLocation(target) {
    // Define function that handles the get map click location
    var mapClickFunction = function (e) {
      // Get the click coordinate in EPSG:4326
      var centreLL = ol.proj.transform(
        e.coordinate,
        app.map.getView().getProjection(),
        "EPSG:4326"
      );

      // Reset the map's single click function to default
      resetDefaultMapSingleClickFunction();

      // Set the input's lon/lat attributes (and display value)
      target.val(formatCoordinateAsString(centreLL, 4326));
      target.attr("longitude", centreLL[0]);
      target.attr("latitude", centreLL[1]);

      // If mobile, show sidebar
      if (isMobile()) showSidebar();

      // Find Route
      app.plugins.CRTsegmentCreator.findRoute();
    };

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
        maximumAge: 0,
      };
      var geoLocationSuccess = function (position) {
        // Set the input's lon/lat attributes (and display value) based on geolocation
        target.val(
          formatCoordinateAsString(
            [position.coords.longitude, position.coords.latitude],
            4326
          )
        );
        target.attr("longitude", position.coords.longitude);
        target.attr("latitude", position.coords.latitude);

        // Find Route
        app.plugins.CRTsegmentCreator.findRoute();
      };
      var geoLocationError = function (error) {
        // Display error/suggestion
        var errorNotice = bootbox.dialog({
          title: "Error",
          message:
            "<p class='text-center'>Cannot determine your current location.<br><br>Please turn on location services.<br></p>",
          closeButton: true,
        });
      };
      navigator.geolocation.getCurrentPosition(
        geoLocationSuccess,
        geoLocationError,
        options
      );
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
    var olFeature4326 = transformFeature(olFeature, "EPSG:3857", "EPSG:4326");
    var centreLL = getFeatureCentre(olFeature4326);

    // Set the input's lon/lat attributes based on user selection
    target.attr("longitude", centreLL[0]);
    target.attr("latitude", centreLL[1]);

    // Find Route
    app.plugins.CRTsegmentCreator.findRoute();
  }

  /**
   * Function: findRoute
   * @param () none
   * @returns () nothing
   * Function that attempts to find and display a route based on inputs
   */
  findRoute() {
    // Clear existing points, route, and hide stats
    app.plugins.CRTsegmentCreator.pointsLayer.getSource().clear();
    app.plugins.CRTsegmentCreator.routeLayer.getSource().clear();
    $("#dr-route-statistics").hide();
    $("#dr-route-failure").hide();
    $("#dr-post-segment-btn").attr("disabled", true);

    // Count how many valid routes points exist
    var validRoutePointCount = 0;
    $("#simple-router-form")
      .find(".dr-location-input")
      .each(function (index) {
        if (
          isLongitude($(this).attr("longitude")) &&
          isLatitude($(this).attr("latitude"))
        )
          validRoutePointCount++;
      });

    // Add the valid route points to the points array and to the map
    var points = [];
    $("#simple-router-form")
      .find(".dr-location-input")
      .each(function (index) {
        if (
          isLongitude($(this).attr("longitude")) &&
          isLatitude($(this).attr("latitude"))
        ) {
          // Add each route point coordinate to the points array
          points.push([$(this).attr("longitude"), $(this).attr("latitude")]);

          // Build a feature from the route point
          var pointGeometry = new ol.geom.Point([
            $(this).attr("longitude"),
            $(this).attr("latitude"),
          ]);
          var pointGeometryInMapProjection = pointGeometry.transform(
            "EPSG:4326",
            app.map.getView().getProjection()
          );
          var pointFeature = new ol.Feature({
            geometry: pointGeometryInMapProjection,
          });

          // Determine which point style to apply
          if (index == 0) {
            pointFeature.set("pointStyle", "start");
          } else if (index == validRoutePointCount - 1) {
            pointFeature.set("pointStyle", "end");
          } else {
            pointFeature.set("pointStyle", "waypoint");
          }

          // For draggable route markers to maintain their order
          pointFeature.set("order", index);

          // Add the styled feature to the points layer
          app.plugins.CRTsegmentCreator.pointsLayer
            .getSource()
            .addFeature(pointFeature);
        }
      });

    // Bail if there are not enough points
    if (points.length < 2) return;

    // Add the tab spinner
    var spinner = new Spinner(app.spinnerOptionsMedium).spin(
      $(app.plugins.CRTsegmentCreator.tabContent)[0]
    );

    // Convert points araay into string usable by the router-form
    var pointString = "";
    $.each(points, function (index, point) {
      if (pointString != "") pointString += ",";
      pointString += point[0] + "," + point[1];
    });

    // Define the parameters
    var params = {
      criteria: "fastest",
      points: pointString,
      roundTrip: false,
      apikey: app.plugins.CRTsegmentCreator.pcfg.routerApiKey,
    };

    // Query the DataBC GeoCoder
    $.ajax({
      url: "api/spatial/router",
      headers: {
        "Access-Control-Allow-Origin": "*",
        Pragma: "no-cache",
        Authorization: "Bearer " + keycloak.token,
      },
      data: params,
      timeout: 7500,
    })

      // Handle a successful result
      .done(function (data) {
        spinner.stop();

        keycloak.updateToken(5);

        // Bail if a rout was not found
        if (!data.routeFound) {
          $("#dr-route-failure").show();
          return;
        }

        // Get, transform, and display route geometry on map
        var routeGeometry = new ol.geom.LineString(data.route);
        var routeGeometryInMapProjection = routeGeometry.transform(
          "EPSG:" + data.srsCode,
          app.map.getView().getProjection()
        );
        var routeFeature = new ol.Feature({
          geometry: routeGeometryInMapProjection,
        });
        app.plugins.CRTsegmentCreator.routeLayer.getSource().clear();
        app.plugins.CRTsegmentCreator.routeLayer
          .getSource()
          .addFeature(routeFeature);

        // Show the stats
        $("#dr-route-statistics").show();
        $("#dr-travel-distance").html(
          data.distance.toFixed(2) + " " + data.distanceUnit
        );
        $("#dr-travel-time").html(data.timeText);

        // Transform and show the directions
        $("#dr-travel-directions").html("");
        $.each(data.directions, function (index, direction) {
          $("#dr-travel-directions").append("<li>" + direction.text + "</li>");
        });

        // Zoom to the route
        if (isMobile()) hideSidebar();
        zoomToFeature(routeFeature);

        // enable Save Segment button
        $("#dr-post-segment-btn").attr("disabled", false);
      })

      // Handle a failure
      .fail(function (jqxhr, settings, exception) {
        spinner.stop();
        $("#dr-route-failure").show();
        logger("ERROR", app.plugins.CRTsegmentCreator.name + ": Router Error");
      });
  }

  /**
   * Function: addLocationInputEventHandlers
   * @param (string) parentClass
   * @returns () nothing
   * Function that adds misc event handlers to specified location input
   */
  addLocationInputEventHandlers(parentClass) {
    // Register the get location from map buttons
    $("." + parentClass + " .dr-get-location-from-map-btn").click(function () {
      var associatedInput = $(this).parent().siblings(".dr-location-input");
      app.plugins.CRTsegmentCreator.registerMapClickLocation(associatedInput);
    });

    // Register the category autocompletes
    $("." + parentClass + " .dr-location-input").catcomplete({
      minLength: 3,
      source: this.search,
      select: function (event, selection) {
        app.plugins.CRTsegmentCreator.registerSearchSelectionLocation(
          $(this),
          selection.item
        );
      },
    });

    // Register the geolocator buttons
    $("." + parentClass + " .dr-get-geolocation-btn").click(function () {
      var associatedInput = $(this).parent().siblings(".dr-location-input");
      app.plugins.CRTsegmentCreator.registerDeviceLocation(associatedInput);
    });

    // Register the Use Orignial Start Lat/Long button
    $("#dr-use-start-btn").click(function () {
      var associatedInput = $(".dr-location-input-start");
      associatedInput.attr("longitude", $("#dr-start-lon-input").val());
      associatedInput.attr("latitude", $("#dr-start-lat-input").val());
      associatedInput.val(
        $("#dr-start-lon-input").val() + ", " + $("#dr-start-lat-input").val()
      );
      // Find Route
      app.plugins.CRTsegmentCreator.findRoute();
    });
    // Register the Use Orignial End Lat/Long buttons
    $("#dr-use-end-btn").click(function () {
      var associatedInput = $(".dr-location-input-end");
      associatedInput.attr("longitude", $("#dr-end-lon-input").val());
      associatedInput.attr("latitude", $("#dr-end-lat-input").val());
      associatedInput.val(
        $("#dr-end-lon-input").val() + ", " + $("#dr-end-lat-input").val()
      );
      // Find Route
      app.plugins.CRTsegmentCreator.findRoute();
    });

    // Register the Save Segment button
    $("#dr-post-segment-btn").click(function () {
      console.log("click");
      // transform web mercator line to 4326 for posting to database
      var format = new ol.format.WKT();
      var wkt = "";
      var feature4326 = {};
      // multilinestring
      if (
        app.plugins.CRTsegmentCreator.routeLayer.getSource().getFeatures()
          .length > 1
      ) {
        var multiLine = new ol.geom.MultiLineString(
          app.plugins.CRTsegmentCreator.routeLayer
            .getSource()
            .getFeatures()[0]
            .getGeometry()
            .getCoordinates()
        );
        app.plugins.CRTsegmentCreator.routeLayer
          .getSource()
          .getFeatures()
          .forEach(function (feat) {
            multiLine.appendLineString(feat.getGeometry().getCoordinates());
          });
        var multiFeature = new ol.Feature({ geometry: multiLine });
        feature4326 = transformFeature(multiFeature, "EPSG:3857", "EPSG:4326");
        wkt = format.writeFeature(feature4326, {});
      } else {
        feature4326 = transformFeature(
          app.plugins.CRTsegmentCreator.routeLayer.getSource().getFeatures()[0],
          "EPSG:3857",
          "EPSG:4326"
        );
        wkt = format.writeFeature(feature4326, {});
      }
      /* Original Start and End Coordinates will be replaced with Route Start and End
			var startPoint = feature4326.getGeometry().getFirstCoordinate();
			var endPoint = feature4326.getGeometry().getLastCoordinate();

			var associatedInput = $(".dr-location-input-start");
			$("#dr-start-lon-input").val(startPoint[1].toString().slice(0,11));
			$("#dr-start-lat-input").val(startPoint[0].toString().slice(0,9));
			associatedInput = $(".dr-location-input-end");
			$("#dr-end-lon-input").val(endPoint[1].toString().slice(0,11));
			$("#dr-end-lat-input").val(endPoint[0].toString().slice(0,9));
			
			// TO DO Update green and red markers to reflect Route Start and End			
			
*/

      //Using dragged points as start and end
      var associatedInput = $(".dr-location-input-start");
      $("#dr-start-lon-input").val(
        associatedInput.attr("longitude").slice(0, 11)
      );
      $("#dr-start-lat-input").val(
        associatedInput.attr("latitude").slice(0, 9)
      );
      associatedInput = $(".dr-location-input-end");
      $("#dr-end-lon-input").val(
        associatedInput.attr("longitude").slice(0, 11)
      );
      $("#dr-end-lat-input").val(associatedInput.attr("latitude").slice(0, 9));

      alert("POST this to the database:\n" + wkt);
    });

    // Register the clear input buttons
    $("." + parentClass + " .dr-clear-input-btn").click(function () {
      // Clear the input and attributes
      var associatedInput = $(this).parent().siblings(".dr-location-input");
      associatedInput.val("");
      associatedInput.attr("longitude", null);
      associatedInput.attr("latitude", null);

      // Find Route
      app.plugins.CRTsegmentCreator.findRoute();
    });

    // Register the delete waypoint buttons
    $("." + parentClass + " .dr-delete-waypoint-btn").click(function () {
      $(this).parent().parent().remove();

      // Find Route
      app.plugins.CRTsegmentCreator.findRoute();
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
    var callback = function (success, tabNav, tabContent) {
      // Bail if failed
      if (!success) {
        logger(
          "ERROR",
          app.plugins.CRTsegmentCreator.name + ": Plugin failed to initialize"
        );
        return;
      }

      // Set class variables
      app.plugins.CRTsegmentCreator.tabNav = tabNav;
      app.plugins.CRTsegmentCreator.tabContent = tabContent;

      // Allow adding of way points if so configured
      if (app.plugins.CRTsegmentCreator.pcfg.allowWayPoints) {
        $("#dr-waypoint-add-div").show();
        $("#dr-waypoint-add-instructions").show();
        $("#simple-router-form #dr-waypoint-add-btn").click(function () {
          // Get the waypoint template, clone it, add/remove classes, add it to the interface, and show it
          var clone = $(".dr-waypoint-template").clone(true);
          var uniqueClass = "dr-waypoint-" + Date.now();
          clone.addClass(uniqueClass);
          clone.addClass("dr-way-point");
          clone.removeClass("dr-waypoint-template");
          $("#dr-waypoint-add-div").before(clone);
          clone.show();

          // Add location event handlers for the way point
          app.plugins.CRTsegmentCreator.addLocationInputEventHandlers(
            uniqueClass
          );
        });
      }

      // Add location event handlers for start point
      app.plugins.CRTsegmentCreator.addLocationInputEventHandlers(
        "dr-start-point"
      );

      // Add location event handlers for end point
      app.plugins.CRTsegmentCreator.addLocationInputEventHandlers(
        "dr-end-point"
      );

      // Log success
      logger(
        "INFO",
        app.plugins.CRTsegmentCreator.name + ": Plugin successfully loaded"
      );
    };

    // Add the tab
    addSideBarTab(this.tabName, this.tabContentFile, callback);
  }
}

// Class initialization
app.plugins.CRTsegmentCreator = new CRTsegmentCreator();
