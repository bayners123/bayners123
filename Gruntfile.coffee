module.exports = (grunt) ->

    require('load-grunt-tasks')(grunt)
    
    # 1. All configuration goes here 
    grunt.initConfig
        pkg: grunt.file.readJSON('package.json')
        
        config:
            app: '.'
            
        coffee:
            build:
                files: 
                    '_js/build/scripts_coffee.js': '_js/*.coffee'
                    '_js/build/libs_coffee.js': '_js/libs/*.coffee'

        # copy:
        #     build:
        #         files: [
        #             expand: true
        #             src: ['js/*.js', 'js/jquery_plugins/*.js']
        #             dest: 'js/build/coffeed/raw.js'
        #         ]
        
        concat:
            # 2. Configuration for concatinating files goes here.
            rawLibs: # not skrollr or jquery or Modernizr
                src: ['_js/libs/*.js', '!_js/libs/skrollr*.js', '!_js/libs/jquery.min.js', '!_js/libs/Modernizr.js']
                dest: "_js/build/libs_raw.js"
            jquery: 
                src: '_js/libs/jquery.min.js'
                dest: 'js/jquery.min.js'
            modernizr: 
                src : '_js/libs/Modernizr.js'
                dest : 'js/Modernizr.js'
            skrollr:
                src: ['_js/libs/skrollr.min.js', '_js/libs/skrollr*.js']
                dest: "_js/build/libs_skrollr.js"
            final:
                src: ["_js/build/libs_raw.js", "_js/build/libs_coffee.js", "_js/build/scripts_coffee.js"]
                dest: "js/output.js"
                
        uglify:
            build: 
                src: 'js/output.js'
                dest: 'js/output.min.js'
            skrollr:
                src: '_js/build/libs_skrollr.js'
                dest: 'js/skrollr.min.js'
        
        jekyll:
            options:                           # Universal options
                bundleExec: true
                src : '<%= config.app %>'
                
            dist:                             # Target
                options:                         # Target options
                    dest: '<%= config.app %>/_site',
                    config: '_config.yml'
            
        # The actual grunt server settings
        # See http://www.thecrumb.com/2014/03/16/using-grunt-for-live-reload-revisited/
        connect: 
            options: 
                port: 9000,
                livereload: 35729,
                hostname: 'localhost'
            
            livereload: 
                options: 
                    open: true,
                    base: [
                        '.tmp',
                        '<%= config.app %>/_site'
                    ]
                        
        watch: 
            livereload: 
                options: 
                    livereload: '<%= connect.options.livereload %>'
                
                files: [
                    '<%= config.app %>/_site/{,*/}*.html',
                    '.tmp/styles/{,*/}*.css',
                    '<%= config.app %>/_site/images/{,*/}*'
                ]
            jekyll:
                files: [
                    '<%= config.app %>/src/**',
                    
                    # '<%= config.app %>/**',
                    # '!<%= config.app %>/node_modules/**',
                    # '!<%= config.app %>/.*/**',
                    # '!<%= config.app %>/site/**',
                    # '!<%= config.app %>/js/**'
                ]
                tasks:
                    ['build']
                    
                
        # open:
        #     all:
        #     # Gets the port from the connect configuration
        #         path: 'http://localhost:<%= connect.options.port%>'
        
                
    # 3. Where we tell Grunt we plan to use this plug-in.
    grunt.loadNpmTasks('grunt-contrib-concat');
    grunt.loadNpmTasks('grunt-contrib-coffee');
    # grunt.loadNpmTasks('grunt-contrib-copy');
    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.loadNpmTasks('grunt-contrib-connect');
    grunt.loadNpmTasks('grunt-contrib-watch');
    
    grunt.loadNpmTasks('grunt-open');

    # 4. Where we tell Grunt what to do when we type "grunt" into the terminal.
    grunt.registerTask('default', ['build', 'serve']);
    grunt.registerTask('build', ['coffee', 'concat', 'uglify', 'jekyll']);
    grunt.registerTask('serve', ['connect:livereload', 'watch'])
