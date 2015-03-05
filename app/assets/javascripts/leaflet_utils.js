var Leaflet = ( function () {
  var tile    = 'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png'
    , map = {
          map     : ''
        , markers : []
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
            var point = new L.LatLng(intervention.latitude, intervention.longitude)
              , description = '<h4>' + (i+1) + '</h4>' + intervention.address
              , marker = L.marker(point)
              , htmlElement = intervention.element
  //            , graphic = basicMarker

            arrayOfLatLngs[i] = [intervention.latitude, intervention.longitude]
            marker.addTo(map).bindPopup(description)
            Leaflet.map.markers[i] = marker
            htmlElement.dataset.markerIndex = Leaflet.map.markers.length - 1
            htmlElement.addEventListener('click', function () {
              var index = this.dataset.markerIndex
              Leaflet.map.markers[index].openPopup()
            })
          }
        }

        bounds = new L.LatLngBounds(arrayOfLatLngs);
        map.fitBounds(bounds);
        map.addLayer(osm);
    }

  return {
      changeMarker : changeMarker
    , initLargeMap : initLargeMap
    , initMap      : initMap
    , map          : map
  }
}() );