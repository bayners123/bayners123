(function() {
  (function($, window, document) {
    var Plugin, data, defaults, pluginName;
    pluginName = "groupScroller";
    defaults = {
      leftArrow: null,
      rightArrow: null,
      personHeading: null,
      slideImg: null,
      descUL: null,
      first: 0
    };
    data = {
      leftArrow: null,
      rightArrow: null,
      personHeading: null,
      slideImg: null,
      descUL: null,
      currentSlide: null,
      noSlides: null,
      groupListLinks: null
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
      if (this.options.leftArrow) {
        this.data.leftArrow = $(this.options.leftArrow);
      } else {
        this.data.leftArrow = $element.find(".arrow.left");
      }
      if (this.options.rightArrow) {
        this.data.rightArrow = $(this.options.rightArrow);
      } else {
        this.data.rightArrow = $element.find(".arrow.right");
      }
      if (this.options.personHeading) {
        this.data.personHeading = $(this.options.personHeading);
      } else {
        this.data.personHeading = $element.find(".person");
      }
      if (this.options.slideImg) {
        this.data.slideImg = $(this.options.slideImg);
      } else {
        this.data.slideImg = $element.find(".slideImg");
      }
      if (this.options.descUL) {
        this.data.descUL = $(this.options.descUL);
      } else {
        this.data.descUL = $element.find(".desc");
      }
      if (this.options.groupListLinks) {
        this.data.groupListLinks = $(this.options.groupListLinks);
      } else {
        this.data.groupListLinks = $element.find(".groupList a");
      }
      this.data.noSlides = this.data.descUL.children("li").length;
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
      this.data.groupListLinks.click((function(_this) {
        return function(e) {
          var clickedLink;
          clickedLink = e.target;
          e.preventDefault();
          return _this._goto(_this.data.groupListLinks.index(clickedLink), true);
        };
      })(this));
      return $((function(_this) {
        return function() {
          _this.data.slideImg.zoomImage({
            resizeCallbackAfter: function() {
              if (typeof skrollr !== "undefined" && skrollr !== null) {
                if (skrollr.get()) {
                  return skrollr.get().refresh();
                }
              }
            },
            useMarginFunctions: true,
            initialAnimation: false,
            getXOverride: function() {
              return _this.getXMargin(_this.data.currentSlide);
            }
          });
          return _this._goto(_this.options.first, false);
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
      var $slides, $thisSlide;
      if (slide < this.data.noSlides) {
        $slides = this.data.descUL.children("li");
        $thisSlide = $slides.eq(slide);
        $slides.hide();
        $thisSlide.show();
        this.data.personHeading.html($thisSlide.data("person"));
        this.data.currentSlide = slide;
        return this.data.slideImg.data("plugin_zoomImage").resize(animation);
      }
    };
    Plugin.prototype.getXMargin = function(slide) {
      var farRight, imgWidth, parentWidth, xMargin;
      imgWidth = this.data.slideImg.width();
      parentWidth = $(this.element).width();
      farRight = -(imgWidth / parentWidth - 1) * 100;
      xMargin = 0 + farRight * slide / (this.data.noSlides - 1);
      return xMargin;
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
