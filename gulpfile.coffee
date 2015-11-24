#------------------------------------------
# modules
#------------------------------------------
gulp = require 'gulp'
slim = require 'gulp-slim'
sass = require 'gulp-sass'
autoprefixer = require 'gulp-autoprefixer'
minifyCss = require 'gulp-minify-css'
uglify = require 'gulp-uglify'
concat = require 'gulp-concat'
plumber = require 'gulp-plumber'
imagemin = require 'gulp-imagemin'
watch = require 'gulp-watch'
runSequence = require 'run-sequence'
browserSync = require 'browser-sync'
browserify = require 'browserify'
watchify = require 'gulp-watchify'
rename = require 'gulp-rename'
rimraf = require 'rimraf'

#------------------------------------------
# path
#------------------------------------------
path =
  source:
    root: 'source/'
    stylesheets: 'source/assets/stylesheets/'
    javascripts: 'source/assets/javascripts/'
    images: 'source/assets/images/'

  build:
    root: 'build/'
    stylesheets: 'build/assets/stylesheets/'
    javascripts: 'build/assets/javascripts/'
    images: 'build/assets/images/'

#------------------------------------------
# task
#------------------------------------------
#clean
gulp.task 'clean', (cb) ->
  rimraf 'build/', cb

#html(slim)
gulp.task 'slim', ->
  gulp.src path.source.root + '*.slim'
    .pipe slim()
    .pipe gulp.dest path.build.root
    .pipe browserSync.stream()

#css(sass)
gulp.task 'sass', ->
  gulp.src path.source.stylesheets + '**/*.sass'
    .pipe sass().on 'error', sass.logError
    .pipe autoprefixer 'last 2 version', 'ie 8', 'ie 9'
    .pipe concat 'style.css'
    .pipe minifyCss keepSpecialComments: 0
    .pipe gulp.dest path.build.stylesheets
    .pipe browserSync.stream()

#javascript(watchify)
gulp.task 'watchify', watchify (watchify) ->
  gulp.src path.source.javascripts + 'script.coffee'
    .pipe plumber()
    .pipe watchify
      watch: on
      extenstions: ['.coffee', '.js']
      transform : ['coffeeify']
    .pipe rename
      extname: '.js'
    .pipe gulp.dest path.build.javascripts
    .pipe browserSync.stream()

#image
gulp.task 'imagemin', ->
  gulp.src path.source.images + '**/*'
    .pipe imagemin
      svgoPlugins: [removeViewBox: false]
    .pipe gulp.dest path.build.images
    .pipe browserSync.stream()

#copy
gulp.task 'copy', ->
  gulp.src path.source.root + '.htaccess'
   .pipe gulp.dest path.build.root

#watch
gulp.task 'watch', ->
  watch path.source.root + '*.slim', ->
    gulp.start 'slim'
  watch path.source.stylesheets + '**/*.sass', ->
    gulp.start 'sass'
  watch  path.source.images + '**/*', ->
    gulp.start 'imagemin'

#browserSync
gulp.task 'browserSync', ->
  browserSync.init null,
  server:
    baseDir: path.build.root
  notify: false

#default
gulp.task 'default', ->
  runSequence 'clean', ['slim', 'sass', 'watchify', 'imagemin', 'copy'], 'browserSync', 'watch'