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
        scrollCapture: true
        scrollCaptureRange: 100
        scrollOffset: 0
    
    class Plugin
      constructor: (@element, options) ->
        @options = $.extend true, {}, defaults, options
        @_defaults = defaults
        @_name = pluginName
        @init()

    Plugin::init = ->
        
        # Bind the checker to window resize
        $(window).resize =>
            @check()
            
        # Check once at document.ready
        $ =>
            @check()
            
        # If we're capturing scrolling, register the handler
        if @options.scrollCapture
            $(window).scroll =>
                clearTimeout $.data(window, 'scrollTimer')
                $.data window, 'scrollTimer', setTimeout( =>
                    @_checkScroll()
                , 250)
        
    # Check if the element has the active class and, if it does, resize it
    #  If it doesn't, go back to default stylesheet size
    Plugin::check = ->
        $element = $(@element)
        
        if $element.hasClass @options.activeClass
            @_resizeToFull()
        else
            @_removeStyles()    
    
    # Resize the element fully    
    Plugin::_resizeToFull = ->
        $element = $(@element)
        
        height = window.innerHeight
        width = window.innerWidth
        
        $element.css
              height: height
              width: width
              
    Plugin::setActive = ->
        $(@element).addClass @options.activeClass
        @check()
    
    Plugin::setInactive = ->
        $(@element).removeClass @options.activeClass
        @check()
        
    Plugin::toggleActive = ->
        $element = $(@element)
        
        if $element.hasClass @options.activeClass
            @setInactive()
        else
            @setActive()
    
    # Remove any inline sizes
    Plugin::_removeStyles = ->
        $element = $(@element)
        
        $element.css
              height: ""
              width: ""
        
    # Check the scrollbar position and, if we're close to the element, scroll the screen exactly to it
    Plugin::_checkScroll = ->
        elementPos = @element.offsetTop
        scrollPos = $(window).scrollTop()
        
        if $(@element).hasClass(@options.activeClass) && elementPos + @options.scrollOffset - @options.scrollCaptureRange < scrollPos && scrollPos < elementPos + @options.scrollOffset + @options.scrollCaptureRange
            @_scrollTo()
            
    # Scroll to the element
    Plugin::_scrollTo = ->
        elementPos = @element.offsetTop
        $('html, body').animate scrollTop: elementPos + @options.scrollOffset, 500
        
    # Plugin constructor
    $.fn[pluginName] = (options) ->
      @each ->
        if !$.data(@, "plugin_#{pluginName}")
          $.data(@, "plugin_#{pluginName}", new Plugin(@, options))
    
)(jQuery, window, document)