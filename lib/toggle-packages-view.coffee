{View} = require 'atom'

module.exports =
class TogglePackagesView extends View
  @content: ->
    # @div class: 'toggle-packages overlay from-top', =>
    #   @div "The TogglePackages package is Alive! It's ALIVE!", class: "message"
    # console.log "Got here"
    # @span "The TogglePackages package is Alive! It's ALIVE!", class: "message"
    @span 'Test'
# TODO Get the array of 'togglePackages' here and present to user

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
      view = this
      atom.packages.once 'activated', ->
        console.log "Appending..."
        # atom.workspaceView.append(view)
        atom.workspaceView.statusBar?.appendLeft(view)
