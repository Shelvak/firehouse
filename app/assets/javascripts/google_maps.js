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
  }

var setLatitudeAndLongitude = function(latitude, longitude){
    document.getElementById('intervention_latitude').value  = latitude;
    document.getElementById('intervention_longitude').value = longitude;
};

//var interventions = getMarkersInfo();

var setMarkerInfo = function(map, marker, title, index, infowindow) {
    google.maps.event.addListener(marker, 'click', (function (marker, index) {
        return function () {
            infowindow.setContent(title);
            infowindow.open(map, marker);
        }
    })(marker, index));
};

var autocompleteAddress = function(id){
    var input = document.getElementById(id)
      , options = {
        componentRestrictions: { country: 'ar' }
      };
    address_autocompleted = new google.maps.places.Autocomplete(input, options);
    google.maps.event.addListener(address_autocompleted, 'place_changed', function () {
      Leaflet.changeMarker(input.value, this)
    } );
};
