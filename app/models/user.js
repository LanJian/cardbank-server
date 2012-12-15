var ObjectId, Schema, mongoose, schema;

mongoose = require('mongoose');

Schema = mongoose.Schema;

ObjectId = mongoose.ObjectId;

schema = new Schema({
  email: {
    type: String,
    index: true,
    required: true
  },
  salt: String,
  hashedPassword: String,
  myCards: [ObjectId],
  cards: [ObjectId]
});

schema.virtual('password').set(function(password) {
  this._password = password;
  this.salt = randomSalt();
  return this.hashedPassword = encryptPassword(password);
});

schema.virtual('password').get(function() {
  return this._password;
});

schema.methods.randomSalt = function() {
  return "1111111111";
};

schema.methods.encryptPassword = function() {};

module.exports = mongoose.model('User', schema);
