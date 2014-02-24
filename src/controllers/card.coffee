Card = require '../models/card'
Template = require '../models/template'


CardController =
  #------------------------------------------------------------------------
  # Actions
  #------------------------------------------------------------------------
  index: (req, res) ->
    Card.find {userId: req.user.id}, null,
      {sort: ['lastName', 'descending']}, (err, data) ->
        if err then res.status(500).send {status: 'failure', err: err}
        res.send {status: 'success', updatedAt: req.user.updatedAt, cards: data}


  create: (req, res) ->
    user = req.user
    body = req.body
    body.userId = user.id
    card = new Card body
    card.save (err) ->
      if err then res.status(500).send {status: 'failure', err: err}
      # add card id to user cards
      user.myCards.push card.id
      user.save (err) ->
        if err then res.status(500).send {status: 'failure', err: err}
        res.send {status: 'success'}


  update: (req, res) ->
    delete req.body._id
    user = req.user
    req.card.update req.body, (err, numAffected, raw) ->
      if err then res.status(500).send {status: 'failure', err: err}
      # force a save so we updated the updatedAt field
      user.save (err) ->
        if err then res.status(500).send {status: 'failure', err: err}
        res.send {status: 'success'}


  load: (req, id, fn) ->
    res = req.res
    Card.findOne {_id: id, userId: req.user.id}, (err, data) ->
      if err
        res.status 500
        res.send {status: 'failure', err: err}
      else
        fn null, data


module.exports = CardController
