{$, WorkspaceView, View} = require 'atom'
TogglePackages = require '../lib/toggle-packages'
TogglePackagesStatusView = require '../lib/toggle-packages-status-view'
testDataHelper = require './fixtures/test-data-helper'

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

describe "TogglePackagesStatusView", ->
  [togglePackagesStatusView, view] = []

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    testDataHelper.setup()

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
      expect(togglePackagesStatusView.getPackageDisplayName(testDataHelper.VALID_PACKAGE_ONE)).toBe testDataHelper.VALID_PACKAGE_ONE_DISPLAY_NAME

  describe "The attached view", ->

    it "shows the valid packages", ->
      elements = view.togglePackages.find('a')
      expect(elements.length).toBe testDataHelper.available_toggle_packages.length
      packageNames = elements.map (i, el) =>
          $(el).text()
      .get();
      expect(packageNames).toEqual testDataHelper.AVAILABLE_PACKAGE_DISPLAY_NAMES

  # describe "addToggle"

  # TODO describe "addTogglePackage"
    # TODO Store the contents before adding the package, the contents after should be the contents before plus what should be added
