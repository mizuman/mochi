# Description:
#   nanapi_botちゃんに単語を学習させる
#   あまりうざくならないようにするため当面は"完全一致"での反応のみとする
Fs = require 'fs'
Path = require 'path'

oldCommands = null
oldListeners = null

module.exports = (robot) ->
  getRegExpFromBrain = ->
    keys = []
    for key, value of robot.brain.data.bot
      keys.push key
    return new RegExp("^(#{keys.join('|')})$")

  robot.hear eval('getRegExpFromBrain()'), (msg) ->
    keys = []
    for key, value of robot.brain.data.bot
      keys.push key

    return if !robot.brain.data.bot
    obj = msg.random robot.brain.data.bot[msg.match[1]]
    msg.send obj.message || ""

  robot.respond /word list/i, (msg) ->
    return if !robot.brain.data.bot
    keys = []
    for key, value of robot.brain.data.bot
      keys.push key

    str = keys.join(', ')
    console.log str
    msg.send "こんなメッセージが登録されてるよー。 #{str}"


  robot.respond /word remove (.+?)$/i, (msg) ->
    keyword = msg.match[1]
    robot.brain.data.bot = {} if !robot.brain.data.bot

    delete robot.brain.data.bot[keyword] if robot.brain.data.bot[keyword]

    robot.brain.save()
    msg.send "#{keyword} のキーワードを削除したよー＞＜ノ"
    reload(robot, msg)

  robot.respond /word add (.*?) (.*?)$/i, (msg) ->
    keyword = msg.match[1]
    message = msg.match[2]
    needReload = false
    robot.brain.data.bot = {} if !robot.brain.data.bot

    if !robot.brain.data.bot[keyword]
      robot.brain.data.bot[keyword] = []
      needReload = true

    robot.brain.data.bot[keyword].push {
      message: message,
      user: msg.envelope.user.name,
      time: new Date().getTime()
    }
    robot.brain.save()

    msg.send "#{keyword} に新しいワードを追加したよー＞＜ノ"

    # Keyword自体が新規の場合はリロードが必要
    if needReload
      reload(robot, msg)


reload = (robot, msg) ->
  try
    oldCommands = robot.commands
    oldListeners = robot.listeners

    robot.commands = []
    robot.listeners = []

    reloadAllScripts msg, success, (err) ->
      msg.send err
  catch error
    console.log "Hubot reloader:", error
    msg.send "Could not reload all scripts: #{error}"
success = (msg) ->
  # Cleanup old listeners and help
  for listener in oldListeners
    listener = {}
  oldListeners = null
  oldCommands = null

reloadAllScripts = (msg, success, error) ->
  robot = msg.robot
  scriptsPath = Path.resolve ".", "scripts"
  robot.load scriptsPath

  scriptsPath = Path.resolve ".", "src", "scripts"
  robot.load scriptsPath

  hubotScripts = Path.resolve ".", "hubot-scripts.json"
  Fs.exists hubotScripts, (exists) ->
    if exists
      Fs.readFile hubotScripts, (err, data) ->
        if data.length > 0
          try
            scripts = JSON.parse data
            scriptsPath = Path.resolve "node_modules", "hubot-scripts", "src", "scripts"
            robot.loadHubotScripts scriptsPath, scripts
          catch err
            error "Error parsing JSON data from hubot-scripts.json: #{err}"
            return

  externalScripts = Path.resolve ".", "external-scripts.json"
  Fs.exists externalScripts, (exists) ->
    if exists
      Fs.readFile externalScripts, (err, data) ->
        if data.length > 0
          try
            scripts = JSON.parse data
          catch err
            error "Error parsing JSON data from external-scripts.json: #{err}"
          robot.loadExternalScripts scripts
          return