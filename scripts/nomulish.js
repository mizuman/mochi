// Description
//   nomulish
//
// Dependencies:
//   "q": "1.0.1"
//   "request": "^2.34.0"
//   "cheerio": "^0.13.1"
//
// Configuration:
//   None
//
// Commands:
//   hubot nomulish <words> [l{1-5}] - translate words into 'nomulish'
//
// Notes:
//   None
//
// Author:
//   emanon001
//
module.exports = function(robot) {
  var q = require('q');
  var request = require('request');
  var cheerio = require('cheerio');

  var translate = function (words, level) {
    var deferred = q.defer();

    request.post(
      'http://racing-lagoon.info/nomu/translate.php',
      // transbtn に値を指定しないと変換されない
      { form: { before: words, level: level, transbtn: '_' } },
      function (err, _, body) {
        if (err) deferred.reject(err);

        var $ = cheerio.load(body);
        var nomulish = $('textarea[name=after]').val();
        deferred.resolve(nomulish);
      }
    );
    return deferred.promise;
  };

  robot.respond(/nomulish\s+(.*?)(\s+l([1-5])\s*)?$/i, function(res) {
    var words = res.match[1];
    var level = res.match[3] || process.env.HUBOT_NOMULISH_LEVEL || '4';

    translate(words, level)
    .then(function (nomulish) {
      res.send(nomulish);
    })
    .fail(function (err) {
      res.send(err);
    });
  });
};