module.exports = (robot) ->
  addMissionBar = (msg) ->
    user = msg.message.user.name.toLowerCase()
    robot.brain.data.missionBarers ?= []
    robot.brain.data.missionBarers.push user if user not in robot.brain.data.missionBarers
    msg.send "OK #{user}, I've signed you up for mission bar"

  removeMissionBar = (msg) ->
    user = msg.message.user.name.toLowerCase()
    robot.brain.data.missionBarers ?= []
    useridx = robot.brain.data.missionBarers.indexOf(user)
    if useridx != -1
      robot.brain.data.missionBarers.splice(useridx, 1)
    msg.send "OK #{user}, you hate freedom"

  barfMissionBar = (msg) ->
    msg.send robot.brain.data.missionBarers.join(" ")
    msg.send "(ノﾟοﾟ)ノﾐ★゜・。。・゜゜・。。・゜☆゜・。。・゜゜・。。・゜゜・。。・゜☆゜・。。・゜゜・。。・゜ IIIIIIIIIIIIIIIIITTTTT'S MISSION BAR TIME"

  robot.respond /mission bar time/i, (msg) ->
    barfMissionBar msg

  robot.respond /who is mission bar/i, (msg) ->
    barfMissionBar msg

  robot.respond /mission bar me/i, (msg) ->
    addMissionBar msg

  robot.respond /i love mission bar/i, (msg) ->
    addMissionBar msg

  robot.respond /i hate mission bar/i, (msg) ->
    removeMissionBar msg
