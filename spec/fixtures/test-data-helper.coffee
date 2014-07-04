path = require 'path'

@FIXTURE_PACKAGE_DIRECTORY = path.join(__dirname, "packages")

exports.VALID_PACKAGE_STARTS_ENABLED = "package-without-module"
exports.VALID_PACKAGE_STARTS_ENABLED_DISPLAY_NAME = "Package Without Module"

exports.VALID_PACKAGE_STARTS_DISABLED = "package-with-stylesheets"
exports.VALID_PACKAGE_STARTS_DISABLED_DISPLAY_NAME = "Package With Stylesheets"

exports.INVALID_PACKAGE = "invalid-package"

exports.TOGGLE_PACKAGES = [@VALID_PACKAGE_STARTS_ENABLED, @VALID_PACKAGE_STARTS_DISABLED]

exports.AVAILABLE_PACKAGE_NAMES = [@VALID_PACKAGE_STARTS_ENABLED, @VALID_PACKAGE_STARTS_DISABLED, 'package-three']

exports.AVAILABLE_PACKAGE_DISPLAY_NAMES = [@VALID_PACKAGE_STARTS_ENABLED_DISPLAY_NAME, @VALID_PACKAGE_STARTS_DISABLED_DISPLAY_NAME]

exports.available_toggle_packages = @TOGGLE_PACKAGES.filter (n) =>
  @AVAILABLE_PACKAGE_NAMES.indexOf(n) != -1

@disabled_packages = [@VALID_PACKAGE_STARTS_DISABLED]

@setupTogglePackages = ->
  atom.config.set("toggle-packages.togglePackages", @TOGGLE_PACKAGES)

exports.togglePackage = (name) ->
  index = @disabled_packages.indexOf(name)
  if not (index is -1)
    @disabled_packages.splice(index, 1)
  else
    @disabled_packages.push(name)

exports.setupMockPackages = ->
  @setupTogglePackages()
  spyOn(atom.packages, 'getAvailablePackageNames').andReturn(@AVAILABLE_PACKAGE_NAMES)
  spyOn(atom.packages, 'isPackageDisabled').andCallFake (name) =>
    @disabled_packages.indexOf(name) isnt -1
    # not (args is @VALID_PACKAGE_STARTS_ENABLED)

exports.setupExamplePackages = ->
  @setupTogglePackages()

  waitsForPromise =>
    atom.packages.activatePackage(@VALID_PACKAGE_STARTS_ENABLED)

  waitsForPromise =>
    atom.packages.activatePackage(@VALID_PACKAGE_STARTS_DISABLED)

  runs =>
    atom.packages.disablePackage(@VALID_PACKAGE_STARTS_DISABLED)
