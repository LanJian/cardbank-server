express = require 'express'
stylus = require 'stylus'
assets = require 'connect-assets'
mongoose = require 'mongoose'
require 'express-resource'

# Models
#User = require './models/user'

app = express()
# Add Connect Assets
app.use assets()
# Set the public folder as static assets
app.use express.static(process.cwd() + '/public')
# Set View Engine
app.set 'view engine', 'jade'

app.use express.bodyParser()

# MongoDB
app.db = mongoose.connect 'localhost', 'dummy'


# Resources
app.resource 'users', require('./controllers/user')

# Define Port
port = process.env.PORT or process.env.VMC_APP_PORT or 3000
# Start Server
app.listen port, -> console.log "Listening on #{port}\nPress CTRL-C to stop server."
