_ = require 'underscore-plus'
togglePackagesManager = require './toggle-packages-manager'

class TogglePackagesStatusView extends HTMLDivElement
  initialize: ->
    @classList.add('toggle-packages-wrapper', 'inline-block')
    @togglePackagesLinks = document.createElement('div')
    @appendChild(@togglePackagesLinks)
    @attach()
    this

  destroy: ->
    @activateDisposable?.dispose()
    @statusBarTile?.destroy()

  attach: =>
    statusBar = atom.views.getView(atom.workspace).querySelector('status-bar')
    if statusBar?
      @statusBarTile = statusBar.addLeftTile(item: this, priority: 20)
      @setupChangeHandlers()
    else
      @activateDisposable = atom.packages.onDidActivateInitialPackages =>
        @activateDisposable.dispose()
        @attach()

  setupChangeHandlers: ->
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
    packageLink = @getPackageStatusElement(name)
    packageLink?.classList.remove(@DISABLED_PACKAGE_CLASS)

  disablePackage: (name) ->
    packageLink = @getPackageStatusElement(name)
    packageLink?.classList.add(@DISABLED_PACKAGE_CLASS)

  removeTogglePackage: (name) ->
    packageLink = @getPackageStatusElement(name)
    if packageLink?
      @togglePackagesLinks.removeChild(packageLink)

  addTogglePackage: (name) ->
    if !togglePackagesManager.isValidPackage(name)
      console.warn "'#{name}' is not an available package name"
      return

    packageLink = document.createElement('a')
    packageLink.id = name
    packageLink.textContent = @getPackageDisplayName(name)
    packageLink.addEventListener 'click', ->
      togglePackagesManager.togglePackage(name)
    @togglePackagesLinks.appendChild(packageLink)
    if not togglePackagesManager.isPackageEnabled(name)
      @disablePackage(name)

  getPackageDisplayName: (name) ->
    _.undasherize(_.uncamelcase(name))

  getPackageStatusElement: (name) ->
    if not togglePackagesManager.isValidPackageName(name)
      return
    @togglePackagesLinks.querySelector "##{name}"

module.exports = document.registerElement('toggle-packages', prototype: TogglePackagesStatusView.prototype)
