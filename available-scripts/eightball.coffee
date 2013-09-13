# eightball - act as a magic 8-ball
#

eightball = [
  "It is certain",
  "It is decidedly so",
  "Without a doubt",
  "Yes definitely",
  "You may rely on it",
  "As I see it yes",
  "Most likely",
  "Outlook good",
  "Yes",
  "Signs point to yes",
  "Reply hazy try again",
  "Ask again later",
  "Better not tell you now",
  "Cannot predict now",
  "Concentrate and ask again",
  "Don't count on it",
  "My reply is no",
  "My sources say no",
  "Outlook not so good",
  "Very doubtful",
]

module.exports = (robot) ->
  robot.hear /should i/i, (msg) ->
    msg.send msg.random eightball

  robot.hear /i should/i, (msg) ->
    msg.send msg.random eightball

  robot.respond /eightball/i, (msg) ->
    msg.send msg.random eightball
