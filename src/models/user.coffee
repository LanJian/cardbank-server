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
    index    :
      unique : true
      dropDups: true
    required : true
  hashedPassword :
    type    : String
    required : true
  myCards  : [ObjectId]
  contacts : [ObjectId]


## Virtuals
schema.virtual('password').set (password) ->
  @_password = password
  @hashedPassword = @encryptPassword password


schema.virtual('password').get  ->
  @_password


schema.virtual('id').get ->
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
