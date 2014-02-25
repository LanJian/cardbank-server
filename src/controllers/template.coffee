templates = require '../models/template'


TemplateController =
  #------------------------------------------------------------------------
  # Actions
  #------------------------------------------------------------------------
  index: (req, res) ->
    res.send templates

module.exports = TemplateController
