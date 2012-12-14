var ObjectId, Schema, mongoose, schema;

mongoose = require('mongoose');

Schema = mongoose.Schema;

ObjectId = mongoose.ObjectId;

schema = new Schema({
  firstName: String,
  lastName: String,
  email: String,
  password: String,
  salt: String,
  hashedPassword: String
});

console.log('user model');

module.exports = mongoose.model('User', schema);
