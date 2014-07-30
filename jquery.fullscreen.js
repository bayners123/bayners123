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
      resizeCallback: $.noop
    };
    data = {
      vendorPrefix: null,
      originalHeight: null,
      originalWidth: null,
      animating: false,
      hasFocus: false
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
      this.data.vendorPrefix = this._getVendorPrefix();
      this._getDims();
      $(window).resize((function(_this) {
        return function() {
          _this.check();
          if (_this.data.hasFocus) {
            return _this._scrollTo(false);
          }
        };
      })(this));
      $((function(_this) {
        return function() {
          return _this.check();
        };
      })(this));
      if (this.options.scrollCapture) {
        $(this.options.parentElement).scroll((function(_this) {
          return function() {
            clearTimeout($.data(window, 'scrollTimer'));
            return $.data(window, 'scrollTimer', setTimeout(function() {
              return _this._checkScroll();
            }, 500));
          };
        })(this));
      }
      $(this.options.parentElement).scroll((function(_this) {
        return function() {
          var $element, elementPos, scrollPos;
          $element = $(_this.element);
          if ($element.hasClass(_this.options.activeClass) && !_this.data.animating) {
            elementPos = _this.element.offsetTop;
            scrollPos = $(_this.options.parentElement).scrollTop();
            if (elementPos + _this.options.offset - _this.options.lostFocusRange > scrollPos || scrollPos > elementPos + _this.options.offset + _this.options.lostFocusRange) {
              if (_this.options.shrinkOnLostFocus) {
                if (scrollPos > elementPos + _this.options.offset + _this.options.lostFocusRange) {
                  _this.data.autoShrinking = true;
                }
                _this.setInactive();
              }
              _this.data.hasFocus = false;
              return _this.options.lostFocusCallback(_this.element);
            }
          }
        };
      })(this));
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
    Plugin.prototype.setActive = function() {
      $(this.element).addClass(this.options.activeClass);
      this._resizeToFull();
      this._scrollTo(true);
      return this;
    };
    Plugin.prototype.setInactive = function() {
      $(this.element).removeClass(this.options.activeClass);
      this._removeStyles();
      return this;
    };
    Plugin.prototype.toggleActive = function() {
      var $element;
      $element = $(this.element);
      if ($element.hasClass(this.options.activeClass)) {
        this.setInactive();
      } else {
        this.setActive();
      }
      return this;
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
    Plugin.prototype._resizeToFull = function() {
      var $element, targetHeight, targetWidth;
      $element = $(this.element);
      targetHeight = $(this.options.parentElement).get(0).innerHeight;
      targetWidth = $(this.options.parentElement).get(0).innerWidth;
      if (!this.options.animation || this.data.hasFocus) {
        $element.css({
          height: targetHeight,
          width: targetWidth
        });
      } else {
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
            return _this.options.resizeCallback(_this.element);
          };
        })(this));
      }
      return this;
    };
    Plugin.prototype._removeStyles = function() {
      var $element, targetHeight, targetWidth;
      $element = $(this.element);
      this.data.hasFocus = false;
      if (!this.options.animation) {
        $element.css({
          height: "",
          width: ""
        });
      } else {
        this.data.animating = true;
        targetHeight = this.data.originalHeight;
        targetWidth = this.data.originalWidth;
        this.element.style[this.data.vendorPrefix + "Transition"] = "height " + this.options.animationDuration + " ease-in-out";
        setTimeout((function(_this) {
          return function() {
            var elementBottom;
            $element.css({
              height: targetHeight,
              width: targetWidth
            });
            if (_this.data.autoShrinking) {
              elementBottom = _this.element.offsetTop + _this.data.originalHeight;
              if ($(_this.options.parentElement).get(0) === window) {
                $('html, body').animate({
                  scrollTop: elementBottom
                }, 300);
              } else {
                $(_this.options.parentElement).animate({
                  scrollTop: elementBottom
                }, 300);
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
