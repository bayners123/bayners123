(function() {
  Modernizr.load({
    test: Modernizr.touch,
    nope: ['skrollr.min.js', 'skrollr-stylesheets.js', 'skrollr-menu.min.js'],
    callback: function(url, result, key) {
      var menubar;
      if (url === "skrollr.min.js" && !result) {
        if (screen.width > 799) {
          menubar = document.getElementById('menubar');
          menubar.style.top = "100%";
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
      var $menubar, $mobilebar, $moreButtonA, $moreButtonI, delta, mobileThreshold, scrollIntercept, slideHeight, slideHeightMobile, slideWidth, toggleMenu;
      if (!window.jQuery) {
        Modernizr.load('jquery.min.js');
      }
      toggleMenu = function(menubar, moreButtonI) {
        if (menubar.is(':visible')) {
          menubar.slideUp();
          return moreButtonI.removeClass("fa-angle-double-up").addClass("fa-angle-double-down");
        } else {
          menubar.slideDown();
          return moreButtonI.removeClass("fa-angle-double-down").addClass("fa-angle-double-up");
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
      $($menubar).click(function() {
        if ($mobilebar.is(':visible')) {
          return toggleMenu($menubar, $moreButtonI);
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
        $(function() {
          return $('#researchDetails').hide();
        });
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
          $("#slider").data("plugin_slidesjs").resize(slideWidth, slideHeight);
          return skrollr.get().refresh();
        } else if ($(this).width() < mobileThreshold && !mobileMode) {
          $("#slider").data("plugin_slidesjs").resize(slideWidth, slideHeightMobile);
          return skrollr.get().refresh();
        }
      });
      $('.hoverPulse').addClass('animated').hover(function() {
        return $(this).toggleClass('pulse');
      });
      delta = 0;
      scrollIntercept = function(e) {
        var appearanceThreshold;
        appearanceThreshold = 5;
        if (e.originalEvent.detail < 0 || e.originalEvent.wheelDelta > 0) {
          delta--;
        } else {
          delta++;
        }
        if (delta > 0) {
          delta = 0;
        } else if (delta < -appearanceThreshold) {
          delta = -appearanceThreshold;
        }
        if (delta === 0) {
          return $('#menubar').addClass("hidden");
        } else if (delta === -appearanceThreshold) {
          return $('#menubar').removeClass("hidden");
        }
      };
      return $(window).on('DOMMouseScroll.menuscrolling mousewheel.menuscrolling', scrollIntercept);
    }
  });

}).call(this);
