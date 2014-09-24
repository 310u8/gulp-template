gulp = require 'gulp'
slim = require 'gulp-slim'
rubySass = require 'gulp-ruby-sass'
coffee = require 'gulp-coffee'
minifyCss = require 'gulp-minify-css'
autoprefixer = require 'gulp-autoprefixer'
imagemin = require 'gulp-imagemin'
uglify = require 'gulp-uglify'
concat = require 'gulp-concat'
plumber = require 'gulp-plumber'
connect = require 'gulp-connect'
browserSync = require 'browser-sync'
streamqueue = require 'streamqueue'
rimraf = require 'rimraf'

gulp.task 'clean', (cb) ->
  rimraf './build/', cb

gulp.task 'browserSync', ->
  browserSync.init null,
    server:
      baseDir: './build/'

gulp.task 'slim', ->
  gulp.src './source/*.slim'
    .pipe slim()
    .pipe gulp.dest './build/'
    .pipe browserSync.reload stream:true

gulp.task 'sass', ->
  streamqueue objectMode: true,
      gulp.src './source/assets/stylesheets/lib/*.css'
      gulp.src './source/assets/stylesheets/**/*.sass', !'./source/assets/stylesheets/**/mixin.sass'
        .pipe plumber()
        .pipe rubySass
          noCache: true
        .pipe autoprefixer 'last 2 version', 'ie 8', 'ie 9'
    .pipe concat 'style.css'
    .pipe minifyCss keepSpecialComments: 0
    .pipe gulp.dest './build/assets/stylesheets/'
    .pipe browserSync.reload stream:true

gulp.task 'coffee', ->
  gulp.src './source/assets/javascripts/**/*.coffee'
  .pipe plumber()
  .pipe coffee()
  .pipe uglify()
  .pipe gulp.dest './build/assets/javascripts/'
  .pipe browserSync.reload stream:true

gulp.task 'javascript', ->
  streamqueue objectMode: true,
      gulp.src './source/assets/javascripts/lib/jquery-1.11.1.min.js'
      gulp.src './source/assets/javascripts/lib/*.js'
    .pipe concat 'lib.js'
    .pipe uglify()
    .pipe gulp.dest './build/assets/javascripts/lib/'
    .pipe browserSync.reload stream:true

gulp.task 'imagemin', ->
  gulp.src './source/assets/images/**/*.{png,jpg,gif}'
    .pipe imagemin()
    .pipe gulp.dest '/build/assets/images/'
    .pipe browserSync.reload stream:true

gulp.task 'watch', ->
  gulp.watch './source/*.slim', ['slim']
  gulp.watch './source/assets/stylesheets/**/*.sass', ['sass']
  gulp.watch './source/assets/javascripts/**/*.coffee', ['coffee']
  gulp.watch './source/assets/images/**/*.{png,jpg,gif}', ['imagemin']

gulp.task 'connect', ->
  connect.server root: 'build'

gulp.task 'default', [
  'browserSync'
  'slim'
  'sass'
  'coffee'
  'javascript'
  'imagemin'
  'watch'
]