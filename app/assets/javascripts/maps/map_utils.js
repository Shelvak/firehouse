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
//    estos colores deberian ser por tipo de intervencion
    , stationMarker  = "/assets/map/marker-blue2.png"
    , basicMarker    = "/assets/map/marker-basic2.png"
    , interventions  = getMarkersInfo()

  setMarker(station, stationDesc, stationMarker, vectorLayer, 1)

  for (var i = 0, intervention; intervention = interventions[i]; i++) {
    var point       = new OpenLayers.Geometry.Point( intervention.longitude, intervention.latitude ).transform(fromProjection, toProjection)
      , index       = parseInt(intervention.index) + 1
      , description = '<h4>' + index + '</h4>' + intervention.address
      , graphic     = basicMarker

    setMarker(point, description, graphic, vectorLayer, 1)
    intervention.element.addEventListener('click', function(){
      var longitude = this.dataset.markerLongitude
        , latitude  = this.dataset.markerLatitude

      if (latitude && longitude) {
        var point = new OpenLayers.Geometry.Point( longitude, latitude ).transform(fromProjection, toProjection)
        drawLine(map, station, point)
      }


    })
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

//getMarkersInfo es lo unico que se esta usando ahora que esta leaflet colocado.
var getMarkersInfo = function () {
      var markersData = []
        , markersDiv  = document.getElementById('markers-data')
        , markers     = markersDiv.children
      for (var i = 0, markerData, marker; marker = markers[i]; i++) {
        markerData = {
          element   : marker,
          address   : marker.dataset.markerAddress,
          latitude  : marker.dataset.markerLatitude,
          longitude : marker.dataset.markerLongitude,
        }
        markersData.push(markerData)
      }
      return markersData
    }

  , setMarker = function (point, description, graphic, vectorLayer, count){
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

  , setFullscreenMapSize = function (){
      var map_canvas              = document.getElementById(MapUtils.map.div);
      document.body.height        = map_canvas.style.height = window.screen.height + 'px';
      document.body.width         = map_canvas.style.width = window.screen.width + 'px';
      document.body.style.padding = '0px';
    }

  , loadMap = function (latitude, longitude) {
      document.getElementById('map_canvas').innerHTML = '' // Deleting the old map to avoid double rendering
      var map            = new OpenLayers.Map("map_canvas")
        , mapnik         = new OpenLayers.Layer.OSM()
        , fromProjection = new OpenLayers.Projection("EPSG:4326")   // Transform from WGS 1984
        , toProjection   = new OpenLayers.Projection("EPSG:900913") // to Spherical Mercator Projection
        , zoom           = 16
//        , markers        = new OpenLayers.Layer.Markers( "Markers" )
        , markersLayer   = new OpenLayers.Layer.Vector("Overlay")
        , autocomplete   = this
        , latitude       = latitude
        , longitude      = longitude
        , position

      if (autocomplete.componentRestrictions) {
        var place = autocomplete.getPlace()
        latitude  = place.geometry.location.lat();
        longitude = place.geometry.location.lng();
        setLatitudeAndLongitude(latitude, longitude);
      }
      var point       = new OpenLayers.Geometry.Point( longitude, latitude ).transform(fromProjection, toProjection)
        , description = ''
        , graphic     = "/assets/map/marker-basic2.png"
        , position    = new OpenLayers.LonLat(longitude, latitude).transform( fromProjection, toProjection)

      setMarker(point, description, graphic, markersLayer, 1)

      map.addControl(new OpenLayers.Control.DragFeature(markersLayer, {
        autoActivate: true,
        onComplete: function (feature) {
          var newPosition = new OpenLayers.LonLat(feature.geometry.x, feature.geometry.y).transform( toProjection, fromProjection )
          setLatitudeAndLongitude(newPosition.lat, newPosition.lon)
        }
      }));
      map.addLayer(mapnik);
      map.addLayer(markersLayer);
      map.setCenter(position, zoom);
    }

  , drawLine = function (map, from, to) {
      var points    = [from, to]
        , line      = new OpenLayers.Geometry.LineString(points)
        , style     = {
            strokeColor   : '#0000ff',
            strokeOpacity : 0.5,
            strokeWidth   : 5
          }
        , lineFeature = new OpenLayers.Feature.Vector(line, null, style);

      if (lineLayer) map.removeLayer(lineLayer);

      lineLayer = new OpenLayers.Layer.Vector("Line Layer")
      lineLayer.addFeatures([lineFeature]);
      map.addLayer(lineLayer);
      map.addControl(new OpenLayers.Control.DrawFeature(lineLayer, OpenLayers.Handler.Path));
    }
  , lineLayer;

var MapUtils = ( function () {
  var station = {
          latitude    : '-32.926887'
        , longitude   : '-68.846255'
        , description : "Estación de bomberos"
      }
    , map = {
          div     : "map_canvas"
        , maxZoom : 18
        , minZoom : 10
    }
    , markerGraphics = {
          station : "/assets/map/marker-blue2.png"
        , basic   : "/assets/map/marker-basic2.png"
    }
    , interventions
    , loadInterventions = function () {
        interventions = getMarkersInfo()
      }
  return {
      loadInterventions : loadInterventions
    , map               : map
    , markerGraphics    : markerGraphics
    , station           : station
  }
}() )
