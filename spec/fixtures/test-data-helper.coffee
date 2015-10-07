path = require 'path'

@FIXTURE_PACKAGE_DIRECTORY = path.join(__dirname, "packages")

exports.VALID_PACKAGE_STARTS_ENABLED = "package-without-module"
exports.VALID_PACKAGE_STARTS_ENABLED_DISPLAY_NAME = "Package Without Module"

exports.VALID_PACKAGE_STARTS_DISABLED = "package-with-styles"
exports.VALID_PACKAGE_STARTS_DISABLED_DISPLAY_NAME = "Package With Styles"

exports.VALID_PACKAGE_STARTS_ENABLED_NOT_STARTING_TOGGLE_PACKAGE = "package-with-menus"
exports.VALID_PACKAGE_STARTS_ENABLED_NOT_STARTING_TOGGLE_PACKAGE_DISPLAY_NAMES = "Package With Menus"

exports.INVALID_PACKAGE = "invalid-package"

exports.STARTING_TOGGLE_PACKAGES = [@VALID_PACKAGE_STARTS_ENABLED, @VALID_PACKAGE_STARTS_DISABLED]

exports.AVAILABLE_PACKAGE_NAMES = [@VALID_PACKAGE_STARTS_ENABLED, @VALID_PACKAGE_STARTS_DISABLED, @VALID_PACKAGE_STARTS_ENABLED_NOT_STARTING_TOGGLE_PACKAGE]

exports.STARTING_TOGGLE_PACKAGE_DISPLAY_NAMES = [@VALID_PACKAGE_STARTS_ENABLED_DISPLAY_NAME, @VALID_PACKAGE_STARTS_DISABLED_DISPLAY_NAME]

exports.available_toggle_packages = @STARTING_TOGGLE_PACKAGES.filter (n) =>
  @AVAILABLE_PACKAGE_NAMES.indexOf(n) != -1

@disabled_packages = [@VALID_PACKAGE_STARTS_DISABLED]

@setupTogglePackages = ->
  atom.config.set('toggle-packages.togglePackages', @STARTING_TOGGLE_PACKAGES)

exports.togglePackage = (name) ->
  index = @disabled_packages.indexOf(name)
  if not (index is -1)
    @disabled_packages.splice(index, 1)
  else
    @disabled_packages.push(name)
  atom.config.set("core.disabledPackages", @disabled_packages)

exports.setupMockPackages = ->
  atom.config.set("core.disabledPackages", @disabled_packages)
  @setupTogglePackages()
  spyOn(atom.packages, 'getAvailablePackageNames').andReturn(@AVAILABLE_PACKAGE_NAMES)
  spyOn(atom.packages, 'isPackageDisabled').andCallFake (name) =>
    @disabled_packages.indexOf(name) isnt -1
    # not (args is @VALID_PACKAGE_STARTS_ENABLED)

exports.setupExamplePackages = ->
  @setupTogglePackages()
  if atom.packages.packageDirPaths[0] != @FIXTURE_PACKAGE_DIRECTORY
    atom.packages.packageDirPaths.unshift(@FIXTURE_PACKAGE_DIRECTORY)

  waitsForPromise =>
    atom.packages.activatePackage(@VALID_PACKAGE_STARTS_ENABLED)

  waitsForPromise =>
    atom.packages.activatePackage(@VALID_PACKAGE_STARTS_DISABLED)

  runs =>
    atom.packages.disablePackage(@VALID_PACKAGE_STARTS_DISABLED)

exports.commandExists = (commandName) ->
  eventElement = atom.views.getView(atom.workspace)
  commands = atom.commands.findCommands(target: eventElement)
  exists = false
  for command in commands
    if command.name is commandName
      exists = true
  exists
