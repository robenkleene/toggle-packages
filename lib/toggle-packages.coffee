module.exports =
  togglePackagesView: null
  configDefaults:
    togglePackages: [
      'vim-mode',
      'emmet'
    ]

  activate: ->
    atom.packages.once('activated', createTogglePackagesView)

createTogglePackagesView = ->
  {statusBar} = atom.workspaceView
  if statusBar?
    TogglePackagesStatusView = require './toggle-packages-status-view'
    view = new TogglePackagesStatusView(statusBar)
    view.attach()
