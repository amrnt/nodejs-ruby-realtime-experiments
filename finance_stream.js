// Convert streamed data to Socket.io
// The websocket is listen on http://0.0.0.0:9000

var http = require('http')
  , io   = require('socket.io').listen(9000)
  , fs   = require('fs');

app = http.createServer(function (req, res) {
  fs.readFile(__dirname + '/f.html',
  function (err, data) {
    if (err) {
      res.writeHead(500);
      return res.end('Error loading index.html');
    }
    res.writeHead(200);
    res.end(data);
  });
}).listen(9999);

var tickers = ''

io.set('log level', 2);

var stock = io.of('/stock')
.on('connection', function (socket) {
  socket.on('connect', function () {
    socket.send('You are connected now.');
  });
  socket.on('message', function (data) {
    tickers = data;
    process.nextTick(makeReq);
  });
  socket.on('disconnect', function () {
    console.log('Goodbye!');
  });
});

var makeReq = function() {
  var options = {
    host: 'finance.google.com'
    , path: '/finance/info?client=ig&q=' + tickers
    , method: 'GET'
  }
  var req = http.request(options), body = '';
  req.on('response', function (res) {
    res.setEncoding('utf8');
    res.on('data', function (chunk) {
      body += chunk;
    });
    res.on('end', function () {
      body = body.substr(3).replace(/^\s+|\s+$/g,'')
      body = JSON.parse(body)
      body = JSON.stringify(body)
      stock.json.send(body);
      process.nextTick(function(){
        sleep(5000);
        makeReq()
      });
    });
  });
  req.end();
};

var sleep = function(ms) {
  var e = new Date().getTime() + ms;
  while (new Date().getTime() <= e) {
    ;
  }
}

