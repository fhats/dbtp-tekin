xml2js = require "xml2js"
parser = new xml2js.Parser()

christmas = (msg) ->
  msg.http("http://isitchristmas.com/rss.xml").get() (err, res, body) ->
    parser.parseString body, (err, result) ->
      if not err?
        msg.reply result.channel.item[0].title

friday = (msg) ->
  day = new Date().getDay()

  if day == 5
    msg.reply "hell yeah it is"
  else
    if day == 6
      day = -1
    diff = 5 - day
    msg.reply "only #{diff} day#{if diff != 1 then "s" else ""} left..."

nowtf = (msg) ->
  msg.reply "... no?"

russian_christmas = (msg) ->
  today = new Date()
  if today.getMonth() == 0 and today.getDate() == 7
    msg.reply "С Рождеством Христовым!"
  else
    msg.reply "нет"

drinkin_time = (msg) ->
  now = new Date()
  if now.getDay() != 5
    msg.reply "it's not even friday, you ninny"
  else
    hour = now.getHours()
    if hour >= 17
      msg.reply "hell yeah it is"
    else
      diff = 17 - hour
      msg.reply "only #{diff} hour#{if diff != 1 then "s" else ""} left..."

responders =
  "christmas": christmas
  "friday": friday
  "tomorrow": nowtf
  "yesterday": nowtf
  "russian christmas": russian_christmas
  "drinking time": drinkin_time
  "drinkin time": drinkin_time
  "scotch thirty": drinkin_time
  "beer o'clock": drinkin_time

module.exports = (robot) ->
  robot.respond /is it ([^?]+)/i, (msg) ->
    iswhat = msg.match[1]

    if iswhat.toLowerCase() of responders
      responders[iswhat] msg
