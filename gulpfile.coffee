#------------------------------------------
# modules
#------------------------------------------
gulp = require 'gulp'
jade = require 'gulp-jade'
sass = require 'gulp-sass'
imagemin = require 'gulp-imagemin'
sourcemaps = require 'gulp-sourcemaps'
plumber = require 'gulp-plumber'
autoprefixer = require 'gulp-autoprefixer'
concat = require 'gulp-concat'
minifyCss = require 'gulp-minify-css'
uglify = require 'gulp-uglify'
watchify = require 'gulp-watchify'
buffer = require 'vinyl-buffer'
rename = require 'gulp-rename'
svgmin = require 'gulp-svgmin'
iconfontCss = require 'gulp-iconfont-css'
iconfont = require 'gulp-iconfont'
watch = require 'gulp-watch'
browserSync = require 'browser-sync'
runSequence = require 'run-sequence'
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
    fonts: 'source/assets/fonts/'
    icons: 'source/assets/icons/'

  build:
    root: 'build/'
    stylesheets: 'build/assets/stylesheets/'
    javascripts: 'build/assets/javascripts/'
    images: 'build/assets/images/'
    fonts: 'build/assets/fonts/'

#------------------------------------------
# task
#------------------------------------------
#clean
gulp.task 'clean', (cb) ->
  rimraf 'build/', cb

#html(jade)
gulp.task 'jade', ->
  gulp.src [path.source.root + '**/*.jade', '!' + path.source.root + '**/_*.jade']
    .pipe plumber()
    .pipe jade
      basedir: path.source.root
    .pipe gulp.dest path.build.root
    .pipe browserSync.stream()

#css(sass)
gulp.task 'sass', ->
  gulp.src path.source.stylesheets + '**/*.sass'
    .pipe sourcemaps.init()
    .pipe sass().on 'error', sass.logError
    .pipe autoprefixer 'last 2 version', 'ie 8', 'ie 9'
    .pipe concat 'style.css'
    .pipe minifyCss keepSpecialComments: 0
    .pipe sourcemaps.write './'
    .pipe gulp.dest path.build.stylesheets
    .pipe browserSync.stream()

#javascript(watchify)
gulp.task 'watchify', watchify (watchify) ->
  gulp.src path.source.javascripts + 'script.coffee'
    .pipe plumber()
    .pipe watchify
      watch: on
      debug: true
      extenstions: ['.coffee', '.js']
      transform : ['coffeeify']
    .pipe buffer()
    .pipe sourcemaps.init
      loadMaps: true
    .pipe rename
      extname: '.js'
    .pipe uglify()
    .pipe sourcemaps.write './'
    .pipe gulp.dest path.build.javascripts
    .pipe browserSync.stream()

#image
gulp.task 'imagemin', ->
  gulp.src path.source.images + '**/*'
    .pipe imagemin
      svgoPlugins: [removeViewBox: false]
    .pipe gulp.dest path.build.images
    .pipe browserSync.stream()

#iconfont
gulp.task 'iconfont', ->
  svgminData = gulp.src path.source.icons + '*.svg'
    .pipe svgmin()

  svgminData
    .pipe plumber()
    .pipe iconfontCss
      fontName: 'iconfont'
      path: path.source.icons + '_icons.scss'
      targetPath: '../stylesheets/_icons.scss'
      fontPath: '../fonts/'
    .pipe iconfont
      fontName: 'iconfont'
      formats: ['ttf', 'eot', 'woff', 'svg']
      appendCodepoints: false
    .pipe gulp.dest path.source.fonts
    .on 'end', ->
      gulp.src path.source.fonts + '**/*'
        .pipe gulp.dest path.build.fonts

#copy
gulp.task 'copy', ->
  gulp.src path.source.root + '.htaccess'
   .pipe gulp.dest path.build.root

#watch
gulp.task 'watch', ->
  watch path.source.root + '**/*.jade', ->
    gulp.start 'jade'
  watch path.source.stylesheets + '**/*.sass', ->
    gulp.start 'sass'
  watch  path.source.images + '**/*', ->
    gulp.start 'imagemin'
  watch path.source.icons + '**/*', ->
    gulp.start 'iconfont'

#browserSync
gulp.task 'browserSync', ->
  browserSync.init null,
  server:
    baseDir: path.build.root
  notify: false

#default
gulp.task 'default', ->
  runSequence 'clean', 'iconfont', ['jade', 'sass', 'watchify', 'imagemin', 'copy'], 'browserSync', 'watch'