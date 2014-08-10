Cardbank server

## Development

Install [Node 0.10.25 (with npm 1.3.24)](http://nodejs.org/dist/v0.10.25/node-v0.10.25.tar.gz), [MongoDB](http://www.mongodb.org/downloads), and [Heroku Toolbelt](https://toolbelt.heroku.com/).
Then do the following setup in the project directory:

    npm install
    heroku git:remote -a 'cardbeam-server'
  
To run the server:
  
    sudo mongod --nojournal
    NODE_ENV=dev cake dev
  
To run tests:

    sudo mongod --nojournal
    NODE_ENV=test cake test
  
To push to production:

    git push heroku master
    
You can verify the status of the production server with Heroku commands. The following 2 are useful:
    
    heroku ps
    heroku logs

## API:

##### Create user

- **POST /users**  
  email    : String  
  password : String

##### Create session (authenticate)

- **POST /sessions**  
  email    : String  
  password : String

##### Create card for user

- **POST /users/:id/cards?sessionId="sessionId"**  
  firstName   : String  
  lastName    : String  
  email       : String  
  phone       : String  
  companyName : String  
  jobTitle    : String  
  address     : String  
  templateConfig:  
    baseTemplate: String  
    properties: {}

##### Create contact for user

- **POST /users/:id/contacts?sessionId="sessionId"**  
  _id    : String (the contact's card's id)  
  userId : String (the contact's userId)

##### Create an event

- **POST /users/:id/events?sessionId="sessionId"**  
  eventName  : String  
  owner      : ObjectId  
  host       : String  
  location   : String  
  startTime  : Date  
  endTime    : Date  
  expiryTime : Date

  e.g.: `curl "localhost:3000/users/53cb01835bc118851e000003/events?sessionId=4fU%2BfHzuYs9vMEWtqvdoj8%2Ft" --data "eventName=Convocation" --data "location=Great Hall" --data "host=UofW" --data "owner=53cb01835bc118851e000003" --data "endTime=1407628740000" --data "startTime=1407560640000`

##### Join an event

- **POST /users/:id/events?sessionId="sessionId"**  
  eventId : String

##### Get a list of user's cards

- **GET /users/:id/cards?sessionId="sessionId"**

##### Get a list of user's contacts

- **GET /users/:id/contacts?sessionId="sessionId"**

##### Get events created or joined by user

- **GET /users/:id/events?sessionId="sessionId"**
