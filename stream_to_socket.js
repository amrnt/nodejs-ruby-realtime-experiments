// Convert streamed data to Socket.io
// The stream data come from http://0.0.0.0:9998
// The websocket is listen on http://0.0.0.0:9999

var http = require('http')
  , io   = require('socket.io')
  , fs   = require('fs');

app = http.createServer(function (req, res) {
  fs.readFile(__dirname + '/index.html',
  function (err, data) {
    if (err) {
      res.writeHead(500);
      return res.end('Error loading index.html');
    }
    res.writeHead(200);
    res.end(data);
  });
}).listen(9999);

io = io.listen(app)
io.sockets.on('connection', function (socket) {
  socket.on('connect', function () {
    socket.send('You are connected now.')
  });
  socket.on('disconnect', function () {
    console.log('Goodbye!')
  });
});

var req = http.request({host: '0.0.0.0', port: 9998, path: '/', method: 'GET'});
req.on('response', function (res) {
  res.setEncoding('utf8');
  res.on('data', function (chunk) {
    io.sockets.send(chunk);
  });
});
req.end();

