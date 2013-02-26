User = require '../models/user'



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
      if err
        console.log 'error: ',  err
        res.send err
      res.send val


  show: (req, res) ->
    console.log "show user #{req.params.user}"
    res.send req.user


  load: (req, id, fn) ->
    res = req.res
    if req.session.userId and req.session.userId == id
      User.findOne {_id: req.session.userId}, (err, data) ->
        if err
          res.send {error: err}
        else
          fn null, data
    else
      res.send "not authorized"


module.exports = UserController

