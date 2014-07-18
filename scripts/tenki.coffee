parser = require('xml2json')
async = require('async')
require('date-utils')

weathearList = require('../config/weather_area_list.json')

module.exports = (robot) ->
  robot.respond /天気\s*(.*)?$/i, (msg) ->
    place  = '東京'
    place  = msg.match[1] if msg.match[1]?

    async.waterfall([
      (callback) ->
        weathearList.some((v,i) ->
          if v.city instanceof Array
            v.city.some((data, j) ->
              if data.title == place
                callback(null, data)
                return true
            )
          else
            if v.city.title == place
              callback(null, v.city)
              return true
        )
      , (areaData, callback) ->
        # livedoor 天気予報APIのバグ arealistのIDが5桁のものは0パディングしないといけない
        areaId =  ("0" + areaData.id).slice(-6)
        msg
          .http('http://weather.livedoor.com/forecast/webservice/json/v1')
          .query(city : areaId)
          .get() (err, res, body) ->
            json = JSON.parse(body)
            callback(null, json)
    ], (err, result) ->
      throw new Error('err catched.') if err
      forecastTime = new Date(result.publicTime)
      todaymin = "  "
      todaymin = result.forecasts[0].temperature.min.celsius if result.forecasts[0].temperature.min?
      todaymax = "  "
      todaymax = result.forecasts[0].temperature.max.celsius if result.forecasts[0].temperature.max?
      tomorrowmin = "  "
      tomorrowmin = result.forecasts[1].temperature.min.celsius if result.forecasts[1].temperature.min?
      tomorrowmax = "  "
      tomorrowmax = result.forecasts[1].temperature.max.celsius if result.forecasts[1].temperature.max?
      text = "【お天気情報 #{place}】\n" +
      "#{result.forecasts[0].dateLabel}の" +
      "天気 : #{result.forecasts[0].telop}" +
      "(最低気温 #{todaymin} 〜 最高気温 #{todaymax})\n" +

      "#{result.forecasts[1].dateLabel}の" +
      "天気 : #{result.forecasts[1].telop}" +
      "(最低気温 #{tomorrowmin} 〜 最高気温 #{tomorrowmax})\n" +

      "#{result.link}"

      msg.send text
    )