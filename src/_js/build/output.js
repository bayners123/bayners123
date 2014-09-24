/**
 * jQuery Plugin to obtain touch gestures from iPhone, iPod Touch and iPad, should also work with Android mobile phones (not tested yet!)
 * Common usage: wipe images (left and right to show the previous or next image)
 * 
 * @author Andreas Waltl, netCU Internetagentur (http://www.netcu.de)
 * @version 1.1.1 (9th December 2010) - fix bug (older IE's had problems)
 * @version 1.1 (1st September 2010) - support wipe up and wipe down
 * @version 1.0 (15th July 2010)
 */
(function($){$.fn.touchwipe=function(settings){var config={min_move_x:20,min_move_y:20,wipeLeft:function(){},wipeRight:function(){},wipeUp:function(){},wipeDown:function(){},preventDefaultEvents:true};if(settings)$.extend(config,settings);this.each(function(){var startX;var startY;var isMoving=false;function cancelTouch(){this.removeEventListener('touchmove',onTouchMove);startX=null;isMoving=false}function onTouchMove(e){if(config.preventDefaultEvents){e.preventDefault()}if(isMoving){var x=e.touches[0].pageX;var y=e.touches[0].pageY;var dx=startX-x;var dy=startY-y;if(Math.abs(dx)>=config.min_move_x){cancelTouch();if(dx>0){config.wipeLeft()}else{config.wipeRight()}}else if(Math.abs(dy)>=config.min_move_y){cancelTouch();if(dy>0){config.wipeDown()}else{config.wipeUp()}}}}function onTouchStart(e){if(e.touches.length==1){startX=e.touches[0].pageX;startY=e.touches[0].pageY;isMoving=true;this.addEventListener('touchmove',onTouchMove,false)}}if('ontouchstart'in document.documentElement){this.addEventListener('touchstart',onTouchStart,false)}});return this}})(jQuery);
(function() {
  (function($, window, document) {
    var Plugin, data, defaults, pluginName;
    pluginName = "expandable";
    defaults = {
      expandControl: null,
      shortSection: null,
      longSection: null,
      container: null,
      toggleCallback: $.noop
    };
    data = {
      expandControl: null,
      shortSection: null,
      longSection: null,
      container: null
    };
    Plugin = (function() {
      function Plugin(element, options) {
        var init, scrollTo;
        this.element = element;
        init = (function(_this) {
          return function() {
            var $element, _ref, _ref1, _ref2, _ref3;
            $element = $(_this.element);
            if (_this.settings.expandControl != null) {
              _this.data.expandControl = _this.settings.expandControl;
            } else {
              _this.data.expandControl = $(_this.element).children('.expandSection');
              if (_this.data.expandControl.length === 0) {
                _this.data.expandControl = $element.siblings('.expandSection');
              }
            }
            if (_this.data.expandControl.length !== 0) {
              _this.data.shortSection = (_ref = _this.settings.shortSection) != null ? _ref : $element.children('.shrunk');
              _this.data.longSection = (_ref1 = _this.settings.longSection) != null ? _ref1 : $element.children('.expanded');
              _this.data.container = (_ref2 = _this.settings.container) != null ? _ref2 : _this.data.shortSection.parent();
              _this.data.arrow = (_ref3 = _this.settings.arrow) != null ? _ref3 : _this.data.expandControl.children('.fa.fa-arrow-down');
              _this.data.longSection.addClass('hidden').hide();
              return _this.data.expandControl.on("click.expansion", function(e) {
                if (_this.data.longSection.hasClass("hidden")) {
                  _this.data.shortSection.addClass('hidden');
                  _this.data.longSection.removeClass('hidden');
                  _this.data.shortSection.slideUp({
                    duration: 500,
                    complete: _this.settings.toggleCallback()
                  });
                  _this.data.longSection.slideDown({
                    duration: 500,
                    complete: _this.settings.toggleCallback()
                  });
                  scrollTo(_this.data.container, 500);
                  _this.data.arrow.addClass("fa-arrow-up").removeClass("fa-arrow-down");
                } else {
                  _this.data.shortSection.removeClass('hidden');
                  _this.data.longSection.addClass('hidden');
                  _this.data.shortSection.slideDown({
                    duration: 500,
                    complete: _this.settings.toggleCallback()
                  });
                  _this.data.longSection.slideUp({
                    duration: 500,
                    complete: _this.settings.toggleCallback()
                  });
                  scrollTo(_this.data.container, 500);
                  _this.data.arrow.addClass("fa-arrow-down").removeClass("fa-arrow-up");
                }
                return e.preventDefault();
              });
            } else {
              console.log("No .expandSection control found for section:");
              console.log(_this);
              return console.log("This should be either a child or sibling of the .expandable element");
            }
          };
        })(this);
        scrollTo = function(selector, delay) {
          if (delay == null) {
            delay = 200;
          }
          return $('html, body').animate({
            scrollTop: $(selector).offset().top
          }, delay);
        };
        this.settings = $.extend({}, defaults, options);
        this._defaults = defaults;
        this._name = pluginName;
        this.data = $.extend({}, data);
        init();
      }

      return Plugin;

    })();
    return $.fn[pluginName] = function(options) {
      return this.each(function() {
        if (!$.data(this, "plugin_" + pluginName)) {
          return $.data(this, "plugin_" + pluginName, new Plugin(this, options));
        }
      });
    };
  })(jQuery, window, document);

}).call(this);

(function() {
  (function($, window, document) {
    var Plugin, data, defaults, pluginName;
    pluginName = "fullscreen";
    defaults = {
      activeClass: "jqueryfullscreen_active",
      animation: true,
      animationDuration: "0.25s",
      scrollCapture: true,
      scrollCaptureRange: 100,
      offset: 0,
      scrollCallback: $.noop,
      lostFocusCallback: $.noop,
      lostFocusRange: 200,
      shrinkOnLostFocus: false,
      parentElement: window,
      resizeCallback: $.noop,
      active: false
    };
    data = {
      vendorPrefix: null,
      originalHeight: null,
      originalWidth: null,
      animating: false,
      hasFocus: false,
      resizeTimeout: null
    };
    Plugin = (function() {
      function Plugin(element, options) {
        this.element = element;
        this.options = $.extend(true, {}, defaults, options);
        this._defaults = defaults;
        this._name = pluginName;
        this.data = $.extend(true, {}, data);
        this.init();
      }

      return Plugin;

    })();
    Plugin.prototype.init = function() {
      var $element, anim;
      $element = $(this.element);
      this.data.vendorPrefix = this._getVendorPrefix();
      this._getDims();
      $(window).resize((function(_this) {
        return function() {
          return _this.check();
        };
      })(this));
      if (navigator.userAgent.match(/iPhone/i) || navigator.userAgent.match(/iPod/i)) {
        this.data.iPhoneWidth = $(this.options.parentElement).get(0).innerWidth;
        this.data.iPhoneHeight = $(this.options.parentElement).get(0).innerHeight;
        this.data.iPhoneInterval = setInterval((function(_this) {
          return function() {
            var newHeight, newWidth;
            newWidth = $(_this.options.parentElement).get(0).innerWith;
            newHeight = $(_this.options.parentElement).get(0).innerHeight;
            if (newWidth !== _this.data.iPhoneWidth || newHeight !== _this.data.iPhoneHeight) {
              _this.data.iPhoneWidth = newWidth;
              _this.data.iPhoneHeight = newHeight;
              return $(window).resize();
            }
          };
        })(this), 2000);
      }
      if (this.options.scrollCapture) {
        $(this.options.parentElement).scroll((function(_this) {
          return function() {
            clearTimeout(_this.data.scrollTimer);
            return _this.data.scrollTimer = setTimeout(function() {
              return _this._checkScroll();
            }, 500);
          };
        })(this));
      }
      $(this.options.parentElement).scroll((function(_this) {
        return function() {
          var elementPos, scrollPos;
          $element = $(_this.element);
          if ($element.hasClass(_this.options.activeClass) && !_this.data.animating && !(_this.data.resizeTimeout && _this.data.hasFocus)) {
            elementPos = _this.element.offsetTop;
            scrollPos = $(_this.options.parentElement).scrollTop();
            if (elementPos + _this.options.offset - _this.options.lostFocusRange > scrollPos || scrollPos > elementPos + _this.options.offset + _this.options.lostFocusRange) {
              if (_this.data.hasFocus) {
                if (_this.options.shrinkOnLostFocus) {
                  if (scrollPos > elementPos + _this.options.offset + _this.options.lostFocusRange) {
                    _this.data.autoShrinking = true;
                  }
                  _this.setInactive();
                }
                return _this.data.hasFocus = false;
              }
            } else if (!_this.data.hasFocus) {
              _this.data.hasFocus = true;
              return _this.options.lostFocusCallback(_this.element);
            }
          }
        };
      })(this));
      if (this.options.active) {
        anim = this.options.animation;
        this.options.animation = false;
        this.setActive();
        this.options.animation = anim;
      }
      return this;
    };
    Plugin.prototype.check = function() {
      var $element;
      $element = $(this.element);
      if ($element.hasClass(this.options.activeClass)) {
        this._resizeToFull();
      } else {
        if (!this.data.animating) {
          this._getDims();
        }
      }
      return this;
    };
    Plugin.prototype._getDims = function() {
      var $element;
      $element = $(this.element);
      this.data.originalHeight = $element.height();
      return this.data.originalWidth = $element.width();
    };
    Plugin.prototype.setActive = function(callback, scroll) {
      $(this.element).addClass(this.options.activeClass);
      this._addStyles();
      this._resizeToFull(callback, true);
      if (scroll) {
        this._scrollTo(true);
      }
      return this;
    };
    Plugin.prototype.setInactive = function(callback) {
      this._undoResize((function(_this) {
        return function() {
          _this._removeStyles();
          $(_this.element).removeClass(_this.options.activeClass);
          if (callback != null) {
            return callback();
          }
        };
      })(this));
      return this;
    };
    Plugin.prototype.toggleActive = function(callback, scroll) {
      var $element;
      $element = $(this.element);
      if ($element.hasClass(this.options.activeClass)) {
        this.setInactive(callback);
      } else {
        this.setActive(callback, scroll);
      }
      return this;
    };
    Plugin.prototype._addStyles = function() {
      var $element;
      $element = $(this.element);
      return $element.find(".fullHolder, .fullHolderContent").css({
        display: "block",
        height: "100%",
        overflow: "hidden",
        position: "relative"
      });
    };
    Plugin.prototype._removeStyles = function() {
      var $element;
      $element = $(this.element);
      return $element.find(".fullHolder, .fullHolderContent").css({
        display: "",
        height: "",
        overflow: "",
        position: ""
      });
    };
    Plugin.prototype._getVendorPrefix = function() {
      var body, i, style, vendor;
      body = document.body || document.documentElement;
      style = body.style;
      vendor = ["Moz", "Webkit", "Khtml", "O", "ms"];
      i = 0;
      while (i < vendor.length) {
        if (typeof style[vendor[i] + "Transition"] === "string") {
          return vendor[i];
        }
        i++;
      }
      return false;
    };
    Plugin.prototype._resizeToFull = function(afterResized, initialResize) {
      var $element, targetHeight, targetWidth;
      $element = $(this.element);
      targetHeight = $(this.options.parentElement).get(0).innerHeight;
      targetWidth = $(this.options.parentElement).get(0).innerWidth;
      if (this.options.animation && initialResize) {
        this.data.animating = true;
        $element.css("height", $element.height());
        setTimeout((function(_this) {
          return function() {
            _this.element.style[_this.data.vendorPrefix + "Transition"] = "height " + _this.options.animationDuration + " ease-in-out";
            return setTimeout(function() {
              return $element.css({
                height: targetHeight,
                width: targetWidth
              });
            });
          };
        })(this));
        $element.one("transitionend webkitTransitionEnd oTransitionEnd otransitionend MSTransitionEnd", (function(_this) {
          return function() {
            $element = $(_this.element);
            _this.element.style[_this.data.vendorPrefix + "Transition"] = "";
            _this.data.animating = false;
            if (afterResized != null) {
              afterResized();
            }
            return _this.options.resizeCallback(_this.element);
          };
        })(this));
      } else {
        $element.css({
          height: targetHeight,
          width: targetWidth
        });
        if (this.data.resizeTimeout) {
          clearTimeout(this.data.resizeTimeout);
        }
        this.data.resizeTimeout = setTimeout((function(_this) {
          return function() {
            if (_this.data.hasFocus) {
              _this._scrollTo(false);
            }
            if (afterResized != null) {
              afterResized();
            }
            _this.options.resizeCallback(_this.element);
            return _this.data.resizeTimeout = null;
          };
        })(this));
      }
      return this;
    };
    Plugin.prototype._undoResize = function(afterResized) {
      var $element, targetHeight, targetWidth;
      $element = $(this.element);
      this.data.hasFocus = false;
      if (!this.options.animation) {
        $element.css({
          height: "",
          width: ""
        });
        if (afterResized != null) {
          afterResized();
        }
        this.options.resizeCallback(this.element);
      } else {
        this.data.animating = true;
        targetHeight = this.data.originalHeight;
        targetWidth = this.data.originalWidth;
        this.element.style[this.data.vendorPrefix + "Transition"] = "height " + this.options.animationDuration + " ease-in-out";
        setTimeout((function(_this) {
          return function() {
            var currentScroll, elementDelta;
            $element.css({
              height: targetHeight,
              width: targetWidth
            });
            if (_this.data.autoShrinking) {
              elementDelta = $element.height() - _this.data.originalHeight;
              currentScroll = $(_this.options.parentElement).scrollTop();
              if ($(_this.options.parentElement).get(0) === window) {
                $('html, body').scrollTop(currentScroll - elementDelta);
              } else {
                $(_this.options.parentElement).scrollTop(currentScroll - elementDelta);
              }
              return _this.data.autoShrinking = false;
            }
          };
        })(this));
        $element.one("transitionend webkitTransitionEnd oTransitionEnd otransitionend MSTransitionEnd", (function(_this) {
          return function() {
            $element = $(_this.element);
            $element.css({
              height: "",
              width: ""
            });
            _this.element.style[_this.data.vendorPrefix + "Transition"] = "";
            _this.data.animating = false;
            if (afterResized != null) {
              afterResized();
            }
            return _this.options.resizeCallback(_this.element);
          };
        })(this));
      }
      return this;
    };
    Plugin.prototype._checkScroll = function(elementPos, scrollPos) {
      elementPos = this.element.offsetTop;
      scrollPos = $(this.options.parentElement).scrollTop();
      if ($(this.element).hasClass(this.options.activeClass)) {
        if (elementPos + this.options.offset - this.options.scrollCaptureRange < scrollPos && scrollPos < elementPos + this.options.offset + this.options.scrollCaptureRange) {
          this._scrollTo(true);
        }
      }
      return this;
    };
    Plugin.prototype._scrollTo = function(animate) {
      var elementPos;
      elementPos = this.element.offsetTop;
      if (this.options.animation && animate) {
        if ($(this.options.parentElement).get(0) === window) {
          $('html, body').animate({
            scrollTop: elementPos + this.options.offset
          }, 300);
        } else {
          $(this.options.parentElement).animate({
            scrollTop: elementPos + this.options.offset
          }, 300);
        }
      } else {
        if ($(this.options.parentElement).get(0) === window) {
          $('html, body').scrollTop(elementPos + this.options.offset);
        } else {
          $(this.options.parentElement).scrollTop(elementPos + this.options.offset);
        }
      }
      this.data.hasFocus = true;
      this.options.scrollCallback(this.element);
      return this;
    };
    return $.fn[pluginName] = function(options) {
      return this.each(function() {
        if (!$.data(this, "plugin_" + pluginName)) {
          return $.data(this, "plugin_" + pluginName, new Plugin(this, options));
        }
      });
    };
  })(jQuery, window, document);

}).call(this);

(function() {
  (function($, window, document) {
    var Plugin, data, defaults, pluginName;
    pluginName = "groupScroller";
    defaults = {
      leftArrow: null,
      rightArrow: null,
      minusArrow: null,
      plusArrow: null,
      yearHeading: null,
      personHeading: null,
      slideImgHolder: null,
      descULHolder: null,
      groupListHolder: null
    };
    data = {
      leftArrow: null,
      rightArrow: null,
      personHeading: null,
      currentYear: 0,
      noYears: null,
      currentSlide: null,
      noSlides: null,
      groupInfo: []
    };
    Plugin = (function() {
      function Plugin(element, options) {
        this.element = element;
        this.options = $.extend(true, {}, defaults, options);
        this._defaults = defaults;
        this._name = pluginName;
        this.data = data;
        this.init();
      }

      return Plugin;

    })();
    Plugin.prototype.init = function() {
      var $element, descULHolder, groupListHolder, slideImgHolder;
      $element = $(this.element);
      if (this.options.leftArrow) {
        this.data.leftArrow = $(this.options.leftArrow);
      } else {
        this.data.leftArrow = $element.find(".groupDesc .arrow.left");
      }
      if (this.options.rightArrow) {
        this.data.rightArrow = $(this.options.rightArrow);
      } else {
        this.data.rightArrow = $element.find(".groupDesc .arrow.right");
      }
      if (this.options.minusArrow) {
        this.data.minusArrow = $(this.options.minusArrow);
      } else {
        this.data.minusArrow = $element.find(".yearBox .arrow.left");
      }
      if (this.options.plusArrow) {
        this.data.plusArrow = $(this.options.plusArrow);
      } else {
        this.data.plusArrow = $element.find(".yearBox .arrow.right");
      }
      if (this.options.yearHeading) {
        this.data.yearHeading = $(this.options.yearHeading);
      } else {
        this.data.yearHeading = $element.find(".yearBox h3");
      }
      if (this.options.personHeading) {
        this.data.personHeading = $(this.options.personHeading);
      } else {
        this.data.personHeading = $element.find(".groupDesc .person");
      }
      if (this.options.slideImgHolder) {
        slideImgHolder = $(this.options.slideImgHolder);
      } else {
        slideImgHolder = $element.find(".imgHolder");
      }
      $.each(slideImgHolder.children("img"), (function(_this) {
        return function(index) {
          var $img, year;
          $img = slideImgHolder.children("img").eq(index);
          year = $img.data("year");
          _this.data.groupInfo.push({
            year: year,
            image: $img,
            imageLoaded: false
          });
          if (index === 0) {
            return $img.show();
          } else {
            return $img.hide();
          }
        };
      })(this));
      if (this.options.descULHolder) {
        descULHolder = $(this.options.descULHolder);
      } else {
        descULHolder = $element.find(".descHolder");
      }
      $.each(descULHolder.children("ul"), (function(_this) {
        return function(index) {
          var $ul;
          $ul = descULHolder.children("ul").eq(index);
          if (_this.data.groupInfo[index].year !== $ul.data("year")) {
            console.log("Error: order of descHolder ul elements is mismatched with imgs");
          }
          _this.data.groupInfo[index].descUL = $ul;
          if (index !== 0) {
            return $ul.hide();
          }
        };
      })(this));
      if (this.options.groupListHolder) {
        groupListHolder = this.options.groupListHolder;
      } else {
        groupListHolder = $element.find(".groupListHolder");
      }
      $.each(groupListHolder.children("nav"), (function(_this) {
        return function(index) {
          var $nav;
          $nav = groupListHolder.children("nav").eq(index);
          if (_this.data.groupInfo[index].year !== $nav.data("year")) {
            console.log("Error: order of nav elements is mismatched with imgs");
          }
          _this.data.groupInfo[index].nav = $nav;
          if (index !== 0) {
            return $nav.hide();
          }
        };
      })(this));
      this.data.noYears = this.data.groupInfo.length;
      this.data.noSlides = this.data.groupInfo[0].descUL.children("li").length;
      this.data.leftArrow.on("click.groupMembers", (function(_this) {
        return function() {
          _this._prev();
          return false;
        };
      })(this));
      this.data.rightArrow.on("click.groupMembers", (function(_this) {
        return function() {
          _this._next();
          return false;
        };
      })(this));
      this.data.plusArrow.on("click.groupMembers", (function(_this) {
        return function() {
          _this._nextYear();
          return false;
        };
      })(this));
      this.data.minusArrow.on("click.groupMembers", (function(_this) {
        return function() {
          _this._prevYear();
          return false;
        };
      })(this));
      $.each(this.data.groupInfo, (function(_this) {
        return function(index) {
          return _this.data.groupInfo[index].nav.children("a").click(function(e) {
            var clickedLink;
            clickedLink = e.target;
            e.preventDefault();
            return _this._goto(_this.data.groupInfo[index].nav.children("a").index(clickedLink), true);
          });
        };
      })(this));
      return $((function(_this) {
        return function() {
          $.each(_this.data.groupInfo, function(index) {
            return _this.data.groupInfo[index].image.zoomImage({
              resizeCallbackAfter: index === 0 ? function() {
                if (typeof skrollr !== "undefined" && skrollr !== null) {
                  if (skrollr.get()) {
                    return skrollr.get().refresh();
                  }
                }
              } : $.noop,
              useMarginFunctions: true,
              initialAnimation: false,
              getXOverride: function() {
                return _this.getXMargin(_this.data.currentSlide);
              }
            });
          });
          if (skrollr && skrollr.menu) {
            skrollr.menu.jumpToInitialPos();
          }
          return _this._gotoYear(0, false);
        };
      })(this));
    };
    Plugin.prototype._prev = function() {
      if (this.data.currentSlide !== 0) {
        return this._goto(this.data.currentSlide - 1, true);
      }
    };
    Plugin.prototype._next = function() {
      if (this.data.currentSlide < this.data.noSlides - 1) {
        return this._goto(this.data.currentSlide + 1, true);
      }
    };
    Plugin.prototype._goto = function(slide, animation) {
      var $groupListLinks, $slides, $thisSlide;
      if ((0 <= slide && slide < this.data.noSlides)) {
        $slides = this.data.groupInfo[this.data.currentYear].descUL.children("li");
        $thisSlide = $slides.eq(slide);
        $groupListLinks = this.data.groupInfo[this.data.currentYear].nav.children("a");
        $slides.hide();
        $thisSlide.show();
        this.data.personHeading.html($thisSlide.data("person"));
        $groupListLinks.removeClass('active');
        $groupListLinks.eq(slide).addClass('active');
        this.data.currentSlide = slide;
        if (slide === 0) {
          this.data.leftArrow.hide();
          this.data.rightArrow.show();
        } else if (slide === this.data.noSlides - 1) {
          this.data.leftArrow.show();
          this.data.rightArrow.hide();
        } else {
          this.data.leftArrow.show();
          this.data.rightArrow.show();
        }
        return this.data.groupInfo[this.data.currentYear].image.data("plugin_zoomImage").resize(animation);
      }
    };
    Plugin.prototype._prevYear = function() {
      if (this.data.currentYear !== 0) {
        return this._gotoYear(this.data.currentYear - 1, true);
      }
    };
    Plugin.prototype._nextYear = function() {
      if (this.data.currentYear < this.data.noYears - 1) {
        return this._gotoYear(this.data.currentYear + 1, true);
      }
    };
    Plugin.prototype._gotoYear = function(year, animation) {
      var descs, images, navs;
      if ((0 <= year && year < this.data.groupInfo.length)) {
        images = $();
        descs = $();
        navs = $();
        $.each(this.data.groupInfo, (function(_this) {
          return function(i) {
            images = images.add(_this.data.groupInfo[i].image);
            descs = descs.add(_this.data.groupInfo[i].descUL);
            return navs = navs.add(_this.data.groupInfo[i].nav);
          };
        })(this));
        images.add(descs).add(navs).hide();
        images.eq(year).show();
        descs.eq(year).show();
        navs.eq(year).show();
        if (!this.data.groupInfo[year].imageLoaded) {
          this.loadImage(year);
        }
        this.data.yearHeading.html(this.data.groupInfo[year].year);
        this.data.currentYear = year;
        this.data.noSlides = this.data.groupInfo[year].descUL.children("li").length;
        if (year === 0) {
          this.data.minusArrow.hide();
          this.data.plusArrow.show();
        } else if (year === this.data.noYears - 1) {
          this.data.minusArrow.show();
          this.data.plusArrow.hide();
        } else {
          this.data.minusArrow.show();
          this.data.plusArrow.show();
        }
        return this._goto(Math.floor((this.data.noSlides - 1) / 2), animation);
      }
    };
    Plugin.prototype.getXMargin = function(slide) {
      var farRight, imgWidth, parentWidth, xMargin;
      imgWidth = this.data.groupInfo[this.data.currentYear].image.width();
      parentWidth = $(this.element).width();
      farRight = -(imgWidth / parentWidth - 1) * 100;
      xMargin = 0 + farRight * slide / (this.data.noSlides - 1);
      return xMargin;
    };
    Plugin.prototype.loadImage = function(year) {
      var $image, src;
      $image = this.data.groupInfo[year].image;
      src = $image.data("original");
      $('<img />').one("load." + this._name, (function(_this) {
        return function() {
          return $image.attr("src", src);
        };
      })(this)).attr("src", src);
      return this.data.groupInfo[year].imageLoaded = true;
    };
    return $.fn[pluginName] = function(options) {
      return this.each(function() {
        if (!$.data(this, "plugin_" + pluginName)) {
          return $.data(this, "plugin_" + pluginName, new Plugin(this, options));
        }
      });
    };
  })(jQuery, window, document);

}).call(this);

(function() {
  (function($, window, document) {
    var Plugin, defaults, pluginName;
    pluginName = "slidesjs";
    defaults = {
      width: 940,
      height: 528,
      start: 1,
      zoom: false,
      navigation: {
        active: true,
        effect: "slide",
        rollover: true
      },
      pagination: {
        active: true,
        effect: "slide",
        generate: true
      },
      play: {
        active: false,
        generate: true,
        effect: "slide",
        interval: 5000,
        auto: false,
        swap: true,
        pauseOnHover: false,
        restartDelay: 2500
      },
      effect: {
        slide: {
          speed: 500
        },
        fade: {
          speed: 300,
          crossfade: true
        }
      },
      callback: {
        loaded: function() {},
        start: function() {},
        complete: function() {}
      },
      lazy: false
    };
    Plugin = (function() {
      function Plugin(element, options) {
        this.element = element;
        this.options = $.extend(true, {}, defaults, options);
        this._defaults = defaults;
        this._name = pluginName;
        this.init();
      }

      return Plugin;

    })();
    Plugin.prototype.init = function() {
      var $element, nextButton, pagination, paginationLIs, playButton, prevButton, stopButton;
      $element = $(this.element);
      this.data = $.data(this);
      $.data(this, "animating", false);
      $.data(this, "total", $element.children().not(".slidesjs-navigation", $element).length);
      $.data(this, "current", this.options.start - 1);
      $.data(this, "vendorPrefix", this._getVendorPrefix());
      if (typeof TouchEvent !== "undefined") {
        $.data(this, "touch", true);
        this.options.effect.slide.speed = this.options.effect.slide.speed / 2;
      }
      $element.css({
        overflow: "hidden"
      });
      $element.slidesContainer = $element.children().not(".slidesjs-navigation", $element).wrapAll("<div class='slidesjs-container'>", $element).parent().css({
        overflow: "hidden",
        position: "relative"
      });
      $(".slidesjs-container", $element).wrapInner("<div class='slidesjs-control'>", $element).children();
      $(".slidesjs-control", $element).css({
        position: "relative",
        left: 0
      });
      $(".slidesjs-control", $element).children().addClass("slidesjs-slide").css({
        position: "absolute",
        top: 0,
        left: 0,
        width: "100%",
        zIndex: 0,
        display: "none",
        webkitBackfaceVisibility: "hidden"
      });
      $.each($(".slidesjs-control", $element).children(), function(i) {
        var $slide;
        $slide = $(this);
        return $slide.attr("slidesjs-index", i);
      });
      if (this.data.touch) {
        $(".slidesjs-control", $element).on("touchstart", (function(_this) {
          return function(e) {
            return _this._touchstart(e);
          };
        })(this));
        $(".slidesjs-control", $element).on("touchmove", (function(_this) {
          return function(e) {
            return _this._touchmove(e);
          };
        })(this));
        $(".slidesjs-control", $element).on("touchend", (function(_this) {
          return function(e) {
            return _this._touchend(e);
          };
        })(this));
      }
      $element.fadeIn(0);
      this.update();
      if (this.options.zoom) {
        this._zoom();
      }
      if (this.data.touch) {
        this._setuptouch();
      }
      $(".slidesjs-control", $element).children(":eq(" + this.data.current + ")").eq(0).fadeIn(0, function() {
        return $(this).css({
          zIndex: 10
        });
      });
      if (this.options.navigation.active) {
        prevButton = $("<a>", {
          "class": "slidesjs-previous slidesjs-navigation",
          href: "#",
          title: "Previous",
          text: "Previous"
        }).appendTo($element);
        nextButton = $("<a>", {
          "class": "slidesjs-next slidesjs-navigation",
          href: "#",
          title: "Next",
          text: "Next"
        }).appendTo($element);
      }
      $(".slidesjs-next", $element).click((function(_this) {
        return function(e) {
          e.preventDefault();
          _this.stop(true);
          return _this.next(_this.options.navigation.effect);
        };
      })(this));
      $(".slidesjs-previous", $element).click((function(_this) {
        return function(e) {
          e.preventDefault();
          _this.stop(true);
          return _this.previous(_this.options.navigation.effect);
        };
      })(this));
      if (this.options.play.active) {
        if (this.options.play.generate) {
          playButton = $("<a>", {
            "class": "slidesjs-play slidesjs-navigation",
            href: "#",
            title: "Play",
            text: "Play"
          }).appendTo($element);
          stopButton = $("<a>", {
            "class": "slidesjs-stop slidesjs-navigation",
            href: "#",
            title: "Stop",
            text: "Stop"
          }).appendTo($element);
        } else {
          playButton = $(".slidesjs-play.slidesjs-navigation", $element);
          stopButton = $(".slidesjs-stop.slidesjs-navigation", $element);
        }
        playButton.click((function(_this) {
          return function(e) {
            e.preventDefault();
            return _this.play(true);
          };
        })(this));
        stopButton.click((function(_this) {
          return function(e) {
            e.preventDefault();
            return _this.stop(true);
          };
        })(this));
        if (this.options.play.swap) {
          stopButton.css({
            display: "none"
          });
        }
      }
      if (this.options.pagination.active) {
        if (this.options.pagination.generate) {
          pagination = $("<ul>", {
            "class": "slidesjs-pagination"
          }).appendTo($element);
          $.each(new Array(this.data.total), (function(_this) {
            return function(i) {
              var paginationItem, paginationLink;
              paginationItem = $("<li>", {
                "class": "slidesjs-pagination-item"
              }).appendTo(pagination);
              paginationLink = $("<a>", {
                href: "#",
                "data-slidesjs-item": i,
                html: i + 1
              }).appendTo(paginationItem);
              return paginationLink.click(function(e) {
                e.preventDefault();
                _this.stop(true);
                return _this.goto(($(e.currentTarget).attr("data-slidesjs-item") * 1) + 1);
              });
            };
          })(this));
        } else {
          paginationLIs = $('.slidesjs-pagination li', $element);
          paginationLIs.each((function(_this) {
            return function(i) {
              return paginationLIs.eq(i).data("slidesjs-item", i).click(function(e) {
                e.preventDefault();
                _this.stop(true);
                return _this.goto(($(e.currentTarget).data("slidesjs-item") * 1) + 1);
              });
            };
          })(this));
        }
      }
      if (this.options.lazy) {
        $("img.slidesjs-slide, .slidesjs-slide img:first-of-type", $element).each(function() {
          if (this.src === "") {
            return this.src = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsQAAA7EAZUrDhsAAAANSURBVBhXYzh8+PB/AAffA0nNPuCLAAAAAElFTkSuQmCC";
          }
        });
      }
      $(window).bind("resize", (function(_this) {
        return function() {
          return _this.update();
        };
      })(this));
      this._setActive();
      if (this.options.play.auto) {
        this.play();
      }
      if (!this.options.navigation.rollover) {
        this._hideNavArrows();
      }
      return this.options.callback.loaded(this.options.start);
    };
    Plugin.prototype._setActive = function(number) {
      var $element, $img, $slide, current, src;
      $element = $(this.element);
      this.data = $.data(this);
      current = number > -1 ? number : this.data.current;
      $(".active", $element).removeClass("active");
      $(".slidesjs-pagination li:eq(" + current + ") a", $element).addClass("active");
      if (this.options.lazy) {
        $slide = $(".slidesjs-control", $element).children().eq(current);
        $img = $slide.is("img") ? $slide : $slide.find("img:first");
        if (!$img.data("loaded")) {
          src = $img.data("original");
          $('<img />').one("load." + this._name, (function(_this) {
            return function() {
              return $img.attr("src", src);
            };
          })(this)).attr("src", src);
          return $img.data("loaded", true);
        }
      }
    };
    Plugin.prototype._zoom = function() {
      var $element, img, targetRatio;
      $element = $(this.element);
      this.data = $.data(this);
      targetRatio = this.options.width / this.options.height;
      $(".slidesjs-control", $element).children("div").css({
        width: "100%",
        height: "100%"
      });
      img = $(".slidesjs-control", $element).find("img, div img:first");
      return img.each(function() {
        $(this).on("load", function() {
          var $img, imgHeight, imgRatio, imgWidth, overflow;
          $img = $(this);
          imgWidth = this.naturalWidth;
          imgHeight = this.naturalHeight;
          imgRatio = imgWidth / imgHeight;
          $img.css({
            "max-width": "none",
            "max-height": "none"
          });
          if (imgRatio > targetRatio) {
            overflow = (imgRatio / targetRatio - 1) * 100 / 2;
            return $img.css({
              height: "100%",
              width: "auto",
              margin: "0 0 0 -" + overflow + "%"
            });
          } else {
            overflow = (1 / imgRatio - 1 / targetRatio) * 100 / 2;
            return $img.css({
              height: "auto",
              width: "100%",
              margin: "-" + overflow + "% 0 0 0"
            });
          }
        });
        if (this.complete || this.naturalWidth !== 0) {
          return $(this).trigger("load");
        }
      });
    };
    Plugin.prototype.resize = function(width, height) {
      this.options.width = width;
      this.options.height = height;
      this.update();
      if (this.options.zoom) {
        return this._zoom();
      }
    };
    Plugin.prototype.update = function() {
      var $element, height, width;
      $element = $(this.element);
      this.data = $.data(this);
      $(".slidesjs-control", $element).children(":not(:eq(" + this.data.current + "))").css({
        display: "none",
        left: 0,
        zIndex: 0
      });
      width = $element.width();
      height = (this.options.height / this.options.width) * width;
      this.options.width = width;
      this.options.height = height;
      return $(".slidesjs-control, .slidesjs-container", $element).css({
        width: width,
        height: height
      });
    };
    Plugin.prototype.next = function(effect) {
      var $element;
      $element = $(this.element);
      this.data = $.data(this);
      $.data(this, "direction", "next");
      if (effect === void 0) {
        effect = this.options.navigation.effect;
      }
      if (effect === "fade") {
        return this._fade();
      } else {
        return this._slide();
      }
    };
    Plugin.prototype.previous = function(effect) {
      var $element;
      $element = $(this.element);
      this.data = $.data(this);
      $.data(this, "direction", "previous");
      if (effect === void 0) {
        effect = this.options.navigation.effect;
      }
      if (effect === "fade") {
        return this._fade();
      } else {
        return this._slide();
      }
    };
    Plugin.prototype.goto = function(number) {
      var $element, effect;
      $element = $(this.element);
      this.data = $.data(this);
      if (effect === void 0) {
        effect = this.options.pagination.effect;
      }
      if (number > this.data.total) {
        number = this.data.total;
      } else if (number < 1) {
        number = 1;
      }
      if (typeof number === "number") {
        if (effect === "fade") {
          return this._fade(number);
        } else {
          return this._slide(number);
        }
      } else if (typeof number === "string") {
        if (number === "first") {
          if (effect === "fade") {
            return this._fade(0);
          } else {
            return this._slide(0);
          }
        } else if (number === "last") {
          if (effect === "fade") {
            return this._fade(this.data.total);
          } else {
            return this._slide(this.data.total);
          }
        }
      }
    };
    Plugin.prototype._setuptouch = function() {
      var $element, next, previous, slidesControl;
      $element = $(this.element);
      this.data = $.data(this);
      slidesControl = $(".slidesjs-control", $element);
      next = this.data.current + 1;
      previous = this.data.current - 1;
      if (previous < 0) {
        previous = this.data.total - 1;
      }
      if (next > this.data.total - 1) {
        next = 0;
      }
      slidesControl.children(":eq(" + next + ")").css({
        display: "block",
        left: this.options.width
      });
      return slidesControl.children(":eq(" + previous + ")").css({
        display: "block",
        left: -this.options.width
      });
    };
    Plugin.prototype._touchstart = function(e) {
      var $element, touches;
      $element = $(this.element);
      this.data = $.data(this);
      touches = e.originalEvent.touches[0];
      this._setuptouch();
      $.data(this, "touchtimer", Number(new Date()));
      $.data(this, "touchstartx", touches.pageX);
      $.data(this, "touchstarty", touches.pageY);
      return e.stopPropagation();
    };
    Plugin.prototype._touchend = function(e) {
      var $element, duration, prefix, slidesControl, timing, touches, transform;
      $element = $(this.element);
      this.data = $.data(this);
      touches = e.originalEvent.touches[0];
      slidesControl = $(".slidesjs-control", $element);
      if ((slidesControl.position().left > this.options.width * 0.5 || slidesControl.position().left > this.options.width * 0.1 && (Number(new Date()) - this.data.touchtimer < 250)) && (this.data.current !== 0 || this.options.navigation.rollover)) {
        $.data(this, "direction", "previous");
        this._slide();
      } else if ((slidesControl.position().left < -(this.options.width * 0.5) || slidesControl.position().left < -(this.options.width * 0.1) && (Number(new Date()) - this.data.touchtimer < 250)) && (this.data.current !== this.data.total - 1 || this.options.navigation.rollover)) {
        $.data(this, "direction", "next");
        this._slide();
      } else {
        prefix = this.data.vendorPrefix;
        transform = prefix + "Transform";
        duration = prefix + "TransitionDuration";
        timing = prefix + "TransitionTimingFunction";
        slidesControl[0].style[transform] = "translateX(0px)";
        slidesControl[0].style[duration] = this.options.effect.slide.speed * 0.85 + "ms";
      }
      slidesControl.on("transitionend webkitTransitionEnd oTransitionEnd otransitionend MSTransitionEnd", (function(_this) {
        return function() {
          prefix = _this.data.vendorPrefix;
          transform = prefix + "Transform";
          duration = prefix + "TransitionDuration";
          timing = prefix + "TransitionTimingFunction";
          slidesControl[0].style[transform] = "";
          slidesControl[0].style[duration] = "";
          return slidesControl[0].style[timing] = "";
        };
      })(this));
      return e.stopPropagation();
    };
    Plugin.prototype._touchmove = function(e) {
      var $element, prefix, slidesControl, touches, transform;
      $element = $(this.element);
      this.data = $.data(this);
      touches = e.originalEvent.touches[0];
      prefix = this.data.vendorPrefix;
      slidesControl = $(".slidesjs-control", $element);
      transform = prefix + "Transform";
      $.data(this, "scrolling", Math.abs(touches.pageX - this.data.touchstartx) < Math.abs(touches.pageY - this.data.touchstarty));
      if (!this.data.animating && !this.data.scrolling) {
        e.preventDefault();
        this._setuptouch();
        slidesControl[0].style[transform] = "translateX(" + (touches.pageX - this.data.touchstartx) + "px)";
      }
      return e.stopPropagation();
    };
    Plugin.prototype.play = function(next) {
      var $element, currentSlide, slidesContainer;
      $element = $(this.element);
      this.data = $.data(this);
      if (!this.data.playInterval) {
        if (next) {
          currentSlide = this.data.current;
          this.data.direction = "next";
          if (this.options.play.effect === "fade") {
            this._fade();
          } else {
            this._slide();
          }
        }
        $.data(this, "playInterval", setInterval(((function(_this) {
          return function() {
            currentSlide = _this.data.current;
            _this.data.direction = "next";
            if (_this.options.play.effect === "fade") {
              return _this._fade();
            } else {
              return _this._slide();
            }
          };
        })(this)), this.options.play.interval));
        slidesContainer = $(".slidesjs-container", $element);
        if (this.options.play.pauseOnHover) {
          slidesContainer.unbind();
          slidesContainer.bind("mouseenter", (function(_this) {
            return function() {
              clearTimeout(_this.data.restartDelay);
              $.data(_this, "restartDelay", null);
              return _this.stop();
            };
          })(this));
          slidesContainer.bind("mouseleave", (function(_this) {
            return function() {
              if (_this.options.play.restartDelay) {
                return $.data(_this, "restartDelay", setTimeout((function() {
                  return _this.play(true);
                }), _this.options.play.restartDelay));
              } else {
                return _this.play();
              }
            };
          })(this));
        }
        $.data(this, "playing", true);
        $(".slidesjs-play", $element).addClass("slidesjs-playing");
        if (this.options.play.swap) {
          $(".slidesjs-play", $element).hide();
          return $(".slidesjs-stop", $element).show();
        }
      }
    };
    Plugin.prototype.stop = function(clicked) {
      var $element;
      $element = $(this.element);
      this.data = $.data(this);
      clearInterval(this.data.playInterval);
      if (this.options.play.pauseOnHover && clicked) {
        $(".slidesjs-container", $element).unbind();
      }
      $.data(this, "playInterval", null);
      $.data(this, "playing", false);
      $(".slidesjs-play", $element).removeClass("slidesjs-playing");
      if (this.options.play.swap) {
        $(".slidesjs-stop", $element).hide();
        return $(".slidesjs-play", $element).show();
      }
    };
    Plugin.prototype._slide = function(number) {
      var $element, currentSlide, direction, duration, next, prefix, slidesControl, timing, transform, value;
      $element = $(this.element);
      this.data = $.data(this);
      if (!this.data.animating && number !== this.data.current + 1) {
        $.data(this, "animating", true);
        currentSlide = this.data.current;
        if (number > -1) {
          number = number - 1;
          value = number > currentSlide ? 1 : -1;
          direction = number > currentSlide ? -this.options.width : this.options.width;
          next = number;
        } else {
          value = this.data.direction === "next" ? 1 : -1;
          direction = this.data.direction === "next" ? -this.options.width : this.options.width;
          next = currentSlide + value;
        }
        if (next === -1) {
          next = this.data.total - 1;
        }
        if (next === this.data.total) {
          next = 0;
        }
        this._setActive(next);
        slidesControl = $(".slidesjs-control", $element);
        if (number > -1) {
          slidesControl.children(":not(:eq(" + currentSlide + "))").css({
            display: "none",
            left: 0,
            zIndex: 0
          });
        }
        slidesControl.children(":eq(" + next + ")").css({
          display: "block",
          left: value * this.options.width,
          zIndex: 10
        });
        this.options.callback.start(currentSlide + 1);
        if (this.data.vendorPrefix) {
          prefix = this.data.vendorPrefix;
          transform = prefix + "Transform";
          duration = prefix + "TransitionDuration";
          timing = prefix + "TransitionTimingFunction";
          slidesControl[0].style[transform] = "translateX(" + direction + "px)";
          slidesControl[0].style[duration] = this.options.effect.slide.speed + "ms";
          return slidesControl.on("transitionend webkitTransitionEnd oTransitionEnd otransitionend MSTransitionEnd", (function(_this) {
            return function() {
              slidesControl[0].style[transform] = "";
              slidesControl[0].style[duration] = "";
              slidesControl.children(":eq(" + next + ")").css({
                left: 0
              });
              slidesControl.children(":eq(" + currentSlide + ")").css({
                display: "none",
                left: 0,
                zIndex: 0
              });
              $.data(_this, "current", next);
              $.data(_this, "animating", false);
              slidesControl.unbind("transitionend webkitTransitionEnd oTransitionEnd otransitionend MSTransitionEnd");
              slidesControl.children(":not(:eq(" + next + "))").css({
                display: "none",
                left: 0,
                zIndex: 0
              });
              if (!_this.options.navigation.rollover) {
                _this._hideNavArrows();
              }
              if (_this.data.touch) {
                _this._setuptouch();
              }
              return _this.options.callback.complete(next + 1);
            };
          })(this));
        } else {
          return slidesControl.stop().animate({
            left: direction
          }, this.options.effect.slide.speed, ((function(_this) {
            return function() {
              slidesControl.css({
                left: 0
              });
              slidesControl.children(":eq(" + next + ")").css({
                left: 0
              });
              return slidesControl.children(":eq(" + currentSlide + ")").css({
                display: "none",
                left: 0,
                zIndex: 0
              }, $.data(_this, "current", next), !_this.options.navigation.rollover ? _this._hideNavArrows() : void 0, $.data(_this, "animating", false), _this.options.callback.complete(next + 1));
            };
          })(this)));
        }
      }
    };
    Plugin.prototype._fade = function(number) {
      var $element, currentSlide, next, slidesControl, value;
      $element = $(this.element);
      this.data = $.data(this);
      if (!this.data.animating && number !== this.data.current + 1) {
        $.data(this, "animating", true);
        currentSlide = this.data.current;
        if (number) {
          number = number - 1;
          value = number > currentSlide ? 1 : -1;
          next = number;
        } else {
          value = this.data.direction === "next" ? 1 : -1;
          next = currentSlide + value;
        }
        if (next === -1) {
          next = this.data.total - 1;
        }
        if (next === this.data.total) {
          next = 0;
        }
        this._setActive(next);
        slidesControl = $(".slidesjs-control", $element);
        slidesControl.children(":eq(" + next + ")").css({
          display: "none",
          left: 0,
          zIndex: 10
        });
        this.options.callback.start(currentSlide + 1);
        if (this.options.effect.fade.crossfade) {
          slidesControl.children(":eq(" + this.data.current + ")").stop().fadeOut(this.options.effect.fade.speed);
          return slidesControl.children(":eq(" + next + ")").stop().fadeIn(this.options.effect.fade.speed, ((function(_this) {
            return function() {
              slidesControl.children(":eq(" + next + ")").css({
                zIndex: 0
              });
              $.data(_this, "animating", false);
              $.data(_this, "current", next);
              if (!_this.options.navigation.rollover) {
                _this._hideNavArrows();
              }
              return _this.options.callback.complete(next + 1);
            };
          })(this)));
        } else {
          return slidesControl.children(":eq(" + currentSlide + ")").stop().fadeOut(this.options.effect.fade.speed, ((function(_this) {
            return function() {
              slidesControl.children(":eq(" + next + ")").stop().fadeIn(_this.options.effect.fade.speed, (function() {
                return slidesControl.children(":eq(" + next + ")").css({
                  zIndex: 10
                });
              }));
              $.data(_this, "animating", false);
              $.data(_this, "current", next);
              if (!_this.options.navigation.rollover) {
                _this._hideNavArrows();
              }
              return _this.options.callback.complete(next + 1);
            };
          })(this)));
        }
      }
    };
    Plugin.prototype._hideNavArrows = function() {
      var $element, leftArrow, rightArrow;
      $element = $(this.element);
      leftArrow = $(".slidesjs-previous", $element);
      rightArrow = $(".slidesjs-next", $element);
      if (this.data.current === 0) {
        leftArrow.hide();
        return rightArrow.show();
      } else if (this.data.current === this.data.total - 1) {
        rightArrow.hide();
        return leftArrow.show();
      } else {
        rightArrow.show();
        return leftArrow.show();
      }
    };
    Plugin.prototype._getVendorPrefix = function() {
      var body, i, style, transition, vendor;
      body = document.body || document.documentElement;
      style = body.style;
      transition = "transition";
      vendor = ["Moz", "Webkit", "Khtml", "O", "ms"];
      transition = transition.charAt(0).toUpperCase() + transition.substr(1);
      i = 0;
      while (i < vendor.length) {
        if (typeof style[vendor[i] + transition] === "string") {
          return vendor[i];
        }
        i++;
      }
      return false;
    };
    return $.fn[pluginName] = function(options) {
      return this.each(function() {
        if (!$.data(this, "plugin_" + pluginName)) {
          return $.data(this, "plugin_" + pluginName, new Plugin(this, options));
        }
      });
    };
  })(jQuery, window, document);

}).call(this);

(function() {
  (function($, window, document) {
    var Plugin, data, defaults, pluginName;
    pluginName = "tabGroups";
    defaults = {
      links: null,
      tabs: null
    };
    data = {
      links: null,
      tabs: null
    };
    Plugin = (function() {
      function Plugin(element, options) {
        this.element = element;
        this.settings = $.extend({}, defaults, options);
        this._defaults = defaults;
        this._name = pluginName;
        this.data = $.extend({}, data);
        this.init();
      }

      Plugin.prototype.init = function() {
        var $element, clickHandler, i, theLink, _ref, _ref1, _results;
        $element = $(this.element);
        this.data.links = (_ref = this.settings.links) != null ? _ref : $element.find(".tabmenu a");
        this.data.tabs = (_ref1 = this.settings.tabs) != null ? _ref1 : $element.find(".tabs .tab");
        this.data.links.click(function() {
          return false;
        });
        this.showTab(this.data.links.first(), this.data.tabs.first());
        clickHandler = (function(_this) {
          return function(e) {
            var clickedLink;
            clickedLink = $(e.target);
            _this.showTab(clickedLink, clickedLink.data("" + pluginName + "_myTab"));
            return false;
          };
        })(this);
        i = 0;
        _results = [];
        while (this.data.links.size() > i && this.data.tabs.size() > i) {
          theLink = this.data.links.eq(i);
          theLink.data("" + pluginName + "_myTab", this.data.tabs.eq(i));
          theLink.click(clickHandler);
          _results.push(i++);
        }
        return _results;
      };

      return Plugin;

    })();
    Plugin.prototype.showTab = function(link, tab) {
      this.data.links.removeClass('active');
      this.data.tabs.removeClass('active');
      link.addClass('active');
      return tab.addClass('active');
    };
    return $.fn[pluginName] = function(options) {
      return this.each(function() {
        if (!$.data(this, "plugin_" + pluginName)) {
          return $.data(this, "plugin_" + pluginName, new Plugin(this, options));
        }
      });
    };
  })(jQuery, window, document);

}).call(this);

(function() {
  (function($, window, document) {
    var Plugin, data, defaults, pluginName;
    pluginName = "zoomImage";
    defaults = {
      active: true,
      parent: null,
      useMarginFunctions: false,
      getXOverride: function() {
        return null;
      },
      getYOverride: function() {
        return null;
      },
      resizeCallbackAfter: $.noop,
      xOverride: null,
      yOverride: null,
      animation: true,
      initialAnimation: false
    };
    data = {
      active: null,
      parent: null,
      parentWidth: null,
      parentHeight: null,
      targetRatio: null,
      imgWidth: null,
      imgHeight: null,
      imgRatio: null
    };
    Plugin = (function() {
      function Plugin(element, options) {
        this.element = element;
        this.options = $.extend(true, {}, defaults, options);
        this._defaults = defaults;
        this._name = pluginName;
        this.data = data;
        this.init();
      }

      return Plugin;

    })();
    Plugin.prototype.init = function() {
      var $element;
      $element = $(this.element);
      this.data = $.data(this);
      if (!$(window).data("" + this._name + "_zoomedElements")) {
        $(window).data("" + this._name + "_zoomedElements", $([]));
      }
      $(window).data("" + this._name + "_zoomedElements", $(window).data("" + this._name + "_zoomedElements").add($element));
      if (this.options.parent) {
        this.data.parent = $(this.options.parent);
      } else {
        this.data.parent = $element.parent();
      }
      this.data.active = this.options.active;
      if (this.data.active) {
        this._setupStyles();
      }
      $element.on("load." + this._name, (function(_this) {
        return function() {
          $element = $(_this.element);
          $element.show();
          _this.data.imgWidth = _this.element.naturalWidth;
          _this.data.imgHeight = _this.element.naturalHeight;
          _this.data.imgRatio = _this.data.imgWidth / _this.data.imgHeight;
          _this.refresh();
          return _this.resize(false);
        };
      })(this));
      if (this.element.complete || this.element.naturalWidth !== 0) {
        $element.trigger("load");
      }
      return $(window).on("resize." + this._name, (function(_this) {
        return function() {
          _this.refresh();
          return _this.resize(false);
        };
      })(this));
    };
    Plugin.prototype.setActive = function(callback) {
      this.data.active = true;
      this._setupStyles();
      this.refresh();
      this.resize(this.options.initialAnimation);
      if (callback != null) {
        return callback();
      }
    };
    Plugin.prototype.setInactive = function(callback) {
      var $element;
      $element = $(this.element);
      this.data.active = false;
      this._removeStyles();
      $element.css({
        height: "",
        width: "",
        "margin-top": "",
        "margin-right": "",
        "margin-bottom": "",
        "margin-left": ""
      });
      if (callback != null) {
        return callback();
      }
    };
    Plugin.prototype.toggleActive = function(callback) {
      if (this.data.active) {
        return this.setInactive(callback);
      } else {
        return this.setActive(callback);
      }
    };
    Plugin.prototype._setupStyles = function() {
      var $element;
      $element = $(this.element);
      if (this.data.parent.css("position") === "static") {
        this.data.parent.css("position", 'relative');
      }
      this.data.parent.css("overflow", "hidden");
      $element.css("position", "absolute");
      return $element.css({
        "max-width": "none",
        "max-height": "none"
      });
    };
    Plugin.prototype._removeStyles = function() {
      var $element;
      $element = $(this.element);
      this.data.parent.css({
        "position": "",
        "overflow": ""
      });
      return $element.css({
        "position": "",
        "max-width": "",
        "max-height": ""
      });
    };
    Plugin.prototype.refresh = function() {
      var $element;
      $element = $(this.element);
      this.data.parentWidth = this.data.parent.width();
      this.data.parentHeight = this.data.parent.height();
      this.data.targetRatio = this.data.parentWidth / this.data.parentHeight;
      return this;
    };
    Plugin.prototype.resize = function(animation) {
      var $element, overflow;
      $element = $(this.element);
      if (!this.data.active) {
        return false;
      }
      if (this.options.useMarginFunctions) {
        this.options.xOverride = this.options.getXOverride();
        this.options.yOverride = this.options.getYOverride();
      }
      if (animation && this.options.animation) {
        this._transitions("add");
      }
      if (this.data.imgRatio > this.data.targetRatio) {
        if (typeof this.options.xOverride === "number") {
          overflow = this.options.xOverride;
        } else {
          overflow = -(this.data.imgRatio / this.data.targetRatio - 1) * 100 / 2;
        }
        $element.css({
          height: "100%",
          width: "auto",
          margin: "0 0 0 " + overflow + "%"
        });
      } else {
        if (typeof this.options.yOverride === "number") {
          overflow = this.options.yOverride;
        } else {
          overflow = -(1 / this.data.imgRatio - 1 / this.data.targetRatio) * 100 / 2;
        }
        $element.css({
          height: "auto",
          width: "100%",
          margin: overflow + "% 0 0 0"
        });
      }
      if (animation && this.options.animation) {
        $element.one("transitionend webkitTransitionEnd oTransitionEnd otransitionend MSTransitionEnd", (function(_this) {
          return function() {
            _this._transitions("remove");
            return _this.options.resizeCallbackAfter(_this.element);
          };
        })(this));
      } else {
        this.options.resizeCallbackAfter(this.element);
      }
      return this;
    };
    Plugin.prototype._transitions = function(option) {
      var $element;
      $element = $(this.element);
      if (option === "add") {
        $element.css({
          "-webkit-transition": "margin 0.25s ease-in-out",
          "-moz-transition": "margin 0.25s ease-in-out",
          "-o-transition": "margin 0.25s ease-in-out",
          "transition": "margin 0.25s ease-in-out"
        });
      } else if (option = "remove") {
        $element.css({
          "-webkit-transition": "",
          "-moz-transition": "",
          "-o-transition": "",
          "transition": ""
        });
      }
      return setTimeout(function() {
        return this;
      });
    };
    Plugin.prototype.yOverride = function(yOverride) {
      this.options.yOverride = yOverride;
      return this.resize(true);
    };
    Plugin.prototype.xOverride = function(xOverride) {
      this.options.xOverride = xOverride;
      return this.resize(true);
    };
    Plugin.prototype.update = function() {
      this.refresh();
      return this.resize(false);
    };
    $[pluginName] = {
      updateAll: function() {
        var $globalList;
        if ($(window).data("" + pluginName + "_zoomedElements")) {
          $globalList = $(window).data("" + pluginName + "_zoomedElements");
        }
        if ($globalList) {
          return $globalList.each(function() {
            return $(this)["" + pluginName + ".update"]();
          });
        }
      }
    };
    $.fn[pluginName] = function(options) {
      return this.each(function() {
        if (!$.data(this, "plugin_" + pluginName)) {
          return $.data(this, "plugin_" + pluginName, new Plugin(this, options));
        }
      });
    };
    return $.fn["" + pluginName + ".update"] = function() {
      return this.each(function() {
        if ($.data(this, "plugin_" + pluginName)) {
          return $.data(this, "plugin_" + pluginName).update();
        }
      });
    };
  })(jQuery, window, document);

}).call(this);

(function() {
  var $menubar, $mobilebar, $moreButtonA, $moreButtonI, delta, initSkrollr, mobileThreshold, refreshSkrollr, scrollTo, slideHeight, slideHeightMobile, slideWidth, toggleMenu;

  window.joseURL = "";

  initSkrollr = function() {};

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
