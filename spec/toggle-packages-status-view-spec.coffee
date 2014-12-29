{$, WorkspaceView, View} = require 'atom' # TODO Do I need any of this?
TogglePackages = require '../lib/toggle-packages'
TogglePackagesStatusView = require '../lib/toggle-packages-status-view'
testDataHelper = require './fixtures/test-data-helper'

describe "activate()", ->
  workspaceElement = null

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)

    waitsForPromise ->
      atom.packages.activatePackage('status-bar')

    waitsForPromise ->
      atom.packages.activatePackage('toggle-packages')

    waitsForPromise ->
      atom.workspace.open()

    runs ->
      atom.packages.emitter.emit 'did-activate-all'

  afterEach ->
    atom.packages.deactivatePackage('toggle-packages')

  describe "activate()", ->

    it "appends only one .toggle-packages-wrapper", ->
      statusBarElement = workspaceElement.querySelector('status-bar')
      togglePackagesNodeList = statusBarElement.querySelectorAll('toggle-packages')
      expect(togglePackagesNodeList.length).toBe 1

describe "TogglePackagesStatusView with setupMockPackages()", ->
  [togglePackagesStatusView, togglePackagesElement] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)

    waitsForPromise ->
      atom.packages.activatePackage('status-bar')

    # waitsForPromise ->
    #   atom.workspace.open()

    runs ->
      testDataHelper.setupMockPackages()
      togglePackagesStatusView = new TogglePackagesStatusView().initialize()
      statusBarElement = workspaceElement.querySelector('status-bar')
      togglePackagesElement = statusBarElement.querySelector('toggle-packages')

  afterEach ->
    togglePackagesStatusView.destroy()

  describe "getPackageDisplayName(name)", ->

    it "removes underscores and capitalizes", ->
      expect(togglePackagesStatusView.getPackageDisplayName(testDataHelper.VALID_PACKAGE_STARTS_ENABLED)).toBe testDataHelper.VALID_PACKAGE_STARTS_ENABLED_DISPLAY_NAME

  describe "the attached element", ->

    it "shows the valid toggle packages", ->
      nodeList = togglePackagesElement.querySelectorAll('a')
      expect(nodeList.length).toBe testDataHelper.available_toggle_packages.length
      packageNames = []
      for node in nodeList
        packageNames.push node.innerText
      expect(packageNames).toEqual testDataHelper.STARTING_TOGGLE_PACKAGE_DISPLAY_NAMES

    it "makes packages have the right text and attributes", ->
      element = togglePackagesElement.querySelector("##{testDataHelper.VALID_PACKAGE_STARTS_ENABLED}")
      expect(element.className).not.toBe togglePackagesStatusView.DISABLED_PACKAGE_CLASS
      expect(element.innerText).toBe testDataHelper.VALID_PACKAGE_STARTS_ENABLED_DISPLAY_NAME
      expect(element.id).toBe testDataHelper.VALID_PACKAGE_STARTS_ENABLED

      element = togglePackagesElement.querySelector("##{testDataHelper.VALID_PACKAGE_STARTS_DISABLED}")
      expect(element.className).toBe togglePackagesStatusView.DISABLED_PACKAGE_CLASS
      expect(element.innerText).toBe testDataHelper.VALID_PACKAGE_STARTS_DISABLED_DISPLAY_NAME
      expect(element.id).toBe testDataHelper.VALID_PACKAGE_STARTS_DISABLED

    it "toggles the disabled class starting from disabled", ->
      console.log togglePackagesStatusView
      element = togglePackagesStatusView.getPackageStatusElement(testDataHelper.VALID_PACKAGE_STARTS_DISABLED)
      expect(element.className).toBe togglePackagesStatusView.DISABLED_PACKAGE_CLASS
      # Enable
      testDataHelper.togglePackage(testDataHelper.VALID_PACKAGE_STARTS_DISABLED)
      expect(atom.packages.isPackageDisabled(testDataHelper.VALID_PACKAGE_STARTS_DISABLED)).toBe false
      expect(element.className).not.toBe togglePackagesStatusView.DISABLED_PACKAGE_CLASS
      # Disable
      testDataHelper.togglePackage(testDataHelper.VALID_PACKAGE_STARTS_DISABLED)
      expect(atom.packages.isPackageDisabled(testDataHelper.VALID_PACKAGE_STARTS_DISABLED)).toBe true
      expect(element.className).toBe togglePackagesStatusView.DISABLED_PACKAGE_CLASS

    it "toggles the disabled class starting from enabled", ->
      element = togglePackagesStatusView.getPackageStatusElement(testDataHelper.VALID_PACKAGE_STARTS_ENABLED)
      expect(element.className).not.toBe togglePackagesStatusView.DISABLED_PACKAGE_CLASS
      # Disable
      testDataHelper.togglePackage(testDataHelper.VALID_PACKAGE_STARTS_ENABLED)
      expect(atom.packages.isPackageDisabled(testDataHelper.VALID_PACKAGE_STARTS_ENABLED)).toBe true
      expect(element.className).toBe togglePackagesStatusView.DISABLED_PACKAGE_CLASS
      # Enable
      testDataHelper.togglePackage(testDataHelper.VALID_PACKAGE_STARTS_ENABLED)
      expect(atom.packages.isPackageDisabled(testDataHelper.VALID_PACKAGE_STARTS_ENABLED)).toBe false
      expect(element.className).not.toBe togglePackagesStatusView.DISABLED_PACKAGE_CLASS

    it "removes packages removed from config", ->
      packageToRemove = testDataHelper.VALID_PACKAGE_STARTS_ENABLED
      element = togglePackagesStatusView.getPackageStatusElement(packageToRemove)
      expect(element).toExist()
      togglePackages = atom.config.get('toggle-packages.togglePackages')
      togglePackages.splice(togglePackages.indexOf(packageToRemove), 1)
      atom.config.set('toggle-packages.togglePackages', togglePackages)
      element = togglePackagesStatusView.getPackageStatusElement(packageToRemove)
      expect(element).not.toExist()

    it "adds packages added to config", ->
      packageToAdd = testDataHelper.VALID_PACKAGE_STARTS_ENABLED_NOT_STARTING_TOGGLE_PACKAGE
      element = togglePackagesStatusView.getPackageStatusElement(packageToAdd)
      expect(element).not.toExist()
      togglePackages = atom.config.get('toggle-packages.togglePackages')
      togglePackages.push(packageToAdd)
      atom.config.set('toggle-packages.togglePackages', togglePackages)
      element = togglePackagesStatusView.getPackageStatusElement(packageToAdd)
      expect(element).toExist()

    it "logs a warning when adding an invalid package", ->
      spyOn(console, 'warn')
      packageToAdd = testDataHelper.INVALID_PACKAGE
      togglePackages = atom.config.get('toggle-packages.togglePackages')
      togglePackages.push(packageToAdd)
      atom.config.set('toggle-packages.togglePackages', togglePackages)
      element = togglePackagesStatusView.getPackageStatusElement(packageToAdd)
      expect(element).not.toExist()
      expect(console.warn).toHaveBeenCalled()
      expect(console.warn.callCount).toBe 1



# Unprocessed below here

describe "TogglePackagesStatusView with setupMockPackages()", ->
  [togglePackagesStatusView, view] = []

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    testDataHelper.setupMockPackages()
    atom.workspaceView.statusBar = new StatusBarMock()
    atom.workspaceView.statusBar.attach()
    togglePackagesStatusView = new TogglePackagesStatusView()
    view = atom.workspaceView.statusBar.leftPanel.children().view()

  afterEach ->
    atom.workspaceView.statusBar.remove()
    atom.workspaceView.statusBar = null

  describe "addTogglePackage(name)", ->

    it "adds the package display name", ->
      togglePackagesStatusView.addTogglePackage(testDataHelper.VALID_PACKAGE_STARTS_ENABLED_NOT_STARTING_TOGGLE_PACKAGE)
      elements = view.togglePackages.find('a')
      expect(elements.length).toBe testDataHelper.available_toggle_packages.length + 1
      packageNames = elements.map (i, element) =>
          # Test the disabled class for the added package
          element_class = $(element).attr('class')
          if $(element).text() is testDataHelper.VALID_PACKAGE_STARTS_ENABLED_NOT_STARTING_TOGGLE_PACKAGE_DISPLAY_NAMES
            expect(element_class).not.toBe togglePackagesStatusView.DISABLED_PACKAGE_CLASS
          # Return the text
          $(element).text()
      .get();
      expect(packageNames).toEqual testDataHelper.STARTING_TOGGLE_PACKAGE_DISPLAY_NAMES.concat testDataHelper.VALID_PACKAGE_STARTS_ENABLED_NOT_STARTING_TOGGLE_PACKAGE_DISPLAY_NAMES

    it "adds logs a warning when adding an invalid package", ->
      spyOn(console, 'warn')
      togglePackagesStatusView.addTogglePackage(testDataHelper.INVALID_PACKAGE)
      expect(console.warn).toHaveBeenCalled()
      expect(console.warn.callCount).toBe 1
      elements = view.togglePackages.find('a')
      expect(elements.length).toBe testDataHelper.available_toggle_packages.length
      packageNames = elements.map (i, element) =>
          $(element).text()
      .get();
      expect(packageNames).toEqual testDataHelper.STARTING_TOGGLE_PACKAGE_DISPLAY_NAMES

describe "TogglePackagesStatusView with setupExamplePackages()", ->
  [togglePackagesStatusView, view] = []

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    testDataHelper.setupExamplePackages()
    atom.workspaceView.statusBar = new StatusBarMock()
    atom.workspaceView.statusBar.attach()
    togglePackagesStatusView = new TogglePackagesStatusView()
    view = atom.workspaceView.statusBar.leftPanel.children().view()

  afterEach ->
    atom.workspaceView.statusBar.remove()
    atom.workspaceView.statusBar = null

  describe "the attached view", ->

    it "toggles a package that starts enabled when its element is clicked", ->
      element = togglePackagesStatusView.getPackageStatusElement(testDataHelper.VALID_PACKAGE_STARTS_ENABLED)
      expect(atom.packages.isPackageDisabled(testDataHelper.VALID_PACKAGE_STARTS_ENABLED)).toBe false
      element.click()
      expect(atom.packages.isPackageDisabled(testDataHelper.VALID_PACKAGE_STARTS_ENABLED)).toBe true
      element.click()
      expect(atom.packages.isPackageDisabled(testDataHelper.VALID_PACKAGE_STARTS_ENABLED)).toBe false

    it "toggles a package that starts disabled when its element is clicked", ->
      element = togglePackagesStatusView.getPackageStatusElement(testDataHelper.VALID_PACKAGE_STARTS_DISABLED)
      expect(atom.packages.isPackageDisabled(testDataHelper.VALID_PACKAGE_STARTS_DISABLED)).toBe true
      element.click()
      expect(atom.packages.isPackageDisabled(testDataHelper.VALID_PACKAGE_STARTS_DISABLED)).toBe false
      element.click()
      expect(atom.packages.isPackageDisabled(testDataHelper.VALID_PACKAGE_STARTS_DISABLED)).toBe true
