{View} = require 'atom'
_ = require 'underscore-plus'

module.exports =
class TogglePackagesView extends View
  @content: ->
    @div class: 'toggle-packages-wrapper inline-block', =>
      @div outlet: 'togglePackages'

  initialize: (@statusBar) ->
    # atom.config.observe 'toggle-packages.togglePackages', =>
    #   @attach()

  destroy: ->
    @detach()

  attach: ->
    @statusBar.appendLeft(this)

  afterAttach: ->
    togglePackageNames = @getTogglePackageNames()
    for name in togglePackageNames
      if @isValidPackage(name)
        displayName = @getPackageDisplayName(name)
        @addTogglePackage(displayName)

  addTogglePackage: (togglePackage) ->
    @togglePackages.append(" <a href=\"#\">#{togglePackage}</a>")

  getTogglePackageNames: ->
    atom.config.get('toggle-packages.togglePackages') ? []

  getPackageDisplayName: (name) ->
    _.undasherize(_.uncamelcase(name))

  isValidPackage: (name) ->
    atom.packages.getAvailablePackageNames().indexOf(name) isnt -1
