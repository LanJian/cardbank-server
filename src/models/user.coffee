mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = mongoose.ObjectId


##########################################################################
## Schema
##########################################################################
schema = new Schema
  firstName      : String
  lastName       : String
  email          : String
  password       : String
  salt           : String
  hashedPassword : String


##########################################################################
## Model
##########################################################################
console.log 'user model'
module.exports = mongoose.model 'User', schema
