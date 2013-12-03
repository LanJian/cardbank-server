req = require 'request'
helper = require './test_helper'
Card = require '../app/models/card'
User = require '../app/models/user'
Referral = require '../app/models/referral'

host = helper.host

describe 'Referral tests', ->
  user1 =
    email: 'foo@bar.com'
    password: 'foobar'
  user2 =
    email: 'bar@foo.com'
    password: 'barfoo'
  user3 =
    email: 'refer@test.com'
    password: 'referTest'

  user1Card = null
  user2Card = null
  user3Card = null

  # Creates 3 users, save their info, and saves their cards
  before (done) ->
    console.log 'cardoooooooooooooooooo before'
    helper.dropDB ->
      req.post "#{host}/users", form: user1, (e, r, b) ->
        res = JSON.parse r.body
        user1.userId = res.userId
        user1.sessionId = res.sessionId
        user1.query = {sessionId: res.sessionId}
        req.post "#{host}/users", form: user2, (e, r, b) ->
          res = JSON.parse r.body
          user2.userId = res.userId
          user2.sessionId = res.sessionId
          user2.query = {sessionId: res.sessionId}
          req.post "#{host}/users", form: user3, (e, r, b) ->
            console.log "HI BOOK"
            res = JSON.parse r.body
            user3.userId = res.userId
            user3.sessionId = res.sessionId
            user3.query = {sessionId: res.sessionId}
            Card.findOne {userId: user1.userId}, (err, c) ->
              console.log "HI BOOK"
              user1Card = JSON.parse JSON.stringify(c)
              console.log "card1", user1Card
              Card.findOne {userId: user2.userId}, (err, c) ->
                user2Card = JSON.parse JSON.stringify(c)
                done()

  after (done) ->
    console.log '[[[ Done referral tests ]]]'
    done()


  describe 'Create referral', ->
    res = null
    before (done) ->
      form =
        referredTo: user2.userId
        cardId: user1Card._id
      # user3 refers user1 to user2
      req.post "#{host}/users/#{user3.userId}/referrals",
        form: form, qs: user3.query, (e, r, b) ->
          res = JSON.parse r.body
          done()

    it 'is successful', (done) ->
      console.log '****** this is res', res
      res.should.have.property('status').and.equal 'success'
      done()

    it 'creates a referral that refers user1 to user2', (done) ->
      q = {referredFrom: user3.userId, referredTo: user2.userId, cardId: user1Card._id}
      Referral.find q, (err, result) ->
        result.should.be.ok
        result.should.be.not.empty
        result.should.have.length 1
        done()

  describe 'Get referrals', ->
    res = null
    before (done) ->
      form =
        referredTo: user2.userId
        cardId: user1Card._id
      # user2 should have a referal
      req.get "#{host}/users/#{user2.userId}/referrals",
        qs: user2.query, (e, r, b) ->
          res = JSON.parse r.body
          done()

    it 'is successful', (done) ->
      res.should.have.property('status').and.equal 'success'
      done()

    it 'gets the referrals', (done) ->
      console.log 'reeeeeeeeeeeeeees', res
      res.should.have.property('cards').and.have.length 1
      res.cards[0].should.have.property('_id').and.equal user1Card._id
      done()

  describe 'Delete referrals', ->
    res = null
    before (done) ->
      # user2 should have a referal
      req.del "#{host}/users/#{user2.userId}/referrals/0",
        form: {cardId: user1Card._id}, qs: user2.query, (e, r, b) ->
          res = JSON.parse r.body
          done()

    it 'is successful', (done) ->
      res.should.have.property('status').and.equal 'success'
      done()

    it 'deletes the referral', (done) ->
      q = {cardId: user1Card._id}
      Referral.find q, (err, result) ->
        result.should.be.ok
        result.should.be.empty
        done()
