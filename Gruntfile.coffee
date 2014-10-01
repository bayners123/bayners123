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
                    '.build/scripts_coffee.js': 'src/_js/*.coffee'
                    '.build/libs_coffee.js': ['src/_js/libs/load_jquery.coffee', 'src/_js/libs/*.coffee']

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
                src: ['src/_js/libs/*.js', '!src/_js/libs/skrollr*.js', '!src/_js/libs/jquery.min.js', '!src/_js/libs/Modernizr.js']
                dest: ".build/libs_raw.js"
            jquery: 
                src: 'src/_js/libs/jquery.min.js'
                dest: 'src/js/jquery.min.js'
            modernizr: 
                src : 'src/_js/libs/Modernizr.js'
                dest : 'src/js/Modernizr.js'
            skrollr:
                src: ['src/_js/libs/skrollr.min.js', 'src/_js/libs/skrollr*.js']
                dest: "src/js/skrollr.js"
            final:
                src: ["src/_js/build/libs_raw.js", ".build/libs_coffee.js", ".build/scripts_coffee.js"]
                dest: "src/js/output.js"
                
        uglify:
            build: 
                src: 'src/js/output.js'
                dest: 'src/js/output.min.js'
            skrollr:
                src: 'src/js/skrollr.js'
                dest: 'src/js/skrollr.min.js'
        
        jekyll:
            options:                           # Universal options
                bundleExec: true
                src : '<%= config.app %>/src'
                
            dist:                             # Target
                options:                         # Target options
                    dest: '<%= config.app %>/.site',
                    config: '<%= config.app %>/Jekyll-config.yml'
            
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
                        '<%= config.app %>/.site'
                    ]
                        
        watch: 
            livereload: 
                options: 
                    livereload: '<%= connect.options.livereload %>'
                
                files: [
                    '<%= config.app %>/.site/{,*/}*.html',
                    '.tmp/styles/{,*/}*.css',
                    '<%= config.app %>/.site/images/{,*/}*'
                ]
            jekyll:
                files: [
                    '<%= config.app %>/src/**',
                    
                    # '<%= config.app %>/**',
                    # '!<%= config.app %>/node_modules/**',
                    # '!<%= config.app %>/.*/**',
                    # '!<%= config.app %>/.site/**',
                    # '!<%= config.app %>/js/**'
                ]
                tasks:
                    ['build']
                    
                
        'sftp-deploy': 
          build: 
            auth: 
              host: 'linux.ox.ac.uk'
              port: 22
              authKey: 'oxford'
            
            cache: '.sftpCache.json'
            src: '.site'
            dest: 'public_html'
            exclusions: ['site/**/.DS_Store', 'site/**/Thumbs.db']
            serverSep: '/'
            concurrency: 4
            progress: true
        
                
    grunt.loadNpmTasks('grunt-sftp-deploy');
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
    grunt.registerTask('deploy', ['build', 'sftp-deploy'])
