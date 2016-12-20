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
  map = new google.maps.Map(document.getElementById('search-map'), mapOptions);
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

      // Check for failure
      if (msg["fail"]) {
        $(".ey_nav_div").append(
        "<div class='alert alert-danger' role='alert'>" +
        "<span class='glyphicon glyphicon-exclamation-sign' aria-hidden='true'></span>" + msg["fail"] + "</div>")
      } else {
        // Add new markers.
        for (var i = 0; i < msg.length; i++) {
          var location = msg[i];
          var marker = createMarker(location.latitude, location.longitude);
          attachSecretMessage(marker, location.infobox);
        }
      }
    }).always(function() {
      $(".navbar-form").find('.btn-info').attr('disabled', false) // Enable multiple search.
    })
  })
})
