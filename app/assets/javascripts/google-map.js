var map;
var markers = [];

// Map Creation:
function initMap() {
  // Create map options.
  var mapOptions = {
    center: {lat: 32.7157, lng: -117.1611},
    mapTypeId: google.maps.MapTypeId.ROADMAP,
    mapTypeControl: false,
    zoom: 16,
    styles: [ { stylers: [ { hue: "#00ff6f" }, { saturation: -50 } ] },
              {
                "featureType": "water",
                "elementType": "all",
                "stylers": [ { hue: "#AED6F1" },
                             { saturation: -10 },
                             { lightness: 30 } ]
              }
            ]
  };

  // Create a map object and specify the DOM element for display using defined mapOptions.
  if ($('#search-map').length) { map = new google.maps.Map(document.getElementById('search-map'), mapOptions) }
  if ($('#location-map').length) {
    map = new google.maps.Map(document.getElementById('location-map'), mapOptions)
    marker = createMarker($('#location').data('latitude'), $('#location').data('longitude'))
    map.setCenter(marker.getPosition())
  }
}

function loadScript() {
  var script = document.createElement('script');
  script.src = "https://maps.googleapis.com/maps/api/js?key=AIzaSyDn20ttdtOtCSg02P_oONmvRYSrDCb6N7s&callback=initMap";
  document.body.appendChild(script);
}

window.onload = loadScript;

// Marker Creation:
function createMarker(latitude, longitude) {
  var marker = new google.maps.Marker({
    position: {lat: latitude, lng: longitude},
    map: map,
    optimized: false
  })
  markers.push(marker);
  return marker;
}

function attachSecretMessage(marker, secretMessage) {
  var infowindow = new google.maps.InfoWindow({
    content: secretMessage
  });
  marker.addListener('click', function() {
    infowindow.open(marker.get('map'), marker);
  })
}

// JQuery:
$(document).ready(function() {

  // createMarker($('#location').data('latitude'), $('#location').data('longitude'))

  // Search for locations with spaces available around a location.
  $(".navbar-form").on("submit", function(event) {
    event.preventDefault();
    $.ajax({
      url: "search/query",
      method: "GET",
      dataType: "json",
      data: $(this).serialize()
    }).done(function(msg) {
      // Erase current markers.
      for (var i = 0; i < markers.length; i++) {
        markers[i].setMap(null);
      }
      markers = [];

      // Add new markers.
      for (var i = 0; i < msg.length; i++) {
        var location = msg[i];
        console.log(location);
        var marker = createMarker(location.latitude, location.longitude);
        attachSecretMessage(marker, location.infobox);
      }
      $('.btn-info').attr('disabled', false) // Enable multiple search.
    })
  })
})
