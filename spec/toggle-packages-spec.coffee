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

  it "adds toggle commands for enabled packages", ->
    expect(atom.packages.isPackageDisabled(testDataHelper.VALID_PACKAGE_STARTS_ENABLED)).toBe false
    atom.workspaceView.trigger "toggle-packages:toggle-#{testDataHelper.VALID_PACKAGE_STARTS_ENABLED}"
    expect(atom.packages.isPackageDisabled(testDataHelper.VALID_PACKAGE_STARTS_ENABLED)).toBe true
    atom.workspaceView.trigger "toggle-packages:toggle-#{testDataHelper.VALID_PACKAGE_STARTS_ENABLED}"
    expect(atom.packages.isPackageDisabled(testDataHelper.VALID_PACKAGE_STARTS_ENABLED)).toBe false

  it "adds toggle commands for disabled packages", ->
    expect(atom.packages.isPackageDisabled(testDataHelper.VALID_PACKAGE_STARTS_DISABLED)).toBe true
    atom.workspaceView.trigger "toggle-packages:toggle-#{testDataHelper.VALID_PACKAGE_STARTS_DISABLED}"
    expect(atom.packages.isPackageDisabled(testDataHelper.VALID_PACKAGE_STARTS_DISABLED)).toBe false
    atom.workspaceView.trigger "toggle-packages:toggle-#{testDataHelper.VALID_PACKAGE_STARTS_DISABLED}"
    expect(atom.packages.isPackageDisabled(testDataHelper.VALID_PACKAGE_STARTS_DISABLED)).toBe true

  it "adds commands for packages added to config", ->
    # Test command fails for package not in config
    expect(atom.packages.isPackageDisabled(testDataHelper.VALID_PACKAGE_STARTS_ENABLED_NOT_STARTING_TOGGLE_PACKAGE)).toBe false
    atom.workspaceView.trigger "toggle-packages:toggle-#{testDataHelper.VALID_PACKAGE_STARTS_ENABLED_NOT_STARTING_TOGGLE_PACKAGE}"
    expect(atom.packages.isPackageDisabled(testDataHelper.VALID_PACKAGE_STARTS_ENABLED_NOT_STARTING_TOGGLE_PACKAGE)).toBe false
    # Add to config
    togglePackages = atom.config.get('toggle-packages.togglePackages')
    togglePackages.push(testDataHelper.VALID_PACKAGE_STARTS_ENABLED_NOT_STARTING_TOGGLE_PACKAGE)
    atom.config.set('toggle-packages.togglePackages', togglePackages)
    # Test command works
    atom.workspaceView.trigger "toggle-packages:toggle-#{testDataHelper.VALID_PACKAGE_STARTS_ENABLED_NOT_STARTING_TOGGLE_PACKAGE}"
    expect(atom.packages.isPackageDisabled(testDataHelper.VALID_PACKAGE_STARTS_ENABLED_NOT_STARTING_TOGGLE_PACKAGE)).toBe true
    atom.workspaceView.trigger "toggle-packages:toggle-#{testDataHelper.VALID_PACKAGE_STARTS_ENABLED_NOT_STARTING_TOGGLE_PACKAGE}"
    expect(atom.packages.isPackageDisabled(testDataHelper.VALID_PACKAGE_STARTS_ENABLED_NOT_STARTING_TOGGLE_PACKAGE)).toBe false

  it "logs a warning ", ->
    spyOn(console, 'warn')
    togglePackages = atom.config.get('toggle-packages.togglePackages')
    togglePackages.push(testDataHelper.INVALID_PACKAGE)
    atom.config.set('toggle-packages.togglePackages', togglePackages)
    expect(console.warn).toHaveBeenCalled()
    expect(console.warn.callCount).toBe 1
    # TODO should also test that this doesn't add a command

# it "removes commands for packages removed from config", ->
  # it only adds commands for valid packages
