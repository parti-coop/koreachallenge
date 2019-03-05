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
//
//= require rails-ujs
//= require jquery
//= require activestorage
//= require masonry.min
//= require imagesloaded.min


$(document).imagesLoaded(function() {
  $(".posts").masonry();
});

$(document).ready(function(){
  $('nav > button').click(function() {
    $('header').addClass('selected');
  });
  $('nav div > button').click(function() {
    $('header').removeClass('selected');
  });

  //Masonry blocks
  $blocks = $(".posts");

  $blocks.imagesLoaded(function(){
    $blocks.masonry({
      itemSelector: '.post-container'
    });

    // Fade blocks in after images are ready (prevents jumping and re-rendering)
    $(".post-container").fadeIn();
  });

  // $(document).ready( function() { setTimeout( function() {
  //   $blocks.masonry();
  // }, 500); });

  $(window).resize(function () {
    $blocks.masonry();
  });

  // // Load Flexslider
  // $(".flexslider").flexslider({
  //   animation: "slide",
  //   controlNav: false,
  //   smoothHeight: true,
  //   start: $blocks.masonry(),
  // });

  // resizeVideo(vidSelector);

  // $(window).resize(function() {
  //   resizeVideo(vidSelector);
  // });

  // When Jetpack Infinite scroll posts have loaded
  $( document.body ).on( 'post-load', function () {
    var $container = $('.posts');
    $container.masonry( 'reloadItems' );

    $blocks.imagesLoaded(function(){
      $blocks.masonry({
        itemSelector: '.post-container'
      });

      // Fade blocks in after images are ready (prevents jumping and re-rendering)
      $(".post-container").fadeIn();
    });

    // Rerun video resizing
    // resizeVideo(vidSelector);

    $container.masonry( 'reloadItems' );

    // Load Flexslider
    // $(".flexslider").flexslider({
    //     animation: "slide",
    //     controlNav: false,
    //     prevText: "Previous",
    //     nextText: "Next",
    //     smoothHeight: true
    // });

    // $(document).ready( function() { setTimeout( function() { $blocks.masonry(); }, 500); });

  });
});
