{View} = require 'atom'
_ = require 'underscore-plus'
togglePackagesManager = require './toggle-packages-manager'

module.exports =
class TogglePackagesStatusView extends View
  @content: ->
    @div class: 'toggle-packages-wrapper inline-block', =>
      @div outlet: 'togglePackages'

  initialize: (@statusBar) ->
    # atom.packages.on 'activatePackage', (args) =>
    #   console.log args
    # atom.packages.on 'enablePackage', (args) =>
    #   console.log "enabledPackage with " + args
      # Just set the element to have the right class

  # Toggle packages events, confirm there is a list item for each package
  # Disabled package events, confirm that for the new or missing toggle packages, that they have the right status


  # Observe `toggle-packages.togglePackages` and `core.disabledPackages`
  # Do this after attach
  # Only callNow for one of them (the second)
  # The called method:

  updateTogglePackages: ->
    togglePackages = togglePackagesManager.getTogglePackageNames()
    disabledPackages = atom.config.get 'core.disabledPackages'


  destroy: ->
    @detach()

  attach: ->
    @statusBar.appendLeft(this)

  afterAttach: ->
    atom.config.observe 'toggle-packages.togglePackages', callNow: true, (togglePackages, {previous} = {}) =>
      removedPackages = _.difference(previous, togglePackages)
      for removedPackage in removedPackages
        @removeTogglePackage(removedPackage)

      addedPackages = _.difference(togglePackages, previous)
      for addedPackage in addedPackages
        @addTogglePackage(addedPackage)

  DISABLED_PACKAGE_CLASS: 'text-subtle'

  removeTogglePackage: (name) ->
    element = @getPackageStatusElement(name)
    element.remove()

  addTogglePackage: (name) ->
    displayName = @getPackageDisplayName(name)
    packageHTML = " <a href=\"#\" id=\"#{name}\">#{displayName}</a>"
    if not togglePackagesManager.isPackageEnabled(name)
      packageHTML = " <a href=\"#\" id=\"#{name}\" class=\"#{@DISABLED_PACKAGE_CLASS}\">#{displayName}</a>"
    @togglePackages.append(packageHTML)

  getPackageDisplayName: (name) ->
    _.undasherize(_.uncamelcase(name))

  getPackageStatusElement: (name) ->
    @togglePackages.find("##{name}")
