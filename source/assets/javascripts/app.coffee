$ = window.jQuery = require 'jquery'
createjs = require 'PreloadJS'
require 'velocity'

APP = {}
APP.sp = navigator.userAgent.indexOf('iPhone') > -1 || navigator.userAgent.indexOf('iPod') > -1 || navigator.userAgent.indexOf('Android') > -1
APP.ww = $(window).width()
APP.wh = $(window).height()

$ ->