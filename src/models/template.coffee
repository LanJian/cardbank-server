fs = require 'fs'

templates = JSON.parse fs.readFileSync('./src/templates.json')

module.exports = templates
