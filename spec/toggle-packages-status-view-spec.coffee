{WorkspaceView, View} = require 'atom'
TogglePackages = require '../lib/toggle-packages'

class StatusBarMock extends View
  @content: ->
    @div class: 'status-bar tool-panel panel-bottom', =>
      @div outlet: 'leftPanel', class: 'status-bar-left'

  attach: ->
    atom.workspaceView.appendToTop(this)

  appendLeft: (item) ->
    @leftPanel.append(item)

describe "TogglePackagesStatusView", ->

  beforeEach ->
    atom.workspaceView = new WorkspaceView

    waitsForPromise ->
      atom.packages.activatePackage('toggle-packages')

    runs ->
      atom.workspaceView.statusBar = new StatusBarMock()
      atom.workspaceView.statusBar.attach()
      atom.packages.emit('activated')

      togglePackagesView = atom.workspaceView.statusBar.leftPanel.children().view()
      expect(togglePackagesView).toExist()

  afterEach ->
    atom.workspaceView.statusBar.remove()
    atom.workspaceView.statusBar = null

  describe "@attach()", ->
    it "appends only one .toggle-packages-wrapper", ->
      expect(atom.workspaceView.vertical.find('.toggle-packages-wrapper').length).toBe 1
