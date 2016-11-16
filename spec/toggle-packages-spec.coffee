TogglePackages = require '../lib/toggle-packages.coffee'
testDataHelper = require './fixtures/test-data-helper'

describe "TogglePackages", ->
  workspaceElement = null

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    jasmine.attachToDOM(workspaceElement)
    testDataHelper.setupExamplePackages()

    waitsForPromise ->
      atom.packages.activatePackage('toggle-packages')

    waitsForPromise ->
      atom.workspace.open()

  afterEach ->
    if atom.packages.isPackageActive('toggle-packages')
      atom.packages.deactivatePackage('toggle-packages')

  it "adds toggle commands for enabled packages", ->
    testPackage = testDataHelper.VALID_PACKAGE_STARTS_ENABLED
    testCommand = "toggle-packages:toggle-#{testPackage}"
    expect(testDataHelper.commandExists(testCommand)).toBe true
    expect(atom.packages.isPackageDisabled(testPackage)).toBe false
    atom.commands.dispatch workspaceElement, testCommand
    expect(atom.packages.isPackageDisabled(testPackage)).toBe true
    atom.commands.dispatch workspaceElement, testCommand
    expect(atom.packages.isPackageDisabled(testPackage)).toBe false

  it "adds toggle commands for disabled packages", ->
    testPackage = testDataHelper.VALID_PACKAGE_STARTS_DISABLED
    testCommand = "toggle-packages:toggle-#{testPackage}"
    expect(testDataHelper.commandExists(testCommand)).toBe true
    expect(atom.packages.isPackageDisabled(testPackage)).toBe true
    atom.commands.dispatch workspaceElement, testCommand
    expect(atom.packages.isPackageDisabled(testPackage)).toBe false
    atom.commands.dispatch workspaceElement, testCommand
    expect(atom.packages.isPackageDisabled(testPackage)).toBe true

  it "adds commands for packages added to config", ->
    testPackage = testDataHelper.VALID_PACKAGE_STARTS_ENABLED_NOT_STARTING_TOGGLE_PACKAGE
    testCommand = "toggle-packages:toggle-#{testPackage}"
    expect(testDataHelper.commandExists(testCommand)).toBe false
    # Test command fails for package before adding to config
    expect(atom.packages.isPackageDisabled(testPackage)).toBe false
    atom.commands.dispatch workspaceElement, testCommand
    expect(atom.packages.isPackageDisabled(testPackage)).toBe false
    # Add to config
    togglePackages = atom.config.get('toggle-packages.togglePackages')
    togglePackages.push(testPackage)
    atom.config.set('toggle-packages.togglePackages', togglePackages)
    # Test command works
    expect(testDataHelper.commandExists(testCommand)).toBe true
    atom.commands.dispatch workspaceElement, testCommand
    expect(atom.packages.isPackageDisabled(testDataHelper.VALID_PACKAGE_STARTS_ENABLED_NOT_STARTING_TOGGLE_PACKAGE)).toBe true
    atom.commands.dispatch workspaceElement, testCommand
    expect(atom.packages.isPackageDisabled(testDataHelper.VALID_PACKAGE_STARTS_ENABLED_NOT_STARTING_TOGGLE_PACKAGE)).toBe false

  it "doesn't create a command and logs a warning when adding an invalid package to config", ->
    testPackage = testDataHelper.INVALID_PACKAGE
    testCommand = "toggle-packages:toggle-#{testPackage}"
    spyOn(console, 'warn')
    togglePackages = atom.config.get('toggle-packages.togglePackages')
    togglePackages.push(testPackage)
    atom.config.set('toggle-packages.togglePackages', togglePackages)
    expect(console.warn).toHaveBeenCalled()
    expect(console.warn.callCount).toBe 1
    expect(testDataHelper.commandExists(testCommand)).toBe false

  it "removes toggle package commands for packages removed from config", ->
    testPackage = testDataHelper.VALID_PACKAGE_STARTS_ENABLED
    testCommand = "toggle-packages:toggle-#{testPackage}"
    expect(testDataHelper.commandExists(testCommand)).toBe true
    expect(atom.packages.isPackageDisabled(testPackage)).toBe false
    atom.commands.dispatch workspaceElement, testCommand
    expect(atom.packages.isPackageDisabled(testPackage)).toBe true
    atom.commands.dispatch workspaceElement, testCommand
    expect(atom.packages.isPackageDisabled(testPackage)).toBe false
    # Remove from config
    togglePackages = atom.config.get('toggle-packages.togglePackages')
    togglePackages = togglePackages.filter (name) -> name isnt testDataHelper.VALID_PACKAGE_STARTS_ENABLED
    atom.config.set('toggle-packages.togglePackages', togglePackages)
    expect(testDataHelper.commandExists(testCommand)).toBe false
    # Test command fails after removing from config
    expect(atom.packages.isPackageDisabled(testPackage)).toBe false
    atom.commands.dispatch workspaceElement, testCommand
    expect(atom.packages.isPackageDisabled(testPackage)).toBe false

  fit "removes commands for packages removed from config", ->
    testPackage = testDataHelper.VALID_PACKAGE_STARTS_ENABLED
    testCommand = testDataHelper.VALID_PACKAGE_STARTS_ENABLED_COMMAND
    expect(testDataHelper.commandExists(testCommand)).toBe true
    disableCommand = "toggle-packages:toggle-#{testPackage}"
    atom.commands.dispatch workspaceElement, disableCommand
    expect(testDataHelper.commandExists(testCommand)).toBe false

  it "removes all toggle package commands when toggle packages is deactivated", ->
    for testPackage in testDataHelper.STARTING_TOGGLE_PACKAGES
      testCommand = "toggle-packages:toggle-#{testPackage}"
      expect(testDataHelper.commandExists(testCommand)).toBe true
    atom.packages.deactivatePackage('toggle-packages')
    for testPackage in testDataHelper.STARTING_TOGGLE_PACKAGES
      testCommand = "toggle-packages:toggle-#{testPackage}"
      expect(testDataHelper.commandExists(testCommand)).toBe false
