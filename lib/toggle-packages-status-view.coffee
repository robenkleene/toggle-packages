{View} = require 'atom'
_ = require 'underscore-plus'
togglePackagesManager = require './toggle-packages-manager'

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
    togglePackageNames = togglePackagesManager.getTogglePackageNames()
    for name in togglePackageNames
        @addTogglePackage(name)

  addTogglePackage: (name) ->
    displayName = @getPackageDisplayName(name)
    @togglePackages.append(" <a href=\"#\">#{displayName}</a>")

  getPackageDisplayName: (name) ->
    _.undasherize(_.uncamelcase(name))
