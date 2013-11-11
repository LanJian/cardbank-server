MongoClient = require('mongodb').MongoClient

config = require '../config'

before (done) ->
  env = process.env.NODE_ENV
  MongoClient.connect config[env]['db']['url'], (err, db) ->
    if err
      throw err
    db.dropDatabase (err, result) ->
      if err
        throw err
      done()

module.exports =
  host: 'http://localhost:3000'
