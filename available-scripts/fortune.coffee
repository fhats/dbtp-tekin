# archived wisdom
#
# fortune - receive a nugget of dbtp history
#
# add fortune <fortune> - add a quote to the fortune database. spam this and fhats will kill you.
#

fs = require('fs')

module.exports = (robot) ->

  robot.respond /fortune( me)?/i, (msg) ->
    fs.readFile 'quotes', 'utf-8', (err, contents) ->
      entries = (entry for entry in contents.split('%') when entry.split('\n').length <= 5)
      idx = Math.floor(Math.random() * entries.length)
      msg.send entries[idx]

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
