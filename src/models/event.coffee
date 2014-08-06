mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.ObjectId


##########################################################################
## Schema
##########################################################################
# TODO: validate
schema = new Schema
  eventName  : String
  createdBy  : ObjectId
  owner      : ObjectId
  host       : ObjectId
  location   : String
  startTime  : Date
  endTime    : Date
  expiryTime : Date

##########################################################################
## Model
##########################################################################
module.exports = mongoose.model 'Event', schema
