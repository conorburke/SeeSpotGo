// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .
//= require bootstrap-sprockets

$(function () {

  $("#rateYo").rateYo({
    rating: 0,
    starWidth: "20px",
    ratedFill: "#F1C40F",
    normalFill: "#A0A0A0"
  });


  $("#rateYo").click(function(e){
    var rating = $("#rateYo").rateYo("option", "rating");
  });

});
