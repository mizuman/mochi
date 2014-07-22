# Description:
#   Allows patents (TODOs) to be added to Hubot
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot patent add <patent> - Add a patent
#   hubot patent list patents - List the patents
#   hubot patent delete <patent number> - Delete a patent
#
# Author:
#   Crofty

class patents
  constructor: (@robot) ->
    @cache = []
    @robot.brain.on 'loaded', =>
      if @robot.brain.data.patents
        @cache = @robot.brain.data.patents
  nextpatentNum: ->
    maxpatentNum = if @cache.length then Math.max.apply(Math,@cache.map (n) -> n.num) else 0
    maxpatentNum++
    maxpatentNum
  add: (patentString) ->
    patent = {num: @nextpatentNum(), patent: patentString}
    @cache.push patent
    @robot.brain.data.patents = @cache
    patent
  all: -> @cache
  deleteByNumber: (num) ->
    index = @cache.map((n) -> n.num).indexOf(parseInt(num))
    patent = @cache.splice(index, 1)[0]
    @robot.brain.data.patents = @cache
    patent

module.exports = (robot) ->
  patents = new patents robot

  robot.respond /(patent add|add patent|tokkyo add|add tokkyo|特許追加) (.+?)$/i, (msg) ->
    patent = patents.add msg.match[2]
    msg.send "patent added: ##{patent.num} - #{patent.patent}"

  robot.respond /(patent list|list patents|tokkyo list|list tokkyo|特許リスト)/i, (msg) ->
    if patents.all().length > 0
      response = ""
      for patent, num in patents.all()
        response += "##{patent.num} - #{patent.patent}\n"
      msg.send response
    else
      msg.send "There are no patents"

  robot.respond /(patent delete|delete patent|tokkyo delete|delete tokkyo|特許削除) #?(\d+)/i, (msg) ->
    patentNum = msg.match[2]
    patent = patents.deleteByNumber patentNum
    msg.send "patent deleted: ##{patent.num} - #{patent.patent}"