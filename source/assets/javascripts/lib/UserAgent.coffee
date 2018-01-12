# _ua.browser
# _ua.device
# _ua.pc
# _ua.sp

module.exports = class UserAgent

  constructor : ->
    @vars = {}
    @ua = window.navigator.userAgent.toLowerCase()
    @ver = window.navigator.appVersion.toLowerCase()

    @getBrowser()
    @getDevice()
    @isPc()
    @isSp()

    return @vars

  getBrowser : =>
    @vars.browser = do =>
      if @ua.indexOf('edge') != -1
        return 'edge'
      else if @ua.indexOf('trident/7') != -1
        return 'ie11'
      else if @ua.indexOf('msie') != -1 && @ua.indexOf('opera') == -1
        if @ua.indexOf('msie 9.') != -1
          return 'ie9'
        else if @ua.indexOf('msie 10.') != -1
          return 'ie10'
      else if @ua.indexOf('chrome') != -1 && @ua.indexOf('edge') == -1
        return 'chrome'
      else if @ua.indexOf('safari') != -1 && @ua.indexOf('chrome') == -1
        return 'safari'
      else if @ua.indexOf('firefox') != -1
        return 'firefox'
      else if @ua.indexOf('opera') != -1
        return 'opera'
      else
        return ''

  getDevice : =>
    @vars.device = do =>
      if @ua.indexOf('iphone') != -1　|| @ua.indexOf('ipod') != -1
        return 'iphone'
      else if @ua.indexOf('ipad') != -1
        return 'ipad'
      else if @ua.indexOf('android') != -1
        return 'android'
      else
        return ''

  isPc : =>
    @vars.pc = do =>
      unless @vars.device == 'iphone' || @vars.device == 'android'
        return true
      else
        return false

  isSp : =>
    @vars.sp = do =>
      if @vars.device == 'iphone' || @vars.device == 'android'
        return true
      else
        return false