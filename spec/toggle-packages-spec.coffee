{WorkspaceView} = require 'atom'
TogglePackages = require '../lib/toggle-packages.coffee'
testDataHelper = require './fixtures/test-data-helper'

describe "TogglePackages", ->

  beforeEach ->
    atom.workspaceView = new WorkspaceView()
    testDataHelper.setupExamplePackages()
    # atom.workspace = atom.workspaceView.model

    waitsForPromise ->
      atom.packages.activatePackage('toggle-packages')

    waitsForPromise ->
      atom.workspace.open()

  afterEach ->
    atom.packages.deactivatePackage('toggle-packages')

  it "adds toggle commands for enabled packages", ->
    testPackage = testDataHelper.VALID_PACKAGE_STARTS_ENABLED
    testCommand = "toggle-packages:toggle-#{testPackage}"
    expect(testDataHelper.commandExists(testCommand)).toBe true
    expect(atom.packages.isPackageDisabled(testPackage)).toBe false
    atom.workspaceView.trigger testCommand
    expect(atom.packages.isPackageDisabled(testPackage)).toBe true
    atom.workspaceView.trigger testCommand
    expect(atom.packages.isPackageDisabled(testPackage)).toBe false

  it "adds toggle commands for disabled packages", ->
    testPackage = testDataHelper.VALID_PACKAGE_STARTS_DISABLED
    testCommand = "toggle-packages:toggle-#{testPackage}"
    expect(testDataHelper.commandExists(testCommand)).toBe true
    expect(atom.packages.isPackageDisabled(testPackage)).toBe true
    atom.workspaceView.trigger testCommand
    expect(atom.packages.isPackageDisabled(testPackage)).toBe false
    atom.workspaceView.trigger testCommand
    expect(atom.packages.isPackageDisabled(testPackage)).toBe true

  it "adds commands for packages added to config", ->
    testPackage = testDataHelper.VALID_PACKAGE_STARTS_ENABLED_NOT_STARTING_TOGGLE_PACKAGE
    testCommand = "toggle-packages:toggle-#{testPackage}"
    expect(testDataHelper.commandExists(testCommand)).toBe false
    # Test command fails for package before adding to config
    expect(atom.packages.isPackageDisabled(testPackage)).toBe false
    atom.workspaceView.trigger testCommand
    expect(atom.packages.isPackageDisabled(testPackage)).toBe false
    # Add to config
    togglePackages = atom.config.get('toggle-packages.togglePackages')
    togglePackages.push(testPackage)
    atom.config.set('toggle-packages.togglePackages', togglePackages)
    # Test command works
    expect(testDataHelper.commandExists(testCommand)).toBe true
    atom.workspaceView.trigger testCommand
    expect(atom.packages.isPackageDisabled(testDataHelper.VALID_PACKAGE_STARTS_ENABLED_NOT_STARTING_TOGGLE_PACKAGE)).toBe true
    atom.workspaceView.trigger testCommand
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

# TODO it "removes commands for packages removed from config", ->
