cp = require 'child_process'

module.exports = (robot) ->
  robot.respond /colorize (\w+) (\w.+)/i, (msg) ->
    language = msg.match[1]
    chunk = msg.match[2]
    console.log language, chunk

    proc = cp.spawn('pygmentize', ['-l', language])
    output = ''
    proc.stdout.on 'data', (data) ->
      console.log('got data', data)
      output += data
    proc.on 'exit', (code) ->
      console.log('end')
      if code
        console.log('omfg', code)
        return

      irc_output = output.replace /\033\[(?:(\d+);)?(?:(\d+);)?(\d+)m/g, (match, p1, p2, p3) ->
        for xterm_code in [p1, p2, p3]
          if not xterm_code
            continue

          xterm_code = parseInt xterm_code, 10
          if xterm_code == 38
            # reset
            return String.fromCharCode(15)
          if 30 <= xterm_code and xterm_code <= 37
            # dark color, maps to 0-7
            return String.fromCharCode(3) + ('0' + String(xterm_code - 30)).substring(0, 2)
          if 90 <= xterm_code and xterm_code <= 97
            # light color, maps to 8-15
            return String.fromCharCode(3) + ('0' + String(xterm_code - 90 + 8)).substring(0, 2)

        # got nothin; return reset to be safe i guess
        return String.fromCharCode(15)

      msg.send(irc_output)

    proc.stdin.write(chunk)
    proc.stdin.end()
