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
          return res.send {status: 'failure', err: err} if err
          return res.send {status: 'success', updatedAt: req.user.updatedAt, events: data}


  show: (req, res) ->
    event = req.event
    ret = event.data.toObject()
    ret.members = event.members
    return res.send
      status : 'success'
      event  : ret


  create: (req, res) ->
    user = req.user
    body = req.body

    # Joining an event
    if body.eventId
      Event.find {_id: body.eventId}, null, {}, (err, data) ->
        if not data
          return res.send {status: 'bad request', err: 'Event not found'} if err

        if err
          return res.send {status: 'failure', err: err}

        eventMember = new EventMember
          event: body.eventId
          userId: user.id

        eventMember.save (err) ->
          if err then return res.status(500).send {status: 'failure', err: err}
          return res.send {status: 'success'}

    # Creating an event
    else
      d = new Date()
      d.setDate(d.getDate() + 1)
      startTime = parseInt(body.startTime) || d.getTime()

      d = new Date(startTime)
      d.setDate(d.getDate() + 1)
      endTime = parseInt(body.endTime) || d.getTime()

      d = new Date(endTime)
      d.setDate(d.getDate() + 7)
      expiryTime = parseInt(body.expiryTime) || d.getTime()

      if startTime > endTime || endTime > expiryTime
        return res.status(500).send
          status: 'failure',
          err: 'startTime, endTime, expiryTime should be in ascending order'

      event = new Event
        eventName  : body.eventName
        createdBy  : user.id
        owner      : body.owner || user.id
        host       : body.host || ""
        location   : body.location || ""
        startTime  : startTime
        endTime    : endTime
        expiryTime : expiryTime

      event.save (err) ->
        if err then return res.status(500).send {status: 'failure', err: err}
        return res.send {status: 'success', eventId: event.id}


  update: (req, res) ->
    delete req.body._id
    user = req.user
    req.event.update req.body, (err, numAffected, raw) ->
      if err then return res.status(500).send {status: 'failure', err: err}
      return res.send {status: 'success'}


  load: (req, id, fn) ->
    res = req.res
    Event.findOne {_id: id}, (err, data) ->
      if err
        res.status 500
        res.send {status: 'failure', err: err}
      else
        EventMember.find {event: id}, null, {}, (err, members) ->

          # Check that the member is in contact list
          members.forEach (member) ->
            member.isContact = member.id in req.user.contacts

          # Assign members to the json data
          data.members = members

          fn null, {data: data, members: members}

module.exports = EventController
