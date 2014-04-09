dns = require("dns")

send_txt = (addr, msg) ->
	dns.resolve addr, 'TXT', (err, addrs) ->
		if err
			msg.send err
		else
			msg.send t for t in addrs

# lookup an AS number based on IP
module.exports = (robot) ->
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
