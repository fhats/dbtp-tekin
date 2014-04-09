
module.exports = (robot) ->
  robot.hear /(same)/i, (msg) ->
    msg.send msg.match[1]
