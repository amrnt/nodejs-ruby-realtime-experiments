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

stocks = io.of('/stocks')
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
    path: '/finance/info?client=ig&q=' + (tickers or 'NASDAQ:ATVI,NASDAQ:ADBE,NASDAQ:AKAM,NASDAQ:ALXN,NASDAQ:ALTR,NASDAQ:AMZN,NASDAQ:AMGN,NASDAQ:APOL,NASDAQ:AAPL,NASDAQ:AMAT,NASDAQ:ADSK,NASDAQ:ADP,NASDAQ:AVGO,NASDAQ:BIDU,NASDAQ:BBBY,NASDAQ:BIIB,NASDAQ:BMC,NASDAQ:BRCM,NASDAQ:CHRW,NASDAQ:CA,NASDAQ:CELG,NASDAQ:CERN,NASDAQ:CHKP,NASDAQ:CSCO,NASDAQ:CTXS,NASDAQ:CTSH,NASDAQ:CMCSA,NASDAQ:COST,NASDAQ:DELL,NASDAQ:XRAY,NASDAQ:DTV,NASDAQ:DLTR,NASDAQ:EBAY,NASDAQ:EA,NASDAQ:EXPE,NASDAQ:EXPD,NASDAQ:ESRX,NASDAQ:FFIV,NASDAQ:FAST,NASDAQ:FISV,NASDAQ:FLEX,NASDAQ:FOSL,NASDAQ:GRMN,NASDAQ:GILD,NASDAQ:GOOG,NASDAQ:GMCR,NASDAQ:HSIC,NASDAQ:INFY,NASDAQ:INTC,NASDAQ:INTU,NASDAQ:ISRG,NASDAQ:KLAC,NASDAQ:KFT,NASDAQ:LRCX,NASDAQ:LINTA,NASDAQ:LIFE,NASDAQ:LLTC,NASDAQ:MRVL,NASDAQ:MAT,NASDAQ:MXIM,NASDAQ:MCHP,NASDAQ:MU,NASDAQ:MSFT,NASDAQ:MNST,NASDAQ:MYL,NASDAQ:NTAP,NASDAQ:NFLX,NASDAQ:NWSA,NASDAQ:NUAN,NASDAQ:NVDA,NASDAQ:ORLY,NASDAQ:ORCL,NASDAQ:PCAR,NASDAQ:PAYX,NASDAQ:PCLN,NASDAQ:PRGO,NASDAQ:QCOM,NASDAQ:GOLD,NASDAQ:RIMM,NASDAQ:ROST,NASDAQ:SNDK,NASDAQ:STX,NASDAQ:SHLD,NASDAQ:SIAL,NASDAQ:SIRI,NASDAQ:SPLS,NASDAQ:SBUX,NASDAQ:SRCL,NASDAQ:SYMC,NASDAQ:TXN,NASDAQ:VRSN,NASDAQ:VRTX,NASDAQ:VIAB,NASDAQ:VMED,NASDAQ:VOD,NASDAQ:WCRX,NASDAQ:WFM,NASDAQ:WYNN,NASDAQ:XLNX,NASDAQ:YHOO')
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
      stocks.json.send(body)
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
