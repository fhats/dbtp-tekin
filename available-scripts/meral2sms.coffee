fs = require "fs"
path = require "path"
random = require("./random")
twilio = require("twilio")

sms_chance = 5

module.exports = (robot) ->
  robot.hear //, (msg) ->
    if msg.message.user.name == "meral" and random.randrange(0, sms_chance) == 1
      fileName = path.join process.cwd(), "phones"
      twilio_sid = fs.readFileSync("/etc/twilio_sid", "utf-8").replace(/\n$/, '')
      twilio_token = fs.readFileSync("/etc/twilio_token", "utf-8").replace(/\n$/, '')
      twilio_number = fs.readFileSync("/etc/twilio_number", "utf-8").replace(/\n$/, '')
      fs.readFile fileName, (err, file) ->
        if (err)
          throw err
        else
          phones = JSON.parse(file)
          client = new twilio.RestClient(twilio_sid, twilio_token)
          client.sms.messages.create({
            to: random.choice(phones)
            from: twilio_number,
            body:msg.message.text
            }, (error, message) ->
              if (error)
                msg.send ('Oops! There was an error.');
                msg.send error.message
          )
