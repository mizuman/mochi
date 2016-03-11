# Description:
#   Simple todo app to help keep the mind clear
#
# Dependencies:
#
# Configuration:
#   None
#
# Commands:
#   todo: <description> - Add a new todo quickly
#   hubot todo help
#   hubot todo add <description> - Add a new todo with a basic description
#   hubot todo remove <item number | all> - Remove a todo item from the list
#   hubot todo clear - Remove finished todos item from the list
#   hubot todo <ready | start | stop | pending | done> <item number> - set status of a todo item
#   hubot todo list - List your tasks
#   hubot todo insert <item number> into <item number> - change the todo position


class Todos
	constructor: (@robot) ->
		@robot.brain.data.todos = {}
		@robot.brain.data.todoinfo = {}

		# TODO: 正規表現がんばれ
		@robot.respond /(todo|-t) (add|-a) (.+)$/i, @addItem
		@robot.hear /^todo: (.+)$/i, @addItem
		@robot.respond /(todo|-t) (rm|remove|delete) #?(\d+|all)/i, @removeItem
		@robot.respond /(todo|-t) (edit|update) #?(\d+|all)/i, @editItem
		@robot.respond /(todo|-t) (-r|-p|-s|-d|-ready|done|finish|finished|doing|pending|stop|start) #?(\d+)/i, @setStatus
		@robot.respond /(todo|-t) (clear|-c)/i, @clearItems
		@robot.respond /(todo|-t) (list|li|-l)$/i, @listItems
		@robot.respond /(todo|-t) (insert|-i) #?(\d+) (in|into|to) #?(\d+)/i, @insertItem
		@robot.respond /(todo|-t) (-h|help)/i, @help
		@robot.respond /(todo|-t) config:set (.+)=(.+)/i, @setConfig

	getIcons: (status) => 
		switch status
			when "ready"
				return ":white_medium_square: "
			when "done"
				return ":white_check_mark: "
			when "doing"
				return ":arrow_forward: "
			when "pending"
				return ":arrows_counterclockwise: "
			when "stop"
				return ":double_vertical_bar: "
			else
				return ":keycap_star: "

	setConfig: (msg) =>
		user 	   = msg.message.user
		key = msg.match[1]
		value = msg.match[2]

		@robot.brain.data.todoinfo[user.id][key] = value

	help: (msg) =>
		commands = @robot.helpCommands()
		commands = (command for command in commands when command.match(/todo/))

		msg.send commands.join("\n")

	addItem: (msg) =>
		user 	   = msg.message.user
		title = msg.match[1]
		status = "ready"

		# TODO: 正規表現なんとかする
		if title is 'todo' or title is '-t'
			title = msg.match[3]

		task = {
			"title": title,
			"status": status
		}

		@robot.brain.data.todos[user.id] ?= []
		@robot.brain.data.todos[user.id].push(task)

		totalItems = @getItems(user).length
		multiple   = totalItems isnt 1

		if @robot.brain.data.todoinfo[user.id]?
			if @robot.brain.data.todoinfo[user.id]["show_list"] is "enable"
				message = "#{totalItems} item" + (if multiple then 's' else '') + " in your list\n\n"
				message += @createListMessage(user)
				msg.send message
		else
			message = "if you want to show list every time.\n"
			message += "please set config `#{@robot.name} todo config:set show_list=enable`"
			@robot.brain.data.todoinfo[user.id] = {}
			@robot.brain.data.todoinfo[user.id]["show_list"] ?= "disable"
			msg.send message

		# message = "#{totalItems} item" + (if multiple then 's' else '') + " in your list\n\n"
		# message += @createListMessage(user)

		# msg.send message

	setStatus: (msg) =>
		user 	   = msg.message.user
		status     = msg.match[2]
		item       = msg.match[3]
		items      = @getItems(user)
		totalItems = items.length

		# TODO: 正規表現でちゃんと解決する	
		if status is 'finish' or status is 'finished' or status is '-d'
			status = 'done'

		if status is 'start' or status is '-s'
			status = 'doing'

		if status is '-r'
			status = 'ready'

		if status is '-p'
			status = 'pending'

		# console.log msg

		if item > totalItems
			if totalItems > 0
				message = "That item doesn't exist."
				message += " Here's what you've got:\n\n"
				message += @createListMessage(user)
			else
				message = "There's nothing on your list at the moment"

			msg.send message

			return

		else
			@robot.brain.data.todos[user.id][item-1].status = status

		message = ""

		remainingItems = @getItems(user)
		multiple 	  = remainingItems.length isnt 1

		if remainingItems.length > 0
			# message += " #{remainingItems.length} item" + (if multiple then 's' else '') + " left:\n\n"
			icon =  @getIcons(@robot.brain.data.todos[user.id][item-1].status)
			title = @robot.brain.data.todos[user.id][item-1].title
			message += "#{icon} #{item}: #{title}\n"
		else
			message += " You're all done :)"

		msg.send message

	insertItem: (msg) =>
		user 	   = msg.message.user
		item_from  = msg.match[3]
		item_to    = msg.match[5]
		items      = @getItems(user)
		totalItems = items.length

		if item_from > totalItems or item_to > totalItems
			message = "That item doesn't exist."
			msg.send message

			return

		else if item_from is item_to
			message = "It's same position"
			msg.send message

			return

		else
			if item_from > item_to
				item = @robot.brain.data.todos[user.id][item_from-1]
				@robot.brain.data.todos[user.id].splice(item_from-1, 1)
				@robot.brain.data.todos[user.id].splice(item_to-1, 0, item)
			else
				item = @robot.brain.data.todos[user.id][item_from-1]
				@robot.brain.data.todos[user.id].splice(item_from-1, 1)
				@robot.brain.data.todos[user.id].splice(item_to-1, 0, item)

			message = @createListMessage(user)
			msg.send message

	editItem: (msg) =>
		message = "sorry. this feature is not available yet."
		msg.send message

	removeItem: (msg) =>
		user 	   = msg.message.user
		item       = msg.match[3]
		items      = @getItems(user)
		totalItems = items.length

		if item isnt 'all' and item > totalItems
			if totalItems > 0
				message = "That item doesn't exist."
				message += " Here's what you've got:\n\n"
				message += @createListMessage(user)
			else
				message = "There's nothing on your list at the moment"

			msg.send message

			return

		if item is 'all'
			@clearAllItems(user)
		else
			@robot.brain.data.todos[user.id].splice(item - 1, 1)

		# message = "Good stuff!"
		message = ""

		remainingItems = @getItems(user)
		multiple 	  = remainingItems.length isnt 1

		if remainingItems.length > 0
			message += " #{remainingItems.length} item" + (if multiple then 's' else '') + " left:\n\n"

			message += @createListMessage(user)
		else
			message += " You're all done :)"

		msg.send message

	clearItems: (msg) =>
		user 	   = msg.message.user
		items      = @getItems(user)
		totalItems = items.length

		message = ""

		if totalItems > 0
			for todo, index in items
				if @robot.brain.data.todos[user.id][totalItems-index-1].status is 'done'
					@robot.brain.data.todos[user.id].splice(totalItems-index-1, 1)
			if @robot.brain.data.todos[user.id].length is 0
				message += "GJ! MISSION COMPLATE!!"
			else
				message += @createListMessage(user)
		else
			message += "Nothing to do at the moment!"

		msg.send message


	clearAllItems: (user) => @robot.brain.data.todos[user.id].length = 0

	createListMessage: (user) =>
		items = @getItems(user)

		message = ""

		if items.length > 0
			for todo, index in items
				icon = @getIcons(todo.status)
				message += "#{icon} #{index + 1}: #{todo.title}\n"
		else
			message += "Nothing to do at the moment!"

		return message

	getItems: (user) => return @robot.brain.data.todos[user.id] or []

	listItems: (msg) =>
		user   	= msg.message.user
		totalItems = @getItems(user).length
		multiple   = totalItems isnt 1

		message = ""

		if totalItems > 0
			message += "#{totalItems} item" + (if multiple then 's' else '') + " in your list\n\n"

		message += @createListMessage(user)

		msg.send message

module.exports = (robot) -> new Todos(robot)