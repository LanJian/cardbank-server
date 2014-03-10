Cardbank server

## Development

Install [Node 0.10.25 (with npm 1.3.24)](http://nodejs.org/dist/v0.10.25/node-v0.10.25.tar.gz), [MongoDB](http://www.mongodb.org/downloads), and [Heroku Toolbelt](https://toolbelt.heroku.com/).
Then do the following setup in the project directory:

    npm install
    heroku git:remote -a project
  
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
  email    : [email]  
  password : [password]

##### Create session (authenticate)

- **POST /sessions**  
  email    : [email]  
  password : [password]

##### Create card for user

- **POST /users/:id/cards**  
  firstName : [firstName]  
  lastName  : [lastName]  
  email     : [email]  
  phone     : [phone]

##### Create contact for user

- **POST /users/:id/contacts**  
  cardId : [cardId]

##### Get a list of user's cards

- **GET /users/:id/cards**

##### Get a list of user's contacts

- **GET /users/:id/contacts**
