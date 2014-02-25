templates = require '../models/template'


TemplateController =
  #------------------------------------------------------------------------
  # Actions
  #------------------------------------------------------------------------
  index: (req, res) ->
    ret = []
    for k,v of templates
      if k != 'defaultTemplateName'
        v.templateName = k
        ret.push v
    res.send ret

module.exports = TemplateController
