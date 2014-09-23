
do ($ = jQuery, window, document) ->

    # Create the defaults once
    pluginName = "expandable"
    defaults =
        expandControl : null
        shortSection : null
        longSection : null
        container : null
        toggleCallback : $.noop
        
    data = 
        expandControl : null
        shortSection : null
        longSection : null
        container : null
        
    # The actual plugin constructor
    class Plugin
        constructor: (@element, options) ->
            
            init = =>
                $element = $(@element)

                # Find the controlling link if not given. Look first for a child of the .expandable section
                # If not found, look at the siblings
                if @settings.expandControl?
                    @data.expandControl = @settings.expandControl
                else
                    @data.expandControl = $(@element).children('.expandSection')
                    if @data.expandControl.length == 0
                        @data.expandControl = $element.siblings('.expandSection')
        
                # If we found a controlling link...
                if @data.expandControl.length != 0
            
                    # Look for the two divs containing the shrunk and the expanded display & the parent
                    # Also find the arrow if present
                    @data.shortSection = @settings.shortSection ? $element.children('.shrunk')
                    @data.longSection = @settings.longSection ? $element.children('.expanded')
                    @data.container = @settings.container ? @data.shortSection.parent()
                    @data.arrow = @settings.arrow ? @data.expandControl.children('.fa.fa-arrow-down')
            
                    @data.longSection
                        .addClass 'hidden'
                        .hide()
            
                    # Register a click handler to toggle their visibility
                    @data.expandControl.on "click.expansion", (e) =>
                
                        # Toggle their visibilities
                        if @data.longSection.hasClass("hidden")
                            # Mark it as hidden for this script
                            @data.shortSection.addClass 'hidden'
                            @data.longSection.removeClass 'hidden'
                    
                            # Hide / show them
                            @data.shortSection.slideUp
                                duration: 500
                                complete: @settings.toggleCallback()
                            @data.longSection.slideDown
                                duration: 500
                                complete: @settings.toggleCallback()
                        
                            # Put the view back to the section top
                            scrollTo @data.container, 500
                    
                            # Change the arrow
                            @data.arrow
                                .addClass "fa-arrow-up"
                                .removeClass "fa-arrow-down"
                        else
                            @data.shortSection.removeClass 'hidden'
                            @data.longSection.addClass 'hidden'
                            @data.shortSection.slideDown
                                duration: 500
                                complete: @settings.toggleCallback()
                            @data.longSection.slideUp
                                duration: 500
                                complete: @settings.toggleCallback()
                    
                            # Put the view back to the section top
                            scrollTo @data.container, 500
                    
                            @data.arrow
                                .addClass "fa-arrow-down"
                                .removeClass "fa-arrow-up"
                        
                        # Prevent default link action
                        e.preventDefault()
                else
                    # No controlling element found
                    console.log "No .expandSection control found for section:"
                    console.log this
                    console.log "This should be either a child or sibling of the .expandable element"

            # Function to scroll to an object
            scrollTo = (selector, delay) ->
                # Default 200ms delay
                delay = 200 unless delay?
                
                # Do the scroll
                $('html, body').animate
                    scrollTop: $(selector).offset().top
                , delay
                
            
            @settings = $.extend {}, defaults, options
            @_defaults = defaults
            @_name = pluginName
            @data = $.extend {}, data
            init()

    # A really lightweight plugin wrapper around the constructor,
    # preventing against multiple instantiations
    $.fn[pluginName] = (options) ->
        @each ->
            unless $.data @, "plugin_#{pluginName}"
                $.data @, "plugin_#{pluginName}", new Plugin @, options