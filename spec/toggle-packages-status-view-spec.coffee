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
    testDataHelper.setupMockPackages()

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
      expect(togglePackagesStatusView.getPackageDisplayName(testDataHelper.VALID_PACKAGE_STARTS_ENABLED)).toBe testDataHelper.VALID_PACKAGE_STARTS_ENABLED_DISPLAY_NAME

  describe "The attached view", ->

    it "shows the valid packages", ->
      elements = view.togglePackages.find('a')
      expect(elements.length).toBe testDataHelper.available_toggle_packages.length
      packageNames = elements.map (i, element) =>
          $(element).text()
      .get();
      expect(packageNames).toEqual testDataHelper.AVAILABLE_PACKAGE_DISPLAY_NAMES

    it "makes packages have the right text and attributes", ->
      element = view.togglePackages.find("##{testDataHelper.VALID_PACKAGE_STARTS_ENABLED}")
      expect($(element).attr('class')).not.toBe togglePackagesStatusView.DISABLED_PACKAGE_CLASS
      expect($(element).text()).toBe testDataHelper.VALID_PACKAGE_STARTS_ENABLED_DISPLAY_NAME
      expect($(element).attr('id')).toBe testDataHelper.VALID_PACKAGE_STARTS_ENABLED

      element = view.togglePackages.find("##{testDataHelper.VALID_PACKAGE_STARTS_DISABLED}")
      expect($(element).attr('class')).toBe togglePackagesStatusView.DISABLED_PACKAGE_CLASS
      expect($(element).text()).toBe testDataHelper.VALID_PACKAGE_STARTS_DISABLED_DISPLAY_NAME
      expect($(element).attr('id')).toBe testDataHelper.VALID_PACKAGE_STARTS_DISABLED

    # it "removes the disabled class from enabled packages", ->
    #   packageStatusElement = togglePackagesStatusView.getPackageStatusElement(testDataHelper.VALID_PACKAGE_STARTS_DISABLED)
    #   expect($(packageStatusElement).attr('class')).toBe togglePackagesStatusView.DISABLED_PACKAGE_CLASS
    #   console.log "packageStatusElement = #{packageStatusElement.html()}"


  describe "addTogglePackage(name)", ->

    it "adds the package display name", ->
      togglePackagesStatusView.addTogglePackage("package-name")
      elements = view.togglePackages.find('a')
      expect(elements.length).toBe testDataHelper.available_toggle_packages.length + 1
      packageNames = elements.map (i, element) =>
          # If it's the added package then test for the disabled class
          element_class = $(element).attr('class')
          if $(element).text() is "Package Name"
            expect(element_class).toBe togglePackagesStatusView.DISABLED_PACKAGE_CLASS
          # Return the text
          $(element).text()
      .get();
      expect(packageNames).toEqual testDataHelper.AVAILABLE_PACKAGE_DISPLAY_NAMES.concat ["Package Name"]
      # Expect the added package to be disabled?
