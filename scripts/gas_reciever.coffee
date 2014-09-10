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

    if robot.brain.data.sitecheck
    	console.log robot.brain.data.sitecheck
    else 
    	robot.brain.data.sitecheck = {flag: true}

    user = room: "#test"
    # user = room: query.room
    console.log user


    checkUrl = query.checkUrl or "URL不明"
    resCode = query.resCode or "未設定"
    comment = query.comment or "未設定"
    message = "サイトのチェック結果だよ"

    try
      if resCode is "200"
        message = "#{checkUrl} を覗いたけど、頑張って動いてたよ"
        robot.brain.data.sitecheck = {flag: true}
      else
        message = "#{checkUrl} をみたら、#{resCode} #{comment} が返ってきたよ。大丈夫？"
        robot.brain.data.sitecheck = {flag: false}

      sitecheck = robot.brain.data.sitecheck
      if sitecheck.flag isnt true
	      robot.send user, message
      console.log message
      robot.brain.data.sitecheck = {flag: true}
    catch error
      console.log "google spreadsheet notifier error: #{error}. Request: #{req.body}"