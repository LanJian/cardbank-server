req = require 'request'

# TODO: put this in config
host = 'http://localhost:3000'


describe 'POST /users', ->
  user =
    email: 'test@gmail.com'
    password: 'mypassword'

  response = null
  res = null
  before (done) ->
    req.post "#{host}/users", form: user, (e, r, b) ->
      response = r
      res = JSON.parse response.body
      done()

  it 'is successful', (done) ->
    response.statusCode.should.equal 200
    res.should.have.property 'status'
    res.status.should.equal 'success'
    done()

  it 'contains userId and sessionId', (done) ->
    res.should.have.property 'userId'
    res.should.have.property 'sessionId'
    done()

  it 'creates a default card for the user', (done) ->
    query = {sessionId: res.sessionId}
    req.get "#{host}/users/#{res.userId}/cards", qs: query, (e, r, b) ->
      cardRes = JSON.parse r.body
      cardRes.should.have.property 'cards'
      cardRes.cards.should.not.be.empty
      done()
