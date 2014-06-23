{View} = require 'atom'

module.exports =
class TogglePackagesView extends View
  @content: ->
    @div class: 'toggle-packages-wrapper inline-block', =>
      @div outlet: 'togglePackages'

  initialize: (serializeState) ->
    atom.workspaceView.command "toggle-packages:toggle", => @toggle()

  serialize: ->

  destroy: ->
    @detach()

  attach: ->
    atom.workspaceView.statusBar?.appendLeft(this) unless @hasParent()

  toggle: ->
    if @hasParent()
      @detach()
    else
      if atom.workspaceView.statusBar?
        @attach()
      else
        view = this
        atom.packages.once 'activated', ->
          view.attach()

  addTogglePackage: (togglePackage) ->
    @togglePackages.append(" <a href=\"#\">#{togglePackage}</a>")
