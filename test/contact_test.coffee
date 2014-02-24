req = require 'request'
helper = require './test_helper'
Card = require '../app/models/card'
User = require '../app/models/user'


host = helper.host

describe 'Contact tests', ->
  user1 =
    email: 'foo@bar.com'
    password: 'foobar'
  user2 =
    email: 'bar@foo.com'
    password: 'barfoo'

  user1Card = null
  user2Card = null


  # Creates two users, save their info, and saves their cards
  before (done) ->
    helper.dropDB ->
      req.post "#{host}/users", form: user1, (e, r, b) ->
        res = JSON.parse r.body
        user1.userId = res.userId
        user1.sessionId = res.sessionId
        user1.query = {sessionId: res.sessionId, dummy: 'dummy'}
        req.post "#{host}/users", form: user2, (e, r, b) ->
          res = JSON.parse r.body
          user2.userId = res.userId
          user2.sessionId = res.sessionId
          user2.query = {sessionId: res.sessionId}
          console.log 'user1 careted', user1
          console.log 'user2 careted', user2
          console.log '------------------------'
          Card.findOne {userId: user1.userId}, (err, c) ->
            user1Card = JSON.parse JSON.stringify(c)
            Card.findOne {userId: user2.userId}, (err, c) ->
              user2Card = JSON.parse JSON.stringify(c)
              done()

  after (done) ->
    console.log '[[[ Done contact tests ]]]'
    done()

  describe 'Create contact', ->
    res = null
    before (done) ->
      # Get the updatedAt time before hand
      req.get "#{host}/users/#{user1.userId}/contacts", qs: user1.query, (e, r, b) ->
        console.log 'before parse', r.body
        res = JSON.parse r.body
        console.log 'user1', res
        user1.updatedAt = res.updatedAt
        req.get "#{host}/users/#{user2.userId}/contacts", qs: user2.query, (e, r, b) ->
          res = JSON.parse r.body
          console.log 'user2', res
          user2.updatedAt = res.updatedAt
          console.log 'before updatedAt', user2.updatedAt
          # Add user1's card to user2's contacts
          req.post "#{host}/users/#{user2.userId}/contacts",
            qs: user2.query, form: user1Card, (e, r, b) ->
              res = JSON.parse r.body
              done()

    it 'is successful', (done) ->
      res.should.have.property 'status'
      res.status.should.equal 'success'
      done()

    it 'adds a contact to the user', (done) ->
      User.findOne {_id: user2.userId}, (err, u) ->
        u.should.be.ok
        u.should.have.property('contacts').and.not.be.empty
        contactId = u.contacts[0]
        contactId.toString().should.equal user1Card._id
        done()

    it 'exchanges the cards so that the other user gets his card as well', (done) ->
      User.findOne {_id: user1.userId}, (err, u) ->
        u.should.be.ok
        u.should.have.property('contacts').and.not.be.empty
        contactId = u.contacts[0]
        contactId.toString().should.equal user2Card._id
        done()

  describe 'Get contacts', ->
    res = null
    before (done) ->
      req.get "#{host}/users/#{user2.userId}/contacts", qs: user2.query, (e, r, b) ->
        res = JSON.parse r.body
        done()

    it 'is successful', (done) ->
      res.should.have.property 'status'
      res.status.should.equal 'success'
      done()

    it 'contains contacts', (done) ->
      res.should.have.property 'cards'
      res.cards.should.not.be.empty
      done()

    it 'contains last updated time', (done) ->
      res.should.have.property 'updatedAt'
      done()

    it 'contains correct properties', (done) ->
      c = res.cards[0]
      c.should.have.property '_id'
      c.should.have.property 'email'
      c.should.have.property 'firstName'
      c.should.have.property 'lastName'
      c.should.have.property 'phone'
      c.should.have.property 'companyName'
      c.should.have.property 'jobTitle'
      c.should.have.property 'address'
      c.should.have.property 'userId'
      done()

    it 'only has one contact and contains correct info', (done) ->
      c = res.cards[0]
      c._id.should.equal user1Card._id
      c.email.should.equal user1Card.email
      c.firstName.should.equal user1Card.firstName
      c.lastName.should.equal user1Card.lastName
      c.phone.should.equal user1Card.phone
      c.companyName.should.equal user1Card.companyName
      c.jobTitle.should.equal user1Card.jobTitle
      c.address.should.equal user1Card.address
      c.userId.should.equal user1Card.userId
      done()

    it 'updates the timestamp', (done) ->
      console.log 'after updatedAt', res.updatedAt
      res.updatedAt.should.be.above user2.updatedAt
      done()
