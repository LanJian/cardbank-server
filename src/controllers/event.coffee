Event = require '../models/event'
EventMember = require '../models/eventMember'

EventController =
  #------------------------------------------------------------------------
  # Actions
  #------------------------------------------------------------------------
  index: (req, res) ->
    EventMember.find {member: req.user.id}, null, {}, (err, data) ->
      idFilter = data.map (em) -> _id: em.event
      eventFilter = idFilter.concat([{createdBy: req.user.id}])

      Event.find {$or: eventFilter}, null,
        {sort: ['eventName', 'descending']}, (err, data) ->
          res.send {status: 'failure', err: err} if err
          res.send {status: 'success', updatedAt: req.user.updatedAt, events: data}


  create: (req, res) ->
    user = req.user
    body = req.body

    # Joining an event
    if body.eventId
      Event.find {_id: body.eventId}, null, {}, (err, data) ->
        if not data
          res.send {status: 'bad request', err: 'Event not found'} if err

        if err
          res.send {status: 'failure', err: err}

        eventMember = new EventMember
          event: body.eventId
          member: user.id

        eventMember.save (err) ->
          if err then res.status(500).send {status: 'failure', err: err}
          res.send {status: 'success'}

    # Creating an event
    else
      now = new Date()
      event = new Event
        eventName  : body.eventName
        createdBy  : user.id
        owner      : body.owner || user.id
        host       : body.host || user.id
        location   : body.location
        startTime  : body.startTime || now.setDate(now.getDate() + 1)
        endTime    : body.startTime || now.setDate(now.getDate() + 2)
        expiryTime : body.startTime || now.setDate(now.getDate() + 9)

      event.save (err) ->
        if err then res.status(500).send {status: 'failure', err: err}
        res.send {status: 'success', eventId: event.id}


  update: (req, res) ->
    delete req.body._id
    user = req.user
    req.event.update req.body, (err, numAffected, raw) ->
      if err then res.status(500).send {status: 'failure', err: err}
      res.send {status: 'success'}


  load: (req, id, fn) ->
    res = req.res
    Event.findOne {_id: id}, (err, data) ->
      if err
        res.status 500
        res.send {status: 'failure', err: err}
      else
        fn null, data


module.exports = EventController

