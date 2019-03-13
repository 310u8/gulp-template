window.$ = window.jQuery = require 'jquery'
window.velocity = require 'velocity-animate'

UserAgent = require './lib/UserAgent.coffee'
Deferred = require './lib/Deferred.coffee'
Preload = require './lib/Preload.coffee'
ResizeManager = require './lib/ResizeManager.coffee'
ScrollManager = require './lib/ScrollManager.coffee'

window._ua = new UserAgent
window.deferred = new Deferred
window.preload = new Preload
window.resizeManager = new ResizeManager
window.scrollManager = new ScrollManager

$ ->