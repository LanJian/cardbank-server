// Generated by CoffeeScript 1.6.3
var MongoStore, app, assets, cards, contacts, express, mongoose, port, sessions, stylus, users;

express = require('express');

stylus = require('stylus');

assets = require('connect-assets');

mongoose = require('mongoose');

MongoStore = require('connect-mongo')(express);

require('express-resource');

app = express();

app.configure('dev', function() {
  app.set('db-host', "localhost");
  app.set('db-name', "cardbank-dev");
  return app.set('db-url', "mongodb://localhost/cardbank-dev");
});

app.configure('test', function() {
  app.set('db-host', "localhost");
  app.set('db-name', "cardbank-test");
  return app.set('db-url', "mongodb://localhost/cardbank-test");
});

app.configure('prod', function() {
  app.set('db-host', "localhost");
  app.set('db-name', "cardbank-prod");
  return app.set('db-url', "mongodb://heroku:79b088d746a3864e99b9b3818619c343@linus.mongohq.com:10071/app12420988");
});

app.configure(function() {
  var store;
  app.use(assets());
  app.use(express["static"](process.cwd() + '/public'));
  app.set('view engine', 'jade');
  app.use(express.bodyParser());
  app.use(express.cookieParser());
  store = new MongoStore({
    url: app.set('db-url'),
    stringify: false
  });
  app.use(express.session({
    store: store,
    secret: 'topsecret',
    cookie: {
      maxAge: 60 * 60 * 1000
    }
  }));
  return app.use(express.logger());
});

app.db = mongoose.connect(app.set('db-url'));

users = app.resource('users', require('./controllers/user'));

cards = app.resource('cards', require('./controllers/card'));

contacts = app.resource('contacts', require('./controllers/contact'));

users.add(cards);

users.add(contacts);

sessions = app.resource('sessions', require('./controllers/session'));

port = process.env.PORT || process.env.VMC_APP_PORT || 3000;

app.listen(port, function() {
  return console.log("Listening on " + port + "\nPress CTRL-C to stop server.");
});
