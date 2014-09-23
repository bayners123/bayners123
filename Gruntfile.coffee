module.exports = (grunt) ->

    # 1. All configuration goes here 
    grunt.initConfig
        pkg: grunt.file.readJSON('package.json')
        
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
            rawLibs: # not skrollr or jquery
                src: ['_js/libs/*.js', '!_js/libs/skrollr*.js', '!_js/libs/jquery.min.js']
                dest: "_js/build/libs_raw.js"
            jquery: 
                src: '_js/libs/jquery.min.js'
                dest: 'js/jquery.min.js'
            skrollr:
                src: ['_js/libs/skrollr.min.js', '_js/libs/skrollr*.js']
                dest: "_js/build/libs_skrollr.js"
            final:
                src: ["_js/build/libs_raw.js", "_js/build/libs_coffee.js", "_js/build/scripts_coffee.js"]
                dest: "_js/build/output.js"
                
        uglify:
            build: 
                src: '_js/build/output.js'
                dest: 'js/output.min.js'
            skrollr:
                src: '_js/build/libs_skrollr.js'
                dest: 'js/skrollr.min.js'
                
    # 3. Where we tell Grunt we plan to use this plug-in.
    grunt.loadNpmTasks('grunt-contrib-concat');
    grunt.loadNpmTasks('grunt-contrib-coffee');
    # grunt.loadNpmTasks('grunt-contrib-copy');
    grunt.loadNpmTasks('grunt-contrib-uglify');

    # 4. Where we tell Grunt what to do when we type "grunt" into the terminal.
    grunt.registerTask('default', ['coffee', 'concat', 'uglify']);
    grunt.registerTask('compile', ['coffee'])
    grunt.registerTask('min', ['uglify']);
