// Generated by CoffeeScript 1.4.0
var ObjectId, Schema, mongoose, schema;

mongoose = require('mongoose');

Schema = mongoose.Schema;

ObjectId = Schema.ObjectId;

schema = new Schema({
  firstName: String,
  lastName: String,
  email: String,
  phone: String,
  userId: {
    type: ObjectId,
    require: true
  }
});

module.exports = mongoose.model('Card', schema);
