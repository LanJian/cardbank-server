module.exports =
  dev:
    db:
      host: "localhost"
      name: "cardbank-dev"
      url: "mongodb://localhost/cardbank-dev"
  test:
    db:
      host: "localhost"
      name: "cardbank-test"
      url: "mongodb://localhost/cardbank-test"
  prod:
    db:
      host: "localhost"
      name: "cardbank-prod"
      url: process.env.MONGOLAB_URI
