# Description:
#   Utility commands surrounding Hubot uptime.
#
# Commands:
#   hubot ping - Reply with pong
#   hubot echo <text> - Reply back with <text>
#   hubot time - Reply with current time
#   hubot die - End hubot process

module.exports = (robot) ->
  robot.respond /PING$/i, (msg) ->
    msg.send "(ｏ'∀'ｏ)ﾉポン!!"

  robot.respond /ADAPTER$/i, (msg) ->
    msg.send robot.adapterName

  robot.respond /ECHO (.*)$/i, (msg) ->
    msg.send msg.match[1]

  robot.respond /TIME$/i, (msg) ->
    msg.send "Server time is: #{new Date()}"

  robot.respond /DIE$/i, (msg) ->
    msg.send "Goodbye, cruel world."
    process.exit 0

  robot.hear /ぬるぽ/, (msg) ->
    name = msg.envelope.user.name;
    msg.send '''
 
   Λ＿Λ    ＼＼
  （ ・∀・）   | | ｶﾞｯ
 と       ）   | |
   Ｙ /ノ     人
    / ）     <  >  _Λ∩
 ＿/し' ／／  Ｖ｀Д´）/
 （＿フ彡            / ←>> @''' + name + '''
'''
