User = require '../models/user'
Card = require '../models/card'


ContactController =
  #------------------------------------------------------------------------
  # Actions
  #------------------------------------------------------------------------
  index: (req, res) ->
    console.log 'logging it', req.query
    Card.find {_id: {$in: req.user.contacts}}, (err, data) ->
      if err
        res.status 500
        res.send {status: 'failure', err: err}
      res.send {status: 'success', updatedAt: req.user.updatedAt, cards: data}

  create: (req, res) ->
    card = req.body
    #console.log 'card', card
    #console.log 'i have update', (new Date()).toISOString()
    # Add the contact to the current user
    User.findOne {_id: req.user.id}, (err, user) ->
      if err then res.status(500).send {status: 'failure', err: err}
      user.contacts.push card._id
      user.save (err) ->
        if err then res.status(500).send {status: 'failure', err: err}
        User.findOne {_id: card.userId}, (err, user) ->
          if err then res.status(500).send {status: 'failure', err: err}
          user.contacts.push req.user.myCards[0]
          user.save (err) ->
            if err then res.status(500).send {status: 'failure', err: err}
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

