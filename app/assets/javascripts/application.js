// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//= require rails-ujs
//= require jquery
//= require jquery_ujs
//= require toastr
//= require activestorage
//= require turbolinks
//= require_tree .

// code for toastr
$(document).ready(function() {  
    toastr.options = {
        "closeButton": false,
        "debug": false,
        "positionClass": "toast-top-right",
        "onclick": null,
        "showDuration": "300",
        "hideDuration": "1000",
        "timeOut": "5000",
        "extendedTimeOut": "1000",
        "showEasing": "swing",
        "hideEasing": "linear",
        "showMethod": "fadeIn",
        "hideMethod": "fadeOut"
    }
});



function url_locator(city) {
    switch(city){
        case "tokyo":
            location.replace("/cities/1/activities");
            break;
        case "seville":
            location.replace("/cities/5/activities");
            break;
        case "rio":
            location.replace("/cities/2/activities");
            break;
        default:
            location.replace("/cities");
            break;
    }
}

function city_hover(city){
    document.getElementById(city).style.boxShadow = "5px 5px 5px black";
}
function city_out(city) {
    document.getElementById(city).style.boxShadow = "";
}


    
