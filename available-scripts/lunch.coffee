module.exports = (robot) ->
  addLunch = (msg) ->
    user = msg.message.user.name.toLowerCase()
    robot.brain.data.lunchers ?= []
    robot.brain.data.lunchers.push user if user not in robot.brain.data.lunchers
    msg.send "OK #{user}, I've signed you up for lunch"

  removeLunch = (msg) ->
    user = msg.message.user.name.toLowerCase()
    robot.brain.data.lunchers ?= []
    useridx = robot.brain.data.lunchers.indexOf(user)
    if useridx != -1
      robot.brain.data.lunchers.splice(useridx, 1)
    msg.send "OK #{user}, you hate freedom"

  barfLunch = (msg) ->
    msg.send robot.brain.data.lunchers.join(" ")
    msg.send "(ノﾟοﾟ)ノﾐ★゜・。。・゜゜・。。・゜☆゜・。。・゜゜・。。・゜゜・。。・゜☆゜・。。・゜゜・。。・゜ IIIIIIIIIIIIIIIIITTTTT'S LUNCH TIME"

  robot.respond /lunchtime/i, (msg) ->
    barfLunch msg

  robot.respond /who is lunch/i, (msg) ->
    barfLunch msg

  robot.respond /lunch me/i, (msg) ->
    addLunch msg

  robot.respond /i love lunch/i, (msg) ->
    addLunch msg

  robot.respond /unlunch me/i, (msg) ->
    removeLunch msg

  robot.respond /i hate lunch/i, (msg) ->
    removeLunch msg
