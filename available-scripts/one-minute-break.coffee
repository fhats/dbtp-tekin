# take a quick breather
#
# one minute break - take a quick break
#
module.exports = (robot) ->
        robot.hear /one minute break/i, (msg) ->
                msg.send('One minute break!')
                robot.shutdown()
                # note: does not work as expected
                setTimeout(robot.shutdown, 60000)
        robot.catchAll (msg) ->
                if Math.random() < (1 / 75)
                        msg.send('One minute break!')
