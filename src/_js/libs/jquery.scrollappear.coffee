
# Scroll appear 0.1

# Not for release as yet
# Created by Charles Baynham

# Data: 21 Nov 2014

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
    
    pluginName = "scrollappear"
    defaults = 
      duration: 500
      hidden:
        opacity: 0
      showing:
        opacity: 1
    
    data = 
      UID : 0
        
        
    class Plugin
      constructor: (@element, options) ->
        @options = $.extend true, {}, defaults, options
        @_defaults = defaults
        @_name = pluginName
        @data = $.extend(true, {}, data)
        
        @init()

    Plugin::init = ->
      $elem = $(@element)
      
      # Generate a random number to use as an identifier
      @data.UID = Math.floor((Math.random() * 10000) + 1); 
      
      # If already in view, this plugin is unneeded
      if @isScrolledIntoView()
        #console.log "Already visible  with #{@data.UID}"
        
        return 0
        
      # else, hide it
      else
        @disappear(false)
              
      # Bind the scroll event
      $(window).on "scroll.#{@_name}#{@data.UID}", =>
        
        # Have we scrolled it into view?
        if @isScrolledIntoView()
          # Good! Make it appear
          @appear(true)
          
          # Then unbind the handler and remove this plugin
          @destroy();
        
      @
      
      
    Plugin::disappear = () ->
      $elem = $(@element)
      
      $elem.css @options.hidden
    
      #console.log "Disappeared with #{@data.UID}"
      
      @
    
    Plugin::appear = (animate) ->
      $elem = $(@element)
      
      if animate
        $elem.animate @options.showing, @data.duration
      
      else
        $elem.css @options.showing
          
      #console.log "Appeared with #{@data.UID}"
          
      @
        
    Plugin::isScrolledIntoView = () ->
      
      $elem = $(@element)
      
      docViewTop = $(window).scrollTop()
      docViewBottom = docViewTop + $(window).height()

      elemTop = $elem.offset().top
      # elemBottom = elemTop + $elem.height()

      return (elemTop <= docViewBottom)
    
    
    Plugin::destroy = () ->
      
      #console.log "Destroying #{@data.UID}"
      
      # Unbind the scroll handler from window (identified by the UID we generated)
      $(window).off ".#{@_name}#{@data.UID}"
      
      # Remove this plugin from the object
      $.removeData(@element, "plugin_#{pluginName}")
      
      return 0
        
    # Plugin constructor
    $.fn[pluginName] = (options) ->
      @each ->
        if !$.data(@, "plugin_#{pluginName}")
          $.data(@, "plugin_#{pluginName}", new Plugin(@, options))
    
)(jQuery, window, document)