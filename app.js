var app = require('http').createServer(handler)
  , io = require('socket.io').listen(app)
  , fs = require('fs')

app.listen(9999);

function handler (req, res) {
  fs.readFile(__dirname + '/index.html',
  function (err, data) {
    if (err) {
      res.writeHead(500);
      return res.end('Error loading index.html');
    }
    res.writeHead(200);
    res.end(data);
  });
}

io.sockets.on('connection', function (socket) {
  socket.on('connect', function () {
    socket.send('You are connected now.')
  });

  socket.on('message', function (data) {
    //socket.broadcast.send(data); //to the rest of the sockets
    io.sockets.send(data); //to everyone
  });

  socket.on('disconnect', function () {
    console.log('Goodbye!')
  });
});

