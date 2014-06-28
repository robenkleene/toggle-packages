exports.getTogglePackageNames = ->
  togglePackages = atom.config.get('toggle-packages.togglePackages') ? []
  (togglePackage for togglePackage in togglePackages when @isValidPackage(togglePackage))

exports.isValidPackage = (name) ->
  atom.packages.getAvailablePackageNames().indexOf(name) isnt -1
