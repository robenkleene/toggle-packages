exports.getTogglePackageNames = ->
  togglePackages = atom.config.get('toggle-packages.togglePackages') ? []
  togglePackage for togglePackage in togglePackages when @isValidPackage(togglePackage)

exports.isValidPackage = (name) ->
  valid = atom.packages.getAvailablePackageNames().indexOf(name) isnt -1
  unless valid
    console.warn "'#{name}' is not an available package name"
  valid

exports.isPackageEnabled = (name) ->
  not atom.packages.isPackageDisabled(name)

exports.togglePackage = (name) ->
  if @isPackageEnabled(name)
    atom.packages.disablePackage(name)
  else
    atom.packages.enablePackage(name)
