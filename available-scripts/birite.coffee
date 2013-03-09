# birite - tells you today's soft-serve flavors

module.exports = (robot) ->
  robot.respond /birite/i, (msg) ->
    msg.http('http://birite.herokuapp.com')
      .get() (err, res, body) ->
        msg.send "Today's soft-serve flavors: " + body
