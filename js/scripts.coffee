---
---

# MAYBE: Turn plugins into proper Grunt plugins & extract more code as plugins where possible

# Load scripts depending on browser capabilities

# Store url for all scripts. This should be done by Liquid tags, as it also should in SCSS,
#  but for bizarre reasons it was disabled in the build of Jekyll that github now uses.
#  This will have to do until they update to 2.4. 
window.joseURL = ""

# Function to refresh skrollr
refreshSkrollr = ->
    # Refresh skrollr once the animation is over
    skrollr?.get()?.refresh()
            
# Function to scroll to an object
scrollTo = (selector, delay) ->
    # Default 200ms delay
    delay = 200 unless delay?
    
    # Do the scroll
    $('html, body').animate
        scrollTop: $(selector).offset().top
    , delay

# Function to check for body having a given class
checkBody = (testClass) ->
    classes = document.body.className
    test = new RegExp("\\b" + testClass + "\\b",'g')
    
    return test.test(classes)
        
# Are we in mobile mode? This is updated by a screen resize callback once jquery is loaded
window.mobileMode = screen.width < 800

# Load skrollr if we're not on a mobile & the body has the class "skrollrMe", but don't initialise it yet
Modernizr.load [
        test: checkBody("skrollrMe") and not Modernizr.touch,
        yep: [window.joseURL + '/js/skrollr.min.js', window.joseURL + '/js/skrollr-stylesheets.js', window.joseURL + '/js/skrollr-menu.min.js'],

        callback: (url, result, key) ->
        # If we loaded Skrollr & aren't on a small screen, immediately move the menubar off the page since it will otherwise bounce around when skrollr loads
        # We only want to do this once, so check that it was skrollr that was loaded and not skrollr-stylesheets
            if (url=="skrollr.min.js" && !result)
                if screen.width > 799
                    menubar = document.getElementById('menubar')
                    menubar.style.top = "100%"

                # Are we running IE 8 or less? Well bugger, but let's try to patch some holes
                if typeof IElt9 != 'undefined'
                    Modernizr.load window.joseURL + '/js/skrollr.ie.min.js'
    ,
    # Load jquery with a local fallback 
        load: 'timeout=2000!//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js'
        complete: ->
            if !window.jQuery
                Modernizr.load
                    load: window.joseURL + '/js/jquery.min.js'
                    
            # Keep mobilemode up-to-date
            $(window).resize ->
                (window.mobileMode = screen.width < 800)
                    
            # function to toggle menubar visibility & change mobilebar morebutton icon
            toggleMenu = (menubar, moreButtonI) ->
                if menubar.hasClass('hidden')
                    menubar.removeClass('hidden')
                    moreButtonI
                        .removeClass("fa-angle-double-down")
                        .addClass("fa-angle-double-up")
                else
                    menubar.addClass('hidden')
                    moreButtonI
                        .removeClass("fa-angle-double-up")
                        .addClass("fa-angle-double-down")
                        
            $menubar = $('#menubar')
            $mobilebar= $('#mobilebar')
            $moreButtonA = $('#mobilebar #moreButton')
            $moreButtonI = $('#mobilebar #moreButton i')
            
            # Register the click event for the mobile menu
            $($moreButtonA).click (event) ->
                event.preventDefault()

                toggleMenu $menubar, $moreButtonI
                
            # Set the menubar to hidden if we're mobile & remove the CSS hiding it from view
            # This means it's hidden by the margin rather than display: none
            if window.mobileMode
                $menubar
                    .addClass "hidden"
                    .css "display", "block"
                
                
            # Hide the menubar if we click it on a mobile (since the mobilebar is also present)
            # N.B. we do not preventDefault so the click will still cause navigation as expected
            $($menubar).click ->
                # If we're in mobile mode:
                if window.mobileMode
                # then hide the menubar
                    toggleMenu $menubar, $moreButtonI
            
            # Hide menubar when scrolling downwards (not mobile as yet)
            delta = 0
            window.scrollIntercept = (e, override) ->
                appearanceThreshold = 5
                
                if override?
                    delta = override
                else
                    if e.originalEvent.detail < 0 || e.originalEvent.wheelDelta > 0 || e.originalEvent.deltaY < 0
                        delta--
                    else
                        delta++
                    
                if delta > 0
                    delta = 0
                else if delta < -appearanceThreshold 
                    delta = -appearanceThreshold
                
                if window.mobileMode
                    if delta == 0
                        $mobilebar.addClass("hidden")
                        if not $menubar.hasClass("hidden")
                            toggleMenu $menubar, $moreButtonI
                    else if delta == -appearanceThreshold
                        $mobilebar.removeClass("hidden")
                else
                    if delta == 0
                        $menubar.addClass("hidden")
                    else if delta == -appearanceThreshold
                        $menubar.removeClass("hidden")
                
            $(window).on 'DOMMouseScroll.menuscrolling mousewheel.menuscrolling wheel.menuscrolling', window.scrollIntercept
            
            # If we're on the main page, do stuff to those elements:
            if checkBody("mainpage")
            
                # EXPANDABLE SECTIONS
            
                # Find all .expandable sections
                $expandableSections = $('.expandable')
            
                # For each of them, initialise the controlling link to show / hide appropriately
                $expandableSections.each ->
                
                    # Find the controlling link. Look first for a child of the .expandable section
                    # If not found, look at the siblings
                    $expandControl = $(this).children('.expandSection')
                    if $expandControl.length == 0
                        $expandControl = $(this).siblings('.expandSection')
                
                    # If we found a controlling link...
                    if $expandControl.length != 0
                    
                        # Look for the two divs containing the shrunk and the expanded display & the parent
                        # Also find the arrow if present
                        $shortSection = $(this).children('.shrunk')
                        $longSection = $(this).children('.expanded')
                        $container= $shortSection.parent()
                        $arrow = $expandControl.children('.fa.fa-arrow-down')
                    
                        $longSection
                            .addClass 'hidden'
                            .hide()
                    
                        # Save the jQuery objects for these with the link
                        eventData = 
                            "container" : $container
                            "shortSection": $shortSection
                            "longSection": $longSection
                            "arrow": $arrow
                    
                        # Register a click handler to toggle their visibility
                        $expandControl.on "click.expansion", eventData, (e) ->
                        
                            # Get the sections which it controls (set earlier in the initialisation)
                            container = e.data.container
                            short = e.data.shortSection
                            long = e.data.longSection
                            arrow = e.data.arrow
                        
                            # Toggle their visibilities
                            if long.hasClass("hidden")
                                # Mark it as hidden for this script
                                short.addClass 'hidden'
                                long.removeClass 'hidden'
                            
                                # Hide / show them
                                short.slideUp
                                    duration: 500
                                    complete: refreshSkrollr
                                long.slideDown
                                    duration: 500
                                    complete: refreshSkrollr
                                
                                # Put the view back to the section top
                                scrollTo container, 500
                            
                                # Change the arrow
                                arrow
                                    .addClass "fa-arrow-up"
                                    .removeClass "fa-arrow-down"
                            else
                                short.removeClass 'hidden'
                                long.addClass 'hidden'
                                short.slideDown
                                    duration: 500
                                    complete: refreshSkrollr
                                long.slideUp
                                    duration: 500
                                    complete: refreshSkrollr
                            
                                # Put the view back to the section top
                                scrollTo container, 500
                            
                                arrow
                                    .addClass "fa-arrow-down"
                                    .removeClass "fa-arrow-up"
                            
                            # Prevent default link action 
                            e.preventDefault()
                    else
                        # No controlling element found
                        console.log "No .expandSection control found for section:"
                        console.log this
                        console.log "This should be either a child or sibling of the .expandable element"
             

                # Animate .hoverPulse elements when hovered using 'Animate.css'
                # Also, reduce duration to 0.5s
                $('.hoverPulse')
                    .addClass('animated')
                    .css
                        "-webkit-animation-duration": "0.5s"
                        "animation-duration": "0.5s"
                    .hover ->
                        $(this).toggleClass('pulse')
                    
    ,
    # Touchwipe allows us to simulate a scroll event for touchscreens that wouldn't otherwise fire one
        test: Modernizr.touch
        yep: window.joseURL + '/js/jquery.touchwipe.min.js'
        callback: ->
            $(window).touchwipe({
                wipeUp: ->
                    window.scrollIntercept(null, -100)
                wipeDown: ->
                    window.scrollIntercept(null, 0)
                min_move_x: 20,
                min_move_y: 20,
                preventDefaultEvents: false
            });
    ,
        test: checkBody("mainpage")
        yep: window.joseURL + '/js/jquery.slides.js'
        callback: ->
            
    # ... then run code that depends on slidesjs

            # Load constants for the slider
            slideWidth = $("#topSlider").data("aspectratio")
            slideHeight = 1
            slideHeightMobile = $("#topSlider").data("aspectratiomobile")
            mobileThreshold = 550

            # Bind to doc. ready
            $ ->
                
                # Initiation of slider
                $("#topSlider")
                    .slidesjs
                        width: slideWidth,
                        height: if (screen.width < mobileThreshold ) then slideHeightMobile else slideHeight,
                        zoom: true,
                        navigation: 
                            active: false,
                        play:
                            active: true,
                            effect: "fade"
                            interval: 4000,
                            auto: true,
                            swap: true,
                            pauseOnHover: false,
                            generate: false,
                            restartDelay: 1000
                        effect:
                            fade: 
                                speed: 600
                                crossfade: true


                
                    
                # END DOC READY
                        
            # Resize slider aspect ratio if the screen gets smaller (bind to window.resize event) if present
            if $("#topSlider").length != 0
                $(window).resize ->
                            
                    # Are we already in mobile mode? Check by looking at the slider's current dimentions
                    window.mobileMode = $("#topSlider").data("plugin_slidesjs").options.width / $("#topSlider").data("plugin_slidesjs").options.height == slideWidth / slideHeightMobile

                    # If it's currently in mobile mode & we changed to normal mode:
                    if window.mobileMode && $(@).width() > mobileThreshold
                        $("#topSlider").data("plugin_slidesjs").resize slideWidth, slideHeight
                    
                        # Refresh skrollr if present
                        refreshSkrollr()

                    # Else if it's currently in normal and we changed to mobile:
                    else if $(@).width() < mobileThreshold  && !window.mobileMode
                        $("#topSlider").data("plugin_slidesjs").resize slideWidth, slideHeightMobile
                    
                        # Refresh skrollr if present
                        refreshSkrollr()
                    
            # Initiation of second slider
            $("#facilities .slider")
                .slidesjs
                    width: screen.width
                    height: screen.height
                    zoom: true
                    navigation:
                        active: false
                        rollover: false
                    play:
                        active: true
                        effect: "fade"
                        interval: 4000
                        auto: false
                        swap: true
                        pauseOnHover: false
                        generate: false
                    pagination:
                        active: true
                        generate: false
                    effect:
                        fade: 
                            speed: 600
                            crossfade: true
                            
            # Init skrollr if present (after slider)
            if skrollr?
                skrollr.init
                    smoothScrolling: false,
                    forceHeight: false
                # Init skrollr menus
                skrollr.menu.init skrollr.get()
            
    ,
        test: checkBody("mainpage")
        yep: window.joseURL + '/js/jquery.fullscreen.js',
        callback: ->
            
            # Setup animation for arrows
            $('#groupmembers .arrow')
                .addClass "animated"
                .css
                    "-webkit-animation-duration": "1s"
                    "animation-duration": "1s"
                    "-webkit-animation-iteration-count": "1"
                    "animation-iteration-count": "1"
            
            $('#groupmembers').fullscreen
                active: true
                scrollCallback: ->
                    $('#menubar, #mobilebar').addClass "hidden"
                    $('#groupmembers .arrow.left')
                        .one "animationend webkitAnimationEnd oAnimationEnd oanimationend MSAnimationEnd", ->
                            $(this).removeClass "pulseLeft"
                        .addClass "pulseLeft"
                    $('#groupmembers .arrow.right')
                        .one "animationend webkitAnimationEnd oAnimationEnd oanimationend MSAnimationEnd", ->
                            $(this).removeClass "pulseRight"
                        .addClass "pulseRight"
                        
                # lostFocusCallback: (element) ->
                #     toggleSection $(element)
                    # console.log $(element).find('.slideImg')
                # animation: false
                # animationDuration: "1s"
                # parentElement: $('#skrollr-body')
                # offset: -50
                scrollCaptureRange: if window.mobileMode then 75 else 150
                    # Distance from element within which the window will lock to it
                    #    Smaller for mobiles
                lostFocusRange: if window.mobileMode then 51 else 151 # Distance at which to trigger the lostFocusCallback
                resizeCallback: ->
                    # Refresh skrollr if present
                    refreshSkrollr()
                    if $.zoomImage?
                        $.zoomImage.updateAll() # Run twice since otherwise the image scrolling won't work when
                        $.zoomImage.updateAll() #  you open the fullscreen bit. Hacky hacky hack
                            
            # Fullscreen the facilities section
            $('#facilities').fullscreen
                active: true
                scrollCallback: ->
                    $('#menubar, #mobilebar').addClass("hidden")
                scrollCaptureRange: if window.mobileMode then 75 else 150
                    # Distance from element within which the window will lock to it
                    #    Smaller for mobiles
                lostFocusRange: if window.mobileMode then 51 else 151 # Distance at which to trigger the lostFocusCallback
                resizeCallback: ->
                    # Refresh skrollr if present
                    refreshSkrollr()
                        
                    # Resize the slider
                    width = $('#facilities').width()
                    height = $('#facilities').height()
                    $("#facilities .slider").data("plugin_slidesjs").resize(width, height)
                    
                    # Reposition the arrows in the center
                    arrows = $('#facilities .slidesjs-next, #facilities .slidesjs-previous')
                    right = $('#facilities .slidesjs-next')
                    left = $('#facilities .slidesjs-previous')
                    
                    arrows.css
                        top: ($('#facilities .slider').height() - arrows.first().height()) / 2
                    
    ,
        test: checkBody("mainpage")
        yep: [window.joseURL + '/js/jquery.zoomImage.js',window.joseURL + '/js/jquery.groupMembers.js']
        complete: ->
            # Init all the groupmembers stuff
            if checkBody("mainpage")
                $('#groupmembers .fullHolder').groupScroller
                    first: "middle"
                
                $('#groupmembers .fullHolder a').click ->
                    scrollTo "#groupmembers"
                    
                # Zoom all the highlighted research images
                $('#publications .filledImg img').zoomImage()
    ,   
        test: checkBody("mainpage")
        yep: window.joseURL + '/js/jquery.tabgroups.js'
        callback: ->
            # Initiation of .tabgroups
            $(".tabgroup").tabGroups()
            
            # Set research tabs to hidden on load (so they're visible if Java is disabled)
            $('#researchDetails').hide()
        
            # Bind research bubbles to the appropriate sections of the tabs & make them cause the tabs to appear
            $('.researchBubble').click ->
                # $('#researchDetails').removeClass("hidden")
                $('#researchDetails').show().addClass("animated appearZoom")
        
            $('#research1').click ->
                $('#researchLink1').click()
            $('#research2').click ->
                $('#researchLink2').click()
            $('#research3').click ->
                $('#researchLink3').click()

    ]