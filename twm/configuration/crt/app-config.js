app.config = {
  title: {
    desktop: "Captial and Rehabilitation Project Tracking",
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
          name: "MoTI (Int)",
          url: " ../ogs-internal/ows",
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
        title: "Segments",
        type: "overlay",
        visible: true,
        source: new ol.source.ImageWMS({
          url: " ../ogs-internal/ows",
          params: {
            LAYERS: "crt:SEGMENT_RECORD",
            CQL_FILTER: "project_id="+app.projectId,
          },
        fields: [
          {
            name: "description",
            searchable: true,
            nameTransform: function (name) {
              return "Desciption:";
            },
          },
        ],          transition: 0,
        }),
      }),

      new ol.layer.Image({
        title: "Digital Road Atlas",
        type: "overlay",
        visible: true,
        source: new ol.source.ImageWMS({
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
        title: "Electoral Districts",
        type: "overlay",
        visible: false,
        source: new ol.source.ImageWMS({
          url: "https://openmaps.gov.bc.ca/geo/ows",
          params: {
            LAYERS: "pub:WHSE_ADMIN_BOUNDARIES.EBC_PROV_ELECTORAL_DIST_SVW",
          },
          transition: 0,
        }),
        fields: [
          {
            name: "ED_ABBREVIATION",
            searchable: true,
            title: true,
            nameTransform: function (name) {
              return "";
            },
          },
          {
            name: "ED_NAME",
            searchable: true,
            nameTransform: function (name) {
              return "District Name:";
            },
          },
        ],
      }),

      new ol.layer.Image({
        title: "MoTI Service Area",
        type: "overlay",
        visible: false,
        source: new ol.source.ImageWMS({
          url: " ../ogs-internal/ows",
          params: {
            LAYERS: "hwy:DSA_CONTRACT_AREA",
          },
          transition: 0,
        }),
        fields: [
          {
            name: "CONTRACT_AREA_NUMBER",
            searchable: true,
            nameTransform: function (name) {
              return "Service Area No";
            },
          },
          {
            name: "CONTRACT_AREA_NAME",
            searchable: true,
            title: true,
            nameTransform: function (name) {
              return "Name";
            },
          },
        ],
      }),
      
      new ol.layer.Image({
        title: "MoTI District",
        type: "overlay",
        visible: false,
        source: new ol.source.ImageWMS({
          url: " ../ogs-internal/ows",
          params: {
            LAYERS: "hwy:DSA_DISTRICT_BOUNDARY",
          },
          transition: 0,
        }),
        fields: [
          {
            name: "DISTRICT_NUMBER",
            searchable: true,
            nameTransform: function (name) {
              return "Region No";
            },
          },
          {
            name: "DISTRICT_NAME",
            searchable: true,
            nameTransform: function (name) {
              return "Region Name";
            },
          },
        ],
      }),


      new ol.layer.Image({
        title: "Economic Regions",
        type: "overlay",
        visible: false,
        source: new ol.source.ImageWMS({
          url: "https://openmaps.gov.bc.ca/geo/ows",
          params: {
            LAYERS: "pub:WHSE_HUMAN_CULTURAL_ECONOMIC.CEN_ECONOMIC_REGIONS_SVW",
          },
          transition: 0,
        }),
        fields: [
          {
            name: "CENSUS_YEAR",
            nameTransform: function (name) {
              return "Census Year";
            },
          },
          {
            name: "ECONOMIC_REGION_NAME",
            searchable: true,
            nameTransform: function (name) {
              return "Name:";
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
