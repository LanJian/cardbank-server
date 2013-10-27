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
    console.log "body", req.body
    if not req.user
      res.send {status: 'failure', err: 'not authenticated'}
    user = req.user
    body = req.body
    body.userId = user.id
    card = new Card body
    card.save (err) ->
      if err then res.send {status: 'failure', err: err}
      # add card id to user cards
      user.myCards.push card.id
      user.save (err) ->
        if err then res.send {status: 'failure', err: err}
        res.send {status: 'success'}


  update: (req, res) ->
    delete req.body._id
    req.card.update req.body, (err, numAffected, raw) ->
      if err then res.send {status: 'failure', err: err}
      res.send {status: 'success'}


  load: (req, id, fn) ->
    if not req.user
      res.send {status: 'failure', err: 'not authenticated'}
    res = req.res
    Card.findOne {_id: id, userId: req.user.id}, (err, data) ->
      if err
        res.send {status: 'failure', err: err}
      else
        fn null, data


module.exports = CardController

