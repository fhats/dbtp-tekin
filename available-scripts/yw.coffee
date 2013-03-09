# welcoming

thankseses = ["you got it buddy", ":)", "welcome!", "I serve the user"]

module.exports = (robot) ->
  robot.respond /thank you$/i, (msg) ->
    msg.reply msg.random thankseses

  robot.respond /thanks$/i, (msg) ->
    msg.reply msg.random thankseses

  robot.hear /^thanks tekin/i, (msg) ->
    msg.reply msg.random thankseses

  robot.hear /^thank you tekin/i, (msg) ->
    msg.reply msg.random thankseses
