togglePackagesManager = require '../lib/toggle-packages-manager'

describe "TogglePackagesManager", ->
  VALID_PACKAGE_ONE = "valid-package-one"
  INVALID_PACKAGE_ONE = "invalid-package-one"
  TOGGLE_PACKAGES = [VALID_PACKAGE_ONE, 'valid-package-two', INVALID_PACKAGE_ONE]
  AVAILABLE_PACKAGE_NAMES = [VALID_PACKAGE_ONE, 'valid-package-two', 'valid-package-three']
  available_toggle_packages = TOGGLE_PACKAGES.filter (n) ->
    AVAILABLE_PACKAGE_NAMES.indexOf(n) != -1

  beforeEach ->
    atom.config.set("toggle-packages.togglePackages", TOGGLE_PACKAGES)
    spyOn(atom.packages, 'getAvailablePackageNames').andReturn(AVAILABLE_PACKAGE_NAMES);
    spyOn(console, 'warn')

  describe "isValidPackage()", ->

    it "returns true and doesn't log a warning for valid packages ", ->
      expect(togglePackagesManager.isValidPackage(VALID_PACKAGE_ONE)).toBe true
      expect(console.warn).not.toHaveBeenCalled()

    it "returns false and logs a warning for invalid packages", ->
      expect(togglePackagesManager.isValidPackage(INVALID_PACKAGE_ONE)).toBe false
      expect(console.warn).toHaveBeenCalled()

  describe "getTogglePackageNames()", ->

    it "returns only valid packages and logs a warning for invalid packages", ->
      expect(togglePackagesManager.getTogglePackageNames()).toEqual available_toggle_packages
      expect(console.warn).toHaveBeenCalled()
      expect(console.warn.callCount).toBe 1
