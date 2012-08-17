express = require 'express'
engines = require 'consolidate'
app = express()

app.configure ->
  app.engine 'html', engines.handlebars
  app.set 'view engine', 'html'
  app.set 'views', "#{__dirname}/../express/views"

  app.use express.favicon()
  app.use express.logger 'dev'
  app.use express.static "#{__dirname}/../express/public"
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.cookieParser 'secret'
  app.use express.session secret: 'keyboard cat'
  app.use app.router

app.get '/', (req, res) ->

  res.render 'index',
    title: 'Hello World'

app.listen(3000)

