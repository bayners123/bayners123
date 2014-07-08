---
---

# Load scripts depending on browser capabilities

if typeof IElt9 == 'undefined'
    alert "Phew"
else
    alert "Oh no!"

# Load skrollr if we're not on a mobile, but don't initialise it yet
Modernizr.load
    test: Modernizr.touch,
    nope: ['skrollr.min.js', 'skrollr-stylesheets.js'],

    callback: (url, result, key) ->
    # If we loaded Skrollr, immediately move the menubar off the page since it will otherwise bounce around when skrollr loads
    # We only want to do this once, so check that it was skrollr that was loaded and not skrollr-stylesheets        
        if (url=="skrollr.min.js" && !result) 
            menubar = document.getElementById('menubar')
            menubar.style.top = "100%"

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
                $moreButton = $('#mobileBar #moreButton i')
                
                console.log $menubar
                console.log $moreButton

                if $menubar.is(':visible')
                    $menubar.slideUp()
                    $moreButton
                        .removeClass("fa-angle-double-up")
                        .addClass("fa-angle-double-down")
                else
                    $menubar
                        .slideDown()
                    $moreButton
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
                        smoothScrolling: false,
                        forceHeight: false


            # Resize slider aspect ratio if the screen gets smaller (bind to window.resize event)
            $(window).resize ->

                mobileMode = $("#slider").data("plugin_slidesjs").options.width / $("#slider").data("plugin_slidesjs").options.height == slideWidth / slideHeightMobile

                # If it's currently in mobile mode & we changed to normal mode:
                if mobileMode && $(@).width() > mobileThreshold
                    $("#slider").data("plugin_slidesjs").resize slideWidth, slideHeight

                # Else if it's currently in normal and we changed to mobile:
                else if $(@).width() < mobileThreshold  && !mobileMode
                    $("#slider").data("plugin_slidesjs").resize slideWidth, slideHeightMobile


