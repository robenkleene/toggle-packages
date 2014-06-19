{View} = require 'atom'

module.exports =
class TogglePackagesView extends View
  @content: ->
    @div class: 'toggle-packages overlay from-top', =>
      @div "The TogglePackages package is Alive! It's ALIVE!", class: "message"

  initialize: (serializeState) ->
    atom.workspaceView.command "toggle-packages:toggle", => @toggle()

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()

  toggle: ->
    console.log "TogglePackagesView was toggled!"
    if @hasParent()
      @detach()
    else
      atom.workspaceView.append(this)
