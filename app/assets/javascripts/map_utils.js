var loadLargeMap = function () {
  var firehouseStation = {
        latitude  : '-32.926887'
      , longitude : '-68.846255'
    }
    , map            = new OpenLayers.Map("map_canvas")
    , mapnik         = new OpenLayers.Layer.OSM()
    , mapnik         = new OpenLayers.Layer.OSM()
    , fromProjection = new OpenLayers.Projection("EPSG:4326")   // Transform from WGS 1984 << WHAT?
    , toProjection   = new OpenLayers.Projection("EPSG:900913") // to Spherical Mercator Projection << DOUBLE WHAT?
    , position       = new OpenLayers.LonLat(firehouseStation.longitude,firehouseStation.latitude).transform( fromProjection, toProjection)
    , vectorLayer    = new OpenLayers.Layer.Vector("Overlay")
    , zoom           = 13
    , station        = new OpenLayers.Geometry.Point( firehouseStation.longitude, firehouseStation.latitude ).transform(fromProjection, toProjection)
    , stationDesc    = "Estación de bomberos"
    , stationMarker  = "/assets/map/marker-basic2.png" //todo: cambiar por el azul
    , basicMarker    = "/assets/map/marker-basic2.png"

  setMarker(station,stationDesc, stationMarker, vectorLayer, 1)

  for (i = 0; i < interventions.length; i++) {
    var point       = new OpenLayers.Geometry.Point( interventions[i].longitude, interventions[i].latitude ).transform(fromProjection, toProjection)
//        , description = interventions[i].index + '<br>' + interventions[i].address
      , description = interventions[i].address
      , graphic     = basicMarker

    setMarker(point, description, graphic, vectorLayer, 1)
  }

  map.addLayer(mapnik);
  map.addLayer(vectorLayer);
  map.setCenter(position, zoom);

  //Add a selector control to the vectorLayer with popup functions
  var controls = {
    selector: new OpenLayers.Control.SelectFeature(vectorLayer, { onSelect: createPopup, onUnselect: destroyPopup })
  };

  function createPopup(feature) {
    feature.popup = new OpenLayers.Popup.FramedCloud(
      "pop"
      , feature.geometry.getBounds().getCenterLonLat()
      , null
      , '<div>'+feature.attributes.description+'</div>'
      , null
      , true
      , function() { controls['selector'].unselectAll(); }
    );
    //feature.popup.closeOnMove = true;
    map.addPopup(feature.popup);
  }

  function destroyPopup(feature) {
    feature.popup.destroy();
    feature.popup = null;
  }

  map.addControl(controls['selector']);
  controls['selector'].activate();

};

function setMarker(point, description, graphic, vectorLayer, count){
  var feature = new OpenLayers.Feature.Vector(
    point,
    { description     : description },
    { externalGraphic : graphic
      , graphicHeight   : 25
      , graphicWidth    : 25
      , graphicXOffset  : -15
      , graphicYOffset  : -20  }
  );
  vectorLayer.addFeatures(feature);
}

var setFullscreenMapSize = function(){
  var map_canvas = document.getElementById('map_canvas');
  document.body.height = map_canvas.style.height = window.screen.height + 'px';
  document.body.width = map_canvas.style.width = window.screen.width + 'px';
  document.body.style.padding = '0px';
};