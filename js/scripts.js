(function() {
  var checkBody, refreshSkrollr, scrollTo;

  refreshSkrollr = function() {
    if (typeof skrollr !== "undefined" && skrollr !== null) {
      if (skrollr.get()) {
        return skrollr.get().refresh();
      }
    }
  };

  scrollTo = function(selector, delay) {
    if (delay == null) {
      delay = 200;
    }
    return $('html, body').animate({
      scrollTop: $(selector).offset().top
    }, delay);
  };

  checkBody = function(testClass) {
    var classes, test;
    classes = document.body.className;
    test = new RegExp("\\b" + testClass + "\\b", 'g');
    return classes.match(test) != null;
  };

  Modernizr.load([
    {
      test: checkBody("skrollrMe") && !Modernizr.touch,
      yep: ['/js/skrollr.min.js', '/js/skrollr-stylesheets.js', '/js/skrollr-menu.min.js'],
      callback: function(url, result, key) {
        var menubar;
        if (url === "skrollr.min.js" && !result) {
          if (screen.width > 799) {
            menubar = document.getElementById('menubar');
            menubar.style.top = "100%";
          }
          if (typeof IElt9 !== 'undefined') {
            return Modernizr.load('/js/skrollr.ie.min.js');
          }
        }
      }
    }, {
      load: 'timeout=2000!//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js',
      complete: function() {
        var $expandableSections, $menubar, $mobilebar, $moreButtonA, $moreButtonI, delta, scrollIntercept, toggleMenu;
        if (!window.jQuery) {
          Modernizr.load({
            load: '/js/jquery.min.js'
          });
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
        $(window).on('DOMMouseScroll.menuscrolling mousewheel.menuscrolling', scrollIntercept);
        if (checkBody("mainpage")) {
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
          $expandableSections = $('.expandable');
          $expandableSections.each(function() {
            var $arrow, $container, $expandControl, $longSection, $shortSection, eventData;
            $expandControl = $(this).children('.expandSection');
            if ($expandControl.length === 0) {
              $expandControl = $(this).siblings('.expandSection');
            }
            if ($expandControl.length !== 0) {
              $shortSection = $(this).children('.shrunk');
              $longSection = $(this).children('.expanded');
              $container = $shortSection.parent();
              $arrow = $expandControl.children('.fa.fa-arrow-down');
              $longSection.addClass('hidden').hide();
              eventData = {
                "container": $container,
                "shortSection": $shortSection,
                "longSection": $longSection,
                "arrow": $arrow
              };
              return $expandControl.on("click.expansion", eventData, function(e) {
                var arrow, container, long, short;
                container = e.data.container;
                short = e.data.shortSection;
                long = e.data.longSection;
                arrow = e.data.arrow;
                if (long.hasClass("hidden")) {
                  short.addClass('hidden');
                  long.removeClass('hidden');
                  short.slideUp({
                    duration: 500,
                    complete: refreshSkrollr
                  });
                  long.slideDown({
                    duration: 500,
                    complete: refreshSkrollr
                  });
                  scrollTo(container, 500);
                  arrow.addClass("fa-arrow-up").removeClass("fa-arrow-down");
                } else {
                  short.removeClass('hidden');
                  long.addClass('hidden');
                  short.slideDown({
                    duration: 500,
                    complete: refreshSkrollr
                  });
                  long.slideUp({
                    duration: 500,
                    complete: refreshSkrollr
                  });
                  scrollTo(container, 500);
                  arrow.addClass("fa-arrow-down").removeClass("fa-arrow-up");
                }
                return e.preventDefault();
              });
            } else {
              console.log("No .expandSection control found for section:");
              console.log(this);
              return console.log("This should be either a child or sibling of the .expandable element");
            }
          });
          return $('.hoverPulse').addClass('animated').hover(function() {
            return $(this).toggleClass('pulse');
          });
        }
      }
    }, {
      test: checkBody("mainpage"),
      yep: '/js/jquery.slides.js',
      callback: function() {
        var mobileThreshold, slideHeight, slideHeightMobile, slideWidth;
        slideWidth = $("#topSlider").data("aspectratio");
        slideHeight = 1;
        slideHeightMobile = $("#topSlider").data("aspectratiomobile");
        mobileThreshold = 550;
        $(function() {
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
            }
          });
          if (typeof skrollr !== "undefined" && skrollr !== null) {
            skrollr.init({
              smoothScrolling: false,
              forceHeight: false
            });
            return skrollr.menu.init(skrollr.get());
          }
        });
        if ($("#topSlider").length !== 0) {
          $(window).resize(function() {
            var mobileMode;
            mobileMode = $("#topSlider").data("plugin_slidesjs").options.width / $("#topSlider").data("plugin_slidesjs").options.height === slideWidth / slideHeightMobile;
            if (mobileMode && $(this).width() > mobileThreshold) {
              $("#topSlider").data("plugin_slidesjs").resize(slideWidth, slideHeight);
              return refreshSkrollr();
            } else if ($(this).width() < mobileThreshold && !mobileMode) {
              $("#topSlider").data("plugin_slidesjs").resize(slideWidth, slideHeightMobile);
              return refreshSkrollr();
            }
          });
        }
        return $("#facilities .slider").slidesjs({
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
            active: false
          },
          effect: {
            fade: {
              speed: 600,
              crossfade: true
            }
          }
        });
      }
    }, {
      test: checkBody("mainpage"),
      yep: '/js/jquery.fullscreen.js',
      callback: function() {
        $('#groupmembers').fullscreen({
          active: true,
          scrollCallback: function() {
            return $('#menubar, #mobilebar').addClass("hidden");
          },
          scrollCaptureRange: 150,
          lostFocusRange: 151,
          resizeCallback: function() {
            refreshSkrollr();
            if ($.zoomImage != null) {
              $.zoomImage.updateAll();
              return $.zoomImage.updateAll();
            }
          }
        });
        return $('#facilities').fullscreen({
          active: true,
          scrollCallback: function() {
            return $('#menubar, #mobilebar').addClass("hidden");
          },
          scrollCaptureRange: 150,
          lostFocusRange: 151,
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
      }
    }, {
      test: checkBody("mainpage"),
      yep: ['/js/jquery.zoomImage.js', '/js/jquery.groupMembers.js'],
      complete: function() {
        if (checkBody("mainpage")) {
          return $('#groupmembers .fullHolder').groupScroller({
            first: 1
          });
        }
      }
    }
  ]);

}).call(this);
