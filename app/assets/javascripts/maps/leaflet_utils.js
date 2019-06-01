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
        } else {
          opts = _.defaults(
            {
              latitude: point.lat,
              longitude: point.lon,
              draggable: true
            },
            Leaflet.elements.defaultMarkerInfo
          )
          marker = setNewMarker(opts)
        }
        // Cambio popup
        setPopup(marker, description)

        // Bindeo movimiento del marcador
        bindDrag(marker)
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
    , setLatAndLongFromContextEvent = function(event) {
        var marker = Leaflet.elements.markers[0],
            point  = event.latlng

        marker.setLatLng(point);
        setLatitudeAndLongitude(point.lat, point.lng)
      }
    // Bindea las acciones para completar satisfactoriamente el drag del marcador
    , bindDrag = function (marker) {
        marker.on('dragend', function () {
          var position = marker.getLatLng()
          geocoder = new google.maps.Geocoder()
          geocoder.geocode({ 'location': position }, function(results, status) {
            if (results.length)  {
              notes = $('#intervention_kind_notes')
              wrote = notes.val()

              newLine = '[' + Helpers.getHour() + '] ' + results[0].formatted_address

              if ( _.last(wrote.split("\n")) != newLine )
                if ( wrote.length )
                  wrote += "\n" + newLine
                else
                  wrote = newLine

              notes.val(wrote)

              Intervention.saveField(notes)
            }
          })
          setLatitudeAndLongitude(position.lat, position.lng)
          setPopup(marker)
        })
      }
    // Coloca el zoom necesario para mostrar todos los marcadores
    , fitBounds = function (arrayOfLatLngs) {
        var bounds = new L.LatLngBounds(arrayOfLatLngs)
        Leaflet.elements.map.fitBounds(bounds)
    }
    , fitMarkers = function (first, second) {
        var bounds = new L.LatLngBounds([first, second])

        Leaflet.elements.map.fitBounds(bounds, {
            paddingTopLeft: [2, 2],
            paddingBottomRight: [2, 2]
        });
    }
    , drawRoute = function (latitude, longitude) {
        var station  = L.latLng(MapUtils.station.latitude, MapUtils.station.longitude)
          , newPoint = L.latLng(parseFloat(latitude), parseFloat(longitude))
          , bounds   = [
                [station.lat,  station.lng]
              , [newPoint.lat, newPoint.lng]
            ]

        if (Leaflet.elements.route) {
            Leaflet.elements.map.removeControl(Leaflet.elements.route);
        }
        Leaflet.elements.route = L.Routing.control({
              waypoints          : [station, newPoint]
            // , lineOptions        : {addWaypoints: false}
            // , autoRoute          : false
            , routeWhileDragging : false
            , showAlternatives   : false
            // , draggableWaypoints : false
            , createMarker       : function(i, wp) {
                // El primer marcador solamente tiene que ser de color rojo porque es la estación
                if (i == 0) {
                    return L.marker(wp.latLng, {
                        icon: icons.redIcon
                    })
                }
            }
        }).addTo(Leaflet.elements.map);

        // If we fit the markers/bounds more than ones, map freeze and not auto-refresh
        //fitMarkers(station, newPoint)
        if (Leaflet.options.shouldFitMarkers) {
            setTimeout( function() {fitBounds(bounds)}, 1500);
        }
      }
    , newMap = function () {
        L.Icon.Default.imagePath = leafletImagesRoute;

        var shouldSetInterventions = Leaflet.options.shouldShowGeneralMap
          , shouldMakeFullScreen   = Leaflet.options.shouldMakeFullScreen
          , mapOpts                = {}

        if (shouldMakeFullScreen) setFullscreenMapSize()

        if (Leaflet.elements.defaultMarkerInfo.draggable && Leaflet.options.shouldShowSimple) {
          mapOpts.contextmenu = true
          mapOpts.contextmenuItems = [
            {
              text: 'Poner marcador aquí',
              callback: setLatAndLongFromContextEvent
            }
          ]
        }

        Leaflet.elements.map = new L.Map(MapUtils.map.div, mapOpts)

        if (shouldSetInterventions) setInterventionsMarkers()
        setNewMarker(Leaflet.elements.defaultMarkerInfo)

        setupMap(shouldSetInterventions)

      }
    , setupMap = function (shouldShowMarkersLayer) {
        L.Icon.Default.imagePath = leafletImagesRoute;

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

        // if (Leaflet.elements.defaultMarkerInfo.draggable) {
        //   Leaflet.elements.map.on('contextmenu', function(context) {

        //   })
        // }

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

        return marker
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

                // temporal fix
                Leaflet.elements.map.setView(marker._latlng, 17, {animation: true});
                if (Leaflet.options.shouldDrawRoute) drawRoute(latitude, longitude);
                marker.openPopup()
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
          , markersLayer  = L.layerGroup([])
          , cleanMarkers  = []
          , specialTiles  = {
              'Mostrar Hidrantes' : openfire
            }

        // some markers are undefined and layerGroup raise...
        // for (var i=0; i<Leaflet.elements.markers.length; ++i) {
        //     if (Leaflet.elements.markers[i])
        //         cleanMarkers.push(Leaflet.elements.markers[i])
        // }

        markersLayer = L.layerGroup([]);
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
