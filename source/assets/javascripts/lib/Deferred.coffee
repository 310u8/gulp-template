# $.timeout 1000
#   .then =>
#     console.log '1000'
#     return $.timeout 1000
#   .then =>
#     console.log '2000'
#
# $.interval 1000
#   .when =>
#     console.log '1000'

module.exports = class Deferred

  constructor : ->
    @timeout()
    @interval()

  timeout : =>
    $.timeout = (msec) =>
      d = new $.Deferred
      p = d.promise()

      timerId = setTimeout =>
        d.resolve()
      ,msec

      p.clear = () ->
        clearTimeout timerId
        d.rejectWith()

      return p

  interval : =>
    $.interval = (msec) =>
      d = new $.Deferred
      p = d.promise()

      timerId = setInterval =>
        d.notifyWith()
      ,msec

      p.clear = () =>
        clearInterval timerId
        d.rejectWith()

      return p