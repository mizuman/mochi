# Description:
#   Simple todo app to help keep the mind clear
#
# Dependencies:
#
# Configuration:
#   None
#
# Commands:
#   todo add <description> - Add a new todo with a basic description
#   todo remove <item number | all> - Remove a todo item from the list
#   todo clear - Remove finished todos item from the list
#   todo ready|start|stop|pending|done <item number> - set status of a todo item
#   todo list - List your tasks


class Todos
	constructor: (@robot) ->
		@robot.brain.data.todos = {}

		@robot.respond /todo add (.+)$/i, @addItem
		@robot.respond /todo remove #?(\d+|all)/i, @removeItem
		@robot.respond /todo (ready|done|finish|finished|doing|pending|stop|start) #?(\d+)/i, @setStatus
		@robot.respond /todo clear/i, @clearItems
		@robot.respond /todo (list|li)$/i, @listItems
		@robot.respond /todo help/i, @help

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

	help: (msg) =>
		commands = @robot.helpCommands()
		commands = (command for command in commands when command.match(/\/todos/))

		msg.send commands.join("\n")

	addItem: (msg) =>
		user 	   = msg.message.user
		title = msg.match[1]
		status = "ready"
		task = {
			"title": title,
			"status": status
		}

		@robot.brain.data.todos[user.id] ?= []
		@robot.brain.data.todos[user.id].push(task)

		totalItems = @getItems(user).length
		multiple   = totalItems isnt 1

		message = "#{totalItems} item" + (if multiple then 's' else '') + " in your list\n\n"
		message += @createListMessage(user)

		msg.send message

	setStatus: (msg) =>
		user 	   = msg.message.user
		status     = msg.match[1]
		item       = msg.match[2]
		items      = @getItems(user)
		totalItems = items.length

		if status is 'finish' or status is 'finished'
			status = 'done'

		if status is 'start'
			status = 'doing'

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
			message += " #{remainingItems.length} item" + (if multiple then 's' else '') + " left:\n\n"

			message += @createListMessage(user)
		else
			message += " You're all done :)"

		msg.send message

	removeItem: (msg) =>
		user 	   = msg.message.user
		item       = msg.match[1]
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