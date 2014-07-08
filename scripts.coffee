---
---

# Load scripts depending on browser capabilities

# Load skrollr if we're not on a mobile, but don't initialise it yet
Modernizr.load
    test: Modernizr.touch,
    nope: 'skrollr.min.js'
    # If we're loading Skrollr, immediately move the menubar off the page since it will otherwise bounce around when skrollr loads
    complete: ->
        menubar = document.getElementById('menubar')
        menubar.style.top = "100%"


# # If we're on an ancient browser that doesn't support CSS media queries, add support
# Modernizr.load
#     test: Modernizr.mq,
#     nope: 'css3.mediaqueries.js'

Modernizr.load
    # Load jquery with a local fallback 
        load: ['//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js','jquery.slides.js']
        complete: ->
            if !window.jQuery
                Modernizr.load 'jquery.min.js'

    # ... then run code that depends on jQuery & slidesjs

        # Register the click event for the mobile menu
            $('#mobileBar #moreButton').click (event) ->
                event.preventDefault()

                $menubar = $('#menubar')
                $morebutton = $('#mobileBar #morebutton i')

                if $menubar.is(':visible')
                    $menubar.slideUp()
                    $morebutton
                        .removeClass("fa-angle-double-up")
                        .addClass("fa-angle-double-down")
                else
                    $menubar
                        .slideDown()
                    $morebutton
                        .removeClass("fa-angle-double-down")
                        .addClass("fa-angle-double-up")

            # Load constants for the slider
            slideWidth = $("#slider").data("aspectratio")
            slideHeight = 1
            slideHeightMobile = $("#slider").data("aspectratiomobile")
            mobileThreshold = 550

            # Bind init slider to doc. ready
            $ ->
                $("#slider")
                    .slidesjs
                        width: slideWidth,
                        height: if (screen.width < mobileThreshold ) then slideHeightMobile else slideHeight,
                        zoom: true,
                        navigation: false
                
                # Init skrollr if we're not on a mobile (after slider)
                if !Modernizr.touch
                    skrollr.init
                        smoothScrolling: false


            # Resize slider aspect ratio if the screen gets smaller (bind to window.resize event)
            $(window).resize ->

                mobileMode = $("#slider").data("plugin_slidesjs").options.width / $("#slider").data("plugin_slidesjs").options.height == slideWidth / slideHeightMobile

                # If it's currently in mobile mode & we changed to normal mode:
                if mobileMode && $(@).width() > mobileThreshold
                    $("#slider").data("plugin_slidesjs").resize slideWidth, slideHeight

                # Else if it's currently in normal and we changed to mobile:
                else if $(@).width() < mobileThreshold  && !mobileMode
                    $("#slider").data("plugin_slidesjs").resize slideWidth, slideHeightMobile


