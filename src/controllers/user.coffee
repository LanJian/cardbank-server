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
    console.log req.session
    res.send "index users"


  create: (req, res) ->
    console.log "create user"
    console.log req.body
    body = req.body
    user = new User
      email: body.email
      password: body.password
      myCards: []
      cards: []

    user.save (err, val) ->
      if err then res.send {status: 'failure', err: err}
      # create a default card
      card = new Card
        firstName: 'Your'
        lastName: 'Name'
        email: 'Your Email'
        phone: 'Your Phone'
        imageUrl: '0'
        userId: user.id
      card.save (err) ->
        if err then res.send {status: 'failure', err: err}
        # add card id to user cards
        user.myCards.push card.id
        user.save (err) ->
          if err then res.send {status: 'failure', err: err}
          console.log "sessionId", req.sessionID
          req.session.userId = user.id
          res.send {status: 'success', userId: user.id, sessionId: encodeURIComponent req.sessionID}


  show: (req, res) ->
    console.log "show user #{req.params.user}"
    res.send req.user


  load: (req, id, fn) ->
    res = req.res
    req.sessionID = unescape req.query.sessionId
    console.log "query.sessionId", req.query.sessionId
    console.log "sessionId", req.sessionID
    # Grab the session ourselves
    req.sessionStore.get req.sessionID, (err, data) ->
      if err
        req.mySession = {}
      else
        req.mySession = data
      console.log "mySession", req.mySession
      if req.mySession.userId and req.mySession.userId == id
        User.findOne {_id: req.mySession.userId}, (err, data) ->
          if err
            res.send {status: 'failure', err: err}
          else
            fn null, data
      else
        res.send {status: 'failure', err: 'not authenticated'}



module.exports = UserController

