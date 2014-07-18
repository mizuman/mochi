cronJob = require('cron').CronJob

module.exports = (robot) ->
	cronjob = new cronJob('00 45 11 * * 1-5', () =>
		envelope = room: "#random"
		robot.send envelope, "(´º﹃º｀) はらへ"
	)
	cronjob.start()

	cronjob_weeklyreport = new cronJob('00 * * * * 5', () =>
	# cronjob_weeklyreport = new cronJob('00 00 9 * * 5', () =>
		envelope = room: "#test"
		robot.send envelope, '''
		今週もお疲れさまです。
		週報書いてね
		https://webcore.ft.nttcloud.net/redmine/projects/teirei/wiki
		'''
	)
	cronjob_weeklyreport.start()