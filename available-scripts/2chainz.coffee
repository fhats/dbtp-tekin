# 2 *s

module.exports = (robot) ->
  robot.hear /(two|2)\s+(\w+)s/i, (msg) ->
    msg.send "2 "+msg.match[2].toUpperCase()+"Z!!"
