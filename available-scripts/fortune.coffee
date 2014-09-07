# archived wisdom
#
# fortune - receive a nugget of dbtp history
#
# add fortune <fortune> - add a quote to the fortune database. spam this and fhats will kill you.
#

fs = require('fs')
random = require('./random')

module.exports = (robot) ->

  robot.respond /fortune( me)?/i, (msg) ->
    fortunes = robot.brain.data.fortunes
    msg.send random.choice(fortunes)

  robot.respond /add fortune\s+(.*)$/i, (msg) ->
    quotes = "#{msg.match[1]}"
    robot.brain.data.fortunes = robot.brain.data.fortunes
    msg.reply "I added your quote to the db."
