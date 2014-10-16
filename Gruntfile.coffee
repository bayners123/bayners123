module.exports = (grunt) ->

    require('load-grunt-tasks')(grunt)
    
    # 1. All configuration goes here 
    grunt.initConfig
        pkg: grunt.file.readJSON('package.json')
        
        rsync_options: grunt.file.readJSON('.settings.json')
        
        settings:
            app: '.'
            devURL: 'http://localhost:9000'
            releaseURL: 'http://users.ox.ac.uk/~quee2327'
            
        coffee:
            build:
                files: 
                    '<%= settings.app %>/.build/scripts_coffee.js': '<%= settings.app %>/src/_js/*.coffee'
                    '<%= settings.app %>/.build/libs_coffee.js': ['<%= settings.app %>/src/_js/libs/load_jquery.coffee', '<%= settings.app %>/src/_js/libs/*.coffee']
        
        concat:
            # 2. Configuration for concatinating files goes here.
            rawLibs: # not skrollr or jquery or Modernizr
                src: ['<%= settings.app %>/src/_js/libs/*.js', '!<%= settings.app %>/src/_js/libs/skrollr*.js', '!<%= settings.app %>/src/_js/libs/jquery.min.js', '!<%= settings.app %>/src/_js/libs/Modernizr.js']
                dest: "<%= settings.app %>/.build/libs_raw.js"
            rawScripts: # Script files not in coffee format
                src: '<%= settings.app %>/src/_js/*.js'
                dest: '<%= settings.app %>/.build/scripts_raw.js'
            jquery: 
                src: '<%= settings.app %>/src/_js/libs/jquery.min.js'
                dest: '<%= settings.app %>/src/js/jquery.min.js'
            modernizr: 
                src : '<%= settings.app %>/src/_js/libs/Modernizr.js'
                dest : '<%= settings.app %>/src/js/Modernizr.js'
            skrollr:
                src: ['<%= settings.app %>/src/_js/libs/skrollr.min.js', '<%= settings.app %>/src/_js/libs/skrollr*.js']
                dest: "<%= settings.app %>/src/js/skrollr.js"
            final:
                src: ["<%= settings.app %>/.build/libs_raw.js", "<%= settings.app %>/.build/libs_coffee.js", "<%= settings.app %>/.build/scripts_raw.js", "<%= settings.app %>/.build/scripts_coffee.js"]
                dest: "<%= settings.app %>/.build/output.js"
            # Prepend YAML frontmatter
            YAML:
                src: ["<%= settings.app %>/src/_js/YAML-frontmatter.txt", "<%= settings.app %>/.build/output.js"]
                dest: "<%= settings.app %>/src/js/output.js"
            YAMLmin:
                src: ["<%= settings.app %>/src/_js/YAML-frontmatter.txt", "<%= settings.app %>/.build/output.min.js"]
                dest: "<%= settings.app %>/src/js/output.min.js"
                
        uglify:
            build: 
                src: '<%= settings.app %>/.build/output.js'
                dest: '<%= settings.app %>/.build/output.min.js'
            skrollr:
                src: '<%= settings.app %>/src/js/skrollr.js'
                dest: '<%= settings.app %>/src/js/skrollr.min.js'
        
        # Prepend YAML frontmatter
        file_append: 
            default_options:
                files:
                    '<%= settings.app %>/src/js/output.js':
                        input: '<%= settings.app %>/.build/output.js'
                        prepend: "---\n---\n"
                    '<%= settings.app %>/src/js/output.min.js':
                        input: '<%= settings.app %>/.build/output.min.js'
                        prepend: "---\n---\n"
                    
        
        jekyll:
            options:                           # Universal options
                # bundleExec: true
                src : '<%= settings.app %>/src'
                
            dist:                             # Target
                options:                         # Target options
                    dest: '<%= settings.app %>/.site',
                    config: '<%= settings.app %>/Jekyll-config.yml,<%= settings.app %>/.build/JekyllURL.yml'
            
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
                        '<%= settings.app %>/.site'
                    ]
                        
        watch: 
            livereload: 
                options: 
                    livereload: '<%= connect.options.livereload %>'
                
                files: [
                    '<%= settings.app %>/.site/{,*/}*.html',
                    '.tmp/styles/{,*/}*.css',
                    '<%= settings.app %>/.site/images/{,*/}*'
                ]
            jekyll:
                files: [
                    '<%= settings.app %>/src/**',
                    
                    # '<%= settings.app %>/**',
                    # '!<%= settings.app %>/node_modules/**',
                    # '!<%= settings.app %>/.*/**',
                    # '!<%= settings.app %>/.site/**',
                    # '!<%= settings.app %>/js/**'
                ]
                tasks:
                    ['build']
            
        rsync: 
                    options: 
                        # these are my preferred arguments when using rsync
                        args: ['-xzP', '--verbose', '--delete']
                        # an array of files you'd like to exclude; usual suspects...
                        exclude: ['.*']
                        recursive: true
                    
                    prod: 
                        options: 
                            # the dir you want to sync, in this case the current dir
                            src: '<%= settings.app %>/.site/'
                            # user pregenerated ssh keypairs
                            ssh: true
                            privateKey: ".key"
                            
                            # where should it be synced to on the remote host?
                            dest: "<%= rsync_options.user %>@<%= rsync_options.server %>:<%= rsync_options.path %>"
        
                            
    grunt.loadNpmTasks('grunt-rsync');
    grunt.loadNpmTasks('grunt-contrib-concat');
    grunt.loadNpmTasks('grunt-contrib-coffee');
    # grunt.loadNpmTasks('grunt-contrib-copy');
    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.loadNpmTasks('grunt-contrib-connect');
    grunt.loadNpmTasks('grunt-contrib-watch');
    
    grunt.loadNpmTasks('grunt-open');

    # 4. Where we tell Grunt what to do when we type "grunt" into the terminal.
    grunt.registerTask('concatting', ['concat:rawLibs', 'concat:rawScripts', 'concat:jquery', 'concat:modernizr', 'concat:skrollr', 'concat:final']);
        
    grunt.registerTask('default', ['setTarget:dev', 'build', 'serve']);
    grunt.registerTask('build', ['coffee', 'concatting', 'uglify', 'concat:YAML', 'concat:YAMLmin', 'jekyll']);
    grunt.registerTask('serve', ['connect:livereload', 'watch'])
    grunt.registerTask('deploy', ['setTarget:release', 'build', 'rsync'])
    
    grunt.registerTask 'setTarget', "Setup Jekyll for remote or local hosting", (target) ->
        # Output a YAML file for jekyll to use as config, specifying the URL
        switch target
            when "dev"
                content = "url: #{grunt.config("settings.devURL")}"
            when "release"
                content = "url: #{grunt.config("settings.releaseURL")}"
            
        grunt.file.write("#{grunt.config("settings.app")}/.build/JekyllURL.yml", content)
        console.log content
