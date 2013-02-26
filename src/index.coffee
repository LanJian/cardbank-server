express = require 'express'
stylus = require 'stylus'
assets = require 'connect-assets'
mongoose = require 'mongoose'
MongoStore = require('connect-mongo')(express)
require 'express-resource'


app = express()

# Environments
app.configure 'dev', ->
  app.set 'db-host', "localhost"
  app.set 'db-name', "dummy"

app.configure 'test', ->
  app.set 'db-host', "localhost"
  app.set 'db-name', "cardbank-test"

app.configure 'prod', ->
  app.set 'db-host', "localhost"
  app.set 'db-name', "cardbank-prod"

app.configure ->
  # Add Connect Assets
  app.use assets()
  # Set the public folder as static assets
  app.use express.static(process.cwd() + '/public')
  # Set View Engine
  app.set 'view engine', 'jade'
  app.use express.bodyParser()
  app.use express.cookieParser()
  store = new MongoStore
    db        : app.set('db-name')
    stringify : false
  app.use express.session
    store  : store
    secret : 'topsecret'
  app.use express.logger()

# MongoDB
app.db = mongoose.connect app.set('db-host'), app.set('db-name')


# Resources
users = app.resource 'users', require('./controllers/user')
cards = app.resource 'cards', require('./controllers/card')
users.add cards

sessions = app.resource 'sessions', require('./controllers/session')

# Define Port
port = process.env.PORT or process.env.VMC_APP_PORT or 3000
# Start Server
app.listen port, -> console.log "Listening on #{port}\nPress CTRL-C to stop server."
