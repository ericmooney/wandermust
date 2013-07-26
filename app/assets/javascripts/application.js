// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require_tree .


$(document).ready(function(){

     if ($(window).width() <= 480) {
         $('#login_modal_big').addClass('hide1');
         $('#login_not_modal_small').removeClass('hide1');
         $('#save_without_modal').removeClass('hide1');
         $('#save_w_modal').addClass('hide1');
     }
     else {
       $('#login_not_modal_small').addClass('hide1');
       $('#login_modal_big').removeClass('hide1');
       $('#save_w_modal').removeClass('hide1');
       $('#save_without_modal').addClass('hide1');
     }


  // to stop duplication of wander button on homepage
  if ($('#homepage').length > 0) {
    $('#wander_button').hide();
  }

// if the sidebar destination is equaled to the current vie, highlight the sidebar
  var destination_header_class = $("h1").attr("class");

  if ($("."+destination_header_class).length > 1) {
    $("li."+destination_header_class).addClass("alert alert-info");
  }
// user login modal

  $("form[data-async]").on("submit", function(event){
    var form = $(this);
    var target = $(form.attr('data-target'));

    $.ajax({
      type: form.attr("method"),
      url: form.attr("action")+".js", //Maybe I just need show.js.erb views to get modal to disappear without redirect?
      data: form.serialize(),

      success: function(data, status) {
        target.js(data);
      }
    });

    event.preventDefault();
  });

});