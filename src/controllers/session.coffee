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
        res.send {status: 'success', userId: user.id, sessionId: encodeURIComponent req.sessionID}
      else
        res.status 403
        res.send {status: 'failure', err: "failed to authenticate #{body.email}"}

  destroy: (req, res) ->
    sessionId = unescape req.params.session
    # This is to prevent weird shit from happening
    delete req.session
    # This actually removes the session from db
    req.sessionStore.destroy sessionId, (err, data) ->
      if err
        res.status 403
        res.send {status: 'failure', err: "failed to remove session #{sessionId}"}
      res.send {status: 'success'}

module.exports = SessionController

