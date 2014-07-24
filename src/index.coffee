express = require 'express'
stylus = require 'stylus'
assets = require 'connect-assets'
mongoose = require 'mongoose'
MongoStore = require('connect-mongo')(express)
require 'express-resource'


app = express()

# Environments
# DB config
config = require '../config'
for k,v of config
  app.configure k, ->
    db = v['db']
    app.set 'db-host', db['host']
    app.set 'db-name', db['name']
    app.set 'db-url', db['url']

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
    clear_interval: 60
  app.use express.session
    store  : store
    secret : 'topsecret'
    cookie :
      # 100 years
      maxAge : 100 * 365 * 24 * 60 * 60 * 1000
  app.use express.logger()

# MongoDB
#app.db = mongoose.connect app.set('db-host'), app.set('db-name')
app.db = mongoose.connect app.set('db-url')


# Resources
users = app.resource 'users', require('./controllers/user')
cards = app.resource 'cards', require('./controllers/card')
contacts = app.resource 'contacts', require('./controllers/contact')
referrals = app.resource 'referrals', require('./controllers/referral')
templates = app.resource 'templates', require('./controllers/template')
events = app.resource 'events', require('./controllers/event')

users.add cards
users.add contacts
users.add referrals
users.add events

sessions = app.resource 'sessions', require('./controllers/session')

# Define Port
port = process.env.PORT or process.env.VMC_APP_PORT or 3000
# Start Server
app.listen port, -> console.log "Listening on #{port}\nPress CTRL-C to stop server."

module.exports = app
