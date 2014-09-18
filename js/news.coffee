---
---

# Only included on the news page
window.customJS = ->
    
    Modernizr.load
        load: window.joseURL + '/js/jquery.zoomImage.js'
        complete: ->
            # Zoom all the news images
            $('.filledImg img').zoomImage()