window.$ = require 'jquery'
velocity = require 'velocity-animate'

UserAgent = require './lib/UserAgent.coffee'
Deferred = require './lib/Deferred.coffee'
ReplaceImg = require './lib/ReplaceImg.coffee'
Preload = require './lib/Preload.coffee'

window._ua = new UserAgent
window.deferred = new Deferred

$ ->