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
            effect: "fade",
            interval: 4000,
            auto: true,
            swap: true,
            pauseOnHover: true,
            generate: false,
            restartDelay: 1000
          },
          effect: {
            fade: {
              speed: 600,
              crossfade: true
            }
          }
        });
        $(".tabgroup").each(function() {
          var $group, $links, $tabs, clickHandler, i, showTab, theLink, _results;
          $group = $(this);
          $links = $group.find(".tabmenu a");
          $tabs = $group.find(".tabs .tab");
          $links.click(function() {
            return false;
          });
          showTab = function(group, link, tab) {
            var links, tabs;
            links = group.find(".tabmenu a");
            tabs = group.find(".tabs .tab");
            links.removeClass('active');
            tabs.removeClass('active');
            link.addClass('active');
            return tab.addClass('active');
          };
          showTab($group, $links.first(), $tabs.first());
          clickHandler = function(e) {
            var clickedLink;
            clickedLink = $(e.target);
            showTab(clickedLink.data("myGroup"), clickedLink, clickedLink.data("myTab"));
            return false;
          };
          i = 0;
          _results = [];
          while ($links.size() > i && $tabs.size() > i) {
            theLink = $links.eq(i);
            theLink.data("myGroup", $group);
            theLink.data("myTab", $tabs.eq(i));
            theLink.click(clickHandler);
            _results.push(i++);
          }
          return _results;
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
