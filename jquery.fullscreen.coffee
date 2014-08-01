---
---
# Fullscreen 0.1

# Not for release as yet
# Created by Charles Baynham

# Data: 24 Jul 2014

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
    
    pluginName = "fullscreen"
    defaults = 
        activeClass: "jqueryfullscreen_active"
        animation: true
        animationDuration: "0.25s"
        scrollCapture: true # Enable locking the window to the element when close
        scrollCaptureRange: 100 # Distance from element within which the window will lock to it
        offset: 0 # Consider the top of the element to be offset by this much
        scrollCallback: $.noop # Function (theElement)
        lostFocusCallback: $.noop # Function (theElement)
        lostFocusRange: 200 # Distance at which to trigger the lostFocusCallback
        shrinkOnLostFocus: false # Collapse the element if it's expanded and the user scrolls out of the lostFocus range
        parentElement: window # Parent element to be resized to match
        resizeCallback: $.noop # Function (theElement)
    
    data = 
        vendorPrefix : null
        originalHeight : null
        originalWidth : null
        animating : false
        hasFocus: false
        justResized : false
        
    class Plugin
      constructor: (@element, options) ->
        @options = $.extend true, {}, defaults, options
        @_defaults = defaults
        @_name = pluginName
        @data = data
        @init()

    Plugin::init = ->
        
        # Save the vendor prefix
        @data.vendorPrefix = @_getVendorPrefix()
        
        # Save the original height and width
        @_getDims()
        
        # Bind the checker to parent resize
        $(window).resize =>
            @check()
            @data.justResized = true
            # if it had focus, retain focus
            if @data.hasFocus
                @_scrollTo(false)
            
        # Check once at document.ready
        $ =>
            @check()
            
        # If we're capturing scrolling, register the handler
        if @options.scrollCapture
            $(@options.parentElement).scroll =>
                # Launch @_checkScroll after 500ms stationary
                clearTimeout $.data(window, 'scrollTimer')
                $.data window, 'scrollTimer', setTimeout( =>
                    @_checkScroll()
                , 500)
        
        # Detect moving out of focus range
        $(@options.parentElement).scroll =>
            $element = $(@element)
            
            # Are we active and not animating?
            if $element.hasClass(@options.activeClass) and not @data.animating
                
                # If we leave the capture zone, trigger the callback and set the flag
                elementPos = @element.offsetTop
                scrollPos = $(@options.parentElement).scrollTop()
        
                # Check if we're out of the range (elementPosition + offset) ± captureRange
                # If so, trigger the callback & maybe the shrinking element
                if elementPos + @options.offset - @options.lostFocusRange > scrollPos || scrollPos > elementPos + @options.offset + @options.lostFocusRange
                    
                    if @options.shrinkOnLostFocus
                        # If we scrolled downwards, flag this to the shrinking function
                        # It will compensate for our scroll so that the user isn't thrown all over the place by elements resizing
                        @data.autoShrinking = true if scrollPos > elementPos + @options.offset + @options.lostFocusRange
                        @setInactive()
                    
                    # Set flag
                    @data.hasFocus = false
                    
                    @options.lostFocusCallback(@element)
        @
        
    # Check if the element has the active class and, if it does, resize it
    #  If it doesn't, go back to default stylesheet size
    Plugin::check = ->
        $element = $(@element)
        
        if $element.hasClass @options.activeClass
            @_resizeToFull()
        else
            # If it's not expanded & not mid-animation, update the dimentions
            @_getDims() if not @data.animating
        @ 
    
    # Store the height and width of the un-fullscreened element
    Plugin::_getDims = ->
        $element = $(@element)
        
        @data.originalHeight = $element.height()
        @data.originalWidth = $element.width()
              
    Plugin::setActive = ->
        $(@element).addClass @options.activeClass
        @_resizeToFull()
        @_scrollTo(true)
        
        @
    
    Plugin::setInactive = ->
        $(@element).removeClass @options.activeClass
        @_removeStyles()
        
        @
        
    Plugin::toggleActive = ->
        $element = $(@element)
        
        if $element.hasClass @options.activeClass
            @setInactive()
        else
            @setActive()
            
        @
        
    # @_getVendorPrefix()
    # Check if the browser supports CSS3 Transitions
    # Thanks to Nathan Searles http://nathansearles.com of slidesjs
    Plugin::_getVendorPrefix = () ->
        body = document.body or document.documentElement
        style = body.style

        vendor = ["Moz", "Webkit", "Khtml", "O", "ms"]

        i = 0

        while i < vendor.length
            return vendor[i] if typeof style[vendor[i] + "Transition"] is "string"
            i++
            
        false

    # Resize the element fully    
    Plugin::_resizeToFull = ->
        $element = $(@element)
        
        # Get target height & widths
        targetHeight = $(@options.parentElement).get(0).innerHeight
        targetWidth = $(@options.parentElement).get(0).innerWidth
        
        # Is animation enabled / are we already locked?
        if not @options.animation or @data.hasFocus
            
            # Set the new values
            $element.css
                height: targetHeight 
                width: targetWidth 
        
        else
            # Flag start of animation
            @data.animating = true
            
            # We can't animate from auto CSS values, so we'll set height absolutely first
            $element.css("height", $element.height() )
            
            # Timeout
            setTimeout =>
            
                # Set up the transition
                @element.style[@data.vendorPrefix + "Transition"] = "height " + @options.animationDuration + " ease-in-out"
            
                # Add another timeout to let DOM update
                setTimeout =>
            
                    # Set the new values
                    $element.css
                        height: targetHeight
                        width: targetWidth

            # Once the transition has finished, remove the animation, update the flag and then unbind this handler (.one jquery option)
            $element.one "transitionend webkitTransitionEnd oTransitionEnd otransitionend MSTransitionEnd", =>
                $element = $(@element)
            
                @element.style[@data.vendorPrefix + "Transition"] = ""
                @data.animating = false
                
                # Trigger the resize callback
                @options.resizeCallback(@element)
            
        @
        
    # Remove any inline height/width styles
    Plugin::_removeStyles = ->
        $element = $(@element)
        
        @data.hasFocus = false
        
        # Is animation enabled?
        if not @options.animation
            
            # Remove the styling
            $element.css
                height: ""
                width: ""
        
        else
            # Flag start of animation
            @data.animating = true
            
            # Get target height & widths
            targetHeight = @data.originalHeight
            targetWidth = @data.originalWidth
            
            # Set up the transition
            @element.style[@data.vendorPrefix + "Transition"] = "height " + @options.animationDuration + " ease-in-out"
            
            # Add timeout to let DOM update
            setTimeout =>
            
                # Set the new values
                $element.css
                    height: targetHeight
                    width: targetWidth
                    
                # If this function was triggered by moving out of the focal zone, compensate for the shrinking by scrolling the screen
                if @data.autoShrinking
                    # Scroll the window upwards by the element's expanded height - shrunk height
                    # elementBottom = @element.offsetTop + @data.originalHeight
                    elementDelta = $element.height() - @data.originalHeight
                    currentScroll = $(@options.parentElement).scrollTop()
        
                    if $(@options.parentElement).get(0) == window
                        # $('html, body').animate scrollTop: elementBottom, 300
                        $('html, body').scrollTop currentScroll - elementDelta
                    else
                        # $(@options.parentElement).animate scrollTop: elementBottom, 300
                        $(@options.parentElement).scrollTop currentScroll - elementDelta
                        
                    # Remove the flag
                    @data.autoShrinking = false

            # Once the transition has finished, remove the animation & the styled height & width (hopefully this step should make no visible difference), update the flag and then unbind this handler (.one jquery option)
            $element.one "transitionend webkitTransitionEnd oTransitionEnd otransitionend MSTransitionEnd", =>
                $element = $(@element)
                
                $element.css
                    height: ""
                    width: ""
                    
                @element.style[@data.vendorPrefix + "Transition"] = ""
                @data.animating = false
                
                # Trigger the resize callback
                @options.resizeCallback(@element)
              
        @
        
    # Check the scrollbar position and, if we're close to the element, scroll the screen exactly to it
    Plugin::_checkScroll = (elementPos, scrollPos) ->
        elementPos = @element.offsetTop
        scrollPos = $(@options.parentElement).scrollTop()
        
        # Is the element active?
        if $(@element).hasClass(@options.activeClass)
            # Check if we're in the range (elementPosition + offset) ± captureRange
            # If so, scroll exactly to it
            if elementPos + @options.offset - @options.scrollCaptureRange < scrollPos && scrollPos < elementPos + @options.offset + @options.scrollCaptureRange
                @_scrollTo(true)
        
        @
            
    # Scroll to the element
    Plugin::_scrollTo = (animate) ->
        
        # Scroll the window to the element's top (+ offset) in 300ms
        elementPos = @element.offsetTop
        
        # If animation is enabled and called for, animate this
        if @options.animation and animate
            if $(@options.parentElement).get(0) == window
                $('html, body').animate scrollTop: elementPos + @options.offset, 300
            else
                $(@options.parentElement).animate scrollTop: elementPos + @options.offset, 300
        else
            if $(@options.parentElement).get(0) == window
                $('html, body').scrollTop(elementPos + @options.offset)
            else
                $(@options.parentElement).scrollTop(elementPos + @options.offset)
        
            
        # set flag
        @data.hasFocus = true
        
        # Trigger callback
        @options.scrollCallback @element
        
        @
        
    # Plugin constructor
    $.fn[pluginName] = (options) ->
      @each ->
        if !$.data(@, "plugin_#{pluginName}")
          $.data(@, "plugin_#{pluginName}", new Plugin(@, options))
    
)(jQuery, window, document)