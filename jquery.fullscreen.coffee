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
        
    # Plugin constructor
    $.fn[pluginName] = (options) ->
      @each ->
        if !$.data(@, "plugin_#{pluginName}")
          $.data(@, "plugin_#{pluginName}", new Plugin(@, options))
    
)(jQuery, window, document)