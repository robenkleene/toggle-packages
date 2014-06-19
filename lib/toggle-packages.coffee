TogglePackagesView = require './toggle-packages-view'

module.exports =
  togglePackagesView: null
  configDefaults:
    'togglePackages': 'vim-mode, emmet'


  activate: (state) ->
    console.log "Toggle Packages Activating"
    # @togglePackagesView = new TogglePackagesView(state.togglePackagesViewState)
    @togglePackagesView = new TogglePackagesView()
    @togglePackagesView.toggle()

  deactivate: ->
    @togglePackagesView.destroy()
    # @togglePackagesView.destroy()
    # Remove from statusBar here

  # serialize: ->
  #   togglePackagesViewState: @togglePackagesView.serialize()
