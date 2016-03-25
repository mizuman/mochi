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

	cronjob_workplaceMorning = new cronJob('00 00 9 * * 1-5', () =>
		envelope = room: "#random"
		robot.send envelope, "今日はどこで仕事してるのー？ https://docs.google.com/presentation/d/1w2T5-eJWCcXrxSPyf0OufWYHNfly840yNEXG0QcYEWw/edit?usp=sharing"
	)
	cronjob_workplaceMorning.start()

	cronjob_workplace = new cronJob('00 00 17 * * 1-4', () =>
		envelope = room: "#random"
		robot.send envelope, "明日はどこで仕事してるのー？ https://docs.google.com/presentation/d/1w2T5-eJWCcXrxSPyf0OufWYHNfly840yNEXG0QcYEWw/edit?usp=sharing"
	)
	cronjob_workplace.start()

	cronjob_workplaceFri = new cronJob('00 00 17 * * 5', () =>
		envelope = room: "#random"
		robot.send envelope, "来週はどこで仕事してるのー？ https://docs.google.com/presentation/d/1w2T5-eJWCcXrxSPyf0OufWYHNfly840yNEXG0QcYEWw/edit?usp=sharing"
	)
	cronjob_workplaceFri.start()

	cronjob_voucher = new cronJob('00 45 11 15 * 1-5', () =>
		envelope = room: "#random"
		robot.send envelope, "バウチャーはもらった？"
	)
	cronjob_voucher.start()
