# Convert streamed data to Socket.io
# The websocket is listen on http://0.0.0.0:9000

http = require('http')
io = require('socket.io').listen(9000)
fs = require('fs')

app = http.createServer (req, res) ->
  fs.readFile "#{__dirname}/../public/finance.html", (err, data) ->
    if err
      res.writeHead 500
      res.end 'Error loading index.html'
    res.writeHead 200
    res.end data
.listen 9999

tickers = ''

# io.set 'log level', 2

stock = io.of('/stock')
.on 'connection', (socket) ->
  socket.on 'connect', ->
    socket.send 'You are connected now.'
  socket.on 'message', (data) ->
    tickers = data
    process.nextTick makeReq

  socket.on 'disconnect', ->
    console.log 'Goodbye!'

makeReq = ->
  options =
    host: 'finance.google.com'
    path: '/finance/info?client=ig&q=' + tickers
    method: 'GET'

  req = http.request(options)
  body = ''

  req.on 'response', (res) ->
    res.setEncoding('utf8')
    res.on 'data', (chunk) ->
      body += chunk

    res.on 'end', ->
      body = body.substr(3).replace(/^\s+|\s+$/g,'')
      body = JSON.parse(body)
      body = JSON.stringify(body)
      stock.json.send(body)
      process.nextTick ->
        sleep 2000
        makeReq()

  req.end()

sleep = (ms) ->
  e = new Date().getTime() + ms
  while new Date().getTime() <= e
    ;

# http://visionmedia.github.com/mocha/
# http://www.senchalabs.org/connect/
# http://expressjs.com/
# http://nowjs.com/
