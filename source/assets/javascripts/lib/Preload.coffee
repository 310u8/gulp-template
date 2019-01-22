# preload = new Preload
#
# imgs = preload.search $('img')
#
# p = preload.load imgs
# p.done =>
#   console.log 'done'

module.exports = class Preload

  constructor : ->

  search : ($img) =>
    imgs = []

    $img.each ->
      if $(@).is 'img'
        imgs.push $(@).attr 'src' if $(@).attr('src')?
      else if $(@).css('background-image') != 'none'
        unless $(@).css('background-image').match(/linear-gradient/)
          imgs.push $(@).css('background-image').replace /(url\(|\)|")/g, ''

    return imgs

  load : (imgs) =>
    p = []
    d = new $.Deferred
    isComp = false

    for i, val of imgs
      do =>
        d2 = new $.Deferred
        img = new Image()

        img.onload = ->
          d2.resolve()
          d2 = null

        img.onerror = =>
          d2.reject()
          d2 = null

        img.src = val
        p.push d2.promise()

    $.when.apply(null, p).done =>
      unless isComp
        isComp = true
        d.resolve()

    $.when.apply(null, p).fail =>
      unless isComp
        isComp = true
        d.resolve()

    #timeout
    timerId = $.timeout 10000
      .then =>
        unless isComp
          isComp = true
          d.resolve()

    return d.promise()