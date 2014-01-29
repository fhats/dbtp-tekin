# 2 *s

module.exports = (robot) ->
  robot.hear /\b(two|2)\s+((\w+[^s])*(\w+))'?s\b/i, (msg) ->
    msg.send "2 "+msg.match[2].toUpperCase()+"Z!!"
