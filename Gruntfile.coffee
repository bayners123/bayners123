module.exports = (grunt) ->

    # 1. All configuration goes here 
    grunt.initConfig
        pkg: grunt.file.readJSON('package.json')
        
        coffee:
            build:
                files: 
                    'js/build/coffeed/scripts.js': 'js/*.coffee'
                    'js/build/coffeed/jquery_plugins.js': 'js/jquery_plugins/*.coffee'

        # copy:
        #     build:
        #         files: [
        #             expand: true
        #             src: ['js/*.js', 'js/jquery_plugins/*.js']
        #             dest: 'js/build/coffeed/raw.js'
        #         ]
        
        concat:
            # 2. Configuration for concatinating files goes here.
            rawJS: 
                src: ['js/*.js', 'js/jquery_plugins/*.js']
                dest: "js/build/coffeed/raw.js"
            final:
                src: "js/build/coffeed/*.js"
                dest: "js/build/output.js"
                
        uglify:
            build: 
                src: 'js/build/output.js'
                dest: 'js/build/output.min.js'
                
    # 3. Where we tell Grunt we plan to use this plug-in.
    grunt.loadNpmTasks('grunt-contrib-concat');
    grunt.loadNpmTasks('grunt-contrib-coffee');
    # grunt.loadNpmTasks('grunt-contrib-copy');
    grunt.loadNpmTasks('grunt-contrib-uglify');

    # 4. Where we tell Grunt what to do when we type "grunt" into the terminal.
    grunt.registerTask('default', ['coffee', 'concat', 'uglify']);
    grunt.registerTask('compile', ['coffee'])
    grunt.registerTask('min', ['uglify']);
