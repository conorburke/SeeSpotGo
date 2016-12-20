var map;

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
  return new google.maps.Marker({
    position: {lat: latitude, lng: longitude},
    map: map,
    optimized: false
  })
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

  // Click search button to load all locations onto map.

  $("a").on("click", function(event) {
    event.preventDefault();
    $.ajax({
      url: "search/query",
      method: "GET"
    }).done(function(msg) {
      for (var i = 0; i < msg.length; i++) {
        var location = msg[i];
        console.log(location);
        var marker = createMarker(location.latitude, location.longitude);
        attachSecretMessage(marker, location.infobox);
      }
    })
  })
})
