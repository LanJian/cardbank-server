bcrypt = require 'bcrypt'
mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.ObjectId


##########################################################################
## Schema
##########################################################################
schema = new Schema
  email :
    type     : String
    index    : true
    required : true
  hashedPassword :
    type    : String
    require : true
  myCards        : [ObjectId]
  cards          : [ObjectId]


## Virtuals
schema.virtual('password').set (password) ->
  @_password = password
  @hashedPassword = @encryptPassword password


schema.virtual('password').get  ->
  @_password


schema.virtual('id').get ->
  console.log "get ID: ", @_id.toHexString()
  @_id.toHexString()


## Methods
schema.methods.encryptPassword = (password) ->
  salt = bcrypt.genSaltSync 10
  bcrypt.hashSync password, salt


schema.methods.authenticate = (password) ->
  bcrypt.compareSync password, @hashedPassword
  


##########################################################################
## Model
##########################################################################
module.exports = mongoose.model 'User', schema
