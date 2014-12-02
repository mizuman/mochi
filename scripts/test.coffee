cronJob = require('cron').CronJob

module.exports = (robot) ->
	cronjob = new cronJob('00 45 11 * * 1-5', () =>
		envelope = room: "#random"
		robot.send envelope, "(´º﹃º｀) はらへ"
	)
	cronjob.start()

	cronjob_payday = new cronJob('00 00 7 20 * 1-5', () =>
		envelope = room: "#random"
		robot.send envelope, "今日は給料日です。残業できないから気をつけて。（既に出社している人は早いです。カフェとかで時間をつぶしてね）"
	)
	cronjob_payday.start()

	cronjob_weeklyreport = new cronJob('00 00 9 * * 5', () =>
		envelope = room: "#general"
		robot.send envelope, '''
		今週もお疲れさまです。
		週報書いてね
		https://webcore.ft.nttcloud.net/redmine/projects/teirei/wiki
		'''
	)
	cronjob_weeklyreport.start()

	cronjob_voucher = new cronJob('00 45 11 15 * 1-5', () =>
		envelope = room: "#random"
		robot.send envelope, "バウチャーはもらった？"
	)
	cronjob_voucher.start()