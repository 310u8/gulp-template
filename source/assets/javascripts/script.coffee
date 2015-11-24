$ = window.jQuery = require './lib/jquery.min'
require './lib/jquery.easing.min'
require './lib/velocity.min'

_ua = navigator.userAgent
_sp = _ua.indexOf('iPhone') > -1 || _ua.indexOf('iPod') > -1 || _ua.indexOf('Android') > -1

$ ->