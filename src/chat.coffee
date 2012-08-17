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
.listen 9999

io = io.listen app

io.sockets.on 'connection', (socket) ->
  socket.on 'connect', ->
    socket.send 'You are connected now.'

  socket.on 'message', (data) ->
    # socket.broadcast.send data # to the rest of the sockets
    io.sockets.send data # to everyone

  socket.on 'disconnect', ->
    console.log 'Goodbye!'

