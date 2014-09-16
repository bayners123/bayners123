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
        slideImgHolder: null
        descULHolder: null
        groupListHolder: null
        first: "middle"
    
    data = 
        leftArrow: null
        rightArrow: null
        personHeading: null
        currentSlide: null # of current year
        noSlides: null # of current year
        
        groupInfo: {}
        # groupInfo is an object containing pointers to all the group's info in the HTML
        # It is structured as shown:
        #
        # groupInfo = object
        #     "2014": 
        #       image: element
        #       descUL: element
        #       nav: element
        #
        #     "2013": ...
                  
        
        slideImg: null
        descUL: null
    
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
            
        # find the slideImgHolder
        if @options.slideImgHolder
            slideImgHolder = $(@options.slideImgHolder)
        else
            slideImgHolder = $element.find(".imgHolder")
            
        # loop through all images in it, getting their years
        $.each slideImgHolder.children("img"), (index) =>
            
            $img = slideImgHolder.children("img").eq(index)
            year = $img.data("year")
            @data.groupInfo[year] = {}
            @data.groupInfo[year].image = $img
            
        if @options.descULHolder
            descULHolder = $(@options.descULHolder)
        else
            descULHolder = $element.find(".descHolder")
            
        # Loop through all ULs of descriptions, storing them
        $.each descULHolder.children("ul"), (index) =>
            
            $ul = descULHolder.children("ul").eq(index)
            year = $ul.data("year")
            @data.groupInfo[year].descUL = $ul
        
        if @options.groupListHolder
            groupListHolder = @options.groupListHolder
        else
            groupListHolder = $element.find(".groupListHolder")
            
        # Loop through all NAVs of links, storing them too
        $.each groupListHolder.children("nav"), (index) =>
            
            $nav = groupListHolder.children("nav").eq(index)
            year = $nav.data("year")
            @data.groupInfo[year].nav = $nav
            
        # altered
        # Number of slides:
        @data.noSlides = @data.descUL.children("li").length
        
        # Register left and right arrows
        @data.leftArrow.on "click.groupMembers", =>
            @_prev()
            false
        @data.rightArrow.on "click.groupMembers", =>
            @_next()
            false
            
        # all this altered
        # Bind the .groupList nav to the slides
        # We expect that the .groupList contains the same number of a elements as there are group members
        @data.groupListLinks.click (e) =>
            
            # Get the clicked link
            clickedLink = e.target
            
            # Disable the hyperlink
            e.preventDefault()
            
            # Goto the appropriate slide, with animation
            @_goto @data.groupListLinks.index(clickedLink), true
            
            
        # Zoom the image and goto the first slide on load
        $ =>
            # altered
            # Set image to zoom to fill the area using the zoomImage plugin, start inactive
            @data.slideImg.zoomImage
                # Whenever the image gets resized, update skrollr
                resizeCallbackAfter: ->
                    if skrollr?
                      if skrollr.get()
                        skrollr.get().refresh()
                # Before the image gets resized, recalculate the xMargin
                useMarginFunctions: true
                initialAnimation: false
                getXOverride: =>
                    @getXMargin(@data.currentSlide)
                # Don't zoom the image initially (this will be activated when the section goes fullscreen)
                # active: false
                
            # Re-scroll skrollr if needed
            if (skrollr && skrollr.menu)
                skrollr.menu.jumpToInitialPos()
            
            # altered
            # Calculate the middle slide if requested
            if @options.first == "middle"
                @options.first = Math.floor((@data.noSlides - 1) / 2)
            
            # altered
            # Goto first slide with no animation
            @_goto(@options.first, false)
        
    Plugin::_prev = ->
        
        # Call @_goto with animation
        if @data.currentSlide != 0
            # altered
            @_goto(@data.currentSlide - 1, true)
        
    Plugin::_next = ->
        
        # Call @_goto with animation
        if @data.currentSlide < @data.noSlides - 1
            # altered
            @_goto(@data.currentSlide + 1, true)
        
        # all this altered
    Plugin::_goto = (slide, animation) ->
        
        # Check the argument is valid
        if 0 <= slide < @data.noSlides
            # Get all the list items (the slides)
            $slides = @data.descUL.children("li")
            $thisSlide = $slides.eq(slide)
        
            # Hide all slides
            $slides.hide()
        
            # Show the correct one
            $thisSlide.show()
            
            # Set the person's name
            @data.personHeading.html $thisSlide.data("person")
            
            # Remove all 'active' classes from person list
            @data.groupListLinks.removeClass('active')
            
            # Add 'active' class to correct person
            @data.groupListLinks.eq(slide).addClass('active')
            
            # Update the current slide
            @data.currentSlide = slide
            
            # Hide the arrow if we've reached far left/right
            if slide == 0
              @data.leftArrow.hide()
              @data.rightArrow.show()
            else if slide == @data.noSlides-1
              @data.leftArrow.show()
              @data.rightArrow.hide()
            else
              @data.leftArrow.show()
              @data.rightArrow.show()              
            
            # Resize the image (using animation). This will cause zoomImage to call getXMargin to determine the correct offset
            @data.slideImg.data("plugin_zoomImage").resize(animation)
            
            
    Plugin::getXMargin = (slide) ->
        
        # Calculate the left margin value required for the image. 
        # Remember, this is a percentage of the parent's width
        # This should cause the image to go evenly between the far left and the far right when in horizontal mode
        
        # The far left value = 0
        # The far right value = - (imgWidth - parentWidth) / parentWidth * 100
        #                     = - (imgWidth/parentWidth - 1) * 100
        
        # Altered
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
