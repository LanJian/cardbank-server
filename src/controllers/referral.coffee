User = require '../models/user'


ReferralController =
  #------------------------------------------------------------------------
  # Actions
  #------------------------------------------------------------------------

  # Gets all 
  index: (req, res) ->
    if not req.user
      res.send {status: 'failure', err: 'not authenticated'}
    Referral.find {referredTo: req.user.id}, (err, data) ->
      if err
        res.send {err: err}
      res.send {status: 'success', referrals: data}

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
      res.send {status: 'success', referral: val}


  #show: (req, res) ->
    #res.send req.card


  #load: (req, id, fn) ->
    #res = req.res
    #Card.findOne {_id: id, userId: req.user.id}, (err, data) ->
      #if err
        #res.send {error: err}
      #else
        #fn null, data


module.exports = ReferralController

