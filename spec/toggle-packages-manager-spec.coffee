path = require 'path'
togglePackagesManager = require '../lib/toggle-packages-manager'
testDataHelper = require './fixtures/test-data-helper'

describe "TogglePackagesManager with setupMockPackages()", ->

  beforeEach ->
    testDataHelper.setupMockPackages()

  describe "isValidPackage()", ->

    it "returns true and doesn't log a warning for valid packages ", ->
      spyOn(console, 'warn')
      expect(togglePackagesManager.isValidPackage(testDataHelper.VALID_PACKAGE_STARTS_ENABLED)).toBe true
      expect(console.warn).not.toHaveBeenCalled()

    it "returns false and logs a warning for invalid packages", ->
      expect(togglePackagesManager.isValidPackage(testDataHelper.INVALID_PACKAGE)).toBe false

    it "returns false and logs a warning for empty name", ->
      expect(togglePackagesManager.isValidPackage('')).toBe false

    it "returns false and logs a warning for an invalid name", ->
      expect(togglePackagesManager.isValidPackage('invalid name')).toBe false

  describe "isPackageEnabled(name)", ->

    it "returns true for enabled packages", ->
      expect(togglePackagesManager.isPackageEnabled(testDataHelper.VALID_PACKAGE_STARTS_ENABLED)).toBe true

    it "returns false for disabled packages", ->
      expect(togglePackagesManager.isPackageEnabled(testDataHelper.VALID_PACKAGE_STARTS_DISABLED)).toBe false

describe "TogglePackagesManager with setupExamplePackages()", ->

  beforeEach ->
    testDataHelper.setupExamplePackages()

  describe "isPackageEnabled(name)", ->

    it "returns true for enabled packages", ->
      expect(togglePackagesManager.isPackageEnabled(testDataHelper.VALID_PACKAGE_STARTS_ENABLED)).toBe true

    it "returns false for disabled packages", ->
      expect(togglePackagesManager.isPackageEnabled(testDataHelper.VALID_PACKAGE_STARTS_DISABLED)).toBe false

  describe "togglePackage(name)", ->

    it "toggles a disabled package", ->
      togglePackagesManager.togglePackage(testDataHelper.VALID_PACKAGE_STARTS_ENABLED)
      expect(togglePackagesManager.isPackageEnabled(testDataHelper.VALID_PACKAGE_STARTS_ENABLED)).toBe false
      togglePackagesManager.togglePackage(testDataHelper.VALID_PACKAGE_STARTS_ENABLED)
      expect(togglePackagesManager.isPackageEnabled(testDataHelper.VALID_PACKAGE_STARTS_ENABLED)).toBe true

    it "toggles an enabled package", ->
      togglePackagesManager.togglePackage(testDataHelper.VALID_PACKAGE_STARTS_DISABLED)
      expect(togglePackagesManager.isPackageEnabled(testDataHelper.VALID_PACKAGE_STARTS_DISABLED)).toBe true
      togglePackagesManager.togglePackage(testDataHelper.VALID_PACKAGE_STARTS_DISABLED)
      expect(togglePackagesManager.isPackageEnabled(testDataHelper.VALID_PACKAGE_STARTS_DISABLED)).toBe false

    it "makes 'atom.config' update 'core.disabledPackages' when a package becomes enabled", ->
      expect((atom.config.get 'core.disabledPackages').indexOf(testDataHelper.VALID_PACKAGE_STARTS_DISABLED)).not.toBe -1
      atom.config.onDidChange 'core.disabledPackages', ({newValue}) ->
        expect(newValue.indexOf(testDataHelper.VALID_PACKAGE_STARTS_DISABLED)).toBe -1
      togglePackagesManager.togglePackage(testDataHelper.VALID_PACKAGE_STARTS_DISABLED)

    it "makes 'atom.config' update 'core.disabledPackages' when a package becomes disabled", ->
      expect((atom.config.get 'core.disabledPackages').indexOf(testDataHelper.VALID_PACKAGE_STARTS_ENABLED)).toBe -1
      atom.config.onDidChange 'core.disabledPackages', ({newValue}) ->
        expect(newValue.indexOf(testDataHelper.VALID_PACKAGE_STARTS_ENABLED)).not.toBe -1
      togglePackagesManager.togglePackage(testDataHelper.VALID_PACKAGE_STARTS_ENABLED)
