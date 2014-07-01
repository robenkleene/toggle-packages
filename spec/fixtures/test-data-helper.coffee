exports.VALID_ENABLED_PACKAGE = "valid-active-package-one"
exports.VALID_ENABLED_PACKAGE_DISPLAY_NAME = "Valid Active Package One"

exports.INVALID_PACKAGE_ONE = "invalid-package-one"

exports.TOGGLE_PACKAGES = [@VALID_ENABLED_PACKAGE, 'valid-package-two', @INVALID_PACKAGE_ONE]

exports.AVAILABLE_PACKAGE_NAMES = [@VALID_ENABLED_PACKAGE, 'valid-package-two', 'valid-package-three']

exports.AVAILABLE_PACKAGE_DISPLAY_NAMES = [@VALID_ENABLED_PACKAGE_DISPLAY_NAME, "Valid Package Two"]

exports.available_toggle_packages = @TOGGLE_PACKAGES.filter (n) =>
  @AVAILABLE_PACKAGE_NAMES.indexOf(n) != -1

exports.setup = ->
  atom.config.set("toggle-packages.togglePackages", @TOGGLE_PACKAGES)
  spyOn(atom.packages, 'getAvailablePackageNames').andReturn(@AVAILABLE_PACKAGE_NAMES)
  # TODO `spyOn` `atom.packages` `isPackageDisabled` for `@VALID_ENABLED_PACKAGE`
  spyOn(atom.packages, 'isPackageDisabled').andCallFake (args) ->
    not args is @VALID_ENABLED_PACKAGE
