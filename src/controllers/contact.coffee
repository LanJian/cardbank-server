User = require '../models/user'
Card = require '../models/card'


ContactController =
  #------------------------------------------------------------------------
  # Actions
  #------------------------------------------------------------------------
  index: (req, res) ->
    if not req.user
      res.send 'not authenticated'
    Card.find {userId: {$in: req.user.contacts}}, (err, data) ->
      if err
        res.send {err: err}
      res.send data

  create: (req, res) ->
    if not req.user
      res.send 'not authenticated'
    User.update {_id: req.user.id}, {$addToSet: {contacts: req.body.cardId}}, (err, val) ->
      if err
        res.send {err: err}
      res.send 'success'


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

