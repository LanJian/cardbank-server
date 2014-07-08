mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.ObjectId


##########################################################################
## Schema
##########################################################################
# TODO: validate
schema = new Schema
  eventName: String
  createdBy: ObjectId

##########################################################################
## Model
##########################################################################
module.exports = mongoose.model 'Event', schema
