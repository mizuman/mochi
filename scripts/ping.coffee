# Description:
#   Utility commands surrounding Hubot uptime.
#
# Commands:
#   hubot ping - Reply with pong
#   hubot echo <text> - Reply back with <text>
#   hubot time - Reply with current time
#   hubot bye - End hubot process
#   hubot die - this is fack
#   hubot adapter - Reply with adapter name

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
    msg.send '''
　-= ∧ ∧
-=と(・∀ ・) 　＜馬鹿目！それは残像だ！
　-=/　と_ノ
-=_/／⌒ｿ


. ∧ ∧ =-
（・ ∀ ・) =-　＜ははは！当てられるものなら、当ててみろ！
　と´_,ノヾ =-
　　(´_ヽ、＼ =-


　　　..r ､∧＿∧
‐――`ﾏ( ・∀･ )
　　― ‐〉 　と ノ　　　＿二＿
　　　,.ｲ ,､⌒i／　￣￣￣￣／|!
　　.ー'´ .У　　ｶﾞｯ 　　　／ ／|i
　　　　／　　　　　　 _／ ／
　　　　||￣￣￣￣￣||／
　　　　||　　　　　　　.||!


　　　,__、：．．
　　＜ / '─ - ：．
　　＜（　 `ｰ'ヽ,＼／￣￣￣￣￣／|
　　 ’：;￣`ｰ' "／　　　　　　　／ ／|
　　　　　　　／　　　　　　 _／ ／
　　　　　　 .||￣￣￣￣￣||／
　　　　　　 .||　　　　　　　.||
'''

  robot.respond /BYE$/i, (msg) ->
    msg.send "(人-ω-)｡o.ﾟ｡*･★Good Night★･*｡ﾟo｡"
    process.exit 0

  robot.respond /週報$/i, (msg) ->
    msg.send "週報書いてね https://webcore.ft.nttcloud.net/redmine/projects/teirei/wiki"