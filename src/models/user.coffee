mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = mongoose.ObjectId


##########################################################################
## Schema
##########################################################################
schema = new Schema
  email:
    type     : String
    index    : true
    required : true
  salt           : String
  hashedPassword : String
  myCards        : [ObjectId]
  cards          : [ObjectId]


schema.virtual('password').set (password) ->
  @_password = password
  @salt = randomSalt()
  @hashedPassword = encryptPassword password


schema.virtual('password').get  ->
  @_password


schema.methods.randomSalt = ->
  # TODO: actually generate it
  "1111111111"


schema.methods.encryptPassword = ->
  


##########################################################################
## Model
##########################################################################
module.exports = mongoose.model 'User', schema
