togglePackagesManager = require './toggle-packages-manager'
_ = require 'underscore-plus'
TogglePackagesStatusView = require './toggle-packages-status-view'

module.exports =
  togglePackagesView: null
  configDefaults:
    togglePackages: [
      'vim-mode',
      'emmet'
    ]

  activate: ->
    @togglePackagesStatusView = new TogglePackagesStatusView()

    atom.config.observe 'toggle-packages.togglePackages', callNow: true, (togglePackages, {previous} = {}) =>
      removedPackages = _.difference(previous, togglePackages)
      for removedPackage in removedPackages
        @removeTogglePackageCommand(removedPackage)

      addedPackages = _.difference(togglePackages, previous)
      for addedPackage in addedPackages
        @addTogglePackageCommand(addedPackage)

  deactivate: ->
    @togglePackagesStatusView.destroy()

  addTogglePackageCommand: (name) ->
    atom.workspaceView.command "toggle-packages:toggle-#{name}", => @togglePackage(name)

  removeTogglePackageCommand: (name) ->
    # TODO implement

  togglePackage: (name) =>
    togglePackagesManager.togglePackage(name)
