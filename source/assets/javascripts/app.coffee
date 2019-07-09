window.$ = window.jQuery = require 'jquery'
window.velocity = require 'velocity-animate'
window._ = require 'underscore'

UserAgent = require './lib/UserAgent.coffee'
Deferred = require './lib/Deferred.coffee'
Preload = require './lib/Preload.coffee'
NoScroll = require './lib/NoScroll.coffee'
ResizeManager = require './lib/ResizeManager.coffee'
ScrollManager = require './lib/ScrollManager.coffee'

window._ua = new UserAgent
window.deferred = new Deferred
window.preload = new Preload
window.noScroll = new NoScroll
window.resizeManager = new ResizeManager
window.scrollManager = new ScrollManager

$ ->