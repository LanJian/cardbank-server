User = require '../models/user'
Card = require '../models/card'
Referral = require '../models/referral'


ReferralController =
  #------------------------------------------------------------------------
  # Actions
  #------------------------------------------------------------------------

  # Gets all cards referred to the user
  index: (req, res) ->
    if not req.user
      res.send {status: 'failure', err: 'not authenticated'}
    Referral.find {referredTo: req.user.id}, 'cardId', (err, data) ->
      if err then res.send {err: err}
      cardIds = data.map (d) -> d.cardId
      Card.find {_id: {$in: cardIds}}, (err, cards) ->
        if err then res.send {err: err}
        res.send {status: 'success', cards: cards}


  create: (req, res) ->
    if not req.user
      res.send {status: 'failure', err: 'not authenticated'}
    user = req.user
    body = req.body
    body.referredFrom = user.id
    referral = new Referral body
    referral.save (err, val) ->
      if err
        res.send {status: 'failure', err: err}
      res.send {status: 'success'}


module.exports = ReferralController

