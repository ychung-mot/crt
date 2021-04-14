/**
 * ##############################################################################
 * ------------------------------------------------------------------------------
 * ------------------------------------------------------------------------------
 * ------------------------------------------------------------------------------
 *
 *          File: init.js
 *       Creator: Volker Schunicht
 *       Purpose:
 *	    Required:
 *       Changes: Modified for CRT by Peter Spry and Young-Jin Chung
 *		   Notes: Added KeyCloak authentication, and new url parameters
 *
 * ------------------------------------------------------------------------------
 * ------------------------------------------------------------------------------
 * ------------------------------------------------------------------------------
 * ##############################################################################
 */

/**
 * GLOBALS
 * Variables/objects required in a global context.
 */
var app = new Object();
app.log = [];
app.StartIndexForBaseLayers = 400;
app.StartIndexForOverlayLayers = 500;
app.config = new Object(); // Defined by whatever application config was requested/loaded
app.plugins = new Object();
app.eventKeys = new Object(); // Used to store the keys of map events (so we can destry them if required)
app.defaultMapSingleClickFunction = function () {};

var keycloak = new Keycloak();

function initKeycloak() {
  keycloak
    .init({
      onLoad: "login-required",
      promiseType: "native",
      checkLoginIframe: false,
    })
    .then(function (authenticated) {
      onLoginSuccess();
    })
    .catch(function () {
      alert("keycloak: failed to initialize");
    });
}

/**
 * Function: Document onReady
 * @param () none
 * @returns () nothing
 * Function that runs when the document is ready
 */
$(document).ready(function () {
  // Add log entry
  logger(
    "INFO",
    "-------------------------------------------------------------------------------------------------------------"
  );
  logger("INFO", "INIT: Beginning TWM Session");

  initKeycloak();
});

function imageLoader(image, src) {
  var client = new XMLHttpRequest();
  client.open("GET", src, true);
  client.setRequestHeader("Access-Control-Allow-Origin", "*");
  client.setRequestHeader("Pragma", "no-cache");
  client.setRequestHeader("Authorization", "Bearer " + keycloak.token);

  client.onload = function () {
    var byteArray = new Uint8Array(this.response);
    var blob = new Blob([byteArray], { type: "image/png" });
   // image.setImage(blob);
    var data = 'data:image/png;base64,' + btoa(unescape(encodeURIComponent(this.response)));
    image.getImage().src = data;
    console.log("working?");
  };
  client.send();
}

function onLoginSuccess() {
  console.log("user: " + keycloak.idTokenParsed.preferred_username);

  // Check if Internet Explorer
  var ua = window.navigator.userAgent;
  if (/MSIE|Trident/.test(ua)) {
    // Set title/header to default
    document.title = "Transportation Web Map";
    if (isMobile()) {
      $("#appTitle").text("TWA");
    } else {
      $("#appTitle").text("Transportation Web Map");
    }

    // Display error/suggestion
    var errorNotice = bootbox.dialog({
      title: "Compatibility Issue",
      message:
        "<p class='text-center'>Your browser is not compatible with this application.<br><br>Please use a modern Browser.<br></p>",
      closeButton: false,
    });

    // Bail
    return;
  }

  // Load the core application scripts
  var scripts = [
    "application/inc/projections.js",
    "application/inc/definitions.js",
    "application/inc/extensions.js",
    "application/inc/classes.js",
  ];
  $.each(scripts, function (index, script) {
    $.ajax({
      async: false, // required
      url: script,
      dataType: "script",
    })
      .done(function (response) {
        logger("INFO", "INIT: Successfully loaded " + script);
      })
      .fail(function (jqxhr, settings, exception) {
        logger("ERROR", "INIT: Error loading " + script);
        return;
      });
  });

  // Determine which app config was called and try to load it
  // projectId = getUrlParameterByName("project");
  var configName = getUrlParameterByName("c");
  // project parameter is CRT specific
  app.projectId = getUrlParameterByName("project");
  app.segmentId = getUrlParameterByName("segment");

  loadConfig(configName, 0);
}

/**
 * Function: loadConfig
 * @param (string) config name
 * @param (integer) attempt count
 * @returns () nothing
 * Function that initializes the application
 */
function loadConfig(name, attemptCount) {
  attemptCount++;
  logger("INFO", "Attempting to load '" + name + "' TWM configuration");
  $.getScript("configuration/" + name + "/app-config.js")
    .done(function (script, textStatus) {
      app.config.name = name;
      init();
    })
    .fail(function (jqxhr, settings, exception) {
      logger(
        "WARN",
        "Attempt to load '" +
          name +
          "' TWM configuration failed.  Redirecting to 'default'"
      );
      if (attemptCount < 2) loadConfig("default", attemptCount); // revert to default
    });
}

/**
 * Function: init
 * @param () none
 * @returns () nothing
 * Function that initializes the application
 */
function init() {
  // Add log entry
  logger(
    "INFO",
    "'" + app.config.name + "' TWM configuration loaded successfully"
  );

  // Check if TWM is being called from a valid domain
  if (isValidTwmDomain() === false) {
    // Set title/header to default
    document.title = "Transportation Web Map";
    if (isMobile()) {
      $("#appTitle").text(app.config.title.mobile);
    } else {
      $("#appTitle").text(app.config.title.desktop);
    }

    // Display error/suggestion
    var msg =
      "<p class='text-center'><b>" +
      app.config.title.desktop +
      "</b><br><i>is not permitted to run on</i><br><b>" +
      window.location.hostname +
      "</b><br><br>Please contact <a href='mailto:" +
      app.config.contact.email +
      "?subject=" +
      app.config.title.desktop +
      " Inquiry'>" +
      app.config.contact.name +
      "</a> for assistance.</p>";
    var errorNotice = bootbox.dialog({
      title: "Forbidden Domain",
      message: msg,
      closeButton: false,
    });

    // Bail
    return;
  }

  // Toggle map spinner
  showMapSpinner();

  // Instantiate the Uber Search Class
  app.uberSearch = new UberSearch();

  // Get the map defaults from the config fileCreatedDate
  var mapInitialCentreLon = app.config.map.default.centre.longitude;
  var mapInitialCentreLat = app.config.map.default.centre.latitude;
  var mapInitialZoom = app.config.map.default.zoom;
  var mapMinZoom = app.config.map.zoom.min;
  var mapMaxZoom = app.config.map.zoom.max;

  // Use URL query parameters to override default variables (if specified)
  if (isNumeric(getUrlParameterByName("z"))) {
    mapInitialZoom = getUrlParameterByName("z");
    if (mapInitialZoom > mapMaxZoom) mapInitialZoom = mapMaxZoom;
    if (mapInitialZoom < mapMinZoom) mapInitialZoom = mapMinZoom;
  }
  if (isLongitude(getUrlParameterByName("lon")))
    mapInitialCentreLon = getUrlParameterByName("lon");
  if (isLatitude(getUrlParameterByName("lat")))
    mapInitialCentreLat = getUrlParameterByName("lat");

  // Build the map
  app.map = new ol.Map({
    target: "map",
    view: new ol.View({
      projection: "EPSG:3857",
      center: ol.proj.fromLonLat([mapInitialCentreLon, mapInitialCentreLat]),
      zoom: mapInitialZoom,
      minZoom: mapMinZoom,
      maxZoom: mapMaxZoom,
    }),
  });

  // Add all of the base layers (in reverse of config)
  // Baselayer zIndexes start what app.StartIndexForBaseLayers is defined at
  var zIndex = app.StartIndexForBaseLayers;
  $.each(app.config.map.layers.reverse(), function (index, layer) {
    if (layer.get("type") == "base") {
      // Add the layer to the map
      app.map.addLayer(layer);

      // Set the layer zIndex and increment
      layer.setZIndex(zIndex);
      zIndex++;
    }
  });
  app.config.map.layers.reverse(); // Reset the array to original

  // Add all of the overlay layers (in reverse of config)
  // Overlay layer zIndexes start what app.StartIndexForOverlayLayers is defined at
  var zIndex = app.StartIndexForOverlayLayers;
  $.each(app.config.map.layers.reverse(), function (index, layer) {
    if (layer.get("type") == "overlay") {
      // Add the layer to the map
      app.map.addLayer(layer);

      // Set the layer zIndex and increment
      layer.setZIndex(zIndex);
      zIndex++;

      // Attach additional metadata to layer
      attachMetaDataToLayer(layer);
    }
  });
  app.config.map.layers.reverse(); // Reset the array to original

  // Apply styles to any vector tile layers
  $.each(app.config.map.layers, function (index, layer) {
    if (layer instanceof ol.layer.VectorTile) {
      var styleUrl = layer.get("styleUrl");
      var styleKey = layer.get("styleKey");
      if (styleUrl && styleKey) {
        fetch(styleUrl).then(function (response) {
          response.json().then(function (glStyle) {
            olms.applyStyle(layer, glStyle, styleKey);
          });
        });
      } else {
        logger(
          "ERROR",
          "INIT: Style could not be applied to Vector Tile layer named '" +
            layer.get("title") +
            "'"
        );
      }
    }
  });

  // Define and add an empty highlight layer
  app.highlightLayer = new ol.layer.Vector({
    source: new ol.source.Vector({}),
    style: getHighlightStyle,
  });
  app.map.addLayer(app.highlightLayer);
  app.highlightLayer.setZIndex(600);

  // Define and add the popup overlay
  app.popupOverlay = new ol.Overlay({
    element: document.getElementById("popup"),
    autoPan: true,
    autoPanAnimation: {
      duration: 250,
    },
  });
  app.map.addOverlay(app.popupOverlay);

  // Build the menu
  buildMenu();

  // Restore Application State
  restoreState();

  // Add/register plugins
  $.each(app.config.plugins, function (index, plugin) {
    if (plugin.enabled) {
      loadPlugin(plugin.name);
    }
  });

  // Register the collapse/expand sidebar buttons
  $(".sidebar-collapse-btn").click(function () {
    hideSidebar();
  });
  $(".sidebar-expand-btn").click(function () {
    showSidebar();
  });

  // Register window resize listener
  $(window).resize(function () {
    doLayout();
  });

  // Register map events
  $(app.map).on("moveend", function (e) {
    rewriteUrl();
    rememberState();
  });
  resetDefaultMapSingleClickFunction();

  // Register popup closer
  $("#popup-closer").click(closePopup);

  // Set up tabs for scrolling (& add override styling)
  $(".nav-tabs").scrollingTabs({
    bootstrapVersion: 4,
    cssClassLeftArrow: "oi oi-chevron-left",
    cssClassRightArrow: "oi oi-chevron-right",
    disableScrollArrowsOnFullyScrolled: true,
    scrollToTabEdge: true,
    enableSwiping: true,
  });
  $(".scrtabs-tab-scroll-arrow").css("text-align", "center");
  $(".scrtabs-tab-scroll-arrow").css("border", "none");

  // Register hidden function to open log file
  $("#appImage").dblclick(function () {
    showLog();
  });

  // Report local storage size to logger
  if (lsIsAvailable) {
    var lsReport = lsSizeReport();
    logger(
      "INFO",
      "Local Storage Total Size: " + lsReport.size.toFixed() + lsReport.units
    );
    $.each(lsReport.items, function (index, item) {
      logger(
        "INFO",
        " - Local Storage Item '" +
          item.key +
          "' Size: " +
          item.size.toFixed(1) +
          lsReport.units
      );
    });
  }

  // Watch for sidebar width changes and make layout adjustments if required
  setInterval(function () {
    if (!isMobile() && $("#sidebar").is(":visible")) {
      if ($("#sidebar").outerWidth() != app.config.sidebar.width) {
        app.config.sidebar.width = $("#sidebar").outerWidth();
        doLayout();
      }
    }
  }, 25);

  // Execute config specific init (if it exists)
  if ("init" in app.config && isFunction(app.config.init)) {
    app.config.init();
  }

  // Redo the layout
  doLayout();

  // Toggle map spinner
  hideMapSpinner();
}
