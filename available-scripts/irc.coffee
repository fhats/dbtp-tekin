# join and leave various channels
# currently everyone can do this

module.exports = (robot) ->
  robot.respond /join (.+)/, (msg) ->
    robot.adapter.bot.join(msg.match[1])
    msg.send "\x01ACTION joined #{msg.match[1]}\x01"

  robot.respond /leave\s?(.+)?/, (msg) ->
    if msg.match[1]?
      if msg.match[1] == "#tekin"
        msg.send "http://myfacewhen.com/images/325.gif"
      else
        msg.send "\x01ACTION left #{msg.match[1]}\x01"
        robot.adapter.bot.part(msg.match[1])
    else
      if msg.message.user.room == "#tekin"
        msg.send "http://myfacewhen.com/images/325.gif"
      else
        msg.send "\x01ACTION slinks away awkwardly\x01"
        robot.adapter.bot.part(msg.message.user.room)
