mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.ObjectId


##########################################################################
## Schema
##########################################################################
# TODO: validate
schema = new Schema
  firstName : String
  lastName  : String
  email     : String
  phone     : String
  companyName : String
  jobTitle : String
  address : String
  imageUrl :
    type : String
    default : ""
  userId :
    type    : ObjectId
    require : true



##########################################################################
## Model
##########################################################################
module.exports = mongoose.model 'Card', schema
