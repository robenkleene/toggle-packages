path = require 'path'
togglePackagesManager = require '../lib/toggle-packages-manager'
testDataHelper = require './fixtures/test-data-helper'

describe "TogglePackagesManager with setupMockPackages()", ->

  beforeEach ->
    testDataHelper.setupMockPackages()
    spyOn(console, 'warn')

  describe "isValidPackage()", ->

    it "returns true and doesn't log a warning for valid packages ", ->
      expect(togglePackagesManager.isValidPackage(testDataHelper.VALID_PACKAGE_STARTS_ENABLED)).toBe true
      expect(console.warn).not.toHaveBeenCalled()

    it "returns false and logs a warning for invalid packages", ->
      expect(togglePackagesManager.isValidPackage(testDataHelper.INVALID_PACKAGE)).toBe false
      expect(console.warn).toHaveBeenCalled()

  describe "getTogglePackageNames()", ->

    it "returns only valid packages and logs a warning for invalid packages", ->
      expect(togglePackagesManager.getTogglePackageNames()).toEqual testDataHelper.available_toggle_packages
      expect(console.warn).toHaveBeenCalled()
      expect(console.warn.callCount).toBe 1

  describe "isPackageEnabled(name)", ->

    it "returns true for enabled packages", ->
      expect(togglePackagesManager.isPackageEnabled(testDataHelper.VALID_PACKAGE_STARTS_ENABLED)).toBe true

    it "returns false for disabled packages", ->
      expect(togglePackagesManager.isPackageEnabled(testDataHelper.VALID_PACKAGE_STARTS_DISABLED)).toBe false

describe "TogglePackagesManager with setupExamplePackages()", ->

  beforeEach ->
    testDataHelper.setupExamplePackages()
    # spyOn(console, 'warn')

  describe "isPackageEnabled(name)", ->

    it "returns true for enabled packages", ->
      expect(togglePackagesManager.isPackageEnabled(testDataHelper.VALID_PACKAGE_STARTS_ENABLED)).toBe true

    it "returns false for disabled packages", ->
      expect(togglePackagesManager.isPackageEnabled(testDataHelper.VALID_PACKAGE_STARTS_DISABLED)).toBe false
