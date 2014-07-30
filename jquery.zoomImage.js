(function() {
  (function($, window, document) {
    var Plugin, data, defaults, pluginName;
    pluginName = "zoomImage";
    defaults = {
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
      animation: true
    };
    data = {
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
      if (this.data.parent.css("position") === "static") {
        this.data.parent.css("position", 'relative');
      }
      this.data.parent.css("overflow", "hidden");
      $element.css("position", "absolute");
      $element.css({
        "max-width": "none",
        "max-height": "none"
      });
      $element.one("load." + this._name, (function(_this) {
        return function() {
          $element = $(_this.element);
          _this.data.imgWidth = _this.element.width;
          _this.data.imgHeight = _this.element.height;
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
      console.log("Resize with animation? " + animation);
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
      console.log("Animations! " + option);
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
