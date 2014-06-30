togglePackagesManager = require '../lib/toggle-packages-manager'
testDataHelper = require './fixtures/test-data-helper'

describe "TogglePackagesManager", ->

  beforeEach ->
    atom.config.set("toggle-packages.togglePackages", testDataHelper.TOGGLE_PACKAGES)
    spyOn(atom.packages, 'getAvailablePackageNames').andReturn(testDataHelper.AVAILABLE_PACKAGE_NAMES);
    spyOn(console, 'warn')

  describe "isValidPackage()", ->

    it "returns true and doesn't log a warning for valid packages ", ->
      expect(togglePackagesManager.isValidPackage(testDataHelper.VALID_PACKAGE_ONE)).toBe true
      expect(console.warn).not.toHaveBeenCalled()

    it "returns false and logs a warning for invalid packages", ->
      expect(togglePackagesManager.isValidPackage(testDataHelper.INVALID_PACKAGE_ONE)).toBe false
      expect(console.warn).toHaveBeenCalled()

  describe "getTogglePackageNames()", ->

    it "returns only valid packages and logs a warning for invalid packages", ->
      expect(togglePackagesManager.getTogglePackageNames()).toEqual testDataHelper.available_toggle_packages
      expect(console.warn).toHaveBeenCalled()
      expect(console.warn.callCount).toBe 1
