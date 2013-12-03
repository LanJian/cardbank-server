req = require 'request'
helper = require './test_helper'
Card = require '../app/models/card'


host = helper.host

describe 'Card tests', ->
  user =
    email: 'foo@bar.com'
    password: 'foobar'

  card =
    firstName: 'first'
    lastName: 'last'
    email: 'email@email.com'
    phone: '111111111'

  userId = null
  sessionId = null
  query = null
  before (done) ->
    helper.dropDB ->
      req.post "#{host}/users", form: user, (e, r, b) ->
        res = JSON.parse r.body
        userId = res.userId
        sessionId = res.sessionId
        query = {sessionId: sessionId}
        done()

  after (done) ->
    console.log '[[[ Done card tests ]]]'
    done()

  describe 'Get cards', ->
    res = null
    before (done) ->
      req.get "#{host}/users/#{userId}/cards", qs: query, (e, r, b) ->
        res = JSON.parse r.body
        done()

    it 'is successful', (done) ->
      res.should.have.property 'status'
      res.status.should.equal 'success'
      done()

    it 'contains cards', (done) ->
      res.should.have.property 'cards'
      res.cards.should.not.be.empty
      done()

    it 'contains correct properties', (done) ->
      c = res.cards[0]
      c.should.have.property '_id'
      c.should.have.property 'email'
      c.should.have.property 'firstName'
      c.should.have.property 'lastName'
      c.should.have.property 'phone'
      c.should.have.property 'userId'
      c.should.have.property 'imageUrl'
      done()

  describe 'Create card', ->
    res = null
    count = null

    before (done) ->
      Card.count {userId: userId}, (err, c) ->
        count = c
        req.post "#{host}/users/#{userId}/cards", qs: query, form: card, (e, r, b) ->
          res = JSON.parse r.body
          done()

    it 'is successful', (done) ->
      res.should.have.property 'status'
      res.status.should.equal 'success'
      done()

    it 'creates a new card', (done) ->
      Card.count {userId: userId}, (err, c) ->
        c.should.equal count + 1
        done()

    it 'creates a new card with correct properties', (done) ->
      Card.findOne card, (err, c) ->
        c.should.be.ok
        c.should.have.property('_id')
        c.should.have.property('imageUrl')
        c.should.have.property('firstName').and.equal card.firstName
        c.should.have.property('lastName').and.equal card.lastName
        c.should.have.property('email').and.equal card.email
        c.should.have.property('phone').and.equal card.phone
        c.should.have.property('userId')
        c.userId.toString().should.equal userId
        done()

  describe 'Update card', ->
    res = null
    _id = null

    newCard =
      firstName: 'abcd'
      phone: '222222'

    before (done) ->
      Card.findOne card, (err, c) ->
        _id = c._id.toString()
        req.put "#{host}/users/#{userId}/cards/#{_id}", qs: query, form: newCard, (e, r, b) ->
          res = JSON.parse r.body
          done()

    it 'is successful', (done) ->
      res.should.have.property 'status'
      res.status.should.equal 'success'
      done()

    it 'updates the card with correct properties', (done) ->
      Card.findOne newCard, (err, c) ->
        c.should.be.ok
        c.should.have.property('firstName').and.equal newCard.firstName
        c.should.have.property('phone').and.equal newCard.phone
        done()

    it 'does not change old properties', (done) ->
      Card.findOne newCard, (err, c) ->
        c.should.be.ok
        c.should.have.property('_id')
        c._id.toString().should.equal _id
        c.should.have.property('imageUrl')
        c.should.have.property('lastName').and.equal card.lastName
        c.should.have.property('email').and.equal card.email
        c.should.have.property('userId')
        c.userId.toString().should.equal userId
        done()
