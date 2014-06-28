togglePackagesManager = require '../lib/toggle-packages-manager'

describe "TogglePackagesManager", ->
  beforeEach ->
    atom.config.set("toggle-packages.togglePackages", ['valid-package-one', 'invalid-package-two'])
    spyOn(atom.packages, 'getAvailablePackageNames').andReturn(['valid-package-one', 'valid-package-two']);
    spyOn(console, 'warn')

  describe "isValidPackage()", ->

    it "returns true and doesn't log a warning for valid packages ", ->
      expect(togglePackagesManager.isValidPackage("valid-package-one")).toBe true
      expect(console.warn).not.toHaveBeenCalled()

    it "returns false and logs a warning for invalid packages", ->
      expect(togglePackagesManager.isValidPackage("invalid-package-one")).toBe false
      expect(console.warn).toHaveBeenCalled()

  describe "getTogglePackageNames()", ->

    it "returns only valid packages", ->
      expect(togglePackagesManager.getTogglePackageNames()).toEqual ['valid-package-one']


    # It returns true for a valid package
    # It returns false for an invalid package
    # It emits a warning for an invalid package

# describe getTogglePackageNames

  # It returns valid packages
  # It emits a warning for invalid packages
  # It doesn't return invalid packages
