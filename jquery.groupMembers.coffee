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
        
        # Register left and right arrows
        @data.leftArrow.on "click.groupMembers", =>
            @_prev()
            false
        @data.rightArrow.on "click.groupMembers", =>
            @_next()
            false
            
        # Zoom the image and goto the first slide on load
        $ =>
            # Set image to zoom to fill the area using the zoomImage plugin
            @data.slideImg.zoomImage
                # Whenever the image gets resized, update skrollr
                resizeCallbackAfter: ->
                    if skrollr?
                      if skrollr.get()
                        skrollr.get().refresh()
                # Before the image gets resized, recalculate the xMargin
                useMarginFunctions: true
                getXOverride: =>
                    @getXMargin(@data.currentSlide)
                    
            # Goto first slide with no animation
            @_goto(@options.first, false)
        
    Plugin::_prev = ->
        
        # Call @_goto with animation
        if @data.currentSlide != 0
            @_goto(@data.currentSlide - 1, true)
        
    Plugin::_next = ->
        
        # Call @_goto with animation
        if @data.currentSlide < @data.noSlides - 1
            @_goto(@data.currentSlide + 1, true)
        
    Plugin::_goto = (slide, animation) ->
        
        # Check the argument is valid
        if slide < @data.noSlides
            # Get all the list items (the slides)
            $slides = @data.descUL.children("li")
            $thisSlide = $slides.eq(slide)
        
            # Hide all slides
            $slides.hide()
        
            # Show the correct one
            $thisSlide.show()
            
            # Set the person's name
            @data.personHeading.html $thisSlide.data("person")
            
            # Update the current slide
            @data.currentSlide = slide
            
            # Resize the image (using animation). This will cause zoomImage to call getXMargin to determine the correct offset
            @data.slideImg.data("plugin_zoomImage").resize(animation)
            
            
    Plugin::getXMargin = (slide) ->
        
        # Calculate the left margin value required for the image. 
        # Remember, this is a percentage of the parent's width
        # This should cause the image to go evenly between the far left and the far right when in horizontal mode
        
        # The far left value = 0
        # The far right value = - (imgWidth - parentWidth) / parentWidth * 100
        #                     = - (imgWidth/parentWidth - 1) * 100
        
        imgWidth = @data.slideImg.width()
        parentWidth = $(@element).width()
        # =>
        farRight = - (imgWidth / parentWidth - 1) * 100
        
        # We want to go somewhere between max and min, depending on which slide we're on:
        xMargin = 0 + farRight * slide / (@data.noSlides - 1)
        
        return xMargin
        
        
    # Plugin constructor
    $.fn[pluginName] = (options) ->
      @each ->
        if !$.data(@, "plugin_#{pluginName}")
          $.data(@, "plugin_#{pluginName}", new Plugin(@, options))
    
)(jQuery, window, document)
