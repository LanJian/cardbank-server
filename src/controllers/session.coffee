User = require '../models/user'

SessionController =
  #------------------------------------------------------------------------
  # Actions
  #------------------------------------------------------------------------
  create: (req, res) ->
    body = req.body
    User.findOne {email: body.email}, (err, user) ->
      if err
        res.send {err: err}
      if user and user.authenticate body.password
        req.session.userId = user.id
        res.send {userId: user.id}
      else
        res.send {err: "failed to authenticate #{body.email}"}

module.exports = SessionController

