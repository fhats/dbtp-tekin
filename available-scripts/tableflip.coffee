# flip you
#
# flip cats - flips cats

flip = require('../bin/flip')

module.exports = (robot) ->
  flippers = [
    "(╯°□°）╯︵",
    "(┛◉Д◉)┛彡",
    "ヽ(`Д´)ﾉ︵",
    "(ノಠ益ಠ)ノ彡",
    "(┛ò__ó)┛彡",
    " /(ò.ó)┛彡",
    "(┛❍ᴥ❍)┛彡",
  ]

  robot.respond /flip( (.+))?/i, (msg) ->
    flipped = if msg.match[2] then flip(msg.match[2]) else '┻━┻'
    idx = Math.floor(Math.random() * flippers.length)
    msg.send "\x01ACTION #{flippers[idx]} #{flipped}\x01"

  robot.respond /do a flip/i, (msg) ->
    msg.send "\x01ACTION (╯°□°）╯  ︵  ノ(.ᴗ. ノ)  ︵ ヽ(`Д´)ﾉ\x01"
