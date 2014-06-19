TogglePackagesView = require './toggle-packages-view'

module.exports =
  togglePackagesView: null

  activate: (state) ->
    @togglePackagesView = new TogglePackagesView(state.togglePackagesViewState)

  deactivate: ->
    @togglePackagesView.destroy()

  serialize: ->
    togglePackagesViewState: @togglePackagesView.serialize()
