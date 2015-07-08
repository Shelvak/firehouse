//Leaflet version: 0.7.2
var Leaflet = ( function () {
  var tile = { osm           : 'http://{s}.tile.osm.org/{z}/{x}/{y}.png'
             , openstreetmap : 'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png'
             }
    , elements = { map     : ''
                 , markers : []
                 , route   : ''
                 , defaultMarkerInfo : {
                       latitude    : MapUtils.station.latitude
                     , longitude   : MapUtils.station.longitude
                     , description : MapUtils.station.description
                     , draggable   : true
                     , isStation   : true
                   }
                 }
    , options = { shouldDrawRoute : false
                , makeFullScreen  : false
                , showAlertInfo   : false
                , showGeneralMap  : false
                , showStation     : false
                , showTruckInfo   : false
                }

    , leafletImagesRoute = '/leaflet/images'
    , icons = { redIcon : L.icon({
                            iconUrl      : leafletImagesRoute + '/custom/marker-basic.png'
                          , shadowUrl    : leafletImagesRoute + '/marker-shadow.png'
                          , iconSize     : [38, 38] // size of the icon
                          , shadowSize   : [55, 38] // size of the shadow
                          , iconAnchor   : [18, 38] // point of the icon which will correspond to marker's location
                          , shadowAnchor : [16, 40] // the same for the shadow
                          , popupAnchor  : [1, -32] // point from which the popup should open relative to the iconAnchor
                          })
              }
    , initMap = function (markerInfo) {
        L.Icon.Default.imagePath = leafletImagesRoute
        Leaflet.elements.map          = new L.Map(MapUtils.map.div)
        //Fix para mostrar el marcador cuando apreto uno de los botones rapidos. Deberia cambiar el marcador si esta, no crear uno nuevo
        Leaflet.elements.markers      = []

        var map       = Leaflet.elements.map
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
        var draggableMarker = markerInfo || Leaflet.elements.defaultMarkerInfo

        marker = L.marker([draggableMarker.latitude, draggableMarker.longitude], { draggable: draggableMarker.draggable })
        marker.addTo(map);

        // ##inicio codigo duplicado en changeMarker, unificar a un solo metodo que cree el marcador y lo agregue o use uno existente
        // Cambio popup
        setPopup(marker, draggableMarker.description)

        // Bindeo movimiento del marcador
        bindDrag(marker)
        // ##fin codigo duplicado en changeMarker, unificar a un solo metodo que cree el marcador y lo agregue o use uno existente

        Leaflet.elements.markers.push(marker)

        if (!draggableMarker.draggable) drawRoute(draggableMarker.latitude, draggableMarker.longitude)
      }

    , changeMarker = function (description, event) {
        var map          = Leaflet.elements.map
          , markers      = Leaflet.elements.markers
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
      setPopup(marker, description)

      // Bindeo movimiento del marcador
      bindDrag(marker)
    }
    , setPopup = function (marker, description) {
        var address   = document.querySelector('[data-intervention="address"]').value
          , popupText = description || address
        if (popupText) {
          marker.closePopup()
          marker.bindPopup(popupText)
          marker.openPopup()
        }
    }
    , initLargeMap = function (fullscreen) {
        L.Icon.Default.imagePath = leafletImagesRoute
        if (fullscreen) setFullscreenMapSize();
        Leaflet.elements.map = new L.Map(MapUtils.map.div)

        var map       = Leaflet.elements.map
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
            Leaflet.elements.markers[i]          = marker
            //Guardo en el html el indice que corresponde al array de marcadores para poderlo leer despues en el evento click
            htmlElement.dataset.markerIndex = Leaflet.elements.markers.length - 1

            marker.addTo(map).bindPopup(description)
            htmlElement.addEventListener('click', function () {
              var index     = this.dataset.markerIndex
                , marker    = Leaflet.elements.markers[index]
                , latitude  = marker._latlng.lat
                , longitude = marker._latlng.lng
              marker.openPopup()
              drawRoute(Leaflet.elements.map, latitude, longitude)
            })
          }
        }

        fitBounds(map, arrayOfLatLngs)
        map.addLayer(osm);
    }
    // Bindea las acciones para completar satisfactoriamente el drag del marcador
    , bindDrag = function (marker) {
        marker.on('dragend', function (event) {
          var position = marker.getLatLng()
          setLatitudeAndLongitude(position.lat, position.lng)
          setPopup(marker)
        })
      }
    // Coloca el zoom necesario para mostrar todos los marcadores
    , fitBounds = function (map, arrayOfLatLngs) {
        var bounds = new L.LatLngBounds(arrayOfLatLngs);
        map.fitBounds(bounds);
    }
    , drawRoute = function (latitude, longitude) {
        var station  = L.latLng(MapUtils.station.latitude, MapUtils.station.longitude)
          , newPoint = L.latLng(parseFloat(latitude), parseFloat(longitude))
//          , bounds   = [
//                [station.lat,  station.lng ]
//              , [newPoint.lat, newPoint.lng]
//            ]
        if (Leaflet.elements.route) {
          Leaflet.elements.route.setWaypoints([station, newPoint])
        }
        else {
          Leaflet.elements.route = L.Routing.control({
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
          }).addTo(Leaflet.elements.map);
        }
      // fitBounds desactivado del ruteo porque falla al hacer zoomout y deja el mapa en gris
        // fitBounds(map, bounds)
      }
    , newMap = function () {
        var shouldSetInterventions = Leaflet.options.showGeneralMap
          , shouldMakeFullScreen   = Leaflet.options.makeFullScreen

        if (shouldMakeFullScreen) setFullscreenMapSize()

        setupMap()
        setNewMarker(Leaflet.elements.defaultMarkerInfo)

        if (shouldSetInterventions) setInterventionsMarkers()
      }
    , setupMap = function () {
        L.Icon.Default.imagePath = leafletImagesRoute
        Leaflet.elements.map     = new L.Map(MapUtils.map.div)

        var osmUrl    = tile.osm
          , osmAttrib = ''
          , osm       = new L.TileLayer(osmUrl, {
              minZoom     : MapUtils.map.minZoom
            , maxZoom     : MapUtils.map.maxZoom
            , attribution : osmAttrib
          })
          , point     = new L.LatLng(  MapUtils.station.latitude
                                     , MapUtils.station.longitude
                                    )

        Leaflet.elements.map.setView(point, 17)
        Leaflet.elements.map.addLayer(osm)
      }
    , setNewMarker = function (markerInfo) {
        var marker = L.marker([markerInfo.latitude, markerInfo.longitude], { draggable: markerInfo.draggable })

        if (markerInfo.isStation) marker.setIcon(icons.redIcon)

        marker.addTo(Leaflet.elements.map);

        if (!Leaflet.options.shouldDrawRoute) setLatitudeAndLongitude(markerInfo.latitude, markerInfo.longitude)
        setPopup(marker, markerInfo.description)

        if (markerInfo.draggable) bindDrag(marker)
        if (Leaflet.options.shouldDrawRoute) drawRoute(markerInfo.latitude, markerInfo.longitude)

        Leaflet.elements.markers.push(marker)
      }
    , setInterventionsMarkers = function () {
        var interventions  = getMarkersInfo()
          , arrayOfLatLngs = []

        for (var i = 0, intervention; intervention = interventions[i]; i++) {
          if (intervention.latitude && intervention.longitude) {
            var point       = new L.LatLng(intervention.latitude, intervention.longitude)
              , description = '<h4>' + (i+1) + '</h4>' + intervention.address
              , marker      = L.marker(point)
              , htmlElement = intervention.element

            arrayOfLatLngs[i]               = [intervention.latitude, intervention.longitude]
            Leaflet.elements.markers[i]     = marker
            htmlElement.dataset.markerIndex = Leaflet.elements.markers.length - 1
            //Guardo en el html el indice que corresponde al array de marcadores para poderlo leer despues en el evento click

            marker.addTo(Leaflet.elements.map).bindPopup(description)

            if (!Leaflet.options.makeFullScreen || !Leaflet.options.showSingleMap) {
              htmlElement.addEventListener('click', function () {
                var index     = this.dataset.markerIndex
                  , marker    = Leaflet.elements.markers[index]
                  , latitude  = marker._latlng.lat
                  , longitude = marker._latlng.lng
                marker.openPopup()
                drawRoute(Leaflet.elements.map, latitude, longitude)
              })
            }
          }
        }
      };

  return {
      changeMarker : changeMarker
    , initLargeMap : initLargeMap
    , initMap      : initMap
    , newMap       : newMap
    , elements     : elements
    , options      : options
  }
}() );
