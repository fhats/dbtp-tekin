fs = require "fs"
path = require "path"
random = require("./random")
twilio = require("twilio")

sms_chance = 5
phone_chance = 5

twimlet_base = "http://twimlets.com/echo?Twiml="
twiml_start = "<Response><Say voice='man'>Please hold the line for an important message from Skynet.</Say><Say voice='alice'>"
twiml_end = "</Say><Say voice='man'>This has been a message from Skynet.</Say></Response>"

phone_numbers = "/opt/tekin/data/phones"

module.exports = (robot) ->
  robot.hear /barf (meral|phone)? numbers/i, (msg) ->
    fileName = phone_numbers
    fs.readFile fileName, (err, file) ->
      if (err)
        throw err
      else
        msg.send file

  robot.hear //, (msg) ->
    if msg.message.user.name == "meral" and random.randrange(0, sms_chance) == 1 and msg.message.text.indexOf("Error:") == -1
      fileName = phone_numbers
      twilio_sid = process.env.TWILIO_SID
      twilio_token = process.env.TWILIO_TOKEN
      twilio_number = process.env.TWILIO_NUMBER
      fs.readFile fileName, (err, file) ->
        if (err)
          throw err
        else
          phones = JSON.parse(file)
          client = new twilio.RestClient(twilio_sid, twilio_token)
          if random.randrange(0, phone_chance) == 1
            twiml = twiml_start + msg.message.text + twiml_end
            twimlet_url = twimlet_base + encodeURIComponent(twiml)
            client.calls.create({
              to: random.choice(phones)
              from: twilio_number,
              url: twimlet_url
              }, (error, message) ->
                if (error)
                  msg.send('Oops! Meral forgot how to phonecall.');
                  msg.send error.message
            )
          else:
            client.messages.create({
              to: random.choice(phones)
              from: twilio_number,
              body:msg.message.text
              }, (error, message) ->
                if (error)
                  msg.send ('Oops! There was an error.');
                  msg.send error.message
            )
