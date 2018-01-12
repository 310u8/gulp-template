# replaceImg = new ReplaceImg
#
# replaceImg.replace $('img'), =>
#   console.log 'done'

module.exports = class ReplaceImg

  constructor : ->

  replace : ($img, func) =>
    device = if _ua.pc then 'pc' else 'sp'

    $img.each (i) ->
      if $(@).data('src')?
        if !$(@).data('device')? || $(@).data('device') == device
          $(@).attr('src', $(@).data('src').replace('device', device))

      if i == $img.length - 1
        func() if func?