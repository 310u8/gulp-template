# scrollManager.init()
#
# func = ->
#   console.log scrollManager.top
#
# scrollManager.on func
# scrollManager.off func

module.exports = class ScrollManager

  constructor : ->
    @funcs = []
    @top = 0

  init : =>
    throttle = _.throttle @scroll, 100
    $(window).on 'scroll', throttle

  scroll : =>
    if @funcs.length > 0
      @top = $(window).scrollTop()

      for func in @funcs
        func()

  on : (func) =>
    @funcs.push func

  off : (func) =>
    @funcs.splice func, 1
