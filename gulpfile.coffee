#------------------------------------------
# modules
#------------------------------------------
gulp = require 'gulp'
pug = require 'gulp-pug'
sass = require 'gulp-sass'
webpack = require 'webpack'
gulpWebpack = require 'gulp-webpack'
BowerWebpackPlugin = require 'bower-webpack-plugin'
imagemin = require 'gulp-imagemin'
jpegtran = require 'imagemin-jpegtran'
pngquant  = require 'imagemin-pngquant'
svgmin = require 'gulp-svgmin'
sourcemaps = require 'gulp-sourcemaps'
plumber = require 'gulp-plumber'
autoprefixer = require 'gulp-autoprefixer'
concat = require 'gulp-concat'
minifyCss = require 'gulp-minify-css'
iconfontCss = require 'gulp-iconfont-css'
iconfont = require 'gulp-iconfont'
watch = require 'gulp-watch'
cached = require 'gulp-cached'
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

#html(pug)
gulp.task 'pug', ->
  gulp.src [path.source.root + '**/*.pug', '!' + path.source.root + '**/_*.pug']
    .pipe plumber()
    .pipe pug
      basedir: path.source.root
    .pipe gulp.dest path.build.root
    .pipe browserSync.stream()

#css(sass)
gulp.task 'sass', ->
  gulp.src path.source.stylesheets + 'pc/*.sass'
    .pipe sourcemaps.init()
    .pipe sass().on 'error', sass.logError
    .pipe autoprefixer()
    .pipe concat 'style.css'
    .pipe minifyCss keepSpecialComments: 0
    .pipe sourcemaps.write './'
    .pipe gulp.dest path.build.stylesheets + 'pc/'
    .pipe browserSync.stream()

  gulp.src path.source.stylesheets + 'sp/*.sass'
    .pipe sourcemaps.init()
    .pipe sass().on 'error', sass.logError
    .pipe autoprefixer()
    .pipe concat 'style.css'
    .pipe minifyCss keepSpecialComments: 0
    .pipe sourcemaps.write './'
    .pipe gulp.dest path.build.stylesheets + 'sp/'
    .pipe browserSync.stream()

#javascript(webpack)
gulp.task 'webpack', =>
  gulp.src path.source.javascripts + 'app.coffee'
    .pipe gulpWebpack
      output:
        filename: 'app.js'
      devtool: 'source-map'
      resolve:
        extensions: ['', '.js', '.coffee']
        modulesDirectories: ['node_modules', 'bower_components']
      module:                                                     
        loaders:[
          {test: /\.coffee$/, loader: 'coffee-loader'}
          {test: /bower_components(\/|\\)(PreloadJS|SoundJS|EaselJS|TweenJS)(\/|\\).*\.js$/, loader: 'imports?this=>window!exports?window.createjs'}
        ]
      plugins:[
        new webpack.optimize.UglifyJsPlugin()
        new BowerWebpackPlugin()
      ]
    .pipe gulp.dest path.build.javascripts
    .pipe browserSync.stream()

#image
gulp.task 'imagemin', ->
  gulp.src path.source.images + '**/*'
    .pipe cached 'imagemin'
    .pipe imagemin([
      jpegtran
        quality: 80
      pngquant
        quality: 80
        speed: 1
      imagemin.svgo
        plugins: [removeViewBox: false]
      ])
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
  watch path.source.root + '**/*.pug', ->
    gulp.start 'pug'
  watch path.source.stylesheets + '**/*.sass', ->
    gulp.start 'sass'
  watch path.source.javascripts + '**/*', ->
    gulp.start 'webpack'
  watch path.source.images + '**/*', ->
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
  runSequence 'clean', 'iconfont', ['pug', 'sass', 'webpack', 'copy'], 'browserSync', 'watch'