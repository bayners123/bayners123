---
---

slideWidth = 8
slideHeight = 3
slideHeightMobile = 6
mobileThreshold = 550

$ ->
    $("#slider")
        .slidesjs
            width: slideWidth,
            height: if (screen.width < mobileThreshold ) then slideHeightMobile else slideHeight,
            zoom: true,
            navigation: false

$(window).resize ->
    
    mobileMode = $("#slider").data("plugin_slidesjs").options.width / $("#slider").data("plugin_slidesjs").options.height == slideWidth / slideHeightMobile
    
    # If it's currently in mobile mode & we changed to normal mode:
    if mobileMode && $(@).width() > mobileThreshold 
        $("#slider").data("plugin_slidesjs").resize slideWidth, slideHeight

    # Else if it's currently in normal and we changed to mobile:
    else if $(@).width() < mobileThreshold  && !mobileMode
        $("#slider").data("plugin_slidesjs").resize slideWidth, slideHeightMobile