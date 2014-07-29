---
---
# Jose group members scroller

# Not for release ever
# Created by Charles Baynham

# To be called on the .fullHolder element

# Data: 29 Jul 2014

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
    
    pluginName = "groupScroller"
    defaults = 
        leftArrow: null
        rightArrow: null
        personHeading: null
        slideImg: null
        descUL: null
        first: 0
    
    data = 
        leftArrow: null
        rightArrow: null
        personHeading: null
        slideImg: null
        descUL: null
        currentSlide: null
        noSlides: null
    
    class Plugin
      constructor: (@element, options) ->
        @options = $.extend true, {}, defaults, options
        @_defaults = defaults
        @_name = pluginName
        @data = data
        @init()

    Plugin::init = ->
        $element = $(@element)
        
        # Get various elements if not provided
        if @options.leftArrow
            @data.leftArrow = $(@options.leftArrow)
        else
            @data.leftArrow = $element.find(".arrow.left")
            
        if @options.rightArrow
            @data.rightArrow = $(@options.rightArrow)
        else
            @data.rightArrow = $element.find(".arrow.right")
            
        if @options.personHeading
            @data.personHeading = $(@options.personHeading)
        else
            @data.personHeading = $element.find(".person")
            
        if @options.slideImg
            @data.slideImg= $(@options.slideImg)
        else
            @data.slideImg= $element.find(".slideImg")
        
        if @options.descUL
            @data.descUL= $(@options.descUL)
        else
            @data.descUL= $element.find(".desc")
            
        # Number of slides:
        @data.noSlides = @data.descUL.children("li").length
        
        # Goto first slide
        @_goto(@options.first)
        
        
    Plugin::_next = ->
        
        # Call @_goto
        if @data.currentSlide != 0
            @_goto(@data.currentSlide - 1)
        
    Plugin::_prev = ->
        
        # Call @_goto
        if @data.currentSlide != @data.noSlides
            @_goto(@data.currentSlide + 1)
        
    Plugin::_goto = (slide) ->
        
        # Check the argument is valid
        if slide < @data.noSlides
            # Get all the list items (the slides)
            $slides = @data.descUL.children("li")
        
            # Hide all slides
            $slides.hide()
        
            # Show the correct one
            $slides.eq(slide).show()
            
            # Update the current slide
            @data.currentSlide = slide
        
        
    # Plugin constructor
    $.fn[pluginName] = (options) ->
      @each ->
        if !$.data(@, "plugin_#{pluginName}")
          $.data(@, "plugin_#{pluginName}", new Plugin(@, options))
    
)(jQuery, window, document)
