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

eastasianwidth = require 'eastasianwidth'

strpad = (str, count) ->
  new Array(count + 1).join str

String::toArray = ->
  array = new Array
  i = 0

  while i < @length
    array.push @charAt(i)
    i++
  array

module.exports = (robot) ->
  robot.respond /PING$/i, (msg) ->
    msg.send "(ｏ'∀'ｏ)ﾉポン!!"

  robot.respond /ADAPTER$/i, (msg) ->
    msg.send robot.adapterName

  robot.respond /ECHO (.*)$/i, (msg) ->
    msg.send msg.match[1]

  robot.respond /TIME$/i, (msg) ->
    msg.send "Server time is: #{new Date()}"

  robot.respond /THANK(.*)$/i, (msg) ->
    msg.send msg.random ["You're welcome! :+1: ", "(´,,・ω・,,`)"]

  robot.respond /THX$/i, (msg) ->
    msg.send msg.random ["np! :+1: ", ":+1:"]

  robot.respond /ありがとう$/i, (msg) ->
    msg.send msg.random ["どういたしまして(´,,・ω・,,`)"]


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


  robot.hear /突然の(.*)$/i, (msg) ->
    message = msg.match[1].replace /^\s+|\s+$/g, ''
    return until message.length

    length = Math.floor eastasianwidth.length(message) / 2

    suddendeath = [
      "＿#{strpad '人', length + 2}＿"
      "＞　#{message}　＜"
      "￣Y#{strpad '^Y', length}￣"
    ]
    msg.send suddendeath.join "\n"

  robot.respond /(短冊|tanzaku) (.*)$/i, (msg) ->
    message = msg.match[2].replace /^\s+|\s+$/g, ''
    return until message.length

    if message.length >= 16
      msg.send "メッセージが長過ぎます＞＜ノ 15文字以内にしてね。"
      return

    tanzaku = [
      "┏┷┓"
      "┃　┃"
    ]
    for value in message.toArray()
      tanzaku.push "┃#{value}┃"

    tanzaku.push "┃　┃"
    tanzaku.push "┗━┛"
    msg.send tanzaku.join "\n"