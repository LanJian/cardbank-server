User = require '../models/user'
Card = require '../models/card'


UserController =
  #------------------------------------------------------------------------
  # Actions
  #------------------------------------------------------------------------
  index: (req, res) ->
    if req.session.count
      console.log ' fount'
      req.session.count = req.session.count + 1
    else
      console.log 'not fount'
      req.session.count = 1
    res.send "index users"


  show: (req, res) ->
    user = req.user
    res.send
      status: 'success'
      email: user.email
      cards: user.myCards
      contacts: user.contacts

  create: (req, res) ->
    body = req.body
    user = new User
      email: body.email
      password: body.password
      myCards: []
      cards: []

    user.save (err, val) ->
      if err then res.status(500).send {status: 'failure', err: err}
      # create a default card
      card = new Card
        firstName: 'Your'
        lastName: 'Name'
        email: user.email
        phone: 'Your Phone'
        companyName: 'Your Company'
        jobTitle: 'Your Job Title'
        address: 'Your Address'
        imageUrl: '0'
        userId: user.id
      card.save (err) ->
        if err then res.status(500).send {status: 'failure', err: err}
        # add card id to user cards
        user.myCards.push card.id
        user.save (err) ->
          if err then res.status(500).send {status: 'failure', err: err}
          req.session.userId = user.id
          res.send {status: 'success', userId: user.id, sessionId: encodeURIComponent req.sessionID}


  load: (req, id, fn) ->
    res = req.res
    sid = unescape req.query.sessionId
    # Grab the session ourselves
    req.sessionStore.get sid, (err, data) ->
      if err
        req.mySession = {}
      else
        req.mySession = data
      console.log 'dummy', req.param 'dummy'
      console.log req.query.sessionId, sid, req.mySession, id
      if req.mySession.userId and req.mySession.userId == id
        User.findOne {_id: req.mySession.userId}, (err, data) ->
          if err
            res.status 500
            res.send {status: 'failure', err: err}
          else
            fn null, data
      else
        res.status 403
        res.send {status: 'failure', err: 'not authenticated'}



module.exports = UserController

