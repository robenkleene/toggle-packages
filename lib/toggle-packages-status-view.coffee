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
      @subscribe(atom.packages.once('activated', @attach))

  afterAttach: ->
    atom.config.observe 'toggle-packages.togglePackages', callNow: true, (togglePackages, {previous} = {}) =>
      removedPackages = _.difference(previous, togglePackages)
      for removedPackage in removedPackages
        @removeTogglePackage(removedPackage)

      addedPackages = _.difference(togglePackages, previous)
      for addedPackage in addedPackages
        @addTogglePackage(addedPackage)

    atom.config.observe 'core.disabledPackages', callNow: false, (disabledPackages, {previous} = {}) =>
      enabledPackages = _.difference(previous, disabledPackages)
      for enabledPackage in enabledPackages
        @enablePackage(enabledPackage)

      disabledPackages = _.difference(disabledPackages, previous)
      for disabledPackage in disabledPackages
        @disablePackage(disabledPackage)

  DISABLED_PACKAGE_CLASS: 'text-subtle'

  enablePackage: (name) ->
    element = @getPackageStatusElement(name)
    element.removeClass(@DISABLED_PACKAGE_CLASS)

  disablePackage: (name) ->
    element = @getPackageStatusElement(name)
    element.addClass(@DISABLED_PACKAGE_CLASS)

  removeTogglePackage: (name) ->
    element = @getPackageStatusElement(name)
    element.remove()

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
    @togglePackages.find("##{name}")
