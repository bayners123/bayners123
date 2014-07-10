(function() {
  Modernizr.load({
    test: Modernizr.touch,
    nope: ['skrollr.min.js', 'skrollr-stylesheets.js', 'skrollr-menu.min.js'],
    callback: function(url, result, key) {
      var menuBar;
      if (url === "skrollr.min.js" && !result) {
        if (screen.width > 799) {
          menuBar = document.getElementById('menuBar');
          menuBar.style.top = "100%";
        }
        if (typeof IElt9 !== 'undefined') {
          return Modernizr.load('skrollr.ie.min.js');
        }
      }
    }
  });

  Modernizr.load({
    load: ['//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js', 'jquery.slides.js'],
    complete: function() {
      var $menuBar, $mobileBar, $moreButtonA, $moreButtonI, mobileThreshold, slideHeight, slideHeightMobile, slideWidth, toggleMenu;
      if (!window.jQuery) {
        Modernizr.load('jquery.min.js');
      }
      toggleMenu = function(menuBar, moreButtonI) {
        if (menuBar.is(':visible')) {
          menuBar.slideUp();
          return moreButtonI.removeClass("fa-angle-double-up").addClass("fa-angle-double-down");
        } else {
          menuBar.slideDown();
          return moreButtonI.removeClass("fa-angle-double-down").addClass("fa-angle-double-up");
        }
      };
      $menuBar = $('#menuBar');
      $mobileBar = $('#mobileBar');
      $moreButtonA = $('#mobileBar #moreButton');
      $moreButtonI = $('#mobileBar #moreButton i');
      $($moreButtonA).click(function(event) {
        event.preventDefault();
        return toggleMenu($menuBar, $moreButtonI);
      });
      $($menuBar).click(function() {
        if ($mobileBar.is(':visible')) {
          return toggleMenu($menuBar, $moreButtonI);
        }
      });
      slideWidth = $("#slider").data("aspectratio");
      slideHeight = 1;
      slideHeightMobile = $("#slider").data("aspectratiomobile");
      mobileThreshold = 550;
      $(function() {
        $("#slider").slidesjs({
          width: slideWidth,
          height: screen.width < mobileThreshold ? slideHeightMobile : slideHeight,
          zoom: true,
          navigation: false,
          play: {
            active: true,
            interval: 4000,
            auto: true,
            swap: true,
            pauseOnHover: true,
            generate: false
          }
        });
        if (!Modernizr.touch) {
          skrollr.init({
            smoothScrolling: false,
            forceHeight: false
          });
          return skrollr.menu.init(skrollr.get());
        }
      });
      $(window).resize(function() {
        var mobileMode;
        mobileMode = $("#slider").data("plugin_slidesjs").options.width / $("#slider").data("plugin_slidesjs").options.height === slideWidth / slideHeightMobile;
        if (mobileMode && $(this).width() > mobileThreshold) {
          return $("#slider").data("plugin_slidesjs").resize(slideWidth, slideHeight);
        } else if ($(this).width() < mobileThreshold && !mobileMode) {
          return $("#slider").data("plugin_slidesjs").resize(slideWidth, slideHeightMobile);
        }
      });
      return $('.hoverPulse').addClass('animated').hover(function() {
        return $(this).toggleClass('pulse');
      });
    }
  });

}).call(this);
