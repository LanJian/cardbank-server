Card = require '../models/card'


CardController =
  #------------------------------------------------------------------------
  # Actions
  #------------------------------------------------------------------------
  index: (req, res) ->
    Card.find {userId: req.user.id}, null,
      {sort: ['lastName', 'descending']}, (err, data) ->
        if err
          res.send {status: 'failure', err: err}
        res.send {status: 'success', cards: data}

  create: (req, res) ->
    if not req.user
      res.send 'not authenticated'
    user = req.user
    body = req.body
    body.userId = user.id
    card = new Card body
    card.save (err, val) ->
      if err
        res.send {status: 'failure', err: err}
      # add card id to user cards
      user.myCards.push card.id
      user.save (err) ->
        if err
          res.send {status: 'failure', err: err}
      res.send {status: 'success', card: val}


  show: (req, res) ->
    res.send req.card


  load: (req, id, fn) ->
    res = req.res
    Card.findOne {_id: id, userId: req.user.id}, (err, data) ->
      if err
        res.send {error: err}
      else
        fn null, data


module.exports = CardController

