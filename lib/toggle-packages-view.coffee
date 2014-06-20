{View} = require 'atom'

module.exports =
class TogglePackagesView extends View
  @content: ->
    @div class: 'toggle-packages inline-block', =>
      @div outlet: 'togglePackages'

  initialize: (serializeState) ->
    atom.workspaceView.command "toggle-packages:toggle", => @toggle()

  serialize: ->

  destroy: ->
    @detach()

  toggle: ->
    if @hasParent()
      @detach()
    else
      view = this
      atom.packages.once 'activated', ->
        atom.workspaceView.statusBar?.appendLeft(view)

  addTogglePackage: (togglePackage) ->
    @togglePackages.append(togglePackage)
