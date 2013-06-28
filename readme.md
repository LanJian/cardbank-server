Cardbank server

API:

- Create user

POST /users
  email    : [email]
  password : [password]

- Create session (authenticate)

POST /sessions
  email    : [email]
  password : [password]

- Create card for user

POST /users/:id/cards
  firstName : [firstName]
  lastName  : [lastName]
  email     : [email]
  phone     : [phone]

- Create contact for user

POST /users/:id/contacts
  cardId : [cardId]

- Get a list of user's cards

GET /users/:id/cards

- Get a list of user's contacts

GET /users/:id/contacts
