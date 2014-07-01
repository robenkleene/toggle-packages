exports.VALID_ENABLED_PACKAGE = "valid-active-package"
exports.VALID_ENABLED_PACKAGE_DISPLAY_NAME = "Valid Active Package"

# exports.VALID_DISABLED_PACKAGE = "valid-active-package"
# exports.VALID_ENABLED_PACKAGE_DISPLAY_NAME = "Valid Active Package"

exports.INVALID_PACKAGE = "invalid-package"

exports.TOGGLE_PACKAGES = [@VALID_ENABLED_PACKAGE, 'valid-package-two', @INVALID_PACKAGE]

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
