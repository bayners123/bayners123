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
        active: true # Initial state. Is the plugin active for this element?
        parent: null
        useMarginFunctions: false
        getXOverride: ->
            return null
        getYOverride: ->
            return null
        resizeCallbackAfter: $.noop
        xOverride: null # These will override the x or y margins when the image is centered
        yOverride: null # I.e. if it's taller than it is wide then the y margin is set to 
                     #  yOverride instead of calculated and the value in xOverride is ignored
                     # N.B. these are percentages of the container's WIDTH
        animation: true
        
    data =
        active: null
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
        
        # Add this element to the list of all zoomImaged elements / create this list
        if not $(window).data "#{@_name}_zoomedElements"
            # Init the global variable to an empty jQuery object
            $(window).data "#{@_name}_zoomedElements", $([])
        
        # Add our element to the global object
        $(window).data "#{@_name}_zoomedElements", $(window).data("#{@_name}_zoomedElements").add($element)
	    
        # Get the parent of the element, or use the one given in options
        if @options.parent # -> we were given something in the options
            # Save it in this.data
            @data.parent = $(@options.parent)
        else
            # Else, just get the parent
            @data.parent = $element.parent()
        
        
        # Get whether the plugin is active
        @data.active = @options.active
        
        # If so, set up the image for resizing
        if @data.active
            
            @_setupStyles()
        
        # Register the function to zoom the image (or whatever) as soon as it's loaded if active
        $element.one "load.#{@_name}", =>
            $element = $(@element)
                
            # Get the image's dimentions. 
            #   This only needs to happen once and can only happen once,
            #   since this plugin will change these values but we want the originals
            @data.imgWidth = @element.width
            @data.imgHeight = @element.height
    
            # The aspect ratio of this image
            @data.imgRatio = @data.imgWidth / @data.imgHeight
            
            # Get the parent's info
            @refresh()
                
            # Do the resizing    
            @resize(false) if @data.active
            
        # If the image was already loaded by the time this code runs, trigger the "load" handler now
        if @element.complete || @element.naturalWidth != 0
            $element.trigger "load"
            
        # Bind a rethink for when the window is resized
        $(window).on "resize.#{@_name}", =>

            # Refresh parent dims
            @refresh()

            # Resize element
            @resize(false) if @data.active
    
    # Start zooming this element
    Plugin::setActive = ->
        
        # Set flag
        @data.active = true
        
        # Setup styles
        @_setupStyles()
        
        # Refresh parent dims
        @refresh()

        # Resize element with animation
        @resize(true)
        
    # Stop zooming this element
    Plugin::setInactive = ->
        $element = $(@element)
        
        # Set flag
        @data.active = false
                
        # Remove styles
        @_removeStyles()

        # Remove resizing styles
        $element.css
            height: ""
            width: ""
            "margin-top": ""
            "margin-right": ""
            "margin-bottom": ""
            "margin-left": ""
            
    # Toggle active status
    Plugin::toggleActive = ->
        
        if @data.active
            @setInactive()
        else
            @setActive()   
    
    # Set styles for zooming
    Plugin::_setupStyles = ->
        $element = $(@element)
        
        # Set parent to relative positioning if it's currently static so that the element's positioning works
        if @data.parent.css("position") == "static"
            @data.parent.css("position", 'relative')
        
        # Set the parent's overflow to hidden
        @data.parent.css("overflow", "hidden")
        
        # Set the img (or whatever) to absolute positioning
        $element.css("position", "absolute")
    
        # A max width / height will cause manual resizing to fail, so we remove it if present. 
        $element.css
            "max-width": "none"
            "max-height": "none"
            
    # Remove styles for zooming
    Plugin::_removeStyles = ->
        $element = $(@element)
        
        @data.parent.css
            "position": ""
            "overflow": ""
        
        $element.css
            "position": ""
            "max-width": ""
            "max-height": ""
    
    # Refresh the values stored in @data for the parent's dimentions
    Plugin::refresh = ->
        $element = $(@element)
        
        # Calculate parent's width and height
        @data.parentWidth = @data.parent.width()
        @data.parentHeight = @data.parent.height()
        
        # The aspect ratio of the parent container
        @data.targetRatio = @data.parentWidth  / @data.parentHeight
        
        @
    
    # Using the values saved in @data, resize the image/element
    Plugin::resize = (animation) ->
        $element = $(@element)
        
        if @options.useMarginFunctions
            @options.xOverride = @options.getXOverride()
            @options.yOverride = @options.getYOverride()
        
        # Animate if requested & enabled
        if animation and @options.animation
            @_transitions "add"
            
        # If the image is wider than the container, set it to fill the container's height and overflow by width
        # Also set the margins so that the image is centered
        if @data.imgRatio > @data.targetRatio
            
            if typeof @options.xOverride == "number"
                # Either use the override...
                overflow = @options.xOverride
            else
                # ...or calculate half the amount by which the image is wider than the container as a percentage OF THE CONTAINER'S width
                overflow = - (@data.imgRatio / @data.targetRatio - 1) * 100 / 2
            
            # Do the resizing      
            $element.css
                height: "100%",
                width: "auto",
                margin: "0 0 0 " + overflow + "%"
                    
        # Vice versa for the other case (taller than container)        
        else
            if typeof @options.yOverride == "number"
                # Either use the override...
                overflow = @options.yOverride
            else
                # Calculate half the amount by which the image is taller than the container as a percentage OF THE CONTAINER'S WIDTH
                overflow = - (1 / @data.imgRatio - 1 / @data.targetRatio) * 100 / 2
                
            $element.css
                height: "auto",
                width: "100%",
                margin: overflow + "% 0 0 0"
                
        # Remove the animations afterwards & call the callback
        if animation and @options.animation
            $element.one "transitionend webkitTransitionEnd oTransitionEnd otransitionend MSTransitionEnd", =>
                @_transitions "remove"
                
                @options.resizeCallbackAfter(@element)
        else    
            @options.resizeCallbackAfter(@element)
                
        @
    
    Plugin::_transitions = (option) ->
        $element = $(@element)
        
        if option == "add"
            $element.css
                "-webkit-transition": "margin 0.25s ease-in-out"
                "-moz-transition": "margin 0.25s ease-in-out"
                "-o-transition": "margin 0.25s ease-in-out"
                "transition": "margin 0.25s ease-in-out"
        else if option = "remove"
            $element.css
                "-webkit-transition": ""
                "-moz-transition": ""
                "-o-transition": ""
                "transition": ""
        
        # Pause for DOM update        
        setTimeout ->
            @
    
    Plugin::yOverride = (yOverride) ->
        
        # Save the new override
        @options.yOverride = yOverride
        
        # Resize the image
        @resize(true) if @data.active
    
    Plugin::xOverride = (xOverride) ->
        
        # Save the new override
        @options.xOverride = xOverride
        
        # Resize the image
        @resize(true) if @data.active
        
    Plugin::update = ->
        
        @refresh()
        
        @resize(false) if @data.active
    
    #  --- global functions ---
    
    # Trigger resize updates for all elements that are zoomed
    $[pluginName] = 
        updateAll: ->
            $globalList = $(window).data "#{pluginName}_zoomedElements" if $(window).data "#{pluginName}_zoomedElements"
        
            if $globalList then $globalList.each ->
                $(this)["#{pluginName}.update"]()
                
    # Plugin constructor
    $.fn[pluginName] = (options) ->
        @each ->
            if !$.data(@, "plugin_#{pluginName}")
                $.data(@, "plugin_#{pluginName}", new Plugin(@, options))
    
    $.fn["#{pluginName}.update"] = ->
        @each ->
            if $.data(@, "plugin_#{pluginName}")
                $.data(@, "plugin_#{pluginName}").update()

)(jQuery, window, document)