// Manually compiled and inserted
(function() {
  Modernizr.load({
    test: Modernizr.touch,
    nope: 'skrollr.min.js',
    complete: function() {
      var menubar;
      menubar = document.getElementById('menubar');
      return menubar.style.top = "100%";
    }
  });

  Modernizr.load({
    load: ['//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js', 'jquery.slides.js'],
    complete: function() {
      var mobileThreshold, slideHeight, slideHeightMobile, slideWidth;
      if (!window.jQuery) {
        Modernizr.load('jquery.min.js');
      }
      $('#mobileBar #moreButton').click(function(event) {
        var $menubar, $morebutton;
        event.preventDefault();
        $menubar = $('#menubar');
        $morebutton = $('#mobileBar #morebutton i');
        if ($menubar.is(':visible')) {
          $menubar.slideUp();
          return $morebutton.removeClass("fa-angle-double-up").addClass("fa-angle-double-down");
        } else {
          $menubar.slideDown();
          return $morebutton.removeClass("fa-angle-double-down").addClass("fa-angle-double-up");
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
          navigation: false
        });
        if (!Modernizr.touch) {
          return skrollr.init({
            smoothScrolling: false
          });
        }
      });
      return $(window).resize(function() {
        var mobileMode;
        mobileMode = $("#slider").data("plugin_slidesjs").options.width / $("#slider").data("plugin_slidesjs").options.height === slideWidth / slideHeightMobile;
        if (mobileMode && $(this).width() > mobileThreshold) {
          return $("#slider").data("plugin_slidesjs").resize(slideWidth, slideHeight);
        } else if ($(this).width() < mobileThreshold && !mobileMode) {
          return $("#slider").data("plugin_slidesjs").resize(slideWidth, slideHeightMobile);
        }
      });
    }
  });

}).call(this);
