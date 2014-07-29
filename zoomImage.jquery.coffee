---
---
# ZoomImage 0.1

# Not for release as yet
# Created by Charles Baynham

# Data: 28 Jul 2014

# (c) 2014 by Charles Baynham

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

# http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

(($,window,document) -> 
    
    pluginName = "zoomImage"
    defaults =
        parent: null
        
    data =
        parent: null
        parentWidth: null
        parentHeight: null
        targetRatio: null
        imgWidth: null
        imgHeight: null
        imgRatio: null
    
    class Plugin
      constructor: (@element, options) ->
        @options = $.extend true, {}, defaults, options
        @_defaults = defaults
        @_name = pluginName
        @data = data
        @init()

    Plugin::init = ->
        
        $element = $(@element)
        @data = $.data this
	    
        # Get the parent of the element, or use the one given in options
        if @options.parent # -> we were given something in the options

            # In case we got a selector:
            if typeof @options.parent == "string"
                @options.parent = $(@options.parent)
            
            # In case we got a DOM element, produce a jQuery one:
            #   (N.B. this has no effect if it's already a jQuery object)
            @options.parent = $(@options.parent)
            
            # Save it in this.data
            @data.parent = @options.parent
        else
            # Else, just get the parent
            @data.parent = $element.parent()
        
        # Set parent to relative positioning if it's currently static so that the element's positioning works
        if @data.parent.css("position") == "static"
            @data.parent.css("position", 'relative')
            
        # Set the img (or whatever) to absolute positioning
        $element.css("position", "absolute")
        
        # A max width / height will cause manual resizing to fail, so we remove it if present. 
        $element.css
            "max-width": "none"
            "max-height": "none"
        
        # Register the function to zoom the image (or whatever) as soon as it's loaded
        $(this).one "load", =>
            $element = $(@element)
                
            # Get the image's dimentions. 
            #   This only needs to happen once and can only happen once,
            #   since this plugin will change these values but we want the originals
            @data.imgWidth = this.width
            @data.imgHeight = this.height
    
            # The aspect ratio of this image
            @data.imgRatio = imgWidth / imgHeight
            
            # Get the parent's info
            @refresh()
                
            # Do the resizing    
            @resize()
            
            
        # If the image was already loaded by the time this code runs, trigger the "load" handler now
        if this.complete || this.naturalWidth != 0
            $(this).trigger "load"
    
    # Refresh the values stored in @data for the parent's dimentions
    Plugin::refresh = ->
        $element = $(@element)
        
        # Calculate parent's width and height
        @data.parentWidth = @data.parent.width()
        @data.parentHeight = @data.parent.height()
        
        # The aspect ratio of the parent container
        @data.targetRatio = @data.parentWidth  / @data.parentHeight
        
    
    # Using the values saved in @data, resize the image/element
    Plugin::resize = ->
        $element = $(@element)
        
        # If the image is wider than the container, set it to fill the container's height and overflow by width
        # Also set the margins so that the image is centered
        if @data.imgRatio > @data.targetRatio
            # Calculate half the amount by which the image is wider than the container as a percentage OF THE CONTAINER'S width
            overflow = (@data.imgRatio / @data.targetRatio - 1) * 100 / 2
    
            $element.css
                height: "100%",
                width: "auto",
                margin: "0 0 0 -" + overflow + "%"
        
        # Vice versa for the other case (taller than container)        
        else
            # Calculate half the amount by which the image is taller than the container as a percentage OF THE CONTAINER'S WIDTH
            overflow = (1 / @data.imgRatio - 1 / @data.targetRatio) * 100 / 2
    
            $element.css
                height: "auto",
                width: "100%",
                margin: "-" + overflow + "% 0 0 0"
                
    # Plugin constructor
    $.fn[pluginName] = (options) ->
      @each ->
        console.log "launched"
        if !$.data(@, "plugin_#{pluginName}")
          $.data(@, "plugin_#{pluginName}", new Plugin(@, options))

)(jQuery, window, document)