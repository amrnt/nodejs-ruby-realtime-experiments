# Convert streamed data to Socket.io
# The stream data come from http://0.0.0.0:9999
# The websocket and the sample streaming page
# is listening on http://0.0.0.0:9000

http = require 'http'
io = require 'socket.io'
fs = require 'fs'

app = http.createServer (req, res) ->
  fs.readFile "#{__dirname}/../public/index.html", (err, data) ->
    if err
      res.writeHead 500
      res.end 'Error loading index.html'
    res.writeHead 200
    res.end data
.listen 9000

io = io.listen app
io.sockets.on 'connection', (socket) ->
  socket.on 'connect', ->
    socket.send 'You are connected now.'

  socket.on 'disconnect', ->
    console.log 'Goodbye!'

req = http.request
  host: "0.0.0.0"
  port: 9999
  path: "/"
  method: "GET"

req.on 'response', (res) ->
  res.setEncoding 'utf8'
  res.on 'data', (chunk) ->
    io.sockets.send chunk
req.end()

