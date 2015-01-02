var findAddressInMap = function (e) {
    var e = e || {},
        map_canvas = document.getElementById('map_canvas'),
        address = document.getElementById('intervention_address'),
        autocomplete = this;
    var lat = e['lat'],
        lng = e['lng'],
        place = autocomplete.getPlace();
    if(place){
        lat = place.geometry.location.lat();
        lng = place.geometry.location.lng();
    }
    var position = new google.maps.LatLng(lat, lng);
    setLatitudeAndLongitude(position);

    var options = {
            zoom: 16,
            center: position,
            panControl: true,
            zoomControl: true,
            scaleControl: true,
            mapTypeId: google.maps.MapTypeId.ROADMAP
        };
    var map = new google.maps.Map(map_canvas, options);
    var optionsMarker = {
            map: map,
            position: position,
            draggable: true
//            title: address
        };
    var marker = new google.maps.Marker(optionsMarker);

    setMarkerInfo(map, marker, address, 0, new google.maps.InfoWindow());

    // Register Custom "dragend" Event
    google.maps.event.addListener(marker, 'dragend', function() {
        // Get the Current position, where the pointer was dropped
        var point = marker.getPosition();
        // Center the map at given point
        map.panTo(point);
        // Update the textbox
        setLatitudeAndLongitude(point);
    });
    $(map_canvas).show();
};

var findByCoordenates = function(latitude, longitude, address) {
    var latlng = new google.maps.LatLng( latitude, longitude);
    var myOptions = {
        zoom: 16,
        center: latlng,
        panControl: true,
        zoomControl: true,
        scaleControl: true,
        mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    var map = new google.maps.Map(document.getElementById("map_canvas"),
        myOptions);
    var marker = new google.maps.Marker({
        position: latlng,
        map: map,
        title: address
    });
    setMarkerInfo(map, marker, address, 0, new google.maps.InfoWindow());
};

var loadGeneralMap = function () {
    var firehouseStation = {
          latitude  : '-32.926887'
        , longitude : '-68.846255'
    };
    var map = new google.maps.Map(document.getElementById('map_canvas'), {
        mapTypeId: google.maps.MapTypeId.ROADMAP
    });
    var infowindow = new google.maps.InfoWindow();
    var bounds = new google.maps.LatLngBounds();
    for (i = 0; i < interventions.length; i++) {
        var marker = new StyledMarker({
            styleIcon: new StyledIcon(StyledIconTypes.MARKER,{
                color: "ff0000",
                text: "o",
                fore: "000000"
            }),
            position: new google.maps.LatLng(interventions[i].latitude, interventions[i].longitude),
            map: map
        });
        bounds.extend(marker.position);
        setMarkerInfo(map, marker, interventions[i].address, i,  infowindow);
    }
    var firehouseMarker = new StyledMarker({
        styleIcon: new StyledIcon(StyledIconTypes.MARKER,{
            color: "#3A4AA8",
            text: "B",
            fore: "FFFFFF"
        }),
        position: new google.maps.LatLng(firehouseStation.latitude, firehouseStation.longitude),
        map: map
    });
    bounds.extend(firehouseMarker.position);
    setMarkerInfo(map, firehouseMarker, 'Estacion de bomberos', 0, infowindow);
    map.fitBounds(bounds);
    var listener = google.maps.event.addListener(map, "idle", function () {
        google.maps.event.removeListener(listener);
    });

//  start of OpenStreetMaps
    var
        map            = new OpenLayers.Map("ourMap")
      , mapnik         = new OpenLayers.Layer.OSM()
      , fromProjection = new OpenLayers.Projection("EPSG:4326")   // Transform from WGS 1984 << WHAT?
      , toProjection   = new OpenLayers.Projection("EPSG:900913") // to Spherical Mercator Projection << DOUBLE WHAT?
      , position       = new OpenLayers.LonLat(firehouseStation.longitude,firehouseStation.latitude).transform( fromProjection, toProjection)
      , markers        = new OpenLayers.Layer.Markers( "Markers" )
      , zoom           = 12


    for (i = 0; i < interventions.length; i++) {
      var
          position = new OpenLayers.LonLat(
              interventions[i].longitude
            , interventions[i].latitude
          ).transform( fromProjection, toProjection)
//        , infobox  = new khtml.maplib.overlay.InfoWindow({content: interventions[i].address})
//        , marker   = new khtml.maplib.overlay.Marker({
//                             position : new khtml.maplib.LatLng(interventions[i].latitude, interventions[i].longitude)
//                           , map      : map
//                           , title:"static marker"
//                         });
//
//      marker.attachEvent( 'click', function() { infobox.open(map, this) } )

//      markers.addMarker(new OpenLayers.Marker(position))
      setMarker(map, markers, position, 1)
    }


    map.addLayer(mapnik);
    map.addLayer(markers);
    map.setCenter(position, zoom);
};

function setMarker(map, markers, position, count){

  var lonLatMarker              = position
  var feature                   = new OpenLayers.Feature(markers, lonLatMarker);
  feature.closeBox              = true;
  feature.popupClass            = OpenLayers.Class(OpenLayers.Popup.AnchoredBubble, {minSize: new OpenLayers.Size(300, 180) } );
  feature.data.popupContentHTML = 'Hello World';
  feature.data.overflow         = "hidden";

//  var icon = new OpenLayers.Icon("/src/includes/lib/map/export_badge.php?number="+count);
//  var marker = new OpenLayers.Marker(lonLatMarker, icon);
  var marker = new OpenLayers.Marker(lonLatMarker);
  marker.feature = feature;

  var markerClick = function(evt) {
    if (this.popup == null) {
      this.popup = this.createPopup(this.closeBox);
      map.addPopup(this.popup);
      this.popup.show();
    } else {
      this.popup.toggle();
    }
    OpenLayers.Event.stop(evt);
  };
  marker.events.register("mousedown", feature, markerClick);

  markers.addMarker(marker);
}


var setLatitudeAndLongitude = function(point){
    document.getElementById('intervention_latitude').value = point.lat();
    document.getElementById('intervention_longitude').value = point.lng();
};

var interventions = [];
var addInterventions = function(address, latitude, longitude, index){
    var object = {
        address: address,
        latitude: latitude,
        longitude: longitude,
        index: index
    };
    interventions.push(object);
};

var setFullscreenMapSize = function(){
    var map_canvas = document.getElementById('map_canvas');
    document.body.height = map_canvas.style.height = window.screen.height + 'px';
    document.body.width = map_canvas.style.width = window.screen.width + 'px';
    document.body.style.padding = '0px';
};

var setMarkerInfo = function(map, marker, title, index, infowindow) {
    google.maps.event.addListener(marker, 'click', (function (marker, index) {
        return function () {
            infowindow.setContent(title);
            infowindow.open(map, marker);
        }
    })(marker, index));
};

var initialize_map_with = function(id){
    var input = document.getElementById(id);
    var options = {
        componentRestrictions: {country: 'ar'}
    };
    address_autocompleted = new google.maps.places.Autocomplete(input, options);
    google.maps.event.addListener(address_autocompleted, 'place_changed', findAddressInMap );
};
