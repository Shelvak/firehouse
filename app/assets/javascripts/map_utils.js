var loadLargeMap = function () {
  var firehouseStation = {
        latitude  : '-32.926887'
      , longitude : '-68.846255'
    }
    , map            = new OpenLayers.Map("map_canvas")
    , mapnik         = new OpenLayers.Layer.OSM()
    , fromProjection = new OpenLayers.Projection("EPSG:4326")   // Transform from WGS 1984
    , toProjection   = new OpenLayers.Projection("EPSG:900913") // to Spherical Mercator Projection
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
      , index       = parseInt(interventions[i].index) + 1
      , description = '<h4>' + index + '</h4>' + interventions[i].address
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
      , '<div>' + feature.attributes.description + '</div>'
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
  var map_canvas              = document.getElementById('map_canvas');
  document.body.height        = map_canvas.style.height = window.screen.height + 'px';
  document.body.width         = map_canvas.style.width = window.screen.width + 'px';
  document.body.style.padding = '0px';
};

var loadMap = function (latitude, longitude) {
  document.getElementById('map_canvas').innerHTML = '' // Deleting the old map to avoid double rendering
  var map            = new OpenLayers.Map("map_canvas")
    , mapnik         = new OpenLayers.Layer.OSM()
    , fromProjection = new OpenLayers.Projection("EPSG:4326")   // Transform from WGS 1984
    , toProjection   = new OpenLayers.Projection("EPSG:900913") // to Spherical Mercator Projection
    , zoom           = 16
    , markers        = new OpenLayers.Layer.Markers( "Markers" )
    , autocomplete   = this
    , latitude       = latitude
    , longitude      = longitude
    , position

  //todo: buscar una mejor forma de saber si viene o no por autocompletado
  if (autocomplete.componentRestrictions) {
    var place = autocomplete.getPlace()
    latitude  = place.geometry.location.lat();
    longitude = place.geometry.location.lng();
    setLatitudeAndLongitude(latitude, longitude);
  }

  position = new OpenLayers.LonLat(longitude, latitude).transform( fromProjection, toProjection)
  markers.addMarker(new OpenLayers.Marker(position));

  map.addLayer(mapnik);
  map.addLayer(markers);
  map.setCenter(position, zoom);
}
