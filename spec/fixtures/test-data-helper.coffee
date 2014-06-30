exports.VALID_PACKAGE_ONE = "valid-package-one"
exports.INVALID_PACKAGE_ONE = "invalid-package-one"
exports.TOGGLE_PACKAGES = [@VALID_PACKAGE_ONE, 'valid-package-two', @INVALID_PACKAGE_ONE]
exports.AVAILABLE_PACKAGE_NAMES = [@VALID_PACKAGE_ONE, 'valid-package-two', 'valid-package-three']

exports.available_toggle_packages = @TOGGLE_PACKAGES.filter (n) =>
  @AVAILABLE_PACKAGE_NAMES.indexOf(n) != -1

exports.setup = ->
  atom.config.set("toggle-packages.togglePackages", @TOGGLE_PACKAGES)
  spyOn(atom.packages, 'getAvailablePackageNames').andReturn(@AVAILABLE_PACKAGE_NAMES)
