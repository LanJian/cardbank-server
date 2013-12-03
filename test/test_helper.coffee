MongoClient = require('mongodb').MongoClient

config = require '../config'

env = process.env.NODE_ENV
if env != 'test'
  console.log '** NODE_ENV is not test! **'
  console.log 'Exiting now. No test performed.'
  process.exit(1)

dropDB = (cb) ->
  MongoClient.connect config[env]['db']['url'], (err, db) ->
    if err
      throw err
    db.dropDatabase (err, result) ->
      console.log 'dropDatabase', err, result
      if err
        throw err
      cb()

module.exports =
  host: 'http://localhost:3000'
  dropDB: dropDB
