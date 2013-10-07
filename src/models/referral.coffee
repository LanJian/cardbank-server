mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.ObjectId

##########################################################################
## Schema
##########################################################################
# TODO: validate
schema = new Schema
  referredFrom : ObjectId
  referredTo   : ObjectId
  cardId       : ObjectId


##########################################################################
## Model
##########################################################################
module.exports = mongoose.model 'Referral', schema
