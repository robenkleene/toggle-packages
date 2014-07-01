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
      expect(togglePackagesStatusView.getPackageDisplayName(testDataHelper.VALID_ENABLED_PACKAGE)).toBe testDataHelper.VALID_ENABLED_PACKAGE_DISPLAY_NAME

  describe "The attached view", ->

    it "shows the valid packages", ->
      elements = view.togglePackages.find('a')
      expect(elements.length).toBe testDataHelper.available_toggle_packages.length
      packageNames = elements.map (i, element) =>
          $(element).text()
      .get();
      expect(packageNames).toEqual testDataHelper.AVAILABLE_PACKAGE_DISPLAY_NAMES

    it "disable packages have the disable class applied", ->
      elements = view.togglePackages.find('a')
      packageNames = elements.map (i, element) =>
          console.log element
          element_class = $(element).attr('class')
          if $(element).text() is testDataHelper.VALID_ENABLED_PACKAGE_DISPLAY_NAME
            expect(element_class).not.toBe togglePackagesStatusView.DISABLED_PACKAGE_CLASS
          else if $(element).text() is testDataHelper.VALID_DISABLED_PACKAGE_DISPLAY_NAME
            expect(element_class).toBe togglePackagesStatusView.DISABLED_PACKAGE_CLASS

  describe "addTogglePackage(name)", ->

    it "adds the package display name", ->
      togglePackagesStatusView.addTogglePackage("package-name")
      elements = view.togglePackages.find('a')
      expect(elements.length).toBe testDataHelper.available_toggle_packages.length + 1
      packageNames = elements.map (i, el) =>
          $(el).text()
      .get();
      expect(packageNames).toEqual testDataHelper.AVAILABLE_PACKAGE_DISPLAY_NAMES.concat ["Package Name"]
