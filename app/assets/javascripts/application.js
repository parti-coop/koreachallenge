//= require rails-ujs
//= require jquery
//= require popper
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
//= require jquery.fitvids
//= require clipboard
//= require tinymce-jquery
//= require cocoon
//= require jquery.scrollTo
//= require underscore

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

$.validator.addMethod('filesize', function (value, element, param) {
  return this.optional(element) || (element.files[0].size <= param)
});

$.validator.addMethod('filetype', function (value, element, param) {
  if(this.optional(element)) {
    var check = false;
    var name = element.files[0].name;
    if(name) {
      var extName = name.substring(name.lastIndexOf(".")+1).toUpperCase();
      var validExtNames = param.split(",");
      for(var i = 0; i < validExtNames.length; i++) {
        if(extName == $.trim(validExtNames[i])) {
          return true
        }
      }
    }
  }
  return false;
});

$(document).ready(function(){
  // unobtrusive_flash
  (function() {
    window.UnobtrusiveFlash.flashOptions = {
      type: 'notice',
      timeout: 4000,
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
    $('.js-main-navbar-nav-exclude').addClass('d-sm-none').addClass('d-md-block');
  });
  $('#js-main-navbar-nav').on('hidden.bs.collapse', function(e) {
    $('#js-main-navbar').removeClass('navbar-collapse');
    $('.js-main-navbar-nav-exclude').removeClass('d-sm-none').removeClass('d-md-block');
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
      $elm.closest('form').find('.js-idea-add-member-btn').show();
    } else {
      $('.js-idea-form-mode-team-fieldset').hide();
      $('.js-idea-form-mode-team-fieldset input').attr('data-rule-required', 'false');
      $elm.closest('form').trigger('parti-rebuild-validator');
      $elm.closest('form').find('.js-idea-add-member-btn').hide();
    }
    var instances = $.tooltipster.instances();
    $.each(instances, function(i, instance){
        instance.close();
    });
  });

  // 아이디어 폼 js-idea-form-mode-team-fieldset
  $('.js-idea-form-reuse').on('change', function(e) {
    var $elm = $(e.currentTarget);
    var value = $elm.val();
    if(value === 'true') {
      $('.js-idea-form-reuse-control').show();
      $('.js-idea-form-mode-team-fieldset input').attr('data-rule-required', 'true');
      $elm.closest('form').trigger('parti-rebuild-validator');
    } else {
      $('.js-idea-form-reuse-control').hide();
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
            $.each(successList, function(index, element) {
              $control = $(element);
              $control.removeClass('is-invalid');
              if($control.is(':radio')) {
                var name = $control.attr("name");
                if ($control.parents().find("form").length > 0) {
                  $siblings = $control.closest("form").find("input[type=radio][name='" + name + "']");
                  $siblings.removeClass('is-invalid');
                }
              }

              var $invalid_feedback = null;
              if($control.data('invalid-feedback')) {
                $invalid_feedback = $($control.data('invalid-feedback'));
              } else {
                $control_next = $control.next();
                if($control_next.hasClass('.js-invalid-feedback')) {
                  $invalid_feedback = $control_next;
                }
              }

              if($invalid_feedback && $invalid_feedback.length > 0) {
                $invalid_feedback.remove();
              }
            });

            var focused = false;

            var errorList = validator.errorList;
            console.log(errorList);

            return $.each(errorList, function(index, value) {
              $control = $(value.element);
              if(!focused && !$control.data('form-validation-prevent-error-focus')) {
                $control.focus();
                focused = true;
              }

              var $control_target = $($control.data('form-validation-error-target'));
              if($control_target.length > 0) {
                $control = $control_target;
              }

              $control.addClass('is-invalid');
              if($control.is(':radio')) {
                var name = $control.attr("name");
                if ($control.parents().find("form").length > 0) {
                  $siblings = $control.closest("form").find("input[type=radio][name='" + name + "']");
                  $siblings.addClass('is-invalid');
                }
              }

              var $invalid_feedback = null;
              if($control.data('invalid-feedback')) {
                $invalid_feedback = $($control.data('invalid-feedback'));
              } else {
                $control_next = $control.next();
                if($control_next.hasClass('js-invalid-feedback')) {
                  $invalid_feedback = $control_next;
                }
              }

              if($control.data('invalid-feedback')) {
                $invalid_feedback = $($control.data('invalid-feedback'));
              } else {
                $control_next = $control.next();
                if($control_next.hasClass('js-invalid-feedback')) {
                  $invalid_feedback = $control_next;
                }
              }

              if(!$invalid_feedback || $invalid_feedback.length <= 0) {
                $invalid_feedback = $('<div class="js-invalid-feedback invalid-feedback invalid-feedback-force"></div>');
                $control.after($invalid_feedback);
              }
              $invalid_feedback.addClass('js-invalid-feedback');
              $invalid_feedback.addClass('invalid-feedback');
              $invalid_feedback.html(value.message);
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
    if($elm.is(':checked')) {
      $('.js-idea-form-confirm').prop('checked', true);
    } else {
      $('.js-idea-form-confirm').prop('checked', false);
    }

  });

  $('.js-fit-vids').fitVids();

  $(document).ajaxError(function (e, xhr, settings) {
    if(xhr.status == 500) {
      UnobtrusiveFlash.showFlashMessage('뭔가 잘못되었습니다. 곧 고치겠습니다.', {type: 'error'});
    } else if(xhr.status == 403) {
      UnobtrusiveFlash.showFlashMessage('새로 로그인을 해야하거나 적절한 권한이 없습니다.', {type: 'error'})
    } else if(xhr.status == 404) {
      UnobtrusiveFlash.showFlashMessage('어머나! 누가 지웠네요. 페이지를 새로 고쳐보세요.', {type: 'notice'});
    }
  });

  //clipboard
  $('.js-clipboard').each(function() {
    var clipboard = new Clipboard(this);

    var self = this;
    clipboard.on('success', function(e) {
      $(self)
        .tooltipster({})
        .tooltipster('content', '복사되었습니다')
        .tooltipster('open')
        .tooltipster('instance').on('off', function(e) {
          if($(e.currentTarget).tooltipster('instance')) {
            $(e.currentTarget).tooltipster('destroy');
          }
        });
      e.clearSelection();
    });
  });

  $('.js-alert').on('click', function(e) {
    e.preventDefault();
    alert($(e.currentTarget).data('message'));
  });

  $('.js-user-confirm-check-all').change(function(e) {
    e.preventDefault();
    var $elm = $(e.currentTarget);

    if($elm.is(":checked")) {
      var $form = $elm.closest('form');
      $form.find('.js-user-confirm-check-all-target').prop('checked', true);
      $.scrollTo($form.find('.js-user-confirm-check-all-scroll-to'), 100);
    } else {
      var $form = $elm.closest('form');
      $form.find('.js-user-confirm-check-all-target').prop('checked', false);
    }
  });

  $('.js-dimd-open').on('click', function(e) {
    $('.js-dimd-wrap').css('display', 'block');
    var url = $(this).data('dimd-open-url');
    if(url) {
      $('.js-dimd-wrap iframe').attr('src', url + "?autoplay=1");
    }
  });

  $('.js-dimd-close').on('click', function(e) {
    $('.js-dimd-wrap').css('display', 'none');
    $('.js-dimd-wrap iframe').attr('src', '');
  });

  (function() {
    var process_remove_button = function($elm) {
      if($elm.find('.js-idea-member-remove').length <= 1) {
        $elm.find('.js-idea-member-remove').hide();
      } else {
        $elm.find('.js-idea-member-remove').show();
      }
    }
    $('#idea-form-members').on('cocoon:after-insert', function(e, insertedItem, originalEvent) {
      process_remove_button($(e.currentTarget));
    });
    $('#idea-form-members').on('cocoon:after-remove', function(e, insertedItem, originalEvent) {
      process_remove_button($(e.currentTarget));
    });
    process_remove_button($('#idea-form-members'));
  })();

  $('.js-subnav-xs').on('click', function(e) {
    if($.breakpoint_max() != 'xs' && $.breakpoint_max() != 'sm') {
      return;
    }
    e.preventDefault();
    var $elm = $(e.currentTarget);
    var $subnav = $($elm.data('subnav'));
    if($subnav.is(':visible')) {
      $subnav.hide();
      $elm.addClass('nav-arrow-down').removeClass('nav-arrow-up');
    } else {
      $subnav.show();
      $elm.addClass('nav-arrow-up').removeClass('nav-arrow-down');
    }
  });

  // 댓글
  $('.js-comment-cancel').on('click', function(e) {
    e.preventDefault();

    if(!confirm('작성하신 것을 모두 지우겠습니까?')) {
      return;
    }
    $elm = $(e.currentTarget);
    $form = $elm.closest('form');
    $form.find('.js-comment-cancel-textarea').val('').focus();
  });

  // 댓글
  $('.js-child-comment-cancel').on('click', function(e) {
    e.preventDefault();
    $elm = $(e.currentTarget);
    $form = $elm.closest('form');
    $form.hide();
  });

  $('.js-show-child-comment-form-delegater').on('click', '.js-show-child-comment-form', function(e) {
    var form_id = $(e.currentTarget).data('show-child-comment-form-id');
    var $form = $('#' + form_id);
    if(form_id && $form.length > 0) {
      $form.show();
      $form.closest('.js-child-comments-list').show();
      $form.find('.js-show-child-comment-form-focus').focus();
      e.preventDefault();
    }
  });

  $('.js-vote-container').on('mouseenter', '.js-vote-btn-on-hover', function(e) {
    var $elm = $(e.currentTarget);
    var old_inner_text = $elm.text();
    var new_inner_text = $elm.data('vote-btn-on-hover-mouseenter');
    $elm.text(new_inner_text);
    $elm.data('vote-btn-on-hover-mouseleave', old_inner_text);
  });

  $('.js-vote-container').on('mouseleave', '.js-vote-btn-on-hover', function(e) {
    var $elm = $(e.currentTarget);
    var old_inner_text = $elm.text();
    var new_inner_text = $elm.data('vote-btn-on-hover-mouseleave');
    $elm.text(new_inner_text);
    $elm.data('vote-btn-on-hover-mouseleave', old_inner_text);
  });
});
