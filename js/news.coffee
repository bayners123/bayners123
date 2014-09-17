---
---

# Only run on the news page

Modernizr.load [

    load: 'timeout=2000!//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js'
    complete: ->
        if !window.jQuery
            Modernizr.load
                load: window.joseURL + '/js/jquery.min.js'
                
,
    
    load: window.joseURL + '/js/jquery.zoomImage.js'
    complete: ->
        # Zoom all the news images
        $('.filledImg img').zoomImage()

]