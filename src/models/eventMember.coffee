mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.ObjectId


##########################################################################
## Schema
##########################################################################
# TODO: validate
schema = new Schema
  event: ObjectId
  member: ObjectId

##########################################################################
## Model
##########################################################################
module.exports = mongoose.model 'EventMember', schema
