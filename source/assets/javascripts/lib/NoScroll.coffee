# noScroll.on()
# noScroll.off()

module.exports = class NoScroll

  constructor : ->
    @$body = $('body')

  preventDefault : (e) =>
    e.preventDefault()

  on : =>
    @$body.css 'overflow':'hidden'
    document.addEventListener 'touchmove', @preventDefault, passive: false

  off : =>
    @$body.css 'overflow':'auto'
    document.removeEventListener 'touchmove', @preventDefault, passive: false