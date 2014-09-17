---
---
# Note that when compiling with coffeescript, the plugin is wrapped in another
# anonymous function. We do not need to pass in undefined as well, since
# coffeescript uses (void 0) instead.
do ($ = jQuery, window, document) ->

    # window and document are passed through as local variable rather than global
    # as this (slightly) quickens the resolution process and can be more efficiently
    # minified (especially when both are regularly referenced in your plugin).

    # Create the defaults once
    pluginName = "tabGroups"
    defaults =
        links: null
        tabs: null
        
    data = 
        links: null
        tabs: null

    # The actual plugin constructor
    class Plugin
        constructor: (@element, options) ->
            # jQuery has an extend method which merges the contents of two or
            # more objects, storing the result in the first object. The first object
            # is generally empty as we don't want to alter the default options for
            # future instances of the plugin
            @settings = $.extend {}, defaults, options
            @_defaults = defaults
            @_name = pluginName
            @data = $.extend {}, data
            @init()

        init: ->
            $element = $(@element)
            
            @data.links = @settings.links ? $element.find(".tabmenu a")
            @data.tabs = @settings.tabs ? $element.find(".tabs .tab")
            
            # Disable all the links in case there aren't the same number of links/tabs (user error):
            @data.links.click ->
                false
            
            # Set slider to the first tab if it isn't already
            @showTab @data.links.first(), @data.tabs.first()
        
            # Click handler for links, to move to the appropriate tab
            clickHandler = (e) =>
                # Get the clicked link from the click event
                clickedLink = $(e.target)
                
                # Call the show tab function, retrieving the associated tab that we saved earlier
                @showTab clickedLink, clickedLink.data("#{pluginName}_myTab")
            
                # Disable normal link action
                return false
            
            # Loop over all links / tabs until we run out of either (hopefully both)
            i = 0
            while @data.links.size() > i && @data.tabs.size() > i
        
                # The current link
                theLink = @data.links.eq(i)
            
                # Store the associated tabs with the links
                theLink.data("#{pluginName}_myTab", @data.tabs.eq(i))
            
                # Bind click handler
                theLink.click clickHandler
            
                # Increment    
                i++
            
    # Define function to show a tab
    Plugin::showTab = (link, tab) ->
        
        # Disable all links and tabs
        @data.links.removeClass('active')
        @data.tabs.removeClass('active')
    
        # Enable the correct two
        link.addClass('active')
        tab.addClass('active')

    # A really lightweight plugin wrapper around the constructor,
    # preventing against multiple instantiations
    $.fn[pluginName] = (options) ->
        @each ->
            unless $.data @, "plugin_#{pluginName}"
                $.data @, "plugin_#{pluginName}", new Plugin @, options
