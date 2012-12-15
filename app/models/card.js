var ObjectId, Schema, mongoose, schema;

mongoose = require('mongoose');

Schema = mongoose.Schema;

ObjectId = mongoose.ObjectId;

schema = new Schema({
  firstName: String,
  lastName: String,
  email: String,
  phone: String,
  userId: ObjectId
});

module.exports = mongoose.model('Card', schema);
