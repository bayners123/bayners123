---
---

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

# Init slider
$ ->
    $("#slider")
        .slidesjs
            width: slideWidth,
            height: if (screen.width < mobileThreshold ) then slideHeightMobile else slideHeight,
            zoom: true,
            navigation: false
        
        
# Resize slider aspect ratio if the screen is smaller
$(window).resize ->

    mobileMode = $("#slider").data("plugin_slidesjs").options.width / $("#slider").data("plugin_slidesjs").options.height == slideWidth / slideHeightMobile

    # If it's currently in mobile mode & we changed to normal mode:
    if mobileMode && $(@).width() > mobileThreshold
        $("#slider").data("plugin_slidesjs").resize slideWidth, slideHeight

    # Else if it's currently in normal and we changed to mobile:
    else if $(@).width() < mobileThreshold  && !mobileMode
        $("#slider").data("plugin_slidesjs").resize slideWidth, slideHeightMobile
        
# Load and init skrollr if we're not on a mobile
Modernizr.load 
    test: Modernizr.touch,
    nope: 'skrollr.min.js',
    complete: ->
        skrollr.init
            smoothScrolling: false