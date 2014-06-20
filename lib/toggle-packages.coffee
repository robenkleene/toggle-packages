TogglePackagesView = require './toggle-packages-view'

module.exports =
  togglePackagesView: null
  configDefaults:
    'togglePackages': 'vim-mode, emmet'

  activate: (state) ->
    # @togglePackagesView = new TogglePackagesView(state.togglePackagesViewState)
    @togglePackagesView = new TogglePackagesView()
    @togglePackagesView.toggle()

    togglePackages = @getTogglePackages()
    for togglePackage in togglePackages
      @togglePackagesView.addTogglePackage(togglePackage)

  deactivate: ->
    @togglePackagesView.destroy()

  # serialize: ->
  #   togglePackagesViewState: @togglePackagesView.serialize()

  getTogglePackages: ->
    atom.config.get('toggle-packages.togglePackages') ? []
