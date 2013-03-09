# i should just move to portland
#
# when is it going to rain - tells you when it is going to rain
# weather - the next five days' weather

module.exports = (robot) ->
  weekdays = ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"]
  weekday_shorts = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
  weathers = [[/sun/i, '☀'], [/cloud|mist|fog/i, '☁'], [/(rain|drizzle)/i, '☂']]

  robot.respond /when( is|'s) it (going to|gonna) rain/i, (msg) ->
    msg.http("http://free.worldweatheronline.com/feed/weather.ashx?q=94103&format=json&num_of_days=5&key=b534fd980f220106111011")
      .get() (err, res, body) ->
        rains = false
        for day in JSON.parse(body).data.weather
          if day.precipMM >= 1.0
            msg.send "it's gonna rain on #{weekdays[(new Date(Date.parse(day.date))).getDay()]}: #{day.weatherDesc[0].value},  #{day.precipMM}mm."
            rains = true

        if !rains
          msg.send "it's not gonna rain this week"

#  robot.respond /weather( (\d{5}))?/i, (msg) ->
#    zip = msg.match[2] or "94103"

    msg.http("http://free.worldweatheronline.com/feed/weather.ashx?q=#{zip}&format=json&num_of_days=5&key=b534fd980f220106111011")
      .get() (err, res, body) ->
        weather_string = ""
        result = JSON.parse(body)

        if result.data.error?
          return msg.send "No data for #{zip}"

        for day in result.data.weather
          for regex_and_icon in weathers
            regex = regex_and_icon[0]
            icon = regex_and_icon[1]

            if regex.test day.weatherDesc[0].value
              weather_string += "#{weekday_shorts[(new Date(Date.parse(day.date))).getDay()]}: #{icon} #{day.tempMinF}F-#{day.tempMaxF}F | "
              break

        msg.send weather_string.substring(0, weather_string.length - 2)

  robot.respond /is it raining/i, (msg) ->
    msg.send "look out the damn window"
