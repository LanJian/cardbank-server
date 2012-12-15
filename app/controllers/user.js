var User, UserController;

User = require('../models/user');

UserController = {
  index: function(req, res) {
    return res.send("index users");
  },
  create: function(req, res) {
    var body, user;
    console.log("create user");
    console.log(req.body);
    body = req.body;
    user = new User({
      email: body.email,
      password: body.password,
      salt: randomSalt()
    });
    return user.save(function(err, val) {
      if (err) {
        console.log('error: ', err);
        res.send(err);
      }
      return res.send(val);
    });
  },
  show: function(req, res) {
    console.log("show user " + req.params.user);
    return res.send(req.user);
  },
  load: function(req, id, fn) {
    var res;
    res = req.res;
    return User.find({
      _id: id
    }, function(err, data) {
      if (err) {
        return res.send({
          error: err
        });
      } else {
        return fn(null, data);
      }
    });
  }
};

console.log(UserController);

module.exports = UserController;
