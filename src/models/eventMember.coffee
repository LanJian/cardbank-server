mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.ObjectId


##########################################################################
## Schema
##########################################################################
# TODO: validate
schema = new Schema
  event: ObjectId
  userId: ObjectId
  isContact: Boolean

##########################################################################
## Model
##########################################################################
module.exports = mongoose.model 'EventMember', schema
