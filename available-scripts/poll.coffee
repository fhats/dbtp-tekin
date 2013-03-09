# Create polls
#
# start a poll: "question?" "option 1" "option 2" "option 3" ...
#
# max 5 options
#
# polls run for 5 minutes
#


pollTime = 300 # seconds
maxOptions = 5

poll = null

getResults = ->
  votes = (vote for vote in poll.votes)
  votes.sort((v1, v2) -> v2[1] - v1[1])

  return ("#{option}: #{num}" for [option, num] in votes).join(", ")

module.exports = (robot) ->
  robot.respond /start a poll:? "([^"]+)" ?(("[^"]+" ?)+)?$/, (msg) ->
    if poll
      return msg.reply "Sorry, a poll is already in progress"

    asker = msg.message.user.name
    question = msg.match[1]

    poll =
      asker: asker
      question: question
      votes: []
      whosvoted: {}

    if not msg.match[2]?
      options = ["yes", "no"]
    else
      opts = msg.match[2].split('"')
      options = (opt for opt in opts when opt.trim() isnt "")
      options = options[...maxOptions] # Trim to size

    if options.length == 1
      msg.reply "This isn't going to be a very interesting poll..."

    for option in options
      poll.votes.push [option, 0]

    msg.send "#{asker} wants to know: #{question}"

    for option, i in options
      msg.send("  #{i + 1}: #{option}")

    # Poll for pollTime sec
    poll.pollTimeout = setTimeout ->
      msg.send "final results: #{getResults()}"
      msg.reply "^"
      poll = null
    , pollTime * 1000

  robot.respond /vote (\d)$/, (msg) ->
    if not poll?
      return msg.reply "there isn't currently a poll in progress"

    userid = msg.message.user.id

    if userid of poll.whosvoted
      return msg.reply "you've already voted in this poll"


    vote = parseInt(msg.match[1]) - 1

    if not (vote of poll.votes)
      return msg.reply "that's not a valid option"

    poll.whosvoted[userid] = true

    poll.votes[vote][1] += 1

    msg.reply "vote counted for '#{poll.votes[vote][0]}'"

  robot.respond /results/, (msg) ->
    if not poll?
      return msg.reply "there isn't currently a poll in progress"

    msg.send "results: #{getResults()}"

  robot.respond /end poll/, (msg) ->
    if not poll?
      return msg.reply "there isn't currently a poll in progress"

    msg.send "final results: #{getResults()}"

    if poll.pollTimeout?
      clearTimeout poll.pollTimeout

    poll = null
