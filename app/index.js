var app, assets, express, mongoose, port, stylus;

express = require('express');

stylus = require('stylus');

assets = require('connect-assets');

mongoose = require('mongoose');

require('express-resource');

app = express();

app.configure('dev', function() {
  return app.set('db-name', "dummy");
});

app.configure('test', function() {
  return app.set('db-name', "cardbank-test");
});

app.configure('prod', function() {
  return app.set('db-name', "cardbank-prod");
});

app.configure(function() {
  app.use(assets());
  app.use(express.static(process.cwd() + '/public'));
  app.set('view engine', 'jade');
  app.use(express.bodyParser());
  app.use(express.cookieParser());
  app.use(express.session());
  return app.use(express.logger());
});

app.db = mongoose.connect('localhost', app.set('db-name'));

app.resource('users', require('./controllers/user'));

port = process.env.PORT || process.env.VMC_APP_PORT || 3000;

app.listen(port, function() {
  return console.log("Listening on " + port + "\nPress CTRL-C to stop server.");
});
