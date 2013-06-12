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
  app.set 'db-name', "cardbank-dev"
  app.set 'db-url', "mongodb://localhost/cardbank-dev"

app.configure 'test', ->
  app.set 'db-host', "localhost"
  app.set 'db-name', "cardbank-test"
  app.set 'db-url', "mongodb://localhost/cardbank-test"

app.configure 'prod', ->
  app.set 'db-host', "localhost"
  app.set 'db-name', "cardbank-prod"
  app.set 'db-url', "mongodb://heroku:79b088d746a3864e99b9b3818619c343@linus.mongohq.com:10071/app12420988"

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
    url       : app.set('db-url')
    stringify : false
  app.use express.session
    store  : store
    secret : 'topsecret'
    cookie :
      maxAge : 60 * 60 * 1000
  app.use express.logger()

# MongoDB
#app.db = mongoose.connect app.set('db-host'), app.set('db-name')
app.db = mongoose.connect app.set('db-url')


# Resources
users = app.resource 'users', require('./controllers/user')
cards = app.resource 'cards', require('./controllers/card')
contacts = app.resource 'contacts', require('./controllers/contact')
users.add cards
users.add contacts

sessions = app.resource 'sessions', require('./controllers/session')

# Define Port
port = process.env.PORT or process.env.VMC_APP_PORT or 3000
# Start Server
app.listen port, -> console.log "Listening on #{port}\nPress CTRL-C to stop server."
