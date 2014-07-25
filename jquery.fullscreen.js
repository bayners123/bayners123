(function() {
  (function($, window, document) {
    var Plugin, defaults, pluginName;
    pluginName = "fullscreen";
    defaults = {
      activeClass: "jqueryfullscreen_active",
      scrollCapture: true,
      scrollCaptureRange: 100,
      scrollOffset: 0,
      scrollCallback: $.noop,
      parentElement: window
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
      $(this.options.parentElement).resize((function(_this) {
        return function() {
          return _this.check();
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
      return this;
    };
    Plugin.prototype.check = function() {
      var $element;
      $element = $(this.element);
      if ($element.hasClass(this.options.activeClass)) {
        this._resizeToFull();
      } else {
        this._removeStyles();
      }
      return this;
    };
    Plugin.prototype._resizeToFull = function() {
      var $element, height, width;
      $element = $(this.element);
      height = $(this.options.parentElement).get(0).innerHeight;
      width = $(this.options.parentElement).get(0).innerWidth;
      $element.css({
        height: height,
        width: width
      });
      return this;
    };
    Plugin.prototype.setActive = function() {
      $(this.element).addClass(this.options.activeClass);
      this.check();
      this._scrollTo();
      return this;
    };
    Plugin.prototype.setInactive = function() {
      $(this.element).removeClass(this.options.activeClass);
      this.check();
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
    Plugin.prototype._removeStyles = function() {
      var $element;
      $element = $(this.element);
      $element.css({
        height: "",
        width: ""
      });
      return this;
    };
    Plugin.prototype._checkScroll = function() {
      var elementPos, scrollPos;
      elementPos = this.element.offsetTop;
      scrollPos = $(this.options.parentElement).scrollTop();
      if ($(this.element).hasClass(this.options.activeClass) && elementPos + this.options.scrollOffset - this.options.scrollCaptureRange < scrollPos && scrollPos < elementPos + this.options.scrollOffset + this.options.scrollCaptureRange) {
        this._scrollTo();
      }
      return this;
    };
    Plugin.prototype._scrollTo = function() {
      var elementPos;
      elementPos = this.element.offsetTop;
      if ($(this.options.parentElement).get(0) === window) {
        $('html, body').animate({
          scrollTop: elementPos + this.options.scrollOffset
        }, 300);
      } else {
        $(this.options.parentElement).animate({
          scrollTop: elementPos + this.options.scrollOffset
        }, 300);
      }
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
