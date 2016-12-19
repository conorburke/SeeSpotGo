var map;
var markers;

function initMap() {
  // Create map options.
  var mapOptions = {
    center: {lat: 40.782710, lng: -73.965310},
    mapTypeId: google.maps.MapTypeId.ROADMAP,
    mapTypeControl: false,
    zoom: 13,
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

function createMarker(latlng) {
  var marker = new google.maps.Marker({
    position: {lat: latlng[0], lng: latlng[1]},
    map: map,
    optimized: false
  })
  marker.addListener('click', function(){ alert('hello')})
  return marker
}

function loadScript() {
  var script = document.createElement('script');
  script.src = "https://maps.googleapis.com/maps/api/js?key=AIzaSyDn20ttdtOtCSg02P_oONmvRYSrDCb6N7s&callback=initMap";
  document.body.appendChild(script);
}

window.onload = loadScript;

$(document).ready(function() {

  // Click search button to load all locations onto map.

  $("a").on("click", function(event) {
    event.preventDefault();
    $.ajax({
      url: "search/query",
      method: "GET"
    }).done(function(msg) {
      markers = [];
      for (var i = 0; i < msg.length; i++) {
        var marker = createMarker(msg[i]);
        console.log(marker);
      }
    })
  })
})
