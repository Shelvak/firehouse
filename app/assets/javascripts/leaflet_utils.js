var Leaflet = ( function () {
  var tile = { osm           : 'http://{s}.tile.osm.org/{z}/{x}/{y}.png'
             , openstreetmap : 'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png'
             }
    , map = { map     : ''
            , markers : []
            , route   : ''
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
          , osmUrl    = tile
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
        if (markerInfo) {
          marker = L.marker([markerInfo.latitude, markerInfo.longitude])
          marker.addTo(map);
          marker.bindPopup(markerInfo.description).openPopup();

          drawRoute(map, markerInfo.latitude, markerInfo.longitude)
        }
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
        }
        // Bindeo de popup y movimiento del marcador
        marker.bindPopup(description)
        marker.on('dragend', function (event) {
          var position = marker.getLatLng();
          setLatitudeAndLongitude(position.lat, position.lng)
        })
    }
    , initLargeMap = function (fullscreen) {
        if (fullscreen) setFullscreenMapSize();
        Leaflet.map.map = new L.Map(MapUtils.map.div)

        var map       = Leaflet.map.map
          , osmUrl    = tile
          , osmAttrib = ''
          , osm       = new L.TileLayer(osmUrl, {
                                          minZoom     : MapUtils.map.minZoom,
                                          maxZoom     : MapUtils.map.maxZoom,
                                          attribution : osmAttrib
                                        })
          , interventions = getMarkersInfo()
          , arrayOfLatLngs = []
          , bounds
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
            htmlElement.dataset.markerIndex = Leaflet.map.markers.length - 1

            marker.addTo(map).bindPopup(description)
            htmlElement.addEventListener('click', function () {
              var index = this.dataset.markerIndex
              Leaflet.map.markers[index].openPopup()
              drawRoute(Leaflet.map.map, this.dataset.markerLatitude, this.dataset.markerLongitude)
            })
          }
        }

        bounds = new L.LatLngBounds(arrayOfLatLngs);
        map.fitBounds(bounds);
        map.addLayer(osm);
    }
    , drawRoute = function (map, latitude, longitude) {
        var station  = L.latLng(MapUtils.station.latitude, MapUtils.station.longitude)
          , newPoint = L.latLng(parseFloat(latitude), parseFloat(longitude))
        if (Leaflet.map.route) {
          Leaflet.map.route.setWaypoints([station, newPoint])
        }
        else {
          Leaflet.map.route = L.Routing.control({
            waypoints: [station, newPoint]
          }).addTo(map);
        }
      };

  return {
      changeMarker : changeMarker
    , initLargeMap : initLargeMap
    , initMap      : initMap
    , map          : map
  }
}() );