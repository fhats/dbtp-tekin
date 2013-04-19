# Make hubot a sweet emcee
#
# what it is

module.exports = (robot) ->
  robot.hear /what it is/i, (msg) ->
    msg.send "what it do"
