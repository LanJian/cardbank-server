User = require '../models/user'
Card = require '../models/card'


ContactController =
  #------------------------------------------------------------------------
  # Actions
  #------------------------------------------------------------------------
  index: (req, res) ->
    if not req.user
      res.send {status: 'failure', err: 'not authenticated'}
    Card.find {_id: {$in: req.user.contacts}}, (err, data) ->
      if err
        res.send {status: 'failure', err: err}
      res.send {status: 'success', updatedAt: req.user.updatedAt, cards: data}

  create: (req, res) ->
    if not req.user
      res.send {status: 'failure', err: 'not authenticated'}
    card = req.body
    console.log 'card', card
    # Add the contact to the current user
    User.update {_id: req.user.id}, {$addToSet: {contacts: card._id}}, (err, val) ->
      if err
        console.log '**err**', err
        res.send {status: 'failure', err: err}
      # Now add current user's first(default) card to the other person
      console.log 'userId', card.userId
      User.update {_id: card.userId}, {$addToSet: {contacts: req.user.myCards[0]}}, (err, val) ->
        if err
          res.send {status: 'failure', err: err}
        res.send {status: 'success'}


  #show: (req, res) ->
    #res.send req.card


  #load: (req, id, fn) ->
    #res = req.res
    #Card.findOne {_id: id, userId: req.user.id}, (err, data) ->
      #if err
        #res.send {error: err}
      #else
        #fn null, data


module.exports = ContactController

