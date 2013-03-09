# get images from imagey subreddits
#
# cat - get a cat
# N cats, give me N cats - get N cats (but less than 9 cats)
# cat bomb - get 5 cats

allowedRooms = ['#lobby', ]

Array::merge = (other) -> Array::push.apply @, other

# map from thing name to subreddit name
thingMap = {
  'cat': ['cats', 'catpictures'],
  'otter': ['otters'],
  'corgi': ['corgi'],
  'pug': ['pug', 'pugs']
}

retrieveThings = (msg, thing, count) ->
  console.log thing, count
  return unless thingMap[thing]?

  allTheThings = []
  generateReturn = (things) ->
    allTheThings.merge things
    resultCount++

    if resultCount == thingMap[thing].length
      thingString = []
      for _ in [0..count-1]
        thingJSON = msg.random allTheThings
        thingString.push 'http://i.imgur.com/' + thingJSON.hash + thingJSON.ext
      msg.send thingString.join(', ')

  # we have multiple sources of things, grab all of em
  resultCount = 0
  for thingSource in thingMap[thing]
    msg.http("http://imgur.com/r/#{thingSource}.json")
      .get() (err, res, body) ->
        generateReturn JSON.parse(body).gallery

module.exports = (robot) ->
  robot.respond /give me (a|\d+)?\s*(\w+)/i, (msg) ->
    thing = msg.match[2]
    if thing[thing.length-1] == 's'
      thing = thing.substring(0, thing.length-1)
    count = if msg.match[1] then msg.match[1] else 3
    count = 1 if count == 'a'
    if count > 8
      if count > 30
        msg.send "http://25.media.tumblr.com/tumblr_m286bpJ3QC1qbt0vwo1_500.gif"
      else
        msg.send "http://myfacewhen.com/images/325.gif"
    else
      retrieveThings(msg, thing, count)

  robot.respond /(\w+)s? bomb/i, (msg) ->
    retrieveThings(msg, msg.match[1], 5)
