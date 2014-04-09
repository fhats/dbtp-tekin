# Give a random response from a file.
# Useful for making random-quotes-from-TV-shows-and-comics

fs = require('fs')
path = require('path')

random_entry = (msg, filename) ->
  fileName = path.join process.cwd(), filename
  console.log fileName
  fs.readFile fileName, 'utf-8', (err, contents) ->

    entries = contents.split('\n')
    idx = Math.floor(Math.random() * entries.length)
    msg.send entries[idx]

module.exports = (robot) ->
  robot.respond /roast beef/i, (msg) ->
    random_entry(msg, 'ext/achewood/beefisms.txt')

  robot.respond /philippe/i, (msg) ->
    random_entry(msg, 'ext/achewood/philippe.txt')

  robot.respond /nice pete/i, (msg) ->
    random_entry(msg, 'ext/achewood/pete.txt')

  robot.respond /ray/i, (msg) ->
    random_entry(msg, 'ext/achewood/ray.txt')
