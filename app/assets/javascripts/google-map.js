// Map & Markers tracker.
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

// Load script onto page.
function loadScript() {
  var script = document.createElement('script');
  script.src = "https://maps.googleapis.com/maps/api/js?key=AIzaSyDn20ttdtOtCSg02P_oONmvRYSrDCb6N7s&callback=initMap";
  document.body.appendChild(script);
}

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

// InfoBox Creation
function attachSecretMessage(marker, secretMessage) {
  var infowindow = new google.maps.InfoWindow({
    content: secretMessage
  });
  marker.addListener('click', function() {
    infowindow.open(marker.get('map'), marker);
  })
}

// Clear All Markers.
function clearMarkers() {
  for (var i = 0; i < markers.length; i++) {
    markers[i].setMap(null);
  }
  markers = [];
}

// JQuery:

// Render when linked-to the page.
$(document).on("turbolinks:load", function() {
  loadScript(); // Render Map.
  $('input[type=checkbox][data-toggle^=toggle]').bootstrapToggle() // Render Toggle.
})

$(document).ready(function() {
  // Switch Map/List View.
  $("input#view-toggle").on("change", function(event) {
    event.preventDefault();
    var viewData = {};

    $("body").find("script").remove(); // Clear Script.

    // Request Specific View from Server.
    if ($(".view-switch-form").find(".toggle").hasClass("btn-primary")) { // Decide which view to request.
      // Request Map View.
      viewData["view"] = "map";

      $.ajax({
        url: "search/view",
        method: "GET",
        dataType: "json",
        data: viewData
      }).done(function(response) {
        $(".search-container").find(".map-container").html(response["view"]); // Render map view.
        loadScript();
      })
    } else {
      // Request list view.
      viewData["view"] = "list";

      $.ajax({
        url: "search/view",
        method: "GET",
        dataType: "json",
        data: viewData
      }).done(function(response) {
        $(".search-container").find(".map-container").html(response["view"]); // Render list view.
      })
    }
  })

  // Search for locations with spaces available.
  $(".navbar-form").on("submit", function(event) {
    event.preventDefault();

    $.ajax({
      url: "search/query",
      method: "GET",
      dataType: "json",
      data: $(this).serialize()
    }).done(function(msg) {
      clearMarkers(); // Erase current markers.

      $("div.alert").addClass("hidden"); // Hide Error Message.

      // Check for failure
      if (msg["fail"]) {
        $(".error-message").text(msg["fail"]);
        $("div.alert").removeClass("hidden");
      } else {
        // Add new markers.
        for (var i = 0; i < msg.length; i++) {
          var location = msg[i];
          var marker = createMarker(location.latitude, location.longitude);
          attachSecretMessage(marker, location.infobox);
        }
      }

      return false
    })
  })
})
