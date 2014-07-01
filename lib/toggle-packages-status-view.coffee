{View} = require 'atom'
_ = require 'underscore-plus'
togglePackagesManager = require './toggle-packages-manager'

module.exports =
class TogglePackagesStatusView extends View
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
    packageHTML = " <a href=\"#\">#{displayName}</a>"
    if not togglePackagesManager.isPackageEnabled(name)
      packageHTML = " <a href=\"#\" class=\"text-subtle\">#{displayName}</a>"
    else
    @togglePackages.append(packageHTML)

  getPackageDisplayName: (name) ->
    _.undasherize(_.uncamelcase(name))
