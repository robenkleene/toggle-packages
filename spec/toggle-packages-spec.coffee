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

  # it "adds toggle commands for disabled packages", ->
  #   expect(atom.packages.isPackageDisabled(testDataHelper.VALID_PACKAGE_STARTS_ENABLED)).toBe false

  # it only adds commands for valid packages
  # it throws a warning when adding invalid packages

    #
    # it "adds commands for packages added to config", ->
    #
    # it "removes commands for packages removed from config", ->
