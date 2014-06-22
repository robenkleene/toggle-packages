TogglePackagesView = require './toggle-packages-view'

module.exports =
  togglePackagesView: null
  configDefaults:
    togglePackages: [
      'vim-mode',
      'emmet'
    ]


  activate: (state) ->
    # @togglePackagesView = new TogglePackagesView(state.togglePackagesViewState)
    @togglePackagesView = new TogglePackagesView()
    @togglePackagesView.toggle()
    # @togglePackagesView.attach()

    togglePackageNames = @getTogglePackageNames()
    for name in togglePackageNames
      if @isValidPackage(name)
        @togglePackagesView.addTogglePackage(name)

  deactivate: ->
    @togglePackagesView.destroy()

  # serialize: ->
  #   togglePackagesViewState: @togglePackagesView.serialize()

  getTogglePackageNames: ->
    atom.config.get('toggle-packages.togglePackages') ? []

  isValidPackage: (name) ->
    atom.packages.getAvailablePackageNames().indexOf(name) isnt -1
