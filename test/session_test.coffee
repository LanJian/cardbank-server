req = require 'request'
helper = require './test_helper'


host = helper.host


describe 'Session test', ->
  user =
    email: 'foo@bar.com'
    password: 'foobar'

  sessionId = null
  before (done) ->
    helper.dropDB ->
      req.post "#{host}/users", form: user, (e, r, b) ->
        res = JSON.parse r.body
        sessionId = res.sessionId
        done()

  after (done) ->
    console.log '[[[ Done session tests ]]]'
    done()


  describe 'Create session', ->
    noUser =
      email: 'wrong@wrong.com'
      password: 'pass'
    wrongPass =
      email: 'foo@bar.com'
      password: 'wrong'

    # Sign out
    before (done) ->
      req.del "#{host}/sessions/#{sessionId}", (e, r, b) ->
        done()

    describe 'correct credentials', ->
      response = null
      res = null
      before (done) ->
        req.post "#{host}/sessions", form: user, (e, r, b) ->
          response = r
          res = JSON.parse r.body
          done()

      it 'is successful', (done) ->
        response.should.have.status 200
        res.should.have.property 'status'
        res.status.should.equal 'success'
        done()

      it 'contains userId and sessionId', (done) ->
        res.should.have.property 'userId'
        res.should.have.property 'sessionId'
        done()

    describe 'non-existent user', ->
      response = null
      res = null
      before (done) ->
        req.post "#{host}/sessions", form: noUser, (e, r, b) ->
          response = r
          res = JSON.parse r.body
          done()

      it 'is failure', (done) ->
        response.should.have.status 403
        res.should.have.property 'status'
        res.status.should.equal 'failure'
        done()

    describe 'incorrect password', ->
      response = null
      res = null
      before (done) ->
        req.post "#{host}/sessions", form: wrongPass, (e, r, b) ->
          response = r
          res = JSON.parse r.body
          done()

      it 'is failure', (done) ->
        response.should.have.status 403
        res.should.have.property 'status'
        res.status.should.equal 'failure'
        done()


  describe 'Delete session', ->
    res = null
    before (done) ->
      req.post "#{host}/sessions", form: user, (e, r, b) ->
        res = JSON.parse r.body
        done()

    it 'is logged out', (done) ->
      req.del "#{host}/sessions/#{res.sessionId}", (e, r, b) ->
        result = JSON.parse r.body
        result.should.have.property 'status'
        result.status.should.equal 'success'
        req.get "#{host}/users/#{res.userId}", (e, r, b) ->
          result = JSON.parse r.body
          result.should.have.property 'status'
          result.should.have.property 'err'
          result.status.should.equal 'failure'
          result.err.should.equal 'not authenticated'
          done()

