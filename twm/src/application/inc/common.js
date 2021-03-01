/**
 * ##############################################################################
 * ------------------------------------------------------------------------------
 * ------------------------------------------------------------------------------
 * ------------------------------------------------------------------------------
 *
 *          File: common.js
 *       Creator: 
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
 * Function: showMapSpinner
 * @param () none
 * @returns () nothing
 * Function that shows the map spinner
 */
function showMapSpinner() {
	app.mapSpinner = new Spinner(app.spinnerOptionsMedium).spin($("#map")[0]);
}

/**
 * Function: hideMapSpinner
 * @param () none
 * @returns () nothing
 * Function that hides the map spinner
 */
function hideMapSpinner() {
	setTimeout(function(){ app.mapSpinner.stop(); }, 300);
}

/**
 * Function: logger
 * @param (string) type (one of ERROR, WARNING, INFO)
 * @param (string) message
 * @returns () nothing
 * Function that creates a simple runtime application log
 */
function logger(type, message) {
	var entry = {
		type: type,
		message: "[" + formatTimestamp(new Date()) + "] " + message
	}
	if (lsIsAvailable) {
		var log = lsRetrieveArray("log");
		if (log.length >= 500) log.shift(); // Never allow more than 500 log items in local storage
		log.push(entry);
		lsStoreItem("log", log);
	} else {
		app.log.push(entry);
	}
}

/**
 * Function: showLog
 * @param () none
 * @returns () nothing
 * Function that shows the application log
 */
function showLog() {
	// Get log from local storage or app array
	if (lsIsAvailable) {
		var log = lsRetrieveArray("log");
	} else {
		var log = app.log;
	}
	
	// Build the content
	var content = " ";
	$.each(log, function(index, entry) {
		switch (entry.type) {
			case "ERROR":
				content += "<span class='logger-error'>" + entry.type + ": " + entry.message + "</span><br>";
				break;
			case "WARN":
				content += "<span class='logger-warn'>" + entry.type + ": " + entry.message + "</span><br>";
				break;
			default:
				content += "<span class='logger-info'>" + entry.type + ": " + entry.message + "</span><br>";
		}
	});
	
	// Show the log window
	var appLogDialog = bootbox.dialog({
		title: "Application Log",
		message: content,
		size: "extra-large",
		closeButton: true,
		buttons: {
			clearAppCache: {
				label: "Reset Application",
				className: 'btn-danger',
				callback: function(){
					if (lsIsAvailable) {
						lsClearLocalStorage();
						window.location = window.location.href.split("?")[0]+"?c="+app.config.name;
					} 
				}
			},
			downloadLog: {
				label: "Download Log",
				className: 'btn-info',
				callback: function(){
					downloadLog(log);
					return false;
				}
			}
		}
	});
	
	// Adjust window size and dialog styling behaviour
	$(appLogDialog).find(".bootbox-body").css("overflow-y", "auto"); 
	$(appLogDialog).find(".bootbox-body").css("overflow-x", "auto");
	$(appLogDialog).find(".bootbox-body").css("white-space", "nowrap");
	$(appLogDialog).find(".bootbox-body").height(($(window).height() - 250));
	
	// Hide session buttons if disabled in the config
	if (app.config.rememberState === false) {
		$(appLogDialog).find(".btn-load-session").hide();
		$(appLogDialog).find(".btn-download-session").hide();
	}
}

/**
 * Function: downloadLog
 * @param (object) log object
 * @returns () nothing
 * Function that downloads the application log
 */
function downloadLog(log) {
	// Convert the passed log into a content string
	var content = "";
	$.each(log, function(index, entry) {
		content += entry.type + " - " + entry.message + "\n";
	});
	
	// Create a hidden download link and click it
	var link = document.createElement("a");
	link.download = "TWM-" + window.location.hostname + ".log";
	link.href = "data:text/html;charset=utf-8," + encodeURIComponent(content);
	link.click();
}

/**
 * Function: downloadSession
 * @param () none
 * @returns () nothing
 * Function that downloads the session (state) file
 */
function downloadSession() {
	// Get the application state object from local storage
	var state = lsRetrieveObject("state-"+app.config.name);

	// Convert json state into a string
	var content = JSON.stringify(state, null, "\t");
		
	// Create a hidden download link and click it
	var link = document.createElement("a");
	link.download = "TWM-" + app.config.name + ".json";
	link.href = "data:application/json;charset=utf-8," + encodeURIComponent(content);
	link.click();
}

/**
 * Function: loadSession
 * @param () none
 * @returns () nothing
 * Function that upload a session (state) file and applies it
 */
function loadSessionFromFile() {
	$("<input type='file' accept='application/json'>").on('change', function () {
		// If a file was selected, then engage the FileReader
		if (this.files && this.files[0]) {
			var fileReader = new FileReader();
			fileReader.onload = function(evt) {
				if (evt && evt.target && evt.target.result) {
					showMapSpinner();
					try {
						// Create a state object from the loaded file
						var state = JSON.parse(evt.target.result);
						
						// Write the newly created state object to the local storage state
						lsStoreItem("state-"+app.config.name, state);
					
						// Reload the page
						location.reload();
						
					} catch(err) {
						hideMapSpinner();
						logger("ERROR", "Cannot read session file - "+err);
						var errorNotice = bootbox.dialog({
							title: "Error",
							message: "<p class='text-center'>Cannot read session file<br></p>",
							closeButton: true
						});
					}
				}
			}
			fileReader.readAsText(this.files[0]);
		}
	}).click();
}

/**
 * Function: buildMenu
 * @param () none
 * @returns () nothing
 * Function that adds items to the menu and displays it
 */
function buildMenu() {
	// Add session management buttons
	if (app.config.rememberState === true && app.config.allowSessionManagement === true) {
		var btnDownloadSession = $("<button class='dropdown-item' type='button'><span class='menu-icon oi oi-data-transfer-download'></span>Download Session</button>");
		btnDownloadSession.on("click", downloadSession);
		$("#mainMenuOptions").append(btnDownloadSession);
		var btnLoadSession = $("<button class='dropdown-item' type='button'><span class='menu-icon oi oi-data-transfer-upload'></span>Load Session</button>");
		btnLoadSession.on("click", loadSessionFromFile);
		$("#mainMenuOptions").append(btnLoadSession);
	}
	
	// Add item from config menuOptions
	if (app.config.menuOptions) {
		$.each(app.config.menuOptions, function(index, menuOption) {
			// Regular menu options
			if (menuOption.text && menuOption.iconCls && menuOption.action && menuOption.url) {
				var menuItem = $("<button class='dropdown-item' type='button'><span class='menu-icon "+menuOption.iconCls+"'></span>"+menuOption.text+"</button>");
				switch(menuOption.action) {
					case "link":
						menuItem.on("click", function(){
							var win = window.open(menuOption.url, "_blank");
							win.focus();
						});
						break;
					case "dialog":
						menuItem.on("click", function(){
							showModalDialog(menuOption.text, menuOption.url);
						});
						break;
				}
				$("#mainMenuOptions").append(menuItem);
				
			// Menu divider
			} else if (menuOption.divider === true) {
				$("#mainMenuOptions").append($("<div class='dropdown-divider'></div>"));
			} 			
		});		
	}
}

/**
 * Function: showModalDialog
 * @param (string) title
 * @param (string) contentUrl
 * @returns () nothing
 * Function that opens a modal dialog and displays the content contained within the passed url
 */
function showModalDialog(title, contentUrl) {
	$.ajax({
		url: contentUrl,
		dataType: "html"
	})
	.done(function(content) {
		bootbox.dialog({
			title: title,
			message: content,
			size: "extra-large",
			closeButton: true
		});
	})
	.fail(function(jqxhr, settings, exception) {
		bootbox.dialog({
			title: title,
			message: exception,
			size: "extra-large",
			closeButton: true
		});
	}); 
}

/**
 * Function: convertFunctionToString
 * @param (function) function
 * @returns (string) string
 * Function that converts a JS function to a string
 */
function convertFunctionToString(fn) {
	var string = JSON.stringify(fn, function(key, value) {
		if (typeof value === "function") {
			return "/Function(" + value.toString() + ")/";
		}
		return value;
	});
	return string;	
}

/**
 * Function: convertStringToFunction
 * @param (string) string
 * @returns (function) function
 * Function that converts a string to a JS function (if the pattern matches)
 */
function convertStringToFunction(string) {			
	var fn = JSON.parse(string, function(key, value) {
		if (typeof value === "string" && value.startsWith("/Function(") && value.endsWith(")/")) {
			value = value.substring(10, value.length - 2);
			return (0, eval)("(" + value + ")");
		}
		return value;
	});
	return fn;
}

/**
 * Function: isConvertedFunction
 * @param (variant) value
 * @returns (boolean) function
 * Function that determines if the passed value is a function converted 
 * to a string by the "convertStringToFunction" function.
 */
function isConvertedFunction(value) {			
	if (typeof value === "string") {
		if (value.startsWith("\"/Function(") && value.endsWith(")/\"")) {
			return true;
		}
	}
	return false;
}

/**
 * Function: formatCoordinateAsString
 * @param (array) coordinate
 * @param (integer) epsg
 * @returns (string) formatted coordinate
 * Function that converts a coordinate to a human readable string format based on EPSG
 */
function formatCoordinateAsString(coordinate, epsg) {
	switch(parseInt(epsg)) {
		case 4326:
			return coordinate[0].toString().slice(0,11) + ", " + coordinate[1].toString().slice(0,9);
		default:
			return "Unknown EPSG";
	}	
}

/**
 * Function: convertStringToCoordinate
 * @param (string) str
 * @param (integer) requestedEpsg
 * @returns (object) location
 * Function that converts a string (based on best guess) to a coordinate in the requested output EPSG
 */
function convertStringToCoordinate(str, requestedEpsg) {
	// Define the location object
	var location = new Object();
	
	// Try ESPG 4326 longitude/latitude seperated by a ', ' or a ','
	if (str.split(", ").length == 2 || str.split(",").length == 2) {
		var first, second;
		if (str.split(", ").length == 2) {
			first = str.split(", ")[0];
			second = str.split(", ")[1];
		}
		if (str.split(",").length == 2) {
			first = str.split(",")[0];
			second = str.split(",")[1];
		}
		if (isLongitude(first) && isLatitude(second)) {
			location.coordinate = [parseFloat(first), parseFloat(second)];
			location.epsg = 4326;
			location.category = "Longitude/Latitude Coordinate";
		} else if (isLongitude(second) && isLatitude(first)) {
			location.coordinate = [parseFloat(second), parseFloat(first)];
			location.epsg = 4326;
			location.category = "Latitude/Longitude Coordinate";
		}
	}

	// Return empty object if string could not be converted into a coordinate
	if (!location.hasOwnProperty("category")) return location;
	
	// Do location transformation if required
	if (parseInt(requestedEpsg) != location.epsg) {
		location.coordinate = ol.proj.transform(location.coordinate, "EPSG:"+location.epsg, "EPSG:"+requestedEpsg);
		location.epsg = parseInt(requestedEpsg);
	}
	
	// Return the location object
	return location;
}

/**
 * Function: convertDuration
 * @param (integer) milliseconds
 * @returns (string) human readable duration
 * Function that converts a duration to a human readable format
 */
function convertDuration(millisec) {
	var seconds = (millisec / 1000).toFixed(1);
	var minutes = (millisec / (1000 * 60)).toFixed(1);
	var hours = (millisec / (1000 * 60 * 60)).toFixed(1);
	var days = (millisec / (1000 * 60 * 60 * 24)).toFixed(1);
	if (seconds < 60) {
		return seconds + " seconds";
	} else if (minutes < 60) {
		return minutes + " minutes";
	} else if (hours < 24) {
		return hours + " hours";
	} else {
		return days + " days"
	}
}

/**
 * Function: formatTimestamp
 * @param (object) date (timestamp)
 * @returns () formated timestamp string
 * Function that formats a timestamp
 */
function formatTimestamp(timestamp) {
	var year = timestamp.getFullYear();
	var month = ((timestamp.getMonth() + 1) < 10) ? "0" + (timestamp.getMonth() + 1) : (timestamp.getMonth() + 1);
	var dom = ((timestamp.getDate()) < 10) ? "0" + (timestamp.getDate()) : (timestamp.getDate());
	var hour = ((timestamp.getHours()) < 10) ? "0" + (timestamp.getHours()) : (timestamp.getHours());
	var minute = ((timestamp.getMinutes()) < 10) ? "0" + (timestamp.getMinutes()) : (timestamp.getMinutes());
	var second = ((timestamp.getSeconds()) < 10) ? "0" + (timestamp.getSeconds()) : (timestamp.getSeconds());
	return year + "-" + month + "-" + dom + " " + hour + ":" + minute + ":" + second;
}

/**
 * Function: loadPlugin
 * @param (string) plugin name
 * @returns () nothing
 * Function that loads and initializes a plugin
 */
function loadPlugin(name) {
	var file = "application/plugins/"+name+"/plugin.js";
	$.ajax({
		async: false, // need to do this to keep tab order - may cause a browser warning
		url: file,
		dataType: "script"
	})
	.fail(function(jqxhr, settings, exception) {
		logger("ERROR", "Error loading plugin " + name);
	}); 
}

/**
 * Function: getPluginConfig
 * @param (string) plugin name
 * @returns () plugin config
 * Function that retrieves the plugin config
 */
function getPluginConfig(name) {
	var pcfg;
	$.each(app.config.plugins, function(index, plugin) {
		if (plugin.name == name) {
			pcfg = plugin;
		}
	});
	return pcfg;
}

/**
 * Function: getUrlParameterByName
 * @param (string) name
 * @returns (string) value
 * Function that returns the value of a passed query parameter name
 */
function getUrlParameterByName(name) {
    var url = window.location.href;
    name = name.replace(/[\[\]]/g, "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)");
    var results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return null;
    return decodeURIComponent(results[2].replace(/\+/g, " "));
}

/**
 * Function: isInt
 * @params (string) value
 * @returns (boolean) 
 * Function that returns the boolean state of whether a passed variable is an integer
 */
function isInt(value) {
	return !isNaN(value) && (function(x) { return (x | 0) === x; })(parseFloat(value))
}

/**
 * Function: isNumeric
 * @params (string) value
 * @returns (boolean) 
 * Function that returns the boolean state of whether a passed variable is numeric
 */
function isNumeric(value) {
	return !isNaN(parseFloat(value)) && isFinite(value);
}

/**
 * Function: isLatitude
 * @params (string) value
 * @returns (boolean) 
 * Function that returns the boolean state of whether a passed variable is a valid latitude
 */
function isLatitude(value) {
	if(isNumeric(value)) if(parseFloat(value) >= -90 && parseFloat(value) <= 90) return true;
	return false;
}

/**
 * Function: isLongitude
 * @params (string) value
 * @returns (boolean) 
 * Function that returns the boolean state of whether a passed variable is a valid longitude
 */
function isLongitude(value) {
	if(isNumeric(value)) if(parseFloat(value) >= -180 && parseFloat(value) <= 180) return true;
	return false;
}

/**
 * Function: lsIsAvailable
 * @params () none
 * @returns (boolean) whether local storage is available
 * Function to test if local storage is available
 */
function lsIsAvailable() {
    try {
        localStorage.setItem("ls-test", "...");
        localStorage.removeItem("ls-test");
        return true;
    } catch(e) {
        return false;
    }
}

/**
 * Function: lsSizeReport
 * @params () none
 * @returns (object) report object
 * Function to return a size report of local storage items
 */
function lsSizeReport() {
	var report = {};
	report.size = 0;
	report.units = "KB";
	report.items = [];
	var lsItemSize;
	var lsKey;
	for (lsKey in localStorage) {
		if (!localStorage.hasOwnProperty(lsKey)) continue;
		lsItemSize = ((localStorage[lsKey].length + lsKey.length) * 2);
		report.size += lsItemSize / 1024;
		report.items.push({key: lsKey, size: lsItemSize / 1024});
	};
	return report;
}

/**
 * Function: lsStoreItem
 * @params (string) key
 * @params (string) value
 * @returns (boolean) success
 * Function that uses local storage to store an item
 */
function lsStoreItem(key, value) {
	try {
		localStorage.setItem(key, JSON.stringify(value));
		return true;
	} catch(e) {
		return false;
	}
}

/**
 * Function: lsRemoveItem
 * @params (string) key
 * @returns (boolean) success
 * Function that removes an item from local storage
 */
function lsRemoveItem(key) {
	try {
		localStorage.removeItem(key);
		return true;
	} catch(e) {
		return false;
	}
}

/**
 * Function: lsRetrieveItem
 * @params (string) key
 * @returns (string or null) item (based on key) or null if failed
 * Function that retrieves an item from local storage
 */
function lsRetrieveItem(key) {
	try {
		return JSON.parse(localStorage.getItem(key));
	} catch(e) {
		return null;
	}
}

/**
 * Function: lsRetrieveArray
 * @params (string) key
 * @returns (array) array based on key or empty array if not found
 * Function that retrieves an array from local storage
 */
function lsRetrieveArray(key) {
	if (lsRetrieveItem(key) != null) {
		return lsRetrieveItem(key);
	} else {
		return [];
	}
}

/**
 * Function: lsRetrieveObject
 * @params (string) key
 * @returns (object) object based on key or empty object if not found
 * Function that retrieves an object from local storage
 */
function lsRetrieveObject(key) {
	if (lsRetrieveItem(key) != null) {
		return lsRetrieveItem(key);
	} else {
		return {};
	}
}

/**
 * Function: lsClearLocalStorage
 * @params () none
 * @returns () nothing
 * Function to clear all local storage
 */
function lsClearLocalStorage() {
	localStorage.clear();
}

/**
 * Function: isMobile
 * @param (string) name
 * @returns (string) value
 * Function that determines whether the client is a mobile device
 */
function isMobile() {
	if($(window).width() > 768) {
		return false;
	} else {
		return true;
	}
}

/**
 * Function: loadTemplate
 * @param (string) filename
 * @param (object) callback
 * @returns () nothing
 * Function that loads and returns an HTML template through a specified callback function
 */
function loadTemplate(filename, callback) {
	$.ajax({
		url: filename,
		dataType: "html"
	})
	.done(function(response) {
		callback(true, response);
	})
	.fail(function(jqxhr, settings, exception) {
		callback(false, null);
	}); 
}

/**
 * Function: addSideBarTab
 * @param (string) name
 * @param (string) filename
 * @param (object) callback
 * @returns () nothing
 * Function that adds a tab to the sidebar
 */
function addSideBarTab(name, filename, callback) {
	// Normalize the name so it can be used for element IDs, etc.
	var nName = name.replace(/[ `~!@#$%^&*()_|+\-=?;:'",.<>\{\}\[\]\\\/]/gi, "");
	
	// Add nav tab
	var tabNav = "<li class='nav-item'><a class='nav-link' id='"+nName+"-tab-nav' data-toggle='tab' href='#"+nName+"-tab-content' role='tab' aria-controls='"+nName+"'>"+name+"</a></li>";
	$("#sidebar-tab-navs").append(tabNav);
	var tabContent = "<div class='tab-pane fade' id='"+nName+"-tab-content' role='tabpanel' aria-labelledby='"+nName+"-tab'></div>";
	$("#sidebar-tab-content").append(tabContent);
	
	// Set active if its the first tab
	if ($("#sidebar-tab-navs > li").length == 1) {
		$("#"+nName+"-tab-nav").tab("show");
	}
	
	// Load content into the tab
	$("#"+nName+"-tab-content").load(filename, function(){
		callback(true, $("#"+nName+"-tab-nav"), $("#"+nName+"-tab-content"));
	});
}

/**
 * Function: doLayout
 * @param () none
 * @returns () nothing
 * Function that adjusts the application appearance
 */
function doLayout() {
	// Set title and header
	if (isMobile()) {
		document.title = app.config.title.mobile;
		$("#appTitle").text(app.config.title.mobile);
	} else {
		document.title = app.config.title.desktop;
		$("#appTitle").text(app.config.title.desktop);
	}
	
	// Adjust popup if exists
	var popupMaxHeight = $("#map").height() - 100;
	$("#popup-content").css("max-height", popupMaxHeight+"px")
	
	// Hide/show sidebar
	if ($("#sidebar").is(":visible")) {
		showSidebar();
	} else {
		hideSidebar();
	}
	
	// Adjust location of UberSearch
	if (isMobile()) {
		$("#frmUberSearch").detach().prependTo("#mainMenuOptions");
		if ($("#mainMenuOptions").children().length > 1) {
			$("#frmUberSearch").addClass("mb-2");
		}
	} else {
		$("#frmUberSearch").detach().prependTo("#headerToolbox");
		$("#frmUberSearch").removeClass("mb-2");
	}
	
	// Hide/show menu button despending on whether menu has content
	if ($("#mainMenuOptions").children().length > 0) {
		$("#mainMenu").show();
	} else {
		$("#mainMenu").hide();
	}
}

/**
 * Function: showSidebar
 * @param () none
 * @returns () nothing
 * Function that shows the sidebar
 */
function showSidebar() {
	// Hide the expander (show the sidebar)
	$("#sidebar-expander").hide();
	$("#sidebar").show();
	
	// If mobile
	if (isMobile()) {
		$("#sidebar").outerWidth($(window).width());
		$("#content").css("left", $(window).width());
	
	// If desktop
	} else {
		$("#sidebar").outerWidth(app.config.sidebar.width);
		$("#content").css("left", $("#sidebar").outerWidth());
	}
	
	// Refresh and reposition scrolling tabs (if required)
	$(".nav-tabs").scrollingTabs("refresh", {forceActiveTab: true});
	
	// Adjust tab content size
	var tabContainerHeight = $(".sidebar-tab-container").height();
	var tabNavsHeight = $("#sidebar-tab-navs").outerHeight();
	$("#sidebar-tab-content").outerHeight(tabContainerHeight - tabNavsHeight);
	
	// Update the map viewport
	app.map.updateSize();
	
	// Rewrite URL and remember application state if available and configured
	rewriteUrl();
	rememberState();
}

/**
 * Function: hideSidebar
 * @param () none
 * @returns () nothing
 * Function that hides the sidebar
 */
function hideSidebar() {
	// Hide the sidebar (show the expander)
	$("#sidebar").hide();
	$("#sidebar-expander").show();
	
	// Show the content full width
	$("#content").css("left", $("#sidebar-expander").outerWidth());
	
	// Update the map viewport
	app.map.updateSize();
	
	// Rewrite URL and remember application state if available and configured
	rewriteUrl();
	rememberState();
}

/**
 * Function: isValidTwmDomain
 * @param () none
 * @returns (boolean) true if is a valid TWM domain, false otherwise
 * Function that determines if the domain from which TWM was called is valid
 */
function isValidTwmDomain() {
	switch (window.location.hostname.toLowerCase()) {
		case "localhost":
		case "127.0.0.1":
		case "dev-motigeo.th.gov.bc.ca":
		case "dev-www.th.gov.bc.ca":
		case "tst-motigeo.th.gov.bc.ca":
		case "tst-www.th.gov.bc.ca":
		case "stg-motigeo.th.gov.bc.ca":
		case "stg-www.th.gov.bc.ca":
		case "prd-motigeo.th.gov.bc.ca":
		case "prd-www.th.gov.bc.ca":
		case "motigeo.th.gov.bc.ca":
		case "www.th.gov.bc.ca":
			return true;
		default:
			return false;
	}
}

/**
 * Function: returnEnvironmentUrl
 * @param (string) endPoint
 * @returns (string) substituted url
 * Function that returns a url substitution based on detected environment
 */
function returnEnvironmentUrl(endPoint) {
	// First, determine environment
	var environment = "UNKNOWN"; // default
	switch (window.location.hostname.toLowerCase()) {
		case "localhost":
		case "127.0.0.1":
		case "dev-motigeo.th.gov.bc.ca":
		case "dev-www.th.gov.bc.ca":
			environment = "DEV";
			break;
		case "tst-motigeo.th.gov.bc.ca":
		case "tst-www.th.gov.bc.ca":
			environment = "TST";
			break;
		case "stg-motigeo.th.gov.bc.ca":
		case "stg-www.th.gov.bc.ca":
			environment = "STG";
			break;
		case "prd-motigeo.th.gov.bc.ca":
		case "prd-www.th.gov.bc.ca":
		case "motigeo.th.gov.bc.ca":
		case "www.th.gov.bc.ca":
			environment = "PRD";
			break;
	}
	
	// If the environment could not be determined, return null
	if (environment == "UNKNOWN") return null;
	
	// Return respective url based on endpoint request and environment
	switch (endPoint) {
			
		// Public GeoServer
		case "ogs-public": 
			switch(environment) {
				case "DEV":
					return "https://dev-maps.th.gov.bc.ca/geoV05";
				case "TST":
					return "https://tst-maps.th.gov.bc.ca/geoV05";
				case "STG":
				case "PRD":
					return "https://maps.th.gov.bc.ca/geoV05";
			}
			
		// Default: UNKNOWN ENDPOINT REQUESTED
		default:
			return "Unknown end-point requested";
			
	}
}

/**
 * Function: zoomToFeature
 * @param (object) feature
 * @returns () nothing
 * Function that zooms the map view to a slightly padded extent of the passed feature
 */
function zoomToFeature(feature) {
	// Ordinary GeoJSON features have proper extents. KML sourced features extents are weirdly buried, see ELSE statement below
	if (isFinite(feature.getGeometry().getExtent()[0])) {
		app.map.getView().fit(feature.getGeometry().getExtent(), {padding: [20,20,20,20]});
	} else {
		app.map.getView().fit(feature.getProperties("properties").properties.geometry.extent_, {padding: [20,20,20,20]});
	}	
}

/**
 * Function: showPopup
 * @param (array) coordinate
 * @param (string) html content
 * @returns () nothing
 * Function that shows a feature popup on the map when passed location and content
 */
function showPopup(coordinate, content) {
	// Update the popup content
	if (isMobile()) hideSidebar();
	$("#popup").hide();
	$("#popup-content").html(content);
	
	// Wait a tick before repositioning/sizing the popup
	setTimeout(function(){
		$("#popup").show();
		app.popupOverlay.setPosition(coordinate);
		doLayout();
	}, 50);
}

/**
 * Function: closePopup
 * @param () none
 * @returns () nothing
 * Function that shows a map popup when passed location and content
 */
function closePopup() {
	$("#popup").hide();
	app.popupOverlay.setPosition(undefined);
	$("#popup-closer").blur();
	return false;
}

/**
 * Function: highlightFeature
 * @param (object) feature
 * @returns () nothing
 * Function that highlights the passed feature
 */
function highlightFeature(feature) {
	app.highlightLayer.getSource().clear();
	app.highlightLayer.getSource().addFeature(feature);
}

/**
 * Function: clearHighlightedFeatures
 * @param () none
 * @returns () nothing
 * Function that highlights the passed feature
 */
function clearHighlightedFeatures() {
	app.highlightLayer.getSource().clear();
}

/**
 * Function: getHighlightStyle
 * @param (object) feature
 * @returns (object) style
 * Function that returns a style based on the passed feature's type.
 */
function getHighlightStyle(feature) {
	return app.highlightStyles[feature.getGeometry().getType()];
};

/**
 * Function: convertToOpenLayersFeature
 * @param (string) source type
 * @param (object) source
 * @returns (object) openlayers feature
 * Function that returns an openlayers feature given a feature in another format
 */
function convertToOpenLayersFeature(sourceType, source) {
	// Basic error checking
	if (!source.geometry) return null;
	if (!source.geometry.type) return null;
	
	// Do conversion
	switch (sourceType) {
		// GeoJSON
		case "GeoJSON":
			switch (source.geometry.type.toUpperCase()) {
				case "POINT":
					var olGeometry = new ol.geom.Point(source.geometry.coordinates);
					break;
				case "MULTIPOINT":
					var olGeometry = new ol.geom.MultiPoint(source.geometry.coordinates);
					break;
				case "LINESTRING":
					var olGeometry = new ol.geom.LineString(source.geometry.coordinates);
					break;
				case "MULTILINESTRING":
					var olGeometry = new ol.geom.MultiLineString(source.geometry.coordinates);
					break;
				case "POLYGON":
					var olGeometry = new ol.geom.Polygon(source.geometry.coordinates);
					break;
				case "MULTIPOLYGON":
					var olGeometry = new ol.geom.MultiPolygon(source.geometry.coordinates);
					break;
				case "GEOMETRYCOLLECTION": // This could probably be handled more elegantly, but, KML sourced layers are of type GeometryCollection
					var foo = source.properties["geometry"].getExtent();
					var olGeometry = new ol.geom.Polygon(foo[0]+","+foo[1]+","+foo[0]+","+foo[3]+","+foo[2]+","+foo[3]+","+foo[2]+","+foo[1]+","+foo[0]+","+foo[1]);
					break;
				default:
					return null;
			}
			var olFeature = new ol.Feature({geometry: olGeometry});
			if (source.properties) olFeature.set("properties", source.properties);
			return olFeature;
			break;
		
		// Unhandled types
		default:
			return null;
	}
};

/**
 * Function: transformFeature
 * @param (object) feature
 * @param (string) sourceCRS
 * @param (string) targetCRS
 * @returns (object) transformed feature (clone)
 * Function that transforms an open layers feature from one CRS to another
 */
function transformFeature(feature, sourceCRS, targetCRS) {
	var clone = feature.clone();
	clone.getGeometry().transform(sourceCRS, targetCRS);
	return clone;
};

/**
 * Function: getFeatureCentre
 * @param (object) feature (of OpenLayers type)
 * @returns (object) openlayers feature
 * Function that returns an openlayers feature's centre
 */
function getFeatureCentre(feature) {
	var centreLocation;
	switch(feature.getGeometry().getType().toUpperCase()) {
		case "POINT":
			centreLocation = feature.getGeometry().getCoordinates();
			break;
		case "LINESTRING":
			var centreCoordIndex = Math.floor(feature.getGeometry().getCoordinates().length / 2);
			centreLocation = feature.getGeometry().getCoordinates()[centreCoordIndex];
			break;
		case "POLYGON":
			centreLocation = ol.extent.getCenter(feature.getGeometry().getExtent());
			break;
		default:
			logger("ERROR", "getFeatureCentre: Unhandled geometry type");
			return;
	}
	return centreLocation;
}

/**
 * Function: rememberState
 * @params () none
 * @returns () nothing
 * Function to remember application state.  Uses a copy of the app config
 * as a starting point template.
 */
function rememberState() {
	// Bail if not available and configured
	if (!lsIsAvailable() || !app.config.rememberState) return;
	
	// Define the application state object.  This will mimic the
	// app config layout, etc.
	var state = new Object();
	
	// Remember sidebar settings
	state.sidebar = new Object();
	if ($("#sidebar").is(":visible")) {
		state.sidebar.openOnDesktopStart = true;
		state.sidebar.openOnMobileStart = true;
	} else {
		state.sidebar.openOnDesktopStart = false;
		state.sidebar.openOnMobileStart = false;
	}
	state.sidebar.width = app.config.sidebar.width;
	
	// Remember map defaults (centre & zoom)
	state.map = new Object();
	state.map.default = new Object();
	var llCentre = ol.proj.toLonLat(app.map.getView().getCenter());
	state.map.default.centre = {
		longitude: llCentre[0],
		latitude: llCentre[1]
	}
	state.map.default.zoom = app.map.getView().getZoom();

	// Get zIndexes for all "managed" layers and sort them
	var zIndexes = [];
	$.each(app.map.getLayers().getArray(), function(index, layer) {
		if (layer.get("title")) zIndexes.push(layer.getZIndex());
	});
	zIndexes.sort();

	// Remember layer settings
	state.map.layers = [];
	$.each(zIndexes, function(index, zIndex) {
		$.each(app.map.getLayers().getArray(), function(index, layer) {
			if (zIndex == layer.getZIndex()) {
				var l = new Object();
				l.title = layer.get("title");
				l.type = layer.get("type");
				l.visible = layer.getVisible();
				l.opacity = layer.getOpacity();
				l.zIndex = layer.getZIndex();
				//l.cqlFilterStack = layer.get("cqlFilterStack"); // On hold for now...
				
				// Add Source info
				l.source = new Object();
				if (layer.getSource() instanceof ol.source.ImageWMS) {
					l.source.type = "ImageWMS";
					l.source.url = layer.getSource().getUrl();
					l.source.params = layer.getSource().getParams();
				}
				if (layer.getSource() instanceof ol.source.TileWMS) {
					l.source.type = "TileWMS";
					l.source.urls = layer.getSource().getUrls();
					l.source.params = layer.getSource().getParams();
				}
				if (layer.getSource() instanceof ol.source.TileImage) {
					l.source.type = "TileImage";
					l.source.urls = layer.getSource().getUrls();
					l.source.attributions = layer.getSource().getAttributions();
				}
				if (layer.getSource() instanceof ol.source.XYZ) {
					l.source.type = "XYZ";
					l.source.urls = layer.getSource().getUrls();
					l.source.attributions = layer.getSource().getAttributions();
				}
				
				// Add layer field configuration if it exists
				if (layer.get("fields")) {
					l.fields = [];
					$.each(layer.get("fields"), function(index, field) {
						var f = new Object();
						$.each(field, function(key, value) {
							if (typeof value === "function") {
								f[key] = convertFunctionToString(value);
							} else {
								f[key] = value;
							}						
						});
						l.fields.push(f);
					});
				}

				// Add layer object to state object
				state.map.layers.push(l);
			}
		});
	});
		
	// Store the application state object
	lsStoreItem("state-"+app.config.name, state);
	
}

/**
 * Function: restoreState
 * @params () none
 * @returns () nothing
 * Function to restore application state
 */
function restoreState() {
	// Get the application state object from local storage (if available)
	var state = lsRetrieveObject("state-"+app.config.name);
	
	// If state is not available or configured, apply some defaults, then bail
	if (lsIsAvailable() === false || app.config.rememberState === false || Object.keys(state).length == 0) {

		// Set sidebar open state (based on url parameter or default app config)
		if (isNumeric(getUrlParameterByName("sb"))) {
			if (getUrlParameterByName("sb") == 1) showSidebar();
		} else {
			// Use app defaults (mobile of desktop)
			if (isMobile() && app.config.sidebar.openOnMobileStart) {
				showSidebar();
			}
			if (!isMobile() && app.config.sidebar.openOnDesktopStart) {
				showSidebar();
			}
		}
		
		// Bail
		return;
	}

	// Encapsulate the state restoration in a try catch statement incase a loaded session
	// file or chnaged state definition no longer follows the new convention
	try {
		
		// Restore sidebar open state
		if (isMobile() && state.sidebar.openOnMobileStart === false) {
			hideSidebar();
		} else {
			showSidebar();
		}
		if (!isMobile() && state.sidebar.openOnDesktopStart === false) {
			hideSidebar();
		} else {
			showSidebar();
		}
		
		// Restore sidebar width
		app.config.sidebar.width = state.sidebar.width;
		
		// Restore map defaults (centre & zoom)
		if (state.map.default.centre.longitude && state.map.default.centre.latitude) {
			app.map.getView().setCenter(ol.proj.fromLonLat([state.map.default.centre.longitude, state.map.default.centre.latitude]));
		}
		if (state.map.default.zoom) {
			app.map.getView().setZoom(state.map.default.zoom);
		}

		// Restore layer settings
		$.each(state.map.layers, function(i, l) {
			l.found = false;  // assume layer is not present until it's found
			$.each(app.map.getLayers().getArray(), function(index, layer) {
				if (l.title == layer.get("title")) {
					if (typeof l.visible !== "undefined") layer.setVisible(l.visible);
					if (typeof l.opacity !== "undefined") layer.setOpacity(l.opacity);
					if (typeof l.zIndex !== "undefined") layer.setZIndex(l.zIndex);
					l.found = true; // Mark layer as found
				}
			});
		});
		
		// Add missing layers
		var basemapCount = 0;
		var basemapVisibleCount = 0;
		$.each(state.map.layers, function(i, l) {
			// Count Basemaps
			if (l.type == "base") {
				basemapCount++;
				if (l.visible === true) basemapVisibleCount++;
			}
			
			// Contruct new layer
			if (l.found === false) {
				switch (l.source.type) {
					case "ImageWMS":
						var newLayer = new ol.layer.Image({
							title: l.title,
							type: l.type,
							removable: true,
							visible: l.visible,
							source: new ol.source.ImageWMS({
								url: l.source.url,
								params: l.source.params,
								transition: 0
							})
						});
						break;
					case "TileWMS":
						var newLayer = new ol.layer.Tile({
							title: l.title,
							type: l.type,
							removable: true,
							visible: l.visible,
							source: new ol.source.TileWMS({
								url: l.source.urls[0],
								params: l.source.params,
								transition: 0
							})
						});
						break;
					case "TileImage":
						var newLayer = new ol.layer.Tile({
							title: l.title,
							type: l.type,
							removable: true,
							visible: l.visible,
							source: new ol.source.TileImage({
								url: l.source.urls[0],
								attributions: l.source.attributions
							})
						});
						break;
					case "XYZ":
						var newLayer = new ol.layer.Tile({
							title: l.title,
							type: l.type,
							removable: true,
							visible: l.visible,
							source: new ol.source.XYZ({
								url: l.source.urls[0],
								attributions: l.source.attributions
							})
						});
						break;
				}
				
				// Set additional layer properties
				if (typeof l.opacity !== "undefined") newLayer.setOpacity(l.opacity);
				
				// Add field configurations if present
				if (typeof l.fields !== "undefined") {
					var fieldsToAdd = [];
					$.each(l.fields, function(index, field) {
						var f = new Object();
						$.each(field, function(key, value) {
							if (isConvertedFunction(value)) {
								f[key] = convertStringToFunction(value);
							} else {
								f[key] = value;
							}
						});
						fieldsToAdd.push(f);
					});
					newLayer.set("fields", fieldsToAdd);
				}
				
				// Set the layer zIndex - this is tricky cuz their could be layers already holding that
				// particular zIndex, so we search for the next available one.
				if (Number.isInteger(l.zIndex) && isLayerZIndexAvailable(l.zIndex, l.type)) {
					newLayer.setZIndex(l.zIndex);
				} else {
					newLayer.setZIndex(getNextAvailableLayerZIndex(l.type));
				}
				
				// Add the layer to the map
				app.map.addLayer(newLayer);
			}
		});
		
		// If no base layer was turned on, turn the first one on.
		if (basemapVisibleCount == 0) {
			$.each(app.map.getLayers().getArray(), function(index, layer) {
				if (layer.get("type") == "base") {
					layer.setVisible(true);
					return false;
				}
			});
		}
	
	// Log errors
	} catch(e) {
		logger("ERROR", "State could not be restored - " + e);
	}

}

/**
 * Function: getNextAvailableLayerZIndex
 * @params (string) layerType (i.e. base, overlay)
 * @returns (integer) next zIndex
 * Function to get the next available unused layer zIndex (based on type)
 */
function getNextAvailableLayerZIndex(layerType) {
	// First get the start index based on layer type
	var nextZIndex = 0;
	switch(layerType) {
		case "overlay":
			nextZIndex = app.StartIndexForOverlayLayers;
			break;
		case "base":
			nextZIndex = app.StartIndexForBaseLayers;
			break;
		default:
			logger("ERROR", "Could not determine next available zIndex becasue layer type is unknown");
			return -1;
	}

	// Search for the next available one
	$.each(app.map.getLayers().getArray(), function(index, layer) {
		if (layer.get("title") && layer.get("type") == layerType) {
			if (layer.getZIndex() >= nextZIndex) {
				nextZIndex = layer.getZIndex() + 1;
			}
		}
	});
	return nextZIndex;
}

/**
 * Function: isLayerZIndexAvailable
 * @params (integer) zIndex
 * @params (string) layerType (i.e. base, overlay)
 * @returns (boolean) true if used, false if not
 * Function to determine if layer zIndex is available
 */
function isLayerZIndexAvailable(zIndex, layerType) {
	// First check if it's in the appropriate zIndex range
	switch(layerType) {
		case "overlay":
			if (zIndex < app.StartIndexForOverlayLayers) return false;
			break;
		case "base":
			if (zIndex < app.StartIndexForBaseLayers) return false;
			break;
		default:
			return false;
	}
	
	// Next check if its available	
	var isAvailable = true;
	$.each(app.map.getLayers().getArray(), function(index, layer) {
		if (layer.get("title") && layer.get("type") == layerType) {
			if (layer.getZIndex() == zIndex) {
				isAvailable = false;
			}
		}
	});
	return isAvailable;
}

/**
 * Function: rewriteUrl
 * @params () none
 * @returns () nothing
 * Function to rewrite the URL using numerous parameters
 */
function rewriteUrl() {
	// Bail if not available and configured
	if (!history.pushState || !app.config.rewriteUrl) return;
	
	// Define the base URL
	var url = window.location.protocol + "//" + window.location.host + window.location.pathname + "?";
	
	// Add the application config name
	url += "c=" + app.config.name + "&";
	
	// Add the lat and lon
	var llCentre = ol.proj.toLonLat(app.map.getView().getCenter());
	url += "lon=" + llCentre[0] + "&";
	url += "lat=" + llCentre[1] + "&";
	
	// Add the zoom level
	url += "z=" + app.map.getView().getZoom() + "&";
	
	// Add sidebar open state
	if ($("#sidebar").is(":visible")) {
		url += "sb=1&";
	} else {
		url += "sb=0&";
	}
	
	// Update the URL
	window.history.pushState({path:url}, "", url);
}

/**
 * Function: redirectMapSingleClickFunction
 * @params (string) cursor (standard CSS cursor type)
 * @params (function) function to execute upon click
 * @returns () nothing
 * Function to redirect the map's default single click function.  An empty function
 * can be passed to this if you simply want to disable the default singleClick
 * click function
 */
function redirectMapSingleClickFunction(cursor, fn) {
	$("#map").css("cursor", cursor);
	if (app.eventKeys.singleClick) ol.Observable.unByKey(app.eventKeys.singleClick);
	app.eventKeys.singleClick = app.map.on("click", function(e) {
		e.preventDefault();
		fn(e);
	});
}

/**
 * Function: resetDefaultMapSingleClickFunction
 * @params () none
 * @returns () nothing
 * Function to reset the map's single click function to default
 */
function resetDefaultMapSingleClickFunction() {
	$("#map").css("cursor", "default");
	if (app.eventKeys.singleClick) ol.Observable.unByKey(app.eventKeys.singleClick);
	app.eventKeys.singleClick = app.map.on("click", function(e) {
		e.preventDefault();
		app.defaultMapSingleClickFunction(e);
	});
}

/**
 * Function: attachMetaDataToLayer
 * @params (object) layer
 * @params (function) callback
 * @returns () nothing
 * Function to attach, if possible, the additional Meta Data to the layer (i.e. attribute model, native projection, etc.)
 */
function attachMetaDataToLayer(layer, callback) {
	// Handle optional parameters
	callback = callback || null;
	
	// Define misc variables
	var ajaxCallCount = 0;
	var completedAjaxCallCount = 0;
	
	// Define the function that completes the callback when everything is done
	var taskComplete = function() {
		completedAjaxCallCount++;
		if (completedAjaxCallCount == ajaxCallCount) {
			if (callback != null) callback();
		}
	}
	
	// Set default layer metadata to null
	layer.set("attributes", null);
	layer.set("nativeProjection", null);
	layer.set("minScaleDenominator", null);
	layer.set("maxScaleDenominator", null);
	layer.set("exportOutputFormats", []);
	layer.set("exportOutputProjections", []);
	layer.set("cqlFilterStack", new Object());
	
	// Only attach metadata for ImageWMS and TileWMS - TODO: write metadata functions for other layer types!!!!!!!
	if (layer.getSource() instanceof ol.source.ImageWMS === false && 
		layer.getSource() instanceof ol.source.TileWMS === false) {
		taskComplete();
		return;
	}
	
	// Get the layer parameters
	var layerParams = layer.getSource().getParams();
	
	// Add CQL Filter from layer config to CQL Filters metadata (required to assemble complex CQL statements later on)
	$.each(layerParams, function(parameterName, parameterValue) {
		if (parameterName.toUpperCase() == "CQL_FILTER") {
			var cqlFilterStack = layer.get("cqlFilterStack");
			cqlFilterStack["config"] = parameterValue;
			layer.set("cqlFilterStack", cqlFilterStack);
		}
	});
	
	// Define the layer url
	if (layer.getSource() instanceof ol.source.TileWMS) {
		var layerUrl = layer.getSource().getUrls()[0]; // TileWMS
	} else if (layer.getSource() instanceof ol.source.ImageWMS) {
		var layerUrl = layer.getSource().getUrl(); // ImageWMS
	} else {
		logger("WARN", "Could not retrieve layer metadata for " + layer.get("title") + "! Layer will have limited functionality");
		return;
	}
	var layerUrl = layerUrl.replace(new RegExp("/ows", "ig"), "/wfs");
	
	// Get layer namespace and layer name (assumes only one layer - will have to expand in the future)
	var layers = layerParams["LAYERS"];
	if (layers.search(":") == -1) {
		var layerNamespace = null;
		var layerName = layers;
	} else {
		var layerNamespace = layers.split(":")[0];
		var layerName = layers.split(":")[1];
	}
	
	// Modify layer URL to be specific to layer (using both namespace and name).
	// Must be careful to ensure that the namespace is not already part of the url.
	var urlAddition
	if (layerNamespace) {
		if (layerUrl.search("/"+layerNamespace+"/") == -1) {
			urlAddition = layerNamespace+"/"+layerName;
		} else {
			urlAddition = layerName;
		}	
	} else {
		urlAddition = layerName;
	}
	layerUrl = layerUrl.replace(new RegExp("/ows", "ig"), "/"+urlAddition+"/ows");
	layerUrl = layerUrl.replace(new RegExp("/wms", "ig"), "/"+urlAddition+"/wms");
	layerUrl = layerUrl.replace(new RegExp("/wfs", "ig"), "/"+urlAddition+"/wfs");
	
	// Issue a DescribeFeatureType request for passed layer
	ajaxCallCount++;
	$.ajax({
		type: "GET",
		url: layerUrl,
		dataType: "json",
		data: {
			service: "WFS",
			version: "2.0.0",
			request: "DescribeFeatureType", 
			typeNames: layers,
			outputFormat: "application/json"
		}
	})
	
	// Handle the DescribeFeatureType response
	.done(function(response) {
		// Make sure the response has something
		if (response.featureTypes) {
			// If there are multiple layers that make up this layer, only use the attributes from the first one
			var featureType = response.featureTypes[0];
			layer.set("attributes", featureType.properties);
					
		} else {
			logger("WARN", "'DescribeFeatureType' failed for " + layer.get("title") + "! Layer will have limited functionality");
		}
		
		// Attach download options to layer (with or without attributes
		attachDownloadOptionsToLayer(layer);
		
		taskComplete();
	})
	
	// Handle the DescribeFeatureType failure
	.fail(function(jqxhr, settings, exception) {
		// Attach download options to layer (without attributes)
		attachDownloadOptionsToLayer(layer);
		
		taskComplete();
		logger("ERROR", "Error executing 'DescribeFeatureType' for " + layer.get("title"));
	}); 
	
	// Issue a GetCapabilities request for passed layer
	ajaxCallCount++;
	$.ajax({
		type: "GET",
		url: layerUrl,
		dataType: "xml",
		data: {
			service: "WMS",
			version: "1.3.0",
			request: "GetCapabilities"
		}
	})
	
	// Handle the GetCapabilities response
	.done(function(response) {
		var parser = new ol.format.WMSCapabilities();
		var gcJson = parser.read(response);
		
		// Test if the first layer exists
		if (gcJson.Capability && gcJson.Capability.Layer && gcJson.Capability.Layer.Layer[0]) {
			// Get the first layer
			var gcLayer = gcJson.Capability.Layer.Layer[0];

			// Get native projection (!!!assume its the first one!!!)
			if (gcLayer.CRS[0]) {
				layer.set("nativeProjection", gcLayer.CRS[0]);
			} else {
				logger("WARN", "'GetCapabilities' [nativeProjection] failed for " + layer.get("title") + "! Layer will have limited functionality");
			}
			
			// Get MinScaleDenominator
			if (gcLayer.MinScaleDenominator) {
				layer.set("minScaleDenominator", gcLayer.MinScaleDenominator);
			} 
			
			// Get MaxScaleDenominator
			if (gcLayer.MaxScaleDenominator) {
				layer.set("maxScaleDenominator", gcLayer.MaxScaleDenominator);
			} 
		
		// Cannot get the first layer -> warn
		} else {
			logger("WARN", "'GetCapabilities' failed for " + layer.get("title") + "! Layer will have limited functionality");
		}
		taskComplete();
	})
	
	// Handle the GetCapabilities failure
	.fail(function(jqxhr, settings, exception) {
		taskComplete();
		logger("ERROR", "Error executing 'GetCapabilities' for " + layer.get("title"));
	}); 
}

/**
 * Function: attachDownloadOptionsToLayer
 * @params (object) layer
 * @returns () nothing
 * Function to attach download options to an overlay layer
 */
function attachDownloadOptionsToLayer(layer) {
	// Build a list of attributes that does not contain geometry fields
	var nonGeometryFields = [];
	$.each(layer.get("attributes"), function(index, attribute) {
		if (attribute.type.startsWith("gml:") === false) {
			nonGeometryFields.push(attribute.name);
		}
	});
	var nonGeometryFieldsListString = nonGeometryFields.join(",");
	
	// Define the export output formats (in the future this should be
	// generated from the WFS/WMS GetCapabilities capability response)
	var exportOutputFormats = [];
	exportOutputFormats.push({name:"Google Earth KML", format: "application/vnd.google-earth.kml+xml", service: "WMS", version: "1.3.0", request: "GetMap", requiredSrs: "EPSG:4326"});
	exportOutputFormats.push({name:"Compressed Shapefile", format:"SHAPE-ZIP", service: "WFS", version: "2.0.0", request: "GetFeature"});
	exportOutputFormats.push({name:"Comma Delimited Text File", format:"csv", service: "WFS", version: "2.0.0", request: "GetFeature", propertyName: nonGeometryFieldsListString});
	exportOutputFormats.push({name:"GeoJSON", format:"application/json", service: "WFS", version: "2.0.0", request: "GetFeature"});
	layer.set("exportOutputFormats", exportOutputFormats);
	
	// Define the export output projections (in the future this should be
	// generated from the WFS/WMS GetCapabilities capability response)
	var exportOutputProjections = [];
	exportOutputProjections.push({name:"NAD83 / BC Albers", value:"EPSG:3005"});
	exportOutputProjections.push({name:"WGS 84", value:"EPSG:4326"});
	layer.set("exportOutputProjections", exportOutputProjections);
}

/**
 * Function: getCurrentMapScale
 * @params () none
 * @returns (integer) scale
 * Function to get the current map scale  (THIS IS A HACK JOB!  OL does not have this function)
 */
function getCurrentMapScale() {
	var SCALE_ADJUSTMENT_FACTOR = 2; // Volker invent to get it to work :-(
	var INCHES_PER_UNIT = {
		"m": 39.37,
		"dd": 4374754
	};
	var DOTS_PER_INCH = 72;
	var units = app.map.getView().getProjection().getUnits();
	var resolution = app.map.getView().getResolution();
	var scale = (INCHES_PER_UNIT[units] * DOTS_PER_INCH * resolution) * SCALE_ADJUSTMENT_FACTOR;
	return Math.round(scale);
};

/**
 * Function: zoomToScale
 * @params (integer) scale
 * @returns () nothing
 * Function to zoom the map to a given scale (THIS IS A HACK JOB!  OL does not have this function)
 */
function zoomToScale(scale) {
	var SCALE_ADJUSTMENT_FACTOR = 2; // Volker invent to get it to work :-(
	var INCHES_PER_UNIT = {
		"m": 39.37,
		"dd": 4374754
	};
	var DOTS_PER_INCH = 72;
	var units = app.map.getView().getProjection().getUnits();
	var resolution = (scale / SCALE_ADJUSTMENT_FACTOR) / (INCHES_PER_UNIT[units] * DOTS_PER_INCH);
	app.map.getView().setResolution(resolution);
}

/**
 * Function: setCqlFilter
 * @params (object) layer
 * @params (string) type
 * @params (string) filter
 * @returns (string) CQL Filter
 * Function to set a layer's CQL filter AND honours pre-existing CQL filter
 */
function setCqlFilter(layer, type, filter) {
	// If filter is blank, convert to null
	if (filter == "") filter = null;

	// Add / update the filter (based on type) to the CQL Filter Stack (in metadata)
	var cqlFilterStack = layer.get("cqlFilterStack");
	cqlFilterStack[type] = filter;
	layer.set("cqlFilterStack", cqlFilterStack);

	// Loop through the filter stack to create a CQL statement
	cqlFilterArray = [];
	$.each(cqlFilterStack, function(i, f) {
		if (f) cqlFilterArray.push(f);
	});
	
	// Convert filter stack to a CQL Statement
	var cqlFilter = (cqlFilterArray.length > 0) ? cqlFilterArray.join(" AND ") : null;
	
	// Apply CQL filter to layer
	var layerParams = layer.getSource().getParams();
	layerParams["CQL_FILTER"] = cqlFilter;
	layer.getSource().updateParams(layerParams);
	
	// Remember application state if available and configured
	rememberState();
	
	// Return the CQL filter
	return cqlFilter;
}

/**
 * Function: downloadFile
 * @params (string) filePath
 * @returns () nothing
 * Function to initiate the download of the file indicated by the passed file path
 */
function downloadFile(filePath){
	var link = document.createElement("a");
	link.href = filePath;
	link.download = filePath.substr(filePath.lastIndexOf("/") + 1);
	link.click();
}
