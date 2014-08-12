---
---

# Load scripts depending on browser capabilities

# Load skrollr if we're not on a mobile, but don't initialise it yet
Modernizr.load [
    test: Modernizr.touch,
    nope: ['/skrollr.min.js', '/skrollr-stylesheets.js', '/skrollr-menu.min.js'],

    callback: (url, result, key) ->
    # If we loaded Skrollr & aren't on a small screen, immediately move the menubar off the page since it will otherwise bounce around when skrollr loads
    # We only want to do this once, so check that it was skrollr that was loaded and not skrollr-stylesheets
        if (url=="skrollr.min.js" && !result)
            if screen.width > 799
                menubar = document.getElementById('menubar')
                menubar.style.top = "100%"

            # Are we running IE 8 or less? Well bugger, but let's try to patch some holes
            if typeof IElt9 != 'undefined'
                Modernizr.load '/skrollr.ie.min.js'
    ,
    # Load jquery with a local fallback 
        load: 'timeout=2000!//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js'
        complete: ->
            if !window.jQuery
                Modernizr.load
                    load: '/jquery.min.js'
    ,
        load: '/jquery.slides.js'
        complete: ->

    # ... then run code that depends on jQuery & slidesjs

            # function to toggle menubar visibility & change mobilebar morebutton icon
            toggleMenu = (menubar, moreButtonI) ->
                if menubar.is(':visible')
                    menubar.slideUp()
                    moreButtonI
                        .removeClass("fa-angle-double-up")
                        .addClass("fa-angle-double-down")
                else
                    menubar
                        .slideDown()
                    moreButtonI
                        .removeClass("fa-angle-double-down")
                        .addClass("fa-angle-double-up")
                        
            $menubar = $('#menubar')
            $mobilebar= $('#mobilebar')
            $moreButtonA = $('#mobilebar #moreButton')
            $moreButtonI = $('#mobilebar #moreButton i')
            
            # Register the click event for the mobile menu
            $($moreButtonA).click (event) ->
                event.preventDefault()

                toggleMenu $menubar, $moreButtonI
                
            # Hide the menubar if we click it on a mobile (since the mobilebar is also present)
            # N.B. we do not preventDefault so the click will still cause navigation
            $($menubar).click ->
                # If we're in mobile mode:
                if $mobilebar.is(':visible')
                # then hide the menubar
                    toggleMenu $menubar, $moreButtonI

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
                            

                # TAB MENU GENERIC STUFF: 
                
                # Initiation of .tabgroups
                $(".tabgroup").each ->
                    
                    # Find all the links and tabs in this tabgroup
                    # Hopefully there will be the same number of each!
                    $group = $(this)
                    $links = $group.find(".tabmenu a")
                    $tabs = $group.find(".tabs .tab")
                    
                    # Disable all the links in case there aren't the same number of links/tabs (user error):
                    $links.click ->
                        false
                        
                    # Define function to show a tab
                    showTab = (group, link, tab) ->
                        links = group.find(".tabmenu a")
                        tabs = group.find(".tabs .tab")
                        
                        # Disable all links and tabs
                        links.removeClass('active')
                        tabs.removeClass('active')
                        
                        # Enable the correct two
                        link.addClass('active')
                        tab.addClass('active')
                        
                    # Set slider to the first tab if it isn't already
                    showTab $group, $links.first(), $tabs.first()
                    
                    # Click handler for links, to move to the appropriate tab
                    clickHandler = (e) ->
                        # Get the clicked link from the click event
                        clickedLink = $(e.target)
                        
                        # Call the show tab function, retrieving the associated tab that we saved earlier
                        showTab clickedLink.data("myGroup"), clickedLink, clickedLink.data("myTab")
                        
                        # Disable normal link action
                        return false
                        
                    # Loop over all links / tabs until we run out of either (hopefully both)
                    i = 0
                    while $links.size() > i && $tabs.size() > i
                    
                        # The current link
                        theLink = $links.eq(i)
                        
                        # Store the associated tabs with the links
                        theLink.data("myGroup", $group)
                        theLink.data("myTab", $tabs.eq(i))
                        
                        # Bind click handler
                        theLink.click clickHandler
                        
                        # Increment    
                        i++

                # END TAB MENU GENERIC STUFF
                    
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
                        
                        # Look for the two divs containing the shrunk and the expanded display
                        # Also find the arrow if present
                        $shortSection = $(this).children('.shrunk')
                        $longSection = $(this).children('.expanded')
                        $arrow = $expandControl.children('.fa.fa-arrow-down')
                        
                        $longSection
                            .addClass 'hidden'
                            .hide()
                        
                        # Save the jQuery objects for these with the link
                        eventData = 
                            "shortSection": $shortSection
                            "longSection": $longSection
                            "arrow": $arrow
                        
                        # Register a click handler to toggle their visibility
                        $expandControl.on "click.expansion", eventData, (e) ->

                            # Get the sections which it controls (set earlier in the initialisation)
                            short = e.data.shortSection
                            long = e.data.longSection
                            arrow = e.data.arrow
                            
                            # Toggle their visibilities
                            if long.hasClass("hidden")
                                # Mark it as hidden for this script
                                short.addClass 'hidden'
                                long.removeClass 'hidden'
                                
                                # Hide / show them
                                short.slideUp()
                                long.slideDown()
                                
                                # Change the arrow
                                arrow
                                    .addClass "fa-arrow-up"
                                    .removeClass "fa-arrow-down"
                            else
                                short.removeClass 'hidden'
                                long.addClass 'hidden'
                                short.slideDown()
                                long.slideUp()
                                arrow
                                    .addClass "fa-arrow-down"
                                    .removeClass "fa-arrow-up"
                                
                            if skrollr?
                                if skrollr.get()
                                    skrollr.get().refresh()
                                
                            # Prevent default link action 
                            e.preventDefault()
                    else
                        # No controlling element found
                        console.log "No .expandSection control found for section:"
                        console.log this
                        console.log "This should be either a child or sibling of the .expandable element"
                            
                # Init skrollr if we're not on a mobile (after slider)
                if !Modernizr.touch
                    skrollr.init
                        smoothScrolling: false,
                        forceHeight: false
                    # Init skrollr menus
                    skrollr.menu.init skrollr.get()
                    
                # END DOC READY
                        
            # Resize slider aspect ratio if the screen gets smaller (bind to window.resize event)
            $(window).resize ->
                            
                # Are we already in mobile mode? Check by looking at the slider's current dimentions
                mobileMode = $("#topSlider").data("plugin_slidesjs").options.width / $("#topSlider").data("plugin_slidesjs").options.height == slideWidth / slideHeightMobile

                # If it's currently in mobile mode & we changed to normal mode:
                if mobileMode && $(@).width() > mobileThreshold
                    $("#topSlider").data("plugin_slidesjs").resize slideWidth, slideHeight
                    
                    # Refresh skrollr if present
                    if skrollr?
                        skrollr.get().refresh()

                # Else if it's currently in normal and we changed to mobile:
                else if $(@).width() < mobileThreshold  && !mobileMode
                    $("#topSlider").data("plugin_slidesjs").resize slideWidth, slideHeightMobile
                    
                    # Refresh skrollr if present
                    if skrollr?
                        skrollr.get().refresh()
                        
            # Animate .hoverPulse elements when hovered using 'Animate.css'
            $('.hoverPulse').addClass('animated').hover ->
                    $(this).toggleClass('pulse')
                    
            # Hide menubar when scrolling downwards
            delta = 0
            scrollIntercept = (e) ->
                appearanceThreshold = 5
                
                if e.originalEvent.detail < 0 || e.originalEvent.wheelDelta > 0
                    delta--
                else
                    delta++
                    
                if delta > 0
                    delta = 0
                else if delta < -appearanceThreshold 
                    delta = -appearanceThreshold
                    
                if delta == 0
                    $('#menubar').addClass("hidden")
                    # $('#mobilebar').addClass("hidden")
                else if delta == -appearanceThreshold
                    $('#menubar').removeClass("hidden")
                    # $('#mobilebar').removeClass("hidden")
                
            $(window).on 'DOMMouseScroll.menuscrolling mousewheel.menuscrolling', scrollIntercept
            
    ,
        load: 'jquery.fullscreen.js',
        complete: ->
            
            $('#groupmembers').fullscreen
                active: true
                scrollCallback: ->
                    $('#menubar, #mobilebar').addClass("hidden")
                # lostFocusCallback: (element) ->
                #     toggleSection $(element)
                    # console.log $(element).find('.slideImg')
                # animation: false
                # animationDuration: "1s"
                # parentElement: $('#skrollr-body')
                # offset: -50
                scrollCaptureRange: 150 # Distance from element within which the window will lock to it
                lostFocusRange: 151 # Distance at which to trigger the lostFocusCallback
                resizeCallback: ->
                    # Refresh skrollr if present
                    if skrollr?
                        skrollr.get().refresh()
                    if $.zoomImage?
                        $.zoomImage.updateAll() # Run twice since otherwise the image scrolling won't work when
                        $.zoomImage.updateAll() #  you open the fullscreen bit. Hacky hacky hack
                        
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
                    effect:
                        fade: 
                            speed: 600
                            crossfade: true
                            
            # Fullscreen the facilities section
            $('#facilities').fullscreen
                active: true
                scrollCallback: ->
                    $('#menubar, #mobilebar').addClass("hidden")
                scrollCaptureRange: 150 # Distance from element within which the window will lock to it
                lostFocusRange: 151 # Distance at which to trigger the lostFocusCallback
                resizeCallback: ->
                    # Refresh skrollr if present
                    if skrollr?
                        skrollr.get().refresh()
                        
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
        load: ['jquery.zoomImage.js','jquery.groupMembers.js']
        complete: ->
            $('#groupmembers .fullHolder').groupScroller
                first: 1

    ]