{WorkspaceView, View} = require 'atom'
TogglePackages = require '../lib/toggle-packages'
TogglePackagesStatusView = require '../lib/toggle-packages-status-view'

class StatusBarMock extends View
  @content: ->
    @div class: 'status-bar tool-panel panel-bottom', =>
      @div outlet: 'leftPanel', class: 'status-bar-left'

  attach: ->
    atom.workspaceView.appendToTop(this)

  appendLeft: (item) ->
    @leftPanel.append(item)

describe "activate()", ->

  beforeEach ->
    atom.workspaceView = new WorkspaceView

    waitsForPromise ->
      atom.packages.activatePackage('toggle-packages')

    runs ->
      atom.workspaceView.statusBar = new StatusBarMock()
      atom.workspaceView.statusBar.attach()
      atom.packages.emit('activated')

      view = atom.workspaceView.statusBar.leftPanel.children().view()
      expect(view).toExist()

  afterEach ->
    atom.workspaceView.statusBar.remove()
    atom.workspaceView.statusBar = null

  describe "activate()", ->

    it "appends only one .toggle-packages-wrapper", ->
      expect(atom.workspaceView.vertical.find('.toggle-packages-wrapper').length).toBe 1

# Figure out how to get the attached togglePackagesStatusView

describe "TogglePackagesStatusView", ->
  [togglePackagesStatusView, view] = []

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    atom.config.set("toggle-packages.togglePackages", ['valid-package-one', 'valid-package-two', 'invalid-package-two'])
    spyOn(atom.packages, 'getAvailablePackageNames').andReturn(['valid-package-one', 'valid-package-two', 'valid-package-three']);

    waitsForPromise ->
      atom.packages.activatePackage('toggle-packages')

    runs ->
      atom.workspaceView.statusBar = new StatusBarMock()
      atom.workspaceView.statusBar.attach()
      togglePackagesStatusView = new TogglePackagesStatusView(atom.workspaceView.statusBar)
      togglePackagesStatusView.attach()
      view = atom.workspaceView.statusBar.leftPanel.children().view()

  afterEach ->
    atom.workspaceView.statusBar.remove()
    atom.workspaceView.statusBar = null

  describe "getPackageDisplayName(name)", ->

    it "removes underscores and capitalizes", ->
      expect(togglePackagesStatusView.getPackageDisplayName("package-name")).toBe "Package Name"

  describe "The attached view", ->

    it "shows the valid packages", ->

      # $('.iterable.object').each ->
      # $(@)
      #   .doThis()
      #   .doThat()
      # elements = view.togglePackages.find('a')

      expect(view.togglePackages.find('a').length).toBe 2
      # TODO unpack the array convert it into a format where it can be compared to the array
      # console.log view.togglePackages.find('a')

  # TODO describe "addTogglePackage"
    # TODO Store the contents before adding the package, the contents after should be the contents before plus what should be added
