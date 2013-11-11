User = require '../models/user'
Card = require '../models/card'
Referral = require '../models/referral'


ReferralController =
  #------------------------------------------------------------------------
  # Actions
  #------------------------------------------------------------------------

  # Gets all cards referred to the user
  index: (req, res) ->
    Referral.find {referredTo: req.user.id}, 'cardId', (err, data) ->
      if err then res.send {err: err}
      cardIds = data.map (d) -> d.cardId
      Card.find {_id: {$in: cardIds}}, (err, cards) ->
        if err then res.send {err: err}
        res.send {status: 'success', cards: cards}


  create: (req, res) ->
    user = req.user
    body = req.body
    body.referredFrom = user.id
    referral = new Referral body
    referral.save (err, val) ->
      if err
        res.status 500
        res.send {status: 'failure', err: err}
      res.send {status: 'success'}


  delete: (req, res) ->
    req.referral.remove (err, data) ->
      if err
        res.status 500
        res.send {status: 'failure', err: err}
      res.send {status: 'success'}

  load: (req, id, fn) ->
    res = req.res
    Referral.findOne {_id: id, referredTo: req.user.id}, (err, data) ->
      if err
        res.status 500
        res.send {status: 'failure', err: err}
      else
        fn null, data


module.exports = ReferralController

