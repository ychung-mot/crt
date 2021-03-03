app.config = {
  title: {
    desktop: "CRT Web Map",
    mobile: "CRT",
  },
  contact: {
    name: "Application Administrator",
    email: "Tran.IMB.Spatial@gov.bc.ca",
  },
  version: 1.0,
  sidebar: {
    width: 300,
    openOnDesktopStart: true,
    openOnMobileStart: false,
  },
  plugins: [
    {
      name: "CRTsegmentCreator",
      tabName: "Define Segments",
      enabled: true,
      allowWayPoints: true,
      visibleLayerSearchEnabled: true,
      visibleLayerSearchMaxResults: 5,
      geoCoderEnabled: true,
      geoCoderMaxResults: 5,
    },
    {
      name: "Identify2Tab",
      tabName: "Features",
      enabled: true,
      maxResults: 10,
    },
    {
      name: "LayerController",
      tabName: "Layers",
      enabled: true,
      allowLayerDownload: true,
      additionalSources: [
        {
          name: "MoTI",
          url: "../ogs-public/ows",
        },

        {
          name: "MoTI",
          url: " ../ogs-internal/ows",
        },

        {
          name: "BCGW (Int)",
          url: "https://apps.gov.bc.ca/ext/sgw/geo.allgov",
        },
        {
          name: "BCGW",
          url: "https://openmaps.gov.bc.ca/geo/ows",
        },
      ],
    },
    {
      name: "Home",
      tabName: "About",
      enabled: true,
    },
    {
      name: "UberSearchBCGeoCoderAddOn",
      enabled: true,
      maxResults: 5,
    },
    {
      name: "UberSearchBCGeographicalNameSearchAddOn",
      enabled: true,
      maxResults: 5,
    },
    {
      name: "UberSearchLayerSearchAddOn",
      enabled: true,
      maxResults: 5,
    },
  ],
  map: {
    default: {
      centre: {
        latitude: 54.5,
        longitude: -123.0,
      },
      zoom: 5,
    },
    zoom: {
      min: 4,
      max: 17,
    },
    layers: [
      // Overlay Layers

      new ol.layer.Image({
        title: "Project Segments",
        type: "overlay",
        visible: false,
        source: new ol.source.ImageWMS({
          url: " ../ogs-internal/ows",
          headers: { host: window.location.hostname },
          params: {
            LAYERS: "crt:ProjectSegment",
          },
          transition: 0,
        }),
      }),

      new ol.layer.Tile({
        title: "Digital Road Atlas",
        type: "overlay",
        visible: true,
        source: new ol.source.TileWMS({
          url: "https://openmaps.gov.bc.ca/geo/ows",
          params: {
            LAYERS: "pub:WHSE_BASEMAPPING.DRA_DGTL_ROAD_ATLAS_MPAR_SP",
          },
          transition: 0,
        }),
        fields: [
          {
            name: "DIGITAL_ROAD_ATLAS_LINE_ID",
            nameTransform: function (name) {
              return "Primary Key:";
            },
          },
          {
            name: "ROAD_NAME_FULL",
            searchable: true,
            title: true,
            nameTransform: function (name) {
              return "Road Name:";
            },
          },
        ],
      }),

      new ol.layer.Image({
        title: "RFI Roads",
        type: "overlay",
        visible: false,
        source: new ol.source.ImageWMS({
          url: " ../ogs-internal/ows",
          headers: { host: window.location.hostname },
          params: {
            LAYERS: "cwr:V_NM_NLT_RFI_GRFI_SDO_DT",
          },
          transition: 0,
        }),
        fields: [
          {
            name: "NE_UNIQUE",
            searchable: true,
            nameTransform: function (name) {
              return "SASHHH";
            },
          },
          {
            name: "NE_DESCR",
            searchable: true,
            nameTransform: function (name) {
              return "Name";
            },
          },
        ],
      }),

      new ol.layer.Image({
        title: "Project Segments",
        type: "overlay",
        visible: false,
        source: new ol.source.ImageWMS({
          url: " ../ogs-internal/ows",
          headers: { host: window.location.hostname },
          params: {
            LAYERS: "crt:ProjectSegment",
          },
          transition: 0,
        }),
      }),

      new ol.layer.Image({
        title: "MoTI Regions",
        type: "overlay",
        visible: false,
        source: new ol.source.ImageWMS({
          url: " ../ogs-internal/ows",
          headers: { host: window.location.hostname },
          params: {
            LAYERS: "hwy:DSA_REGION_BOUNDARY",
          },
          transition: 0,
        }),
        fields: [
          {
            name: "REGION_NUMBER",
            searchable: true,
            nameTransform: function (name) {
              return "Region No";
            },
          },
          {
            name: "REGION_NAME",
            searchable: true,
            title: true,
            nameTransform: function (name) {
              return "Region Name";
            },
          },
        ],
      }),

      // Base Layers
      new ol.layer.Tile({
        title: "ESRI Streets",
        type: "base",
        visible: true,
        source: new ol.source.XYZ({
          url:
            "https://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}",
          attributions:
            "Tiles © <a target='_blank' href='https://services.arcgisonline.com/ArcGIS/rest/services/'>ESRI</a>",
        }),
      }),
      new ol.layer.Tile({
        title: "ESRI Imagery",
        type: "base",
        visible: false,
        source: new ol.source.XYZ({
          url:
            "https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}",
          attributions:
            "Tiles © <a target='_blank' href='https://services.arcgisonline.com/ArcGIS/rest/services/'>ESRI</a>",
        }),
      }),
    ],
  },
};
