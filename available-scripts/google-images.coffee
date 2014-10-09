# Description:
#   A way to interact with the Google Images API.
#
# Commands:
#   hubot image me <query> - The Original. Queries Google Images for <query> and returns a random top result.
#   hubot animate me <query> - The same thing as `image me`, except adds a few parameters to try to return an animated GIF instead.
#   hubot mustache me <url> - Adds a mustache to the specified URL.
#   hubot mustache me <query> - Searches Google Images for the specified query and mustaches it
#
twilio = require('twilio')
fs = require 'fs'


mms_chance = 8

phone_numbers = '/opt/tekin/data/phones'

module.exports = (robot) ->
  robot.respond /(image|img)( me)? (.*)/i, (msg) ->
    imageMe msg, msg.match[3], (url) ->
      msg.send url

  robot.respond /animate( me)? (.*)/i, (msg) ->
    imageMe msg, msg.match[2], true, (url) ->
      msg.send url

  robot.respond /(?:mo?u)?sta(?:s|c)he?(?: me)? (.*)/i, (msg) ->
    type = Math.floor(Math.random() * 3)
    mustachify = "http://mustachify.me/#{type}?src="
    imagery = msg.match[1]

    if imagery.match /^https?:\/\//i
      msg.send "#{mustachify}#{imagery}"
    else
      imageMe msg, imagery, false, true, (url) ->
        msg.send "#{mustachify}#{url}"

  robot.respond /(risky)( me)? (.*)/i, (msg) ->
    imageMe msg, msg.match[3], false, false, 'off', (url) ->
      msg.send url

sendMms = (url, query) ->
  twilio_sid = process.env.TWILIO_SID
  twilio_token = process.env.TWILIO_TOKEN
  twilio_number = process.env.TWILIO_NUMBER
  fs.readFile phone_numbers, (err, file) ->
    if (err)
      throw err
    else:
      phones = JSON.parse(file)
      client = new twilio.RestClient(twilio_sid, twilio_token)
      client.messages.create({
        to: random.choice(phones),
        from: twilio_number,
        mediaUrl: url,
        body: 'TEKIN IMAGE ME ' + query.toUpperCase()
      }, (error, message) ->
        if (error)
          msg.send('Oops! Tekin forgot how to MMS.');
          msg.send error.message
        )

imageMe = (msg, query, animated, faces, safe='active', cb) ->
  cb = animated if typeof animated == 'function'
  cb = faces if typeof faces == 'function'
  q = v: '1.0', rsz: '8', q: query, safe: safe
  q.as_filetype = 'gif' if typeof animated is 'boolean' and animated is true
  q.imgtype = 'face' if typeof faces is 'boolean' and faces is true
  msg.http('http://ajax.googleapis.com/ajax/services/search/images')
    .query(q)
    .get() (err, res, body) ->
      images = JSON.parse(body)
      images = images.responseData?.results
      if images?.length > 0
        image  = msg.random images
        if random.randrange(0, mms_chance) == 1
          sendMms(image, query)
        cb "#{image.unescapedUrl}#.png"

