gulp = require "gulp"

# Import all gulp plugins as a single object.
plugins = (require "gulp-load-plugins")()

tasks =
    default: "default"
    help: "help"
    watch: "watch"

paths =
    coffee: "coffee/*.coffee"
    dest: "static/"

# Task listing via gulp help.
gulp.task tasks.help, plugins.taskListing

# Default task that compiles CoffeeScript.
gulp.task tasks.default, ->
    gulp
        .src paths.coffee
        .pipe plugins.sourcemaps.init()
        .pipe plugins.coffee {}
        .pipe plugins.sourcemaps.write()
        .pipe gulp.dest paths.dest

# Watch command to compile CoffeeScript changes on save.
gulp.task tasks.watch, ->
    gulp.watch paths.coffee, [tasks.default]
