# resizeManager.init()
#
# func = ->
#   console.log resizeManager.width, resizeManager.height
# 
# resizeManager.on func
# resizeManager.off func

module.exports = class resizeManager

  constructor : ->
    @funcs = []
    @width = 0
    @height = 0

  init : =>
    $(window).on 'resize', =>
      if @funcs.length > 0
        @width = $(window).width()
        @height = $(window).height()

        for func in @funcs
          func()

  on : (func) =>
    @funcs.push func

  off : (func) =>
    @funcs.splice func, 1
