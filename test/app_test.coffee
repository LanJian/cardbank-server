request = require 'request'

doRequest = (url, func) ->
  request "http://localhost:5000/#{url}", func

describe 'Sample test', ->
  it 'should be true', ->
    true.should.equal true

describe 'GET /users', ->
  response = null
  before (done) ->
    doRequest 'users', (e, r, b) ->
      response = r
      done()

  it 'should return 200', (done) ->
    response.statusCode.should.equal 200
    done()

  it 'should have response of "index users"', (done) ->
    response.body.should.equal 'index users'
    done()

