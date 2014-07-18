cronJob = require('cron').CronJob

module.exports = (robot) ->
	cronjob = new cronJob('00 45 11 * * 1-5', () =>
		envelope = room: "#random"
		robot.send envelope, "(´º﹃º｀) はらへ"
	)
	cronjob.start()