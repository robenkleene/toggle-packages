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

    it "returns only valid packages and logs a warning for invalid packages", ->
      expect(togglePackagesManager.getTogglePackageNames()).toEqual ['valid-package-one']
      expect(console.warn).toHaveBeenCalled()
      expect(console.warn.callCount).toBe 1
