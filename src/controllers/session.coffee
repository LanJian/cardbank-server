User = require '../models/user'

SessionController =
  #------------------------------------------------------------------------
  # Actions
  #------------------------------------------------------------------------
  create: (req, res) ->
    body = req.body
    User.findOne {email: body.email}, (err, user) ->
      if err
        res.send {status: 'failure', err: err}
      if user and user.authenticate body.password
        req.session.userId = user.id
        console.log "sessionId", req.sessionID
        res.send {status: 'success', userId: user.id, sessionId: encodeURIComponent req.sessionID}
      else
        res.send {status: 'failure', err: "failed to authenticate #{body.email}"}

module.exports = SessionController

