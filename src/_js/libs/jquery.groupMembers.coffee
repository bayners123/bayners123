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
        minusArrow: null
        plusArrow: null
        yearHeading: null
        personHeading: null
        slideImgHolder: null
        descULHolder: null
        groupListHolder: null
        first: null
    
    data = 
        leftArrow: null
        rightArrow: null
        personHeading: null
        currentYear: 0 # 0 based index of groupInfo. 0 initially. 
        noYears: null
        currentSlide: null # of current year
        noSlides: null # of current year
        
        groupInfo: []
        # groupInfo is an array containing pointers to all the group's info in the HTML
        # It is structured as shown:
        #
        # groupInfo = array
        #     - year: string
        #       image: element
        #       firstSlide: int
        #       descUL: element
        #       nav: element
        #
        #       imageLoaded: false    This is for lazy loading: false until the image is loaded. 
        #
        #     - year: ...
        
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
            @data.leftArrow = $element.find(".groupDesc .arrow.left")
            
        if @options.rightArrow
            @data.rightArrow = $(@options.rightArrow)
        else
            @data.rightArrow = $element.find(".groupDesc .arrow.right")
            
        if @options.minusArrow
            @data.minusArrow= $(@options.minusArrow)
        else
            @data.minusArrow= $element.find(".yearBox .arrow.left")
            
        if @options.plusArrow
            @data.plusArrow= $(@options.plusArrow)
        else
            @data.plusArrow= $element.find(".yearBox .arrow.right")
            
        if @options.yearHeading
            @data.yearHeading= $(@options.yearHeading)
        else
            @data.yearHeading= $element.find(".yearBox h3")
            
        if @options.personHeading
            @data.personHeading = $(@options.personHeading)
        else
            @data.personHeading = $element.find(".groupDesc .person")
            
        # find the slideImgHolder
        if @options.slideImgHolder
            slideImgHolder = $(@options.slideImgHolder)
        else
            slideImgHolder = $element.find(".imgHolder")
            
        # loop through all images in it, getting their years & hiding all except the first
        $.each slideImgHolder.children("img"), (index) =>
            
            $img = slideImgHolder.children("img").eq(index)
            year = $img.data("year")
            @data.groupInfo.push 
                year: year
                image: $img
                imageLoaded: index == 0
                
            if index == 0
                $img.show()
            else
                $img.hide()
        
        if @options.descULHolder
            descULHolder = $(@options.descULHolder)
        else
            descULHolder = $element.find(".descHolder")
            
        # Loop through all ULs of descriptions, storing them & hiding all except the first
        $.each descULHolder.children("ul"), (index) =>
            
            $ul = descULHolder.children("ul").eq(index)
            if @data.groupInfo[index].year != $ul.data("year")
                console.log "Error: order of descHolder ul elements is mismatched with imgs"
            @data.groupInfo[index].descUL = $ul
            
            $ul.hide() unless index == 0
        
        if @options.groupListHolder
            groupListHolder = @options.groupListHolder
        else
            groupListHolder = $element.find(".groupListHolder")
            
        # Loop through all NAVs of links, storing them too & hiding all except the first
        $.each groupListHolder.children("nav"), (index) =>
            
            $nav = groupListHolder.children("nav").eq(index)
            if @data.groupInfo[index].year != $nav.data("year")
                console.log "Error: order of nav elements is mismatched with imgs"
            @data.groupInfo[index].nav = $nav
            
            $nav.hide() unless index == 0
        
        # Search for the primary group member, to start the slides on this index
        # Loop through years...
        $.each @data.groupInfo, (index) =>
            
            if @options.first?
                # and through all of the nav's children (the actual links)...
                $.each @data.groupInfo[index].nav.children(), (childIndex) =>
                    link = @data.groupInfo[index].nav.children().eq(childIndex)
                    # Search for the string "jose goicoechea"
                    if link.children(".notMobileOnly").html().trim().toLowerCase() == @options.first.toLowerCase()
                        
                        # Save this as the first slide for this year
                        @data.groupInfo[index].firstSlide = childIndex
                
            # If we didn't find the primary group member or none was provided, goto the middle slide first
            if not @data.groupInfo[index].firstSlide?
                @data.groupInfo[index].firstSlide = Math.floor((@data.groupInfo[index].nav.children().length - 1) / 2)
                    
        # Number of years
        @data.noYears = @data.groupInfo.length
        
        # Number of slides:
        @data.noSlides = @data.groupInfo[0].descUL.children("li").length
        
        # Register left and right arrows
        @data.leftArrow.on "click.groupMembers", =>
            @_prev()
            false
        @data.rightArrow.on "click.groupMembers", =>
            @_next()
            false
        
        # Register plus and minus arrows
        @data.plusArrow.on "click.groupMembers", =>
            @_nextYear()
            false
        @data.minusArrow.on "click.groupMembers", =>
            @_prevYear()
            false
            
        # Bind the .groupList nav to the slides
        # We expect that the .groupList contains the same number of a elements as there are group members
        $.each @data.groupInfo, (index) =>
            @data.groupInfo[index].nav.children("a").click (e) =>
            
                # Get the clicked link
                clickedLink = $(e.target)
                if clickedLink.is("span") then clickedLink = clickedLink.parent()
            
                # Disable the hyperlink
                e.preventDefault()
            
                # Goto the appropriate slide, with animation
                @_goto @data.groupInfo[index].nav.children("a").index(clickedLink), true
            
            
        # Zoom the image and goto the first slide on load
        $ =>
            # Set images to zoom to fill the area using the zoomImage plugin
            $.each @data.groupInfo, (index) =>
                @data.groupInfo[index].image.zoomImage
                    # Whenever the image gets resized, update skrollr
                    # Only bind this for the first image, otherwise we'll just fire it multiple times
                    resizeCallbackAfter: if index==0 then ->
                        if skrollr?
                          if skrollr.get()
                            skrollr.get().refresh()
                    else $.noop
                    # Before the image gets resized, recalculate the xMargin
                    useMarginFunctions: true
                    initialAnimation: false
                    getXOverride: =>
                        @getXMargin(@data.currentSlide)
                    revealImages: false    
                
            # Re-scroll skrollr if needed
            skrollr?.menu?.jumpToInitialPos()
            
            # Goto first slide with no animation
            @_gotoYear(0, false)
        
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
        if 0 <= slide < @data.noSlides
            # Get all the list items (the slides)
            $slides = @data.groupInfo[@data.currentYear].descUL.children("li")
            $thisSlide = $slides.eq(slide)
            $groupListLinks = @data.groupInfo[@data.currentYear].nav.children("a")
            
            # Hide all slides
            $slides.hide()
        
            # Show the correct one
            $thisSlide.show()
            
            # Set the person's name
            @data.personHeading.html $thisSlide.data("person")
            
            # Remove all 'active' classes from person list
            $groupListLinks.removeClass('active')
            
            # Add 'active' class to correct person
            $groupListLinks.eq(slide).addClass('active')
            
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
            @data.groupInfo[@data.currentYear].image.data("plugin_zoomImage").resize(animation)
    
    Plugin::_prevYear = ->
        
        # Call @_gotoYear with animation
        if @data.currentYear != 0
            @_gotoYear(@data.currentYear - 1, true)
        
    Plugin::_nextYear = ->
        
        # Call @_gotoYear with animation
        if @data.currentYear < @data.noYears - 1
            @_gotoYear(@data.currentYear + 1, true)
            
    # Goto the given 0-based year, at the initial slide
    Plugin::_gotoYear = (year, animation) ->
        
        # Check the argument is valid
        if 0 <= year < @data.groupInfo.length
            
            # Rest of this method, to be passed as callback to the image loader
            continuation = =>
                
                # Get all images, description uls and navs
                images = $()
                descs = $()
                navs = $()
            
                $.each @data.groupInfo, (i) =>
                    images = images.add @data.groupInfo[i].image
                    descs = descs.add @data.groupInfo[i].descUL
                    navs = navs.add @data.groupInfo[i].nav
            
                # Hide all of these
                images.add(descs).add(navs).hide()
            
                # Show just the requested one
                images.eq(year).show()
                descs.eq(year).show()
                navs.eq(year).show()
                
                # Update year display
                @data.yearHeading.html @data.groupInfo[year].year
            
                # Update year
                @data.currentYear = year
            
                # Update noSlides
                @data.noSlides = @data.groupInfo[year].descUL.children("li").length
            
                # Hide the arrow if we've reached far left/right
                if year == 0
                  @data.minusArrow.hide()
                  @data.plusArrow.show()
                else if year == @data.noYears - 1
                  @data.minusArrow.show()
                  @data.plusArrow.hide()
                else
                  @data.minusArrow.show()
                  @data.plusArrow.show()
            
                # Goto initial slide
                @_goto @data.groupInfo[year].firstSlide, animation
            
            # See if the next image has been loaded already and load it if not
            if not @data.groupInfo[year].imageLoaded
                @loadImage(year, continuation)
            else
                continuation()
            
            @
            
    Plugin::getXMargin = (slide) ->
        
        # Calculate the left margin value required for the image. 
        # Remember, this is a percentage of the parent's width
        # This should cause the image to go evenly between the far left and the far right when in horizontal mode
        
        # The far left value = 0
        # The far right value = - (imgWidth - parentWidth) / parentWidth * 100
        #                     = - (imgWidth/parentWidth - 1) * 100
        
        imgWidth = @data.groupInfo[@data.currentYear].image.width()
        parentWidth = $(@element).width()
        # =>
        farRight = - (imgWidth / parentWidth - 1) * 100
        
        # We want to go somewhere between max and min, depending on which slide we're on:
        xMargin = 0 + farRight * slide / (@data.noSlides - 1)
        
        return xMargin
    
    # loadimage(year, callback) 
    # year: 0-based index of the year needed in groupInfo
    # callback: function to execute after image is loaded
    # Load and display the image for the given year
    Plugin::loadImage = (year, callback) ->
        
        # Get the element and the image src
        $image = @data.groupInfo[year].image
        src = $image.data("original")
        
        # Create an img element to load the image so that the browser has it in the cache
        $('<img />')
            # When this virtual img is loaded, set the slideshow's src to the same so that we see it
            .one "load.#{@_name}", =>
                                
                # Set the callback to execute after new load
                $image.one "load", ->
                    callback()
                    
                # Then trigger the image update
                $image.attr "src", src
                
            # Actually do the loading
            .attr "src", src
                
        
        
        # Mark the image as loaded so this doesn't run again
        @data.groupInfo[year].imageLoaded = true
        
        
    # Plugin constructor
    $.fn[pluginName] = (options) ->
      @each ->
        if !$.data(@, "plugin_#{pluginName}")
          $.data(@, "plugin_#{pluginName}", new Plugin(@, options))
    
)(jQuery, window, document)
