# Dependencies:
#   "url": ""
#   "querystring": ""
#
# Commands:
#   None
#
# URLS:
#   POST /hubot/google-spreadsheet?room=<room>&name=<name>&value=<value>
#
url = require 'url'
querystring = require 'querystring'

module.exports = (robot) ->
  robot.router.post "/hubot/site-watcher", (req, res) ->
    query = querystring.parse (url.parse req.url).query
    res.end()

    return unless query.room

    user = 
      room: query.room

    checkUrl = query.checkUrl or "URL不明"
    resCode = query.resCode or "未設定"
    comment = query.comment or "未設定"
    message = "サイトのチェック結果だよ"

    try
      if resCode == 200
        message = "#{checkUrl}をチェックしたけど、問題なかったよ"
      else if resCode == "e"
        message = "#{checkUrl}に何か問題があるみたい。#{comment}"
      else
        message = "#{checkUrl}をみたら、#{resCode}が返ってきたよ。大丈夫？"

      robot.send user, message
      console.log message
    catch error
      console.log "google spreadsheet notifier error: #{error}. Request: #{req.body}"