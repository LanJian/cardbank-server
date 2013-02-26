Card = require '../models/card'


CardController =
  #------------------------------------------------------------------------
  # Actions
  #------------------------------------------------------------------------
  index: (req, res) ->
    Card.find {userId: req.user.id}, null,
      {sort: ['lastName', 'descending']}, (err, data) ->
        if err
          res.send {err: err}
        res.send data
        

  create: (req, res) ->
    if not req.user
      res.send 'not authenticated'
    card = req.body
    card.userId = req.user.id
    card.save (err, val) ->
      if err
        res.send {err: err}
      res.send val


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

