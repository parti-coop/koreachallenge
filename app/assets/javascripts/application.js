//= require rails-ujs
//= require jquery
//= require bootstrap
//= require activestorage
//= require masonry.min
//= require imagesloaded.min
//= require unobtrusive_flash
//= require jquery.validate
//= require jquery.validate.additional-methods
//= require jquery.validate.messages_ko
//= require tooltipster.bundle
//= require js.cookie

// breakpoint
$('body').append($('<span id="js-xs-breakpoint" class="d-block d-sm-none"></span>'));
$('body').append($('<span id="js-sm-breakpoint" class="d-none d-sm-block d-md-none"></span>'));
$('body').append($('<span id="js-md-breakpoint" class="d-none d-md-block d-lg-none"></span>'));
$('body').append($('<span id="js-lg-breakpoint" class="d-none d-lg-block d-xl-none"></span>'));
$.breakpoint_max = function() {
  if($('#js-xs-breakpoint').is(":visible")) {
    return 'xs';
  } else if($('#js-sm-breakpoint').is(":visible")) {
    return 'sm';
  } else if($('#js-md-breakpoint').is(":visible")) {
    return 'md';
  } else if($('#js-lg-breakpoint').is(":visible")) {
    return 'lg';
  } else {
    return 'xl';
  }
}

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

  // navbar collapse
  $('#js-main-navbar-nav').on('show.bs.collapse', function(e) {
    $('#js-main-navbar').addClass('navbar-collapse');
    $('.js-main-navbar-nav-exclude').hide();
  });
  $('#js-main-navbar-nav').on('hidden.bs.collapse', function(e) {
    $('#js-main-navbar').removeClass('navbar-collapse');
    $('.js-main-navbar-nav-exclude').show();
  });

  // 탭 메뉴 클릭
  $('.js-tab-menu').on('click', function(e) {
    if($.breakpoint_max() != 'xs' && $.breakpoint_max() != 'sm') {
      return;
    }

    $elm = $(e.currentTarget);
    $menu_list = $elm.closest('.js-tab-menu-list');
    $sibling_menus = $menu_list.find('.js-tab-menu');

    if(!$elm.hasClass('js-tab-menu-active')) {
      return; // 페이지 이동
    }

    if($menu_list.hasClass('js-open')) {
      // 닫기
      $menu_list.removeClass('js-open');
      $sibling_menus.hide();
      $elm.show();
    } else {
      // 열기
      $menu_list.addClass('js-open');
      $sibling_menus.show();
    }
    e.preventDefault();
  });

  // 아이디어 폼 js-idea-form-mode-team-fieldset
  $('.js-idea-form-mode').on('change', function(e) {
    var $elm = $(e.currentTarget);
    var value = $elm.val();
    if(value === 'team') {
      $('.js-idea-form-mode-team-fieldset').show();
      $('.js-idea-form-mode-team-fieldset input').attr('data-rule-required', 'true');
      $elm.closest('form').trigger('parti-rebuild-validator');
    } else {
      $('.js-idea-form-mode-team-fieldset').hide();
      $('.js-idea-form-mode-team-fieldset input').attr('data-rule-required', 'false');
      $elm.closest('form').trigger('parti-rebuild-validator');
    }
    var instances = $.tooltipster.instances();
    $.each(instances, function(i, instance){
        instance.close();
    });
  });

  // 폼 검증
  $('.js-form-validation').each(function() {
    var $form = $(this);
    var $submit = $($form.data("form-validation-submit-control"));

    var build_validator = function() {
      return $form.validate({
        ignore: ':hidden:not(.js-form-validation-force)',
        errorPlacement: function(error, element) {
          return true;
        },
        invalidHandler: function(event, validator) {
          var errors = validator.numberOfInvalids();
          if(errors) {
            var successList = validator.successList;
            console.log('successList', successList);
            $.each(successList, function(index, element) {
              var _popover;
              var $popover_target = $($(element).data('form-validation-error-popover-target'));
              if($popover_target.length <= 0) {
                $popover_target = $(element);
              }
              if($popover_target.hasClass('tooltipstered')) {
                $popover_target.tooltipster('destroy');
              }
            });

            var focused = false;

            var errorList = validator.errorList;
            console.log('errorList', errorList);

            return $.each(errorList, function(index, value) {
              if(!focused && !$(value.element).data('form-validation-prevent-error-focus')) {
                $(value.element).focus();
                focused = true;
              }

              var _popover;
              var $popover_target = $($(value.element).data('form-validation-error-popover-target'));
              if($popover_target.length <= 0) {
                $popover_target = $(value.element);
              }

              if($popover_target.hasClass('tooltipstered')) {
              } else {
                $popover_target.tooltipster({})
              }
              $popover_target.tooltipster('content', value.message).tooltipster('open');
            });
          }
        },
        focusInvalid: false
      });
    };
    var _form_validator = build_validator();

    $submit.removeClass('active');
    var form_callback = function() {
      if(_form_validator.checkForm()) {
        $submit.addClass('active');
      } else {
        $submit.removeClass('active');
      }
    }
    form_callback();

    $form.find(':input').on('input', function(e) {
      form_callback();
    });

    $form.find(':input').on('change', function(e) {
      form_callback();
    });

    $form.find('select').on('change', function(e) {
      form_callback();
    });

    $form.find(':input').on('parti-need-to-validate', function(e) {
      form_callback();
    });

    $form.on('parti-need-to-validate', function(e) {
      form_callback();
    });

    $form.on('parti-rebuild-validator', function(e) {
      _form_validator = build_validator();
      console.log(_form_validator);
    });
  });

  // 파일 업로드
  $('.js-custom-file-input').on("change", function() {
    var fileName = $(this).val().split("\\").pop();
    $(this).siblings(".js-custom-file-label").addClass("selected").html(fileName);
  });

  // 아이디어폼 계속 편집 모드
  (function() {
    if(Cookies.get('idea-form-continue') === 'true') {
      $('.js-idea-form-continue').prop('checked', true);
    } else {
      $('.js-idea-form-continue').prop('checked', false);
    }
    $('.js-idea-form-continue').on('change', function(e) {
      $elm = $(e.currentTarget);
      if($elm.is(':checked')) {
        Cookies.set('idea-form-continue', 'true');
      } else {
        Cookies.set('idea-form-continue', 'false');
      }
    });
  })();

  $('.js-idea-form-confirm-all').on('change', function(e) {
    $elm = $(e.currentTarget);
    console.log('ok', $elm.is(':checked'));
    if($elm.is(':checked')) {
      $('.js-idea-form-confirm').prop('checked', true);
    }
  });
});
