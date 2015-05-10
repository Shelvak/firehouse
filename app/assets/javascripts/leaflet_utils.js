var Leaflet = ( function () {
  var tile = { osm           : 'http://{s}.tile.osm.org/{z}/{x}/{y}.png'
             , openstreetmap : 'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png'
             }
    , map = { map     : ''
            , markers : []
            , route   : ''
            }
    , defaultMarkerInfo = { latitude    : MapUtils.station.latitude
                          , longitude   : MapUtils.station.longitude
                          , description : MapUtils.station.description
                          , draggable   : true
                          }
    //icons not working yet
    , icons = { redIcon : L.icon({
                            iconUrl      : 'map/marker-basic2.png',
                            shadowUrl    : 'leaf-shadow.png',
                            iconSize     : [38, 95], // size of the icon
                            shadowSize   : [50, 64], // size of the shadow
                            iconAnchor   : [22, 94], // point of the icon which will correspond to marker's location
                            shadowAnchor : [4, 62],  // the same for the shadow
                            popupAnchor  : [-3, -76] // point from which the popup should open relative to the iconAnchor
                          })
              }
    , initMap = function (markerInfo) {
        Leaflet.map.map = new L.Map(MapUtils.map.div)

        var map       = Leaflet.map.map
          , osmUrl    = tile.osm
          , osmAttrib = ''
          , osm       = new L.TileLayer(osmUrl, {
                                          minZoom     : MapUtils.map.minZoom,
                                          maxZoom     : MapUtils.map.maxZoom,
                                          attribution : osmAttrib
                                        })
          , point     = new L.LatLng(MapUtils.station.latitude,
                                     MapUtils.station.longitude)
          , marker
        map.setView(point, 17);
        map.addLayer(osm);
        var draggableMarker = markerInfo || defaultMarkerInfo

        marker = L.marker([draggableMarker.latitude, draggableMarker.longitude], { draggable: draggableMarker.draggable })
        marker.addTo(map);
        marker.bindPopup(draggableMarker.description).openPopup();
        bindDrag(marker)
        Leaflet.map.markers.push(marker)

        if (!draggableMarker.draggable) drawRoute(map, draggableMarker.latitude, draggableMarker.longitude)
      }

    , changeMarker = function (event, description) {
        var map          = Leaflet.map.map
          , markers      = Leaflet.map.markers
          , autocomplete = event
          , place        = autocomplete.getPlace()
          , latitude     = place.geometry.location.lat()
          , longitude    = place.geometry.location.lng()
          , point        = new L.LatLng(latitude, longitude)
          , marker

        setLatitudeAndLongitude(latitude, longitude);

        map.setView(point, 17);

        // Actualizo el marcador en vez de crear uno nuevo
        if (markers.length > 0) {
          marker = markers[0]
          marker.setLatLng(point);
        }
        else {
          marker = L.marker(point, { draggable: true }).addTo(map)
          // Siempre debería existir un marcador al menos, pero lo agregamos por si las dudas
          markers.push(marker)
        }
        // Bindeo de popup y movimiento del marcador
        bindDrag(marker, description)
    }
    , initLargeMap = function (fullscreen) {
        if (fullscreen) setFullscreenMapSize();
        Leaflet.map.map = new L.Map(MapUtils.map.div)

        var map       = Leaflet.map.map
          , osmUrl    = tile.osm
          , osmAttrib = ''
          , osm       = new L.TileLayer(osmUrl, {
                                          minZoom     : MapUtils.map.minZoom,
                                          maxZoom     : MapUtils.map.maxZoom,
                                          attribution : osmAttrib
                                        })
          , interventions = getMarkersInfo()
          , arrayOfLatLngs = []
          , stationPoint = new L.LatLng(MapUtils.station.latitude,
                                     MapUtils.station.longitude)
          , stationMarker = L.marker(stationPoint).addTo(map)

        stationMarker.bindPopup(MapUtils.station.description)

        for (var i = 0, intervention; intervention = interventions[i]; i++) {
          if (intervention.latitude && intervention.longitude) {
            var point       = new L.LatLng(intervention.latitude, intervention.longitude)
              , description = '<h4>' + (i+1) + '</h4>' + intervention.address
              , marker      = L.marker(point)
              , htmlElement = intervention.element

            arrayOfLatLngs[i]               = [intervention.latitude, intervention.longitude]
            Leaflet.map.markers[i]          = marker
            //Guardo en el html el indice que corresponde al array de marcadores para poderlo leer despues en el evento click
            htmlElement.dataset.markerIndex = Leaflet.map.markers.length - 1

            marker.addTo(map).bindPopup(description)
            htmlElement.addEventListener('click', function () {
              var index     = this.dataset.markerIndex
                , marker    = Leaflet.map.markers[index]
                , latitude  = marker._latlng.lat
                , longitude = marker._latlng.lng
              marker.openPopup()
              drawRoute(Leaflet.map.map, latitude, longitude)
            })
          }
        }

        fitBounds(map, arrayOfLatLngs)
        map.addLayer(osm);
    }
    , bindDrag = function (marker, description) {
        marker.on('dragend', function (event) {
          var position  = marker.getLatLng()
            , address   = document.getElementById('intervention_address').value
            , popupText = description || address
          setLatitudeAndLongitude(position.lat, position.lng)
          this.bindPopup(popupText)
        })
      }
    , fitBounds = function (map, arrayOfLatLngs) {
        var bounds = new L.LatLngBounds(arrayOfLatLngs);
        map.fitBounds(bounds);
      }
    , drawRoute = function (map, latitude, longitude) {
        var station  = L.latLng(MapUtils.station.latitude, MapUtils.station.longitude)
          , newPoint = L.latLng(parseFloat(latitude), parseFloat(longitude))
          , bounds   = [
                [station.lat,  station.lng ]
              , [newPoint.lat, newPoint.lng]
            ]
        if (Leaflet.map.route) {
          Leaflet.map.route.setWaypoints([station, newPoint])
        }
        else {
          Leaflet.map.route = L.Routing.control({
              waypoints          : [station, newPoint]
            , draggableWaypoints : false
          }).addTo(map);
        }
        fitBounds(map, bounds)
      };

  return {
      changeMarker : changeMarker
    , initLargeMap : initLargeMap
    , initMap      : initMap
    , map          : map
  }
}() );
