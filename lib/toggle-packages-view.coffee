{View} = require 'atom'

module.exports =
class TogglePackagesView extends View
  @content: ->
    @div class: 'toggle-packages-wrapper inline-block', =>
      @div outlet: 'togglePackages'

  # initialize: (serializeState) ->
  #   atom.workspaceView.command "toggle-packages:toggle", => @toggle()

  # serialize: ->

  destroy: ->
    @detach()

  attach: ->
    attach = => atom.workspaceView.statusBar?.appendLeft(this) unless @hasParent()
    if atom.workspaceView.statusBar?
      attach()
    else
      atom.packages.once 'activated', ->
        attach()

  addTogglePackage: (togglePackage) ->
    @togglePackages.append(" <a href=\"#\">#{togglePackage}</a>")
