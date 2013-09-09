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
            title: 'title'
        });
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
    document.getElementById('show_map_title').innerText = address;
};

var setLatitudeAndLongitude = function(point){
    document.getElementById('intervention_latitude').value = point.lat();
    document.getElementById('intervention_longitude').value = point.lng();
};

var loadGeneralMap = function () {
    var map = new google.maps.Map(document.getElementById('map_canvas'), {
        mapTypeId: google.maps.MapTypeId.ROADMAP
    });
    var infowindow = new google.maps.InfoWindow();
    var bounds = new google.maps.LatLngBounds();
    for (i = 0; i < interventions.length; i++) {
        var marker = new StyledMarker({
            styleIcon: new StyledIcon(StyledIconTypes.MARKER,{
// agregar el color de la intervención para verlo en el cosito de google y
// diferenciarlos mejor
                color: "ff0000",
                text: "o",
                fore: "000000"
            }),
            position: new google.maps.LatLng(interventions[i][1], interventions[i][2]),
            map: map
        });
        bounds.extend(marker.position);
        google.maps.event.addListener(marker, 'click', (function (marker, i) {
            return function () {
                infowindow.setContent(interventions[i][0]);
                infowindow.open(map, marker);
            }
        })(marker, i));
    }
    map.fitBounds(bounds);
    var listener = google.maps.event.addListener(map, "idle", function () {
//        cambia el zoom del mapa de ser necesario.
//        map.setZoom(14);
        google.maps.event.removeListener(listener);
    });
};

var interventions = [];
//todo: usar un objeto
var addInterventions = function(address, latitude, longitude, index){
    interventions.push([address, latitude, longitude, index]);
};

var setFullscreenMapSize = function(){
    var map_canvas = document.getElementById('map_canvas');
    document.body.height = map_canvas.style.height = window.screen.height + 'px';
    document.body.width = map_canvas.style.width = window.screen.width + 'px';
    document.body.style.padding = '0px';
};