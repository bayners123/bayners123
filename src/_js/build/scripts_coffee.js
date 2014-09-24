(function() {
  var $menubar, $mobilebar, $moreButtonA, $moreButtonI, delta, initSkrollr, mobileThreshold, refreshSkrollr, scrollTo, slideHeight, slideHeightMobile, slideWidth, toggleMenu;

  window.joseURL = "";

  initSkrollr = function() {
    skrollr.init({
      smoothScrolling: false,
      forceHeight: false
    });
    return skrollr.menu.init(skrollr.get());
  };

  refreshSkrollr = function() {
    var _ref;
    return typeof skrollr !== "undefined" && skrollr !== null ? (_ref = skrollr.get()) != null ? _ref.refresh() : void 0 : void 0;
  };

  scrollTo = function(selector, delay) {
    if (delay == null) {
      delay = 200;
    }
    return $('html, body').animate({
      scrollTop: $(selector).offset().top
    }, delay);
  };

  window.checkBody = function(testClass) {
    var classes, test;
    classes = document.body.className;
    test = new RegExp("\\b" + testClass + "\\b", 'g');
    return test.test(classes);
  };

  window.mobileMode = function() {
    return screen.width < 800;
  };

  window.isMainpage = window.checkBody("mainpage");

  Modernizr.load([
    {
      test: window.isMainpage && !Modernizr.touch && typeof IElt9 === 'undefined',
      yep: window.joseURL + '/js/skrollr.min.js',
      callback: function(url, result, key) {
        var menubar;
        if (!window.mobileMode()) {
          menubar = document.getElementById('menubar');
          menubar.style.top = "100%";
        }
        if (window.jsloaded) {
          return initSkrollr();
        }
      }
    }
  ]);

  toggleMenu = function(menubar, moreButtonI) {
    if (menubar.hasClass('hidden')) {
      menubar.removeClass('hidden');
      return moreButtonI.removeClass("fa-angle-double-down").addClass("fa-angle-double-up");
    } else {
      menubar.addClass('hidden');
      return moreButtonI.removeClass("fa-angle-double-up").addClass("fa-angle-double-down");
    }
  };

  $menubar = $('#menubar');

  $mobilebar = $('#mobilebar');

  $moreButtonA = $('#mobilebar #moreButton');

  $moreButtonI = $('#mobilebar #moreButton i');

  $($moreButtonA).click(function(event) {
    event.preventDefault();
    return toggleMenu($menubar, $moreButtonI);
  });

  $(window).resize(function() {
    if (window.mobileMode()) {
      return $menubar.addClass("hidden").css("display", "block");
    }
  });

  $($menubar).click(function() {
    if (window.mobileMode()) {
      return toggleMenu($menubar, $moreButtonI);
    }
  });

  delta = 0;

  window.scrollIntercept = function(e, override) {
    var appearanceThreshold;
    appearanceThreshold = 5;
    if (override != null) {
      delta = override;
    } else {
      if (e.originalEvent.detail < 0 || e.originalEvent.wheelDelta > 0 || e.originalEvent.deltaY < 0) {
        delta--;
      } else {
        delta++;
      }
    }
    if (delta > 0) {
      delta = 0;
    } else if (delta < -appearanceThreshold) {
      delta = -appearanceThreshold;
    }
    if (window.mobileMode()) {
      if (delta === 0) {
        $mobilebar.addClass("hidden");
        if (!$menubar.hasClass("hidden")) {
          return toggleMenu($menubar, $moreButtonI);
        }
      } else if (delta === -appearanceThreshold) {
        return $mobilebar.removeClass("hidden");
      }
    } else {
      if (delta === 0) {
        return $menubar.addClass("hidden");
      } else if (delta === -appearanceThreshold) {
        return $menubar.removeClass("hidden");
      }
    }
  };

  $(window).on('DOMMouseScroll.menuscrolling mousewheel.menuscrolling wheel.menuscrolling', window.scrollIntercept);

  if (window.isMainpage) {
    $('.hoverPulse').addClass('animated').css({
      "-webkit-animation-duration": "0.5s",
      "animation-duration": "0.5s"
    }).hover(function() {
      return $(this).toggleClass('pulse');
    });
  }

  if (Modernizr.touch) {
    $(window).touchwipe({
      wipeUp: function() {
        return window.scrollIntercept(null, -100);
      },
      wipeDown: function() {
        return window.scrollIntercept(null, 0);
      },
      min_move_x: 20,
      min_move_y: 20,
      preventDefaultEvents: false
    });
  }

  if (window.isMainpage) {
    slideWidth = $("#topSlider").data("aspectratio");
    slideHeight = 1;
    slideHeightMobile = $("#topSlider").data("aspectratiomobile");
    mobileThreshold = 550;
    $("#topSlider").slidesjs({
      width: slideWidth,
      height: screen.width < mobileThreshold ? slideHeightMobile : slideHeight,
      zoom: true,
      navigation: {
        active: false
      },
      play: {
        active: true,
        effect: "fade",
        interval: 4000,
        auto: true,
        swap: true,
        pauseOnHover: false,
        generate: false,
        restartDelay: 1000
      },
      effect: {
        fade: {
          speed: 600,
          crossfade: true
        }
      },
      lazy: true
    });
    if ($("#topSlider").length !== 0) {
      $(window).resize(function() {
        if (window.mobileMode() && $(this).width() > mobileThreshold) {
          $("#topSlider").data("plugin_slidesjs").resize(slideWidth, slideHeight);
          return refreshSkrollr();
        } else if ($(this).width() < mobileThreshold && !window.mobileMode()) {
          $("#topSlider").data("plugin_slidesjs").resize(slideWidth, slideHeightMobile);
          return refreshSkrollr();
        }
      });
    }
    $("#facilities .slider").slidesjs({
      width: screen.width,
      height: screen.height,
      zoom: true,
      navigation: {
        active: false,
        rollover: false
      },
      play: {
        active: true,
        effect: "fade",
        interval: 4000,
        auto: false,
        swap: true,
        pauseOnHover: false,
        generate: false
      },
      pagination: {
        active: true,
        generate: false
      },
      effect: {
        fade: {
          speed: 600,
          crossfade: true
        }
      },
      lazy: true
    });
    $('#groupmembers .arrow').addClass("animated").css({
      "-webkit-animation-duration": "1s",
      "animation-duration": "1s",
      "-webkit-animation-iteration-count": "1",
      "animation-iteration-count": "1"
    });
    $('#groupmembers').fullscreen({
      active: true,
      scrollCallback: function() {
        $('#menubar, #mobilebar').addClass("hidden");
        $('#groupmembers .arrow.left').one("animationend webkitAnimationEnd oAnimationEnd oanimationend MSAnimationEnd", function() {
          return $(this).removeClass("pulseLeft");
        }).addClass("pulseLeft");
        return $('#groupmembers .arrow.right').one("animationend webkitAnimationEnd oAnimationEnd oanimationend MSAnimationEnd", function() {
          return $(this).removeClass("pulseRight");
        }).addClass("pulseRight");
      },
      scrollCaptureRange: window.mobileMode() ? 75 : 150,
      lostFocusRange: window.mobileMode() ? 51 : 151,
      resizeCallback: function() {
        refreshSkrollr();
        if ($.zoomImage != null) {
          $.zoomImage.updateAll();
          return $.zoomImage.updateAll();
        }
      }
    });
    $('#facilities').fullscreen({
      active: true,
      scrollCallback: function() {
        return $('#menubar, #mobilebar').addClass("hidden");
      },
      scrollCaptureRange: window.mobileMode() ? 75 : 150,
      lostFocusRange: window.mobileMode() ? 51 : 151,
      resizeCallback: function() {
        var arrows, height, left, right, width;
        refreshSkrollr();
        width = $('#facilities').width();
        height = $('#facilities').height();
        $("#facilities .slider").data("plugin_slidesjs").resize(width, height);
        arrows = $('#facilities .slidesjs-next, #facilities .slidesjs-previous');
        right = $('#facilities .slidesjs-next');
        left = $('#facilities .slidesjs-previous');
        return arrows.css({
          top: ($('#facilities .slider').height() - arrows.first().height()) / 2
        });
      }
    });
    if (window.isMainpage) {
      $('#groupmembers .fullHolder').groupScroller({
        first: "middle"
      });
      $('#groupmembers .fullHolder a').click(function() {
        return scrollTo("#groupmembers");
      });
      $('#publications .filledImg img').zoomImage();
    }
    $("#researchDetails").tabGroups();
    $("#publications .expanded .tabGroup").tabGroups();
    $('#researchDetails').hide();
    $('.researchBubble').click(function() {
      return $('#researchDetails').show().addClass("animated appearZoom");
    });
    $('#research1').click(function() {
      return $('#researchLink1').click();
    });
    $('#research2').click(function() {
      return $('#researchLink2').click();
    });
    $('#research3').click(function() {
      return $('#researchLink3').click();
    });
    $('.expandable').expandable();
    if (typeof skrollr !== "undefined" && skrollr !== null) {
      initSkrollr();
    }
    window.jsloaded = true;
  }

  if (window.customJS != null) {
    window.customJS();
  }

}).call(this);
