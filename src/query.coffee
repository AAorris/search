querystring = require 'querystring'
request = require 'request'
fs = require 'fs'

do->
  api_key = process.env.BING_ACCOUNT_KEY
  if !api_key?
    console.log "Error, BING_ACCOUNT_KEY is not set!"
  api_auth = new Buffer("#{api_key}:#{api_key}").toString 'base64'

  service = process.argv[2]
  raw_query = process.argv[3].replace("%20", " ")
  query_string = querystring.escape "#{raw_query}"

  options=
    url: "https://api.datamarket.azure.com/Bing/Search/#{service}?$format=json&Query=%27#{query_string}%27"
    method: 'POST'
    headers:
      Authorization: "Basic #{api_auth}"
    postData:
      mimeType: 'application/x-www-form-urlencoded'
      request_fulluri: true
      ignore_errors: true

  callback = (error, response, body)->
    if error
      console.log error
    else if response.statusCode is 200
      search = JSON.parse body
      for result in search.d.results
        process.stdout.write "[#{result.Title}](#{result.DisplayUrl})  \n#{result.Description}\n\n"
    else
      console.log error
      console.log body

  # console.log options
  # console.log process.argv
  if api_key
    request options, callback
      .on 'response', (response)->
        fs.writeFile 'bing-headers.json', JSON.stringify response.headers, null, 2
      .pipe fs.createWriteStream 'bing-response.json'
