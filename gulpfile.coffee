#------------------------------------------
# modules
#------------------------------------------
gulp = require 'gulp'
pug = require 'gulp-pug'
sass = require 'gulp-sass'
webpack = require 'webpack'
webpackStream = require 'webpack-stream'
svgmin = require 'gulp-svgmin'
plumber = require 'gulp-plumber'
autoprefixer = require 'gulp-autoprefixer'
concat = require 'gulp-concat'
minifyCss = require 'gulp-minify-css'
iconfontCss = require 'gulp-iconfont-css'
iconfont = require 'gulp-iconfont'
browserSync = require 'browser-sync'
rimraf = require 'rimraf'

#------------------------------------------
# path
#------------------------------------------
path =
  source:
    root: './source/'
    stylesheets: './source/assets/stylesheets/'
    javascripts: './source/assets/javascripts/'
    images: './source/assets/images/'
    fonts: './source/assets/fonts/'
    icons: './source/assets/icons/'

  build:
    root: './build/'
    stylesheets: './build/assets/stylesheets/'
    javascripts: './build/assets/javascripts/'
    images: './build/assets/images/'
    fonts: './build/assets/fonts/'

#------------------------------------------
# task
#------------------------------------------
#clean
gulp.task 'clean', (cb) ->
  rimraf path.build.root, cb

#html(pug)
gulp.task 'pug', ->
  gulp.src [path.source.root + '**/*.pug', '!' + path.source.root + '**/_*.pug']
    .pipe plumber()
    .pipe pug
      basedir: path.source.root
    .pipe gulp.dest path.build.root

#css(sass)
gulp.task 'sass', ->
  gulp.src path.source.stylesheets + 'pc/*.sass', {sourcemaps:true}
    .pipe sass().on 'error', sass.logError
    .pipe autoprefixer()
    .pipe concat 'style.css'
    .pipe minifyCss keepSpecialComments: 0
    .pipe gulp.dest path.build.stylesheets + 'pc/'
    .pipe browserSync.stream()

  gulp.src path.source.stylesheets + 'sp/*.sass', {sourcemaps:true}
    .pipe sass().on 'error', sass.logError
    .pipe autoprefixer()
    .pipe concat 'style.css'
    .pipe minifyCss keepSpecialComments: 0
    .pipe gulp.dest path.build.stylesheets + 'sp/'
    .pipe browserSync.stream()

#javascript(webpack)
gulp.task 'webpack', =>
  return webpackStream
    entry: path.source.javascripts + 'app.coffee'
    output:
      filename: "app.js"
    module:
      rules: [
        test: /\.coffee?/,
        use: [
          'cache-loader',
          {
            loader: 'babel-loader',
            options:
              presets: ['@babel/preset-env']
          },
          'coffee-loader'
        ]
      ]
    optimization:
      minimize: true
    devtool: 'eval'
    stats:
      errorDetails: true
    mode: "development"
  ,webpack
    .on 'error', ->
      @emit 'end'
    .pipe gulp.dest path.build.javascripts

#image
gulp.task 'image', ->
  gulp.src path.source.images + '**/*'
    .pipe gulp.dest path.build.images

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
      fontPath: '../../fonts/'
    .pipe iconfont
      fontName: 'iconfont'
      prependUnicode: true
      formats: ['ttf', 'eot', 'woff', 'woff2', 'svg']
      timestamp: Math.round　Date.now()/1000
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
gulp.task 'watch', (done) ->
  reload = () ->
    browserSync.reload()
    done()
  gulp.watch(path.source.root + '**/*.pug').on 'change', gulp.series 'pug', reload
  gulp.watch(path.source.stylesheets + '**/*.sass').on 'change', gulp.task 'sass'
  gulp.watch(path.source.javascripts + '**/*').on 'change', gulp.series 'webpack', reload
  gulp.watch(path.source.images + '**/*').on 'change', gulp.series 'image', reload
  gulp.watch(path.source.icons + '**/*').on 'change', gulp.series 'iconfont', reload

#browserSync
gulp.task 'browserSync', (done) ->
  browserSync.init
    server:
      baseDir: path.build.root
    notify: false
    ghostMode: false
  done()

#default
gulp.task 'default', gulp.series('clean', 'iconfont', gulp.parallel('pug', 'sass', 'webpack', 'image', 'copy'), 'browserSync', 'watch')