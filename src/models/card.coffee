mongoose = require 'mongoose'
jsdom = require 'jsdom'
window = jsdom.jsdom().createWindow()
$ = require('jquery')(window)
Schema = mongoose.Schema
ObjectId = Schema.ObjectId

templates = require './template'

##########################################################################
## Schema
##########################################################################
# TODO: validate
schema = new Schema
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
  userId :
    type    : ObjectId
    require : true

schema.virtual('template').get  ->
  # resolve template
  templateName = @templateConfig.baseTemplate
  if templateName == null
    templateName = templates['default_template_name']
  template = templates[templateName]
  # merge custom template config with base config
  properties = $.extend true, {},
    template.properties, @templateConfig.properties
  imageUrl = if template.image_url then template.image_url else "templates/#{templateName}.png"
  return {
    templateName: templateName,
    imageUrl: imageUrl,
    properties: properties
  }

schema.set 'toJSON', {virtuals: true}

##########################################################################
## Model
##########################################################################
module.exports = mongoose.model 'Card', schema
