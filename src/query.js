var querystring, request;

querystring = require('querystring');

request = require('request');

(function() {
  var api_auth, api_key, callback, options, query_string, raw_query, service;
  api_key = process.env.BING_ACCOUNT_KEY;
  api_auth = new Buffer(api_key + ":" + api_key).toString('base64');
  console.log(api_auth);
  service = process.argv[2];
  raw_query = process.argv[3].replace("%20", " ");
  query_string = querystring.escape("" + raw_query);
  options = {
    url: "https://api.datamarket.azure.com/Bing/Search/" + service + "?$format=json&Query=%27" + query_string + "%27",
    method: 'POST',
    headers: {
      Authorization: "Basic " + api_auth
    },
    postData: {
      mimeType: 'application/x-www-form-urlencoded',
      request_fulluri: true,
      ignore_errors: true
    }
  };
  callback = function(error, response, body) {
    if (error) {
      return console.log(error);
    } else if (response.statusCode === 200) {
      console.log(body);
      return console.log(JSON.parse(body));
    } else {
      console.log(error);
      return console.log(body);
    }
  };
  return request(options, callback);
})();