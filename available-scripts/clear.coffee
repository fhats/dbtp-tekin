# Clear it out
#
# clear
# clear it out

module.exports = (robot) ->
  robot.respond /(clear|abort|clear it out|blast off)/i, (msg) ->
    fs = require 'fs'
    rocketship = fs.readFileSync('/usr/share/rocketship.txt')
    msg.send rocketship

