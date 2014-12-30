togglePackagesManager = require './toggle-packages-manager'
_ = require 'underscore-plus'
TogglePackagesStatusView = require './toggle-packages-status-view'

module.exports =
  config:
    togglePackages:
      type: 'array'
      default: ['wrap-guide', 'git-diff']
      items:
        type: 'string'

  activate: ->
    @togglePackagesStatusView = new TogglePackagesStatusView().initialize()
    @commandNameToDisposable = {}

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
    for name, disposable of @commandNameToDisposable
      disposable.dispose()
    @togglePackagesStatusView.destroy()

  addTogglePackageCommand: (name) ->
    if !togglePackagesManager.isValidPackage(name)
      console.warn "'#{name}' is not an available package name"
      return
    disposable = atom.commands.add 'atom-workspace', "toggle-packages:toggle-#{name}", =>
      @togglePackage(name)
    if disposable?
      @commandNameToDisposable[name] = disposable

  removeTogglePackageCommand: (name) ->
    if not togglePackagesManager.isValidPackageName(name)
      return
    if @commandNameToDisposable.hasOwnProperty(name)
      disposable = @commandNameToDisposable[name]
      disposable.dispose()
      delete @commandNameToDisposable[name]

  togglePackage: (name) ->
    togglePackagesManager.togglePackage(name)
