path = require 'path'

@FIXTURE_PACKAGE_DIRECTORY = path.join(__dirname, "packages")

exports.VALID_ENABLED_PACKAGE = "package-without-module"
exports.VALID_ENABLED_PACKAGE_DISPLAY_NAME = "Package Without Module"

exports.VALID_DISABLED_PACKAGE = "package-with-stylesheets"
exports.VALID_DISABLED_PACKAGE_DISPLAY_NAME = "Package With Stylesheets"

exports.INVALID_PACKAGE = "invalid-package"

exports.TOGGLE_PACKAGES = [@VALID_ENABLED_PACKAGE, @VALID_DISABLED_PACKAGE, @INVALID_PACKAGE]

exports.AVAILABLE_PACKAGE_NAMES = [@VALID_ENABLED_PACKAGE, @VALID_DISABLED_PACKAGE, 'package-three']

exports.AVAILABLE_PACKAGE_DISPLAY_NAMES = [@VALID_ENABLED_PACKAGE_DISPLAY_NAME, @VALID_DISABLED_PACKAGE_DISPLAY_NAME]

exports.available_toggle_packages = @TOGGLE_PACKAGES.filter (n) =>
  @AVAILABLE_PACKAGE_NAMES.indexOf(n) != -1

@setupTogglePackages = ->
  atom.config.set("toggle-packages.togglePackages", @TOGGLE_PACKAGES)

exports.setupMockPackages = ->
  @setupTogglePackages()
  spyOn(atom.packages, 'getAvailablePackageNames').andReturn(@AVAILABLE_PACKAGE_NAMES)
  spyOn(atom.packages, 'isPackageDisabled').andCallFake (args) =>
    not (args is @VALID_ENABLED_PACKAGE)

exports.setupExamplePackages = ->
  @setupTogglePackages()

  waitsForPromise =>
    atom.packages.activatePackage(@VALID_ENABLED_PACKAGE)

  waitsForPromise =>
    atom.packages.activatePackage(@VALID_DISABLED_PACKAGE)

  runs =>
    atom.packages.disablePackage(@VALID_DISABLED_PACKAGE)
