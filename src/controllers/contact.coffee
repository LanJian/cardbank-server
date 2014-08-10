User = require '../models/user'
Card = require '../models/card'


ContactController =
  #------------------------------------------------------------------------
  # Actions
  #------------------------------------------------------------------------
  index: (req, res) ->
    Card.find {_id: {$in: req.user.contacts}}, (err, data) ->
      if err
        res.status 500
        return res.send {status: 'failure', err: err}
      return res.send {status: 'success', updatedAt: req.user.updatedAt, cards: data}

  create: (req, res) ->
    card = req.body
    # Add the contact to the current user
    User.findOne {_id: req.user.id}, (err, user) ->
      if err then return res.status(500).send {status: 'failure', err: err}
      user.contacts.push card._id
      user.save (err) ->
        if err then return res.status(500).send {status: 'failure', err: err}
        User.findOne {_id: card.userId}, (err, user) ->
          if err then return res.status(500).send {status: 'failure', err: err}
          user.contacts.push req.user.myCards[0]
          user.save (err) ->
            if err then return res.status(500).send {status: 'failure', err: err}
            return res.send {status: 'success'}


module.exports = ContactController

