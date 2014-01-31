fs = require "fs"
path = require "path"
random = require("./random")
twilio = require("twilio")

sms_chance = 5
phone_chance = 5

twimlet_base = "http://twimlets.com/echo?Twiml="
twiml_start = "<Response><Say voice='man'>Please hold the line for an important message from Skynet.</Say><Say voice='alice'>"
twiml_end = "</Say></Response>"


module.exports = (robot) ->
  robot.hear /barf (meral|phone)? numbers/i, (msg) ->
    fileName = path.join process.cwd(), "phones"
    fs.readFile fileName, (err, file) ->
      if (err)
        throw err
      else
        msg.send file

  robot.hear //, (msg) ->
    if msg.message.user.name == "meral" and random.randrange(0, sms_chance) == 1 and msg.message.text.indexOf("Error:") == -1
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
