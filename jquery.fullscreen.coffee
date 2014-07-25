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
        scrollCapture: true # Enable locking the window to the element when close
        scrollCaptureRange: 100 # Distance from element within which the window will lock to it
        scrollOffset: 0 # Offset to use when scrolling to the element
        scrollCallback: $.noop # Function (theElement)
        parentElement: window # Parent element to be resized to match
    
    class Plugin
      constructor: (@element, options) ->
        @options = $.extend true, {}, defaults, options
        @_defaults = defaults
        @_name = pluginName
        @init()

    Plugin::init = ->
        
        # Bind the checker to parent resize
        $(@options.parentElement).resize =>
            @check()
            
        # Check once at document.ready
        $ =>
            @check()
            
        # If we're capturing scrolling, register the handler
        if @options.scrollCapture
            $(@options.parentElement).scroll =>
                clearTimeout $.data(window, 'scrollTimer')
                $.data window, 'scrollTimer', setTimeout( =>
                    @_checkScroll()
                , 500)
        
        @
        
    # Check if the element has the active class and, if it does, resize it
    #  If it doesn't, go back to default stylesheet size
    Plugin::check = ->
        $element = $(@element)
        
        if $element.hasClass @options.activeClass
            @_resizeToFull()
        else
            @_removeStyles()
            
        @ 
    
    # Resize the element fully    
    Plugin::_resizeToFull = ->
        $element = $(@element)
        
        height = $(@options.parentElement).get(0).innerHeight
        width = $(@options.parentElement).get(0).innerWidth
        
        $element.css
              height: height
              width: width
    
        @
              
    Plugin::setActive = ->
        $(@element).addClass @options.activeClass
        @check()
        @_scrollTo()
        
        @
    
    Plugin::setInactive = ->
        $(@element).removeClass @options.activeClass
        @check()
        
        @
        
    Plugin::toggleActive = ->
        $element = $(@element)
        
        if $element.hasClass @options.activeClass
            @setInactive()
        else
            @setActive()
            
        @
    
    # Remove any inline sizes
    Plugin::_removeStyles = ->
        $element = $(@element)
        
        $element.css
              height: ""
              width: ""
              
        @
        
    # Check the scrollbar position and, if we're close to the element, scroll the screen exactly to it
    Plugin::_checkScroll = ->
        elementPos = @element.offsetTop
        scrollPos = $(@options.parentElement).scrollTop()
        
        if $(@element).hasClass(@options.activeClass) && elementPos + @options.scrollOffset - @options.scrollCaptureRange < scrollPos && scrollPos < elementPos + @options.scrollOffset + @options.scrollCaptureRange
            @_scrollTo()
            
        @
            
    # Scroll to the element
    Plugin::_scrollTo = ->
        
        # Scroll the window to the element's top (+ offset) in 300ms
        elementPos = @element.offsetTop
        
        if $(@options.parentElement).get(0) == window
            $('html, body').animate scrollTop: elementPos + @options.scrollOffset, 300
        else
            $(@options.parentElement).animate scrollTop: elementPos + @options.scrollOffset, 300
        
        # Trigger callback
        @options.scrollCallback @element
        
        @
        
    # Plugin constructor
    $.fn[pluginName] = (options) ->
      @each ->
        if !$.data(@, "plugin_#{pluginName}")
          $.data(@, "plugin_#{pluginName}", new Plugin(@, options))
    
)(jQuery, window, document)