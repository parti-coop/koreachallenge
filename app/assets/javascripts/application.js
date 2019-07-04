//= require rails-ujs
//= require jquery
//= require bootstrap
//= require activestorage
//= require masonry.min
//= require imagesloaded.min
//= require unobtrusive_flash

$(document).imagesLoaded(function() {
  $(".posts").masonry();
});

$(document).ready(function(){
  // unobtrusive_flash
  (function() {
    window.UnobtrusiveFlash.flashOptions = {
      type: 'notice',
      timeout: 0,
      mapping: {
        notice: 'info',
        alert: 'warning',
        error: 'danger'
      }
    };

    flashHandler = function(e, params) {
      var message = params.message
      var options = { type: params.type }

      options = $.extend(UnobtrusiveFlash.flashOptions, options);

      // Workaround for common Rails flash type to match common Bootstrap alert type
      switch (options.type) {
        case 'notice':
        case 'alert':
        case 'error':
          options.type = options.mapping[options.type]
      }

      // Bootstrap class for showing alert
      var showClass = 'in';
      // If we have Bootstrap 4 use the show class instead
      if ( parseInt($.fn.alert.Constructor.VERSION.split('.')[0]) == 4 ) {
        showClass = 'show';
      }

      var $flash = $('<div class="alert alert-'+options.type+' alert-flash fade '+showClass+'"><button type="button" class="close" data-dismiss="alert">&times;</button>'+message+'</div>');

      var $flashContainer = $($('.unobtrusive-flash-container')[0] || $('.container')[0] || $('.container-fluid')[0] || $('body')[0]);
      $flashContainer.prepend($flash);

      $flash.hide().delay(300).slideDown(100);

      $flash.alert();

      if (options.timeout>0) {
        setTimeout(function() {
          $flash.alert('close');
        },options.timeout);
      }
    };
    $(window).bind('rails:flash', flashHandler);
  })();

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

  $('.js-hamburger-open').click(function(e) {
    var $header = $(e.currentTarget).closest('.js-hamburger-header');
    $header.addClass('selected');
    $('.js-hamburger-open-visible').show();
    $('.js-hamburger-open-invisible').hide();
  });
  $('.js-hamburger-close').click(function(e) {
    var $header = $(e.currentTarget).closest('.js-hamburger-header');
    $header.removeClass('selected');
    $('.js-hamburger-close-visible').show();
    $('.js-hamburger-close-invisible').hide();
  });
  $('.js-subhamburger-toggle').click(function(e) {
    var $elm = $(e.currentTarget);
    var $clicked = $(e.target);
    if($('.js-subhamburger-toggle-indicator').is(':visible')) {
      if(! $elm.find('.js-submenu').is($clicked.closest('.js-submenu'))) {
        e.preventDefault();
        if($elm.hasClass('selected')) {
          $('.js-subhamburger-toggle').removeClass('selected');
        } else {
          $('.js-subhamburger-toggle').removeClass('selected');
          $elm.addClass('selected');
        }
      }
    }
  });
  $('.js-menu-toggle').click(function(e) {
    var $header = $(e.currentTarget).closest('.js-menu-header');
    if($header.hasClass('selected')) {
      $header.removeClass('selected');
    } else {
      $header.addClass('selected');
    }
  });

  $(document).on('click', '.js-link', function(e) {
    var href = $(e.target).closest('a').attr('href')
    if (href && href != "#") {
      return true;
    }

    e.preventDefault();
    var url = $(e.currentTarget).data("url");
    if(!url) {
      var $url_source = $($(e.currentTarget).data("url-source"));
      if($url_source.length > 0) {
        url = $url_source.data("url");
      }
    }

    if(!url) {
      return;
    }

    var type = $(e.currentTarget).data("type");
    if("remote" == type) {
      $.ajax({
        url: url,
        type: "get"
      });
    } else if($(this).data('link-target')) {
      window.open(url, $(this).data('link-target'));
    } else if (e.shiftKey || e.ctrlKey || e.metaKey) {
      window.open(url, '_blank');
    } else {
      window.location.href  = url;
    }
  });
});
