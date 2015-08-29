//Leaflet version: 0.7.2
var Leaflet = ( function () {
  var elements = { map     : ''
                 , markers : []
                 , route   : ''
                 , defaultMarkerInfo : {
                       latitude    : MapUtils.station.latitude
                     , longitude   : MapUtils.station.longitude
                     , description : MapUtils.station.description
                     , draggable   : false
                     , isStation   : true
                   }
                 }
    , options = { shouldDrawRoute       : false
                , shouldMakeFullScreen  : false
                , shouldShowAlertInfo   : false
                , shouldShowGeneralMap  : false
                , shouldShowSimple      : false
                , shouldShowStation     : false
                , shouldShowTruckInfo   : false
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

    , changeMarker = function (description, event) {
        var map          = Leaflet.elements.map
          , markers      = Leaflet.elements.markers
          , autocomplete = event
          , place        = autocomplete.getPlace()
          , latitude     = place.geometry.location.lat()
          , longitude    = place.geometry.location.lng()
          , point        = new L.LatLng(latitude, longitude)
          , marker
          , markersCount = markers.length

        setLatitudeAndLongitude(latitude, longitude);

        map.setView(point, 17);

        // Actualizo el marcador en vez de crear uno nuevo
        if (markersCount > 0) {
          marker = markers[markersCount - 1]
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
      Intervention.saveIntervention(false, true)
    }
    , setPopup = function (marker, description) {
        var popupText

        if (!description) {
          var address   = document.querySelector('[data-intervention="address"]').value
          popupText = address
        }
        else {
          popupText = description
        }

        if (popupText) {
          marker.closePopup()
          marker.bindPopup(popupText)
          marker.openPopup()
        }
    }
    // Bindea las acciones para completar satisfactoriamente el drag del marcador
    , bindDrag = function (marker) {
        marker.on('dragend', function (event) {
          var position = marker.getLatLng()
          setLatitudeAndLongitude(position.lat, position.lng)
          setPopup(marker)
          Intervention.saveIntervention(false, true)
        })
      }
    // Coloca el zoom necesario para mostrar todos los marcadores
    , fitBounds = function (arrayOfLatLngs) {
        var bounds = new L.LatLngBounds(arrayOfLatLngs)
        Leaflet.elements.map.fitWorld(bounds)
    }
    , drawRoute = function (latitude, longitude) {
        var station  = L.latLng(MapUtils.station.latitude, MapUtils.station.longitude)
          , newPoint = L.latLng(parseFloat(latitude), parseFloat(longitude))
          , bounds   = [
                [station.lat,  station.lng ]
              , [newPoint.lat, newPoint.lng]
            ]
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

         fitBounds(bounds)
      }
    , newMap = function () {
        var shouldSetInterventions = Leaflet.options.shouldShowGeneralMap
          , shouldMakeFullScreen   = Leaflet.options.shouldMakeFullScreen

        if (shouldMakeFullScreen) setFullscreenMapSize()

        Leaflet.elements.map = new L.Map(MapUtils.map.div)

        if (shouldSetInterventions) setInterventionsMarkers()
        setNewMarker(Leaflet.elements.defaultMarkerInfo)

        setupMap(shouldSetInterventions)

      }
    , setupMap = function (shouldShowMarkersLayer) {
        L.Icon.Default.imagePath = leafletImagesRoute

        var options      = {
              minZoom     : MapUtils.map.minZoom
            , maxZoom     : MapUtils.map.maxZoom
            , attribution : ''
          }
          , baseTiles    = getBaseTiles(options)
          , specialTiles = getSpecialTiles(options, shouldShowMarkersLayer)

          , point         = new L.LatLng(  Leaflet.elements.defaultMarkerInfo.latitude
                                         , Leaflet.elements.defaultMarkerInfo.longitude
                                        )
          , zoom          = Leaflet.options.shouldShowGeneralMap ? 13 : 17

        Leaflet.elements.map.setView(point, zoom)

        L.control.layers(baseTiles, specialTiles).addTo(Leaflet.elements.map)
      }
    , setNewMarker = function (markerInfo) {
        var marker = L.marker([markerInfo.latitude, markerInfo.longitude], { draggable: markerInfo.draggable })

        if (markerInfo.isStation) marker.setIcon(icons.redIcon)

        marker.addTo(Leaflet.elements.map);

        if (Leaflet.options.shouldShowSimple) setLatitudeAndLongitude(markerInfo.latitude, markerInfo.longitude)
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
            var point                 = new L.LatLng(intervention.latitude, intervention.longitude)
              , description           = intervention.address
              , marker                = L.marker(point)
              , htmlElement           = intervention.element
              , shouldBindRoutDrawing = Leaflet.options.shouldShowGeneralMap && !Leaflet.options.shouldMakeFullScreen

            arrayOfLatLngs[i]               = [intervention.latitude, intervention.longitude]
            Leaflet.elements.markers[i]     = marker
            htmlElement.dataset.markerIndex = Leaflet.elements.markers.length - 1
            //Guardo en el html el indice que corresponde al array de marcadores para poderlo leer despues en el evento click

            marker.addTo(Leaflet.elements.map).bindPopup(description)

            if (shouldBindRoutDrawing) {
              htmlElement.addEventListener('click', function () {
                var index     = this.dataset.markerIndex
                  , marker    = Leaflet.elements.markers[index]
                  , latitude  = marker._latlng.lat
                  , longitude = marker._latlng.lng
                marker.openPopup()
                drawRoute(latitude, longitude)
              })
            }
          }
        }
      }
    , getBaseTiles = function (options) {
        var tileset       = MapTiles.base
          , osm           = new L.TileLayer(tileset.osm,           options)
          , thunderforest = new L.TileLayer(tileset.thunderforest, options)
          , mapnik        = new L.TileLayer(tileset.mapnik,        options)
          , baseTiles     = {
                'Base'            : osm
              , 'Curvas de nivel' : thunderforest
              , 'Mapnik'          : mapnik
            }

        Leaflet.elements.map.addLayer(osm)

        return baseTiles
      }
    , getSpecialTiles = function (options, shouldShowMarkersLayer) {
        var tileset       = MapTiles.special
          , openfire      = new L.TileLayer(tileset.openfire, options)
          , markersLayer  = L.layerGroup(Leaflet.elements.markers)
          , specialTiles  = {
              'Mostrar Hidrantes' : openfire
            }


        if (shouldShowMarkersLayer) specialTiles['Mostrar Marcadores'] = markersLayer

        Leaflet.elements.map.addLayer(markersLayer)

        return specialTiles
      };

  return {
      changeMarker : changeMarker
    , newMap       : newMap
    , elements     : elements
    , options      : options
  }
}() );
