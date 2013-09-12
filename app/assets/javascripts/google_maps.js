var findAddressInMap = function (address) {
    var geoCoder = new google.maps.Geocoder(address);
    var request = { address: address };
    geoCoder.geocode(request, function(result, status){
        var latlng = new google.maps.LatLng(
            result[0].geometry.location.lat(),
            result[0].geometry.location.lng()
        );
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
            draggable: true,
            title: address
        });
        setMarkerInfo(map, marker, address, 0, new google.maps.InfoWindow());
        setLatitudeAndLongitude(marker.getPosition());

        // Register Custom "dragend" Event
        google.maps.event.addListener(marker, 'dragend', function() {
            // Get the Current position, where the pointer was dropped
            var point = marker.getPosition();
            // Center the map at given point
            map.panTo(point);
            // Update the textbox
            setLatitudeAndLongitude(point);
        });
    });
    if (document.getElementById('show_map_title').innerText) {
        document.getElementById('show_map_title').innerText = address;
    }
    else {
        document.getElementById('show_map_title').textContent = address;
    }
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
        latitude: '-32.926887',
        longitude: '-68.846255'
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
};

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