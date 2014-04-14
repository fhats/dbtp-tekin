child_process = require("child_process")
dns = require("dns")

send_txt = (addr, msg) ->
	dns.resolve addr, 'TXT', (err, addrs) ->
		if err
			msg.send err
		else
			msg.send t for t in addrs

ping_lines = (msg, address, line_start, line_end, seconds=10) ->
	cmd = "ping -i 0.2 -w #{seconds} -W 5 -q '#{address}'"
	child_process.exec cmd, (_, out, err) ->
		if err
			msg.send "Encountered an error:"
			msg.send err
		else
			msg.send "#{address}: " + line for line in out.split("\n").slice(line_start, line_end) if line != ""


# lookup an AS number based on IP
module.exports = (robot) ->
	robot.respond /(dig|host|resolve) ([0-9a-zA-Z\-\_\.]+[a-zA-Z])/i, (msg) ->
		dns.resolve msg.match[2], (err, addresses) ->
			if err
				msg.send err
			else
				msg.send address for address in addresses

	robot.respond /(host|reverse) ([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})$/i, (msg) ->
		dns.reverse msg.match[2], (err, domains) ->
			if err
				msg.send err
			else
				msg.send domain for domain in domains

	robot.respond /(as )?lookup( as)? ([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})/i, (msg) ->
		reversed_addr = "#{msg.match[6]}.#{msg.match[5]}.#{msg.match[4]}.#{msg.match[3]}"
		cymru_address = "#{reversed_addr}.origin.asn.cymru.com"
		send_txt cymru_address, msg

	robot.respond /((bgp )?peers|who peers with|(who's|who is)peering with) ([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})/i, (msg) ->
		reversed_addr = "#{msg.match[7]}.#{msg.match[6]}.#{msg.match[5]}.#{msg.match[4]}"
		cymru_address = "#{reversed_addr}.peer.asn.cymru.com"
		send_txt cymru_address, msg

	robot.respond /(as )?lookup( as)? ((AS)?[0-9]{1,6})$/i, (msg) ->
		asn = msg.match[3]
		asn = "AS#{asn}" unless asn.substr(0, 2) == 'AS'
		cymru_address = "#{asn}.asn.cymru.com"
		send_txt cymru_address, msg

	robot.respond /(how much |(what's|what is) the )?loss to ([0-9a-zA-Z\-\_\.]+)( for ([0-9]+) seconds)?/i, (msg) ->
		address = msg.match[3]
		seconds_to_run = msg.match[5]
		seconds_to_run ?= 10
		msg.send "Checking loss to #{address} over #{seconds_to_run} seconds"
		ping_lines msg, address, 3, 4, seconds_to_run

	robot.respond /((what's|what is) the )?(rtt|latency) to ([0-9a-zA-Z\-\_\.]+)( for ([0-9]+) seconds)?/i, (msg) ->
		address = msg.match[4]
		seconds_to_run = msg.match[6]
		seconds_to_run ?= 10
		msg.send "Checking round-trip time to #{address} over #{seconds_to_run} seconds"
		ping_lines msg, address, 4, 5, seconds_to_run

	robot.respond /ping (to )?([0-9a-zA-Z\-\_\.]+)( for ([0-9]+) seconds)?/i, (msg) ->
		address = msg.match[2]
		seconds_to_run = msg.match[4]
		seconds_to_run ?= 10
		msg.send "Pinging #{address} for #{seconds_to_run} seconds"
		ping_lines msg, address, 0, -1, seconds_to_run
