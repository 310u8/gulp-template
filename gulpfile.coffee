gulp = require 'gulp'
slim = require 'gulp-slim'
sass = require 'gulp-sass'
autoprefixer = require 'gulp-autoprefixer'
minifyCss = require 'gulp-minify-css'
coffee = require 'gulp-coffee'
uglify = require 'gulp-uglify'
concat = require 'gulp-concat'
plumber = require 'gulp-plumber'
imagemin = require 'gulp-imagemin'
watch = require 'gulp-watch'
runSequence = require 'gulp-run-sequence'
streamqueue = require 'streamqueue'
browserSync = require 'browser-sync'
rimraf = require 'rimraf'

gulp.task 'clean', (cb) ->
  rimraf 'build/', cb

gulp.task 'slim', ->
  gulp.src 'source/*.slim'
    .pipe slim()
    .pipe gulp.dest 'build/'
    .pipe browserSync.reload stream:true

gulp.task 'sass', ->
  streamqueue objectMode: true,
      gulp.src 'source/assets/stylesheets/lib/*.css'
      gulp.src 'source/assets/stylesheets/**/*.sass'
        .pipe plumber()
        .pipe sass sourceComments: 'normal'
        .pipe autoprefixer 'last 2 version', 'ie 8', 'ie 9'
    .pipe concat 'style.css'
    .pipe minifyCss keepSpecialComments: 0
    .pipe gulp.dest 'build/assets/stylesheets/'
    .pipe browserSync.reload stream:true

gulp.task 'coffee', ->
  gulp.src 'source/assets/javascripts/**/*.coffee'
    .pipe plumber()
    .pipe coffee()
    .pipe uglify()
    .pipe gulp.dest 'build/assets/javascripts/'
    .pipe browserSync.reload stream:true

gulp.task 'javascript', ->
  streamqueue objectMode: true,
      gulp.src 'source/assets/javascripts/lib/jquery.min.js'
      gulp.src 'source/assets/javascripts/lib/*.js'
    .pipe concat 'lib.js'
    .pipe uglify()
    .pipe gulp.dest 'build/assets/javascripts/lib/'
    .pipe browserSync.reload stream:true

gulp.task 'imagemin', ->
  gulp.src 'source/assets/images/**/*'
    .pipe imagemin
      svgoPlugins: [removeViewBox: false]
    .pipe gulp.dest 'build/assets/images/'
    .pipe browserSync.reload stream:true

gulp.task 'copy', ->
  gulp.src 'source/.htaccess'
    .pipe gulp.dest 'build/'

gulp.task 'watch', ->
  watch 'source/*.slim', ->
    gulp.start 'slim'
  watch 'source/assets/stylesheets/**/*.sass', ->
    gulp.start 'sass'
  watch 'source/assets/javascripts/**/*.coffee', ->
    gulp.start 'coffee'
  watch 'source/assets/javascripts/lib/*.js', ->
    gulp.start 'javascript'
  watch 'source/assets/images/**/*', ->
    gulp.start 'imagemin'

gulp.task 'browserSync', ->
  browserSync.init null,
    server:
      baseDir: 'build/'
    notify: false

gulp.task 'default', ->
  runSequence 'clean', ['slim', 'sass', 'coffee', 'javascript', 'imagemin', 'copy'], 'browserSync', 'watch'