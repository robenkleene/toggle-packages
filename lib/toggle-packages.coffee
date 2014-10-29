togglePackagesManager = require './toggle-packages-manager'
_ = require 'underscore-plus'
TogglePackagesStatusView = require './toggle-packages-status-view'

module.exports =
  togglePackagesView: null
  configDefaults:
    togglePackages: [
      'wrap-guide',
      'git-diff'
    ]

  activate: ->
    @togglePackagesStatusView = new TogglePackagesStatusView()

    togglePackagesChangeHandler = (newValue, oldValue) =>
      removedPackages = _.difference(oldValue, newValue)
      for removedPackage in removedPackages
        @removeTogglePackageCommand(removedPackage)
      addedPackages = _.difference(newValue, oldValue)
      for addedPackage in addedPackages
        @addTogglePackageCommand(addedPackage)
    atom.config.onDidChange 'toggle-packages.togglePackages', ({newValue, oldValue}) ->
      togglePackagesChangeHandler(newValue, oldValue)
    togglePackagesChangeHandler(atom.config.get('toggle-packages.togglePackages'), [])

  deactivate: ->
    @togglePackagesStatusView.destroy()

  addTogglePackageCommand: (name) ->
    if !togglePackagesManager.isValidPackage(name)
      console.warn "'#{name}' is not an available package name"
      return
    atom.workspaceView.command "toggle-packages:toggle-#{name}", => @togglePackage(name)

  removeTogglePackageCommand: (name) ->
    if not togglePackagesManager.isValidPackageName(name)
      return
    # TODO implement

  togglePackage: (name) =>
    togglePackagesManager.togglePackage(name)
