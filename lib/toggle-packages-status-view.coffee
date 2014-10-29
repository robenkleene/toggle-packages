{$, View} = require 'atom'
_ = require 'underscore-plus'
togglePackagesManager = require './toggle-packages-manager'

module.exports =
class TogglePackagesStatusView extends View
  @content: ->
    @div class: 'toggle-packages-wrapper inline-block', =>
      @div outlet: 'togglePackages'

  initialize: ->
    @attach()

  destroy: ->
    @remove()

  attach: =>
    statusBar = atom.workspaceView.statusBar
    if statusBar
      statusBar.appendLeft(this)
    else
      atom.packages.onDidActivateAll(@attach)

  afterAttach: ->
    togglePackagesChangeHandler = (newValue, oldValue) =>
      removedPackages = _.difference(oldValue, newValue)
      for removedPackage in removedPackages
        @removeTogglePackage(removedPackage)
      addedPackages = _.difference(newValue, oldValue)
      for addedPackage in addedPackages
        @addTogglePackage(addedPackage)
    atom.config.onDidChange 'toggle-packages.togglePackages', ({newValue, oldValue}) ->
      togglePackagesChangeHandler(newValue, oldValue)
    togglePackagesChangeHandler(atom.config.get('toggle-packages.togglePackages'), [])

    disabledPackagesChangeHandler = (newValue, oldValue) =>
      enabledPackages = _.difference(oldValue, newValue)
      for enabledPackage in enabledPackages
        @enablePackage(enabledPackage)
      disabledPackages = _.difference(newValue, oldValue)
      for disabledPackage in disabledPackages
        @disablePackage(disabledPackage)
    atom.config.onDidChange 'core.disabledPackages', ({newValue, oldValue}) ->
      disabledPackagesChangeHandler(newValue, oldValue)
    disabledPackagesChangeHandler(atom.config.get('core.disabledPackages'), [])

  DISABLED_PACKAGE_CLASS: 'text-subtle'

  enablePackage: (name) ->
    element = @getPackageStatusElement(name)
    element.removeClass(@DISABLED_PACKAGE_CLASS)

  disablePackage: (name) ->
    element = @getPackageStatusElement(name)
    element.addClass(@DISABLED_PACKAGE_CLASS)

  removeTogglePackage: (name) ->
    element = @getPackageStatusElement(name)
    element?.remove()

  addTogglePackage: (name) ->
    if !togglePackagesManager.isValidPackage(name)
      console.warn "'#{name}' is not an available package name"
      return
    packageElement = $("<a>")
    packageElement.attr("id", name)
    packageElement.append(@getPackageDisplayName(name))
    packageElement.click =>
      togglePackagesManager.togglePackage(name)
    if not togglePackagesManager.isPackageEnabled(name)
      packageElement.addClass(@DISABLED_PACKAGE_CLASS)
    @togglePackages.append(" ")
    @togglePackages.append(packageElement)

  getPackageDisplayName: (name) ->
    _.undasherize(_.uncamelcase(name))

  getPackageStatusElement: (name) ->
    if not togglePackagesManager.isValidPackageName(name)
      return
    @togglePackages.find("##{name}")
