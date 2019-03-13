# imgs = preload.search $('body *')
#
# preload.divide imgs
#
# preload.load imgs,
#   'loaded': (img) =>
#     preload.set img
#   'complete':=>
#     console.log 'complete'

module.exports = class Preload

  constructor : ->

  search : ($img) =>
    imgs = []

    $img.each ->
      isImg = $(@).is('img')
      isBg = $(@).css('background-image') != 'none' && !$(@).css('background-image').match(/linear-gradient/)

      if isImg || isBg
        img = []
        img['$'] = $(@)

        if isImg
          if $(@).attr('data-src')?
            img['src'] = $(@).attr 'data-src'
          else if $(@).attr('src')?
            img['src'] = $(@).attr 'src'
        else if isBg
          img['src'] = $(@).css('background-image').replace /(url\(|\)|")/g, ''

        imgs.push img

    return imgs

  divide : (imgs) =>
    device = if _ua.pc then 'pc' else 'sp'

    for val in imgs
      val.src = val.src.replace 'device', device

  load : (imgs, func) =>
    p = []
    d = new $.Deferred
    isComp = false

    for i, val of imgs
      do (val) ->
        d2 = new $.Deferred
        img = new Image()

        img.onload = ->
          d2.resolve()
          func.loaded val

        img.onerror = ->
          d2.reject()

        img.src = val.src
        p.push d2.promise()

    $.when.apply(null, p).done ->
      unless isComp
        isComp = true
        d.resolve()

    $.when.apply(null, p).fail ->
      unless isComp
        isComp = true
        d.resolve()

    #timeout
    timerId = $.timeout 10000
      .then =>
        unless isComp
          isComp = true
          d.resolve()

    d.done ->
      func.complete()

    d.fail ->
      func.complete()

  set : (img) =>
    img.$.attr 'src', img.src if img.$.attr('data-src')?