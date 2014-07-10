---
---

# Load scripts depending on browser capabilities

# Load skrollr if we're not on a mobile, but don't initialise it yet
Modernizr.load
    test: Modernizr.touch,
    nope: ['skrollr.min.js', 'skrollr-stylesheets.js', 'skrollr-menu.min.js'],

    callback: (url, result, key) ->
    # If we loaded Skrollr & aren't on a small screen, immediately move the menuBar off the page since it will otherwise bounce around when skrollr loads
    # We only want to do this once, so check that it was skrollr that was loaded and not skrollr-stylesheets        
        if (url=="skrollr.min.js" && !result) 
            if screen.width > 799
                menuBar = document.getElementById('menuBar')
                menuBar.style.top = "100%"
            
            # Are we running IE 8 or less? Well bugger, but let's try to patch some holes
            if typeof IElt9 != 'undefined'
                Modernizr.load 'skrollr.ie.min.js'   

Modernizr.load 
    # Load jquery with a local fallback 
        load: ['//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js','jquery.slides.js']
        complete: ->
            if !window.jQuery
                Modernizr.load 'jquery.min.js'

    # ... then run code that depends on jQuery & slidesjs

            # function to toggle menuBar visibility & change mobilebar morebutton icon
            toggleMenu = (menuBar, moreButtonI) ->
                if menuBar.is(':visible')
                    menuBar.slideUp()
                    moreButtonI
                        .removeClass("fa-angle-double-up")
                        .addClass("fa-angle-double-down")
                else
                    menuBar
                        .slideDown()
                    moreButtonI
                        .removeClass("fa-angle-double-down")
                        .addClass("fa-angle-double-up")
                        
            $menuBar = $('#menuBar')
            $mobileBar= $('#mobileBar')
            $moreButtonA = $('#mobileBar #moreButton')
            $moreButtonI = $('#mobileBar #moreButton i')
            
            # Register the click event for the mobile menu
            $($moreButtonA).click (event) ->
                event.preventDefault()

                toggleMenu $menuBar, $moreButtonI
                
            # Hide the menubar if we click it on a mobile (since the mobileBar is also present)
            # N.B. we do not preventDefault so the click will still cause navigation
            $($menuBar).click ->
                # If we're in mobile mode:
                if $mobileBar.is(':visible')
                # then hide the menubar
                    toggleMenu $menuBar, $moreButtonI

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
                        navigation: false,
                        play:
                            active: true,
                            interval: 4000,
                            auto: true,
                            swap: true,
                            pauseOnHover: true,
                            generate: false
                
                # Init skrollr if we're not on a mobile (after slider)
                if !Modernizr.touch
                    skrollr.init
                        smoothScrolling: false,
                        forceHeight: false
                    # Init skrollr menus
                    skrollr.menu.init skrollr.get()


            # Resize slider aspect ratio if the screen gets smaller (bind to window.resize event)
            $(window).resize ->

                mobileMode = $("#slider").data("plugin_slidesjs").options.width / $("#slider").data("plugin_slidesjs").options.height == slideWidth / slideHeightMobile

                # If it's currently in mobile mode & we changed to normal mode:
                if mobileMode && $(@).width() > mobileThreshold
                    $("#slider").data("plugin_slidesjs").resize slideWidth, slideHeight

                # Else if it's currently in normal and we changed to mobile:
                else if $(@).width() < mobileThreshold  && !mobileMode
                    $("#slider").data("plugin_slidesjs").resize slideWidth, slideHeightMobile
            
            # Animate .hoverPulse elements when hovered using 'Animate.css'
            $('.hoverPulse').addClass('animated').hover ->
                    $(this).toggleClass('pulse')
                    
    
