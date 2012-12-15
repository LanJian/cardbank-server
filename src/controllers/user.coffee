User = require '../models/user'



UserController =
  #------------------------------------------------------------------------
  # Actions
  #------------------------------------------------------------------------
  index: (req, res) ->
    res.send "index users"

  create: (req, res) ->
    console.log "create user"
    console.log req.body
    body = req.body
    user = new User
      email: body.email
      password: body.password
      salt: randomSalt()

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
    User.find {_id: id}, (err, data) ->
      if err
        res.send {error: err}
      else
        fn null, data


console.log UserController
module.exports = UserController

