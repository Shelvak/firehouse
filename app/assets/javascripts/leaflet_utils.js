//Leaflet version: 0.7.2
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
    , leafletImagesRoute = '/leaflet/images'
    , icons = { redIcon : L.icon({
                            iconUrl      : leafletImagesRoute + '/custom/marker-basic.png'
                          , shadowUrl    : leafletImagesRoute + '/marker-shadow.png'
                          , iconSize     : [38, 38] // size of the icon
                        ,   shadowSize   : [55, 38] // size of the shadow
                          , iconAnchor   : [18, 38] // point of the icon which will correspond to marker's location
                        ,   shadowAnchor : [16, 40] // the same for the shadow
                          , popupAnchor  : [1, -32] // point from which the popup should open relative to the iconAnchor
                          })
              }
    , initMap = function (markerInfo) {
        L.Icon.Default.imagePath = leafletImagesRoute
        Leaflet.map.map          = new L.Map(MapUtils.map.div)
        //Fix para mostrar el marcador cuando apreto uno de los botones rapidos. Deberia cambiar el marcador si esta, no crear uno nuevo
        Leaflet.map.markers      = []

        var map       = Leaflet.map.map
          , osmUrl    = tile.osm
          , osmAttrib = ''
          , osm       = new L.TileLayer(osmUrl, {
                                            minZoom     : MapUtils.map.minZoom
                                          , maxZoom     : MapUtils.map.maxZoom
                                          , attribution : osmAttrib
                                        })
          , point     = new L.LatLng(MapUtils.station.latitude,
                                     MapUtils.station.longitude)
          , marker
        map.setView(point, 17);
        map.addLayer(osm);
        var draggableMarker = markerInfo || defaultMarkerInfo

        marker = L.marker([draggableMarker.latitude, draggableMarker.longitude], { draggable: draggableMarker.draggable })
        marker.addTo(map);

        // ##inicio codigo duplicado en changeMarker, unificar a un solo metodo que cree el marcador y lo agregue o use uno existente
        // Cambio popup
        changePopup(marker, draggableMarker.description)

        // Bindeo movimiento del marcador
        bindDrag(marker)
        // ##fin codigo duplicado en changeMarker, unificar a un solo metodo que cree el marcador y lo agregue o use uno existente

        Leaflet.map.markers.push(marker)

        if (!draggableMarker.draggable) drawRoute(map, draggableMarker.latitude, draggableMarker.longitude)
      }

    , changeMarker = function (description, event) {
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
      // Cambio popup
      changePopup(marker, description)

      // Bindeo movimiento del marcador
      bindDrag(marker)
    }
    , changePopup = function (marker, description) {
        var address   = document.querySelector('[data-intervention="address"]').value
          , popupText = description || address

        marker.closePopup()
        marker.bindPopup(popupText)
        marker.openPopup()
    }
    , initLargeMap = function (fullscreen) {
        L.Icon.Default.imagePath = leafletImagesRoute
        if (fullscreen) setFullscreenMapSize();
        Leaflet.map.map = new L.Map(MapUtils.map.div)

        var map       = Leaflet.map.map
          , osmUrl    = tile.osm
          , osmAttrib = ''
          , osm       = new L.TileLayer(osmUrl, {
                                            minZoom     : MapUtils.map.minZoom
                                          , maxZoom     : MapUtils.map.maxZoom
                                          , attribution : osmAttrib
                                        })
          , interventions = getMarkersInfo()
          , arrayOfLatLngs = []
          , stationPoint = new L.LatLng(MapUtils.station.latitude,
                                     MapUtils.station.longitude)
          , stationMarker = L.marker(stationPoint).addTo(map)

        stationMarker.bindPopup(MapUtils.station.description)
        stationMarker.setIcon(icons.redIcon)

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
    // Bindea las acciones para completar satisfactoriamente el drag del marcador
    , bindDrag = function (marker) {
        var position = marker.getLatLng()

        marker.on('dragend', function (event) {
          setLatitudeAndLongitude(position.lat, position.lng)
        })
      }
    // Coloca el zoom necesario para mostrar todos los marcadores
    , fitBounds = function (map, arrayOfLatLngs) {
        var bounds = new L.LatLngBounds(arrayOfLatLngs);
        map.fitBounds(bounds);
    }
    , drawRoute = function (map, latitude, longitude) {
        var station  = L.latLng(MapUtils.station.latitude, MapUtils.station.longitude)
          , newPoint = L.latLng(parseFloat(latitude), parseFloat(longitude))
//          , bounds   = [
//                [station.lat,  station.lng ]
//              , [newPoint.lat, newPoint.lng]
//            ]
        if (Leaflet.map.route) {
          Leaflet.map.route.setWaypoints([station, newPoint])
        }
        else {
          Leaflet.map.route = L.Routing.control({
              waypoints          : [station, newPoint]
            , draggableWaypoints : false
            , createMarker       : function(i, wp) {
                // El primer marcador solamente tiene que ser de color rojo porque es la estación
                if (i == 0) {
                  return L.marker(wp.latLng, {
                    icon: icons.redIcon
                  })
                }
              }
          }).addTo(map);
        }
        // fitBounds desactivado del ruteo porque falla al hacer zoomout y deja el mapa en gris
        // fitBounds(map, bounds)
      };

  return {
      changeMarker : changeMarker
    , initLargeMap : initLargeMap
    , initMap      : initMap
    , map          : map
  }
}() );
