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
    fortunes = JSON.parse(robot.brain.get("fortunes")["fortunes"])
    msg.send random.choice(fortunes)

  robot.respond /add fortune\s+(.*)$/i, (msg) ->
    quotes = "#{msg.match[1]}\n%\n"
    log = fs.createWriteStream('quotes', {'flags': 'a'})
    log.end msg.match[1]
    log = fs.createWriteStream('quotes', {'flags': 'a'})
    log.end "\n"
    log = fs.createWriteStream('quotes', {'flags': 'a'})
    log.end "%"
    log = fs.createWriteStream('quotes', {'flags': 'a'})
    log.end "\n"
    robot.reply "I added your quote to the db."
