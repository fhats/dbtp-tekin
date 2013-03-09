# bring some friends along
#
# bring a friend - invites one of tekin's friends to join him
# hang out with <professor> - instructs tekin to allow <professor> into his orifice
# colloquium - brings all the professors together for a chit chat
# kill <professor> - GTFO
# kill 'em all - why the fuck are so many bots in here
#

sys = require 'sys'
exec = require('child_process').exec

class Friends
	constructor: (@robot) ->
		@cache = []
		@friends = [
			"vincenzo",
			"gq",
			"oldham",
			"pod",
			"shudong",
			"soumya"
		]
		@cache_handles = {}

	update_brains: () ->
		@robot.brain.data.tekin_friends = @cache
		@robot.brain.data.tekin_friends_handles = @cache_handles

	add_friend: (faculty) ->
		@cache.push(faculty)
		p = exec("/usr/bin/supybot ~/friends/" + faculty + ".conf")
		@cache_handles[faculty] = p.pid + 1 
		p.on('exit', (code) =>
			this.kill_friend(faculty)
		)
		this.update_brains()
	
	bring_friend: (faculty) -> 
		if faculty not in @friends
			return "I couldn't find " + faculty
		if faculty in @cache
			return faculty + " is already here!"
		this.add_friend(faculty)
		return faculty + " please see me!"

	kill_friend: (faculty) ->
		if faculty not in @friends
			return "I can't kill what isn't there...."
		exec "/usr/bin/pgrep -f " + faculty, (error, stdout, stderror) =>
			console.log(stdout)
			for line in stdout.split("\n")
				do (line) => 
					p = parseInt(line, 10)
					exec("/bin/kill " + p)
					@cache.remove(faculty)
					@cache_handles[faculty] = undefined
					this.update_brains()
		return "I will smang you so hard..."

	random_friend: () ->
		available_friends = (friend for friend in @friends when friend not in @cache)
		if available_friends.length == 0
			return
		idx = Math.floor(Math.random() * available_friends.length)
		return available_friends[idx]


module.exports = (robot) ->
	friends = new Friends robot
	robot.respond /bring a friend/i, (msg) ->
		f = friends.random_friend()
		msg.send(friends.bring_friend(f))
	robot.respond /hang out with ([a-zA-Z0-9]+)/i, (msg) ->
		f = msg.match[1].toLowerCase()
		msg.send(friends.bring_friend(f))
	robot.respond /kill ([a-zA-Z0-9]+)/i, (msg) ->
		f = msg.match[1].toLowerCase()
		msg.send(friends.kill_friend(f))
	robot.respond /kill 'em all/i, (msg) ->
		friends.kill_friend(f) for f in friends.friends
	robot.respond /colloquium/i, (msg) ->
		friends.bring_friend(f) for f in friends.friends

Array::remove = (e) -> @[t..t] = [] if (t = @indexOf(e)) > -1
