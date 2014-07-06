exports.isValidPackage = (name) ->
  valid = atom.packages.getAvailablePackageNames().indexOf(name) isnt -1
  unless valid
    console.warn "'#{name}' is not an available package name"
  valid

exports.isPackageEnabled = (name) ->
  not atom.packages.isPackageDisabled(name)

exports.togglePackage = (name) ->
  # TODO Warn and stop executing if the package has been removed from config?
  # TODO Warn and stop executing if it's an invalid package?
  if @isPackageEnabled(name)
    atom.packages.disablePackage(name)
  else
    atom.packages.enablePackage(name)
