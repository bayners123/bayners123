
# MAYBE: Turn plugins into proper Grunt plugins & extract more code as plugins where possible

# Load scripts depending on browser capabilities

# Store url for all scripts. This should be done by Liquid tags, as it also should in SCSS,
#  but for bizarre reasons it was disabled in the build of Jekyll that github now uses.
#  This will have to do until they update to 2.4. 
window.joseURL = ""

# Function to init skrollr
initSkrollr = ->
    skrollr.init
        smoothScrolling: false,
        forceHeight: false
    # Init skrollr menus
    skrollr.menu.init skrollr.get()
    
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
window.checkBody = (testClass) ->
    classes = document.body.className
    test = new RegExp("\\b" + testClass + "\\b",'g')
    
    return test.test(classes)
        
# Are we on a mobile?
window.mobileMode = -> 
    screen.width < 800
        
# Are we on the main page?
window.isMainpage = window.checkBody("mainpage")

# Load skrollr if we're not on a mobile or IE < 8
Modernizr.load [
        test: window.isMainpage and not Modernizr.touch and typeof IElt9 == 'undefined',
        yep: window.joseURL + '/js/skrollr.min.js'

        callback: (url, result, key) ->
            # If we loaded Skrollr & aren't on a small screen, immediately move the menubar off the page since it will otherwise bounce around when skrollr loads
            if not window.mobileMode()
                menubar = document.getElementById('menubar')
                menubar.style.top = "100%"
            
            # If the other scripts have finished by now, initiate skrollr
            initSkrollr() if window.jsloaded
    ]

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
$(window).resize ->
    if window.mobileMode()
        $menubar
            .addClass "hidden"
            .css "display", "block"

# Hide the menubar if we click it on a mobile (since the mobilebar is also present)
# N.B. we do not preventDefault so the click will still cause navigation as expected
$($menubar).click ->
    # If we're in mobile mode:
    if window.mobileMode()
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

    if window.mobileMode()
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
if window.isMainpage

    # Animate .hoverPulse elements when hovered using 'Animate.css'
    # Also, reduce duration to 0.5s
    $('.hoverPulse')
        .addClass('animated')
        .css
            "-webkit-animation-duration": "0.5s"
            "animation-duration": "0.5s"
        .hover ->
            $(this).toggleClass('pulse')


# Touchwipe allows us to simulate a scroll event for touchscreens that wouldn't otherwise fire one
if Modernizr.touch
    $(window).touchwipe({
        wipeUp: ->
            window.scrollIntercept(null, -100)
        wipeDown: ->
            window.scrollIntercept(null, 0)
        min_move_x: 20,
        min_move_y: 20,
        preventDefaultEvents: false
    });


# If we're on the homepage:
if window.isMainpage

    # SLIDESJS

    # Load constants for the slider
    slideWidth = $("#topSlider").data("aspectratio")
    slideHeight = 1
    slideHeightMobile = $("#topSlider").data("aspectratiomobile")
    mobileThreshold = 550

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
            lazy: true
    
    # Resize slider aspect ratio if the screen gets smaller (bind to window.resize event) if present
    if $("#topSlider").length != 0
        $(window).resize ->
            
            # If it's currently in mobile mode & we changed to normal mode:
            if window.mobileMode() && $(@).width() > mobileThreshold
                $("#topSlider").data("plugin_slidesjs").resize slideWidth, slideHeight
    
                # Refresh skrollr if present
                refreshSkrollr()

            # Else if it's currently in normal and we changed to mobile:
            else if $(@).width() < mobileThreshold  && !window.mobileMode()
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
            lazy: true

    # FULLSCREEN

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
        scrollCaptureRange: if window.mobileMode() then 75 else 150
            # Distance from element within which the window will lock to it
            #    Smaller for mobiles
        lostFocusRange: if window.mobileMode() then 51 else 151 # Distance at which to trigger the lostFocusCallback
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
        scrollCaptureRange: if window.mobileMode() then 75 else 150
            # Distance from element within which the window will lock to it
            #    Smaller for mobiles
        lostFocusRange: if window.mobileMode() then 51 else 151 # Distance at which to trigger the lostFocusCallback
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
            
    # ZOOMIMAGE & GROUPMEMBERS

    # Init all the groupmembers stuff
    if window.isMainpage
        $('#groupmembers .fullHolder').groupScroller
            first: "middle"

        $('#groupmembers .fullHolder a').click ->
            scrollTo "#groupmembers"

        # Zoom all the highlighted research images
        $('#publications .filledImg img').zoomImage()


    # TABGROUPS

    # Initiation of tabgroups for research
    $("#researchDetails").tabGroups()

    # Initiation of tabgroups for publications
    $("#publications .expanded .tabGroup").tabGroups()

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

    # EXPANDABLE SECTIONS

    $('.expandable').expandable()
        
    # INIT SKROLLR

    # Init skrollr if present (after sliders, tab groups and group members)
    initSkrollr() if skrollr?
    
    window.jsloaded = true
    
# Run any custom javascript that was passed by a page
if window.customJS?
    window.customJS()
    
    