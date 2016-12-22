// Map & Markers tracker.
var map;
var markers = [];
var view = "map";
var currentMarker;

// Map Creation:
function initMap() {
  // Create map options.
  var mapOptions = {
    center: {lat: 32.7157, lng: -117.1611},
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
    animation: google.maps.Animation.DROP,
    optimized: false
  })
  markers.push(marker);
  return marker;
}

function toggleBounce(marker) {
  if (marker.getAnimation() !== null) {
    marker.setAnimation(null);
  } else {
    marker.setAnimation(google.maps.Animation.BOUNCE);
  }
}

// InfoBox Creation
function attachSecretMessage(marker, secretMessage) {
  var infowindow = new google.maps.InfoWindow({
    content: secretMessage
  });

  google.maps.event.addListener(infowindow, 'closeclick', function(e) {
    currentMarker.setAnimation(null);
  })

  marker.addListener('click', function() {
    infowindow.open(marker.get('map'), marker);
    toggleBounce(marker);
    currentMarker = marker;
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
$(document).on("ready", function() {
  // Render Map.
  loadScript();

  // Render Toggle.
  $('input[type=checkbox][data-toggle^=toggle]').bootstrapToggle();

  // Render Bootstrap-select.
  $('.selectpicker').selectpicker();

  // Render Popup.
  $('.modaltrigger').on("click", function(event) {
    $("#loginmodal").css("display", "none");
    $("#registermodal").css("display", "none");
    $("#locationmodal").css("display", "none")
  })

  $('.modaltrigger').leanModal({ top: 110, overlay: 0.45, closeButton: ".hidemodal" });

  // Render Space Form after Create Location.
  $("#form-div").on("submit", "#new_location", function(event) {
    event.preventDefault();

    $.ajax({
      url: "locations",
      method: "POST",
      data: $(this).serialize()
    }).done(function(response) {
      $("#space-location-form-container").html(response["location_selector"]); // Re-render Location-selector.
      $("#form-div").html(response["space_form"]); // Render Space Form.
      $("#space-location-form-container").find("option[value=" + response["location_id"] + "]").attr("selected", "selected")
      $('input[type=checkbox][data-toggle^=toggle]').bootstrapToggle(); // Render Toggle.
      $('.selectpicker').selectpicker(); // Render Selector.
    })
  })

  // Render Form According to User's Selection.
  $("#space-location-form-container .selectpicker").on("change", function(event) {
    var selected = $(this).find("option:selected").val();
    if (selected === "0") {
      $.ajax({
        url: "locations/new",
        method: "GET"
      }).done(function(response) {
        $("#form-div").html(response["location_form"]); // Render Location Form.
      })
    } else {
      $.ajax({
        url: "locations/" + selected + "/spaces/new",
        method: "GET"
      }).done(function(response) {
        $("#form-div").html(response["space_form"]); // Render Space Form.
        $('input[type=checkbox][data-toggle^=toggle]').bootstrapToggle(); // Render Toggle.
        $('.selectpicker').selectpicker(); // Render Selector.
      })
    }
  })

  // Clear Location Form.
    // $(".reset").click(function() {
    //   $(this).closest('form').find("input[type=text], textarea").val("");
    // });

  // Switch Map/List View.
  $("input#view-toggle").on("change", function(event) {
    event.preventDefault();
    var viewData = {};

    $("body").find("script").remove(); // Clear Script.

    // Request Specific View from Server.
    if ($(".view-switch-form").find(".toggle").hasClass("btn-primary")) { // Decide which view to request.
      // Request Map View.
      view = "map";
      viewData["view"] = view;

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
      view = "list";
      viewData["view"] = view;

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
    var searchData = $(this).serialize();
    searchData = searchData + "&view=" + view

    $.ajax({
      url: "search/query",
      method: "GET",
      dataType: "json",
      data: searchData
    }).done(function(msg) {
      clearMarkers(); // Erase current markers.

      $("div.alert").addClass("hidden"); // Hide Error Message.

      // Check for failure
      if (msg["fail"]) {
        $(".error-message").text(msg["fail"]);
        $("div.alert").removeClass("hidden");
      } else {
        if (view === "map") {
          // Recenter Map.
          map.panTo({lat: msg["center"][0], lng: msg["center"][1]})

          // Add new markers.
          msg = msg["markers"];
          for (var i = 0; i < msg.length; i++) {
            var location = msg[i];
            var marker = createMarker(location.latitude, location.longitude);
            attachSecretMessage(marker, location.infobox);
          }
        } else {
          $(".search-container").find(".map-container").html(msg["view"]);
        }
      }

      return false
    })
  })
})
