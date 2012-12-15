mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = mongoose.ObjectId


##########################################################################
## Schema
##########################################################################
schema = new Schema
  firstName : String
  lastName  : String
  email     : String
  phone     : String
  userId    : ObjectId



##########################################################################
## Model
##########################################################################
module.exports = mongoose.model 'Card', schema
