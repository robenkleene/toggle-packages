exports.isValidPackage = (name) ->
  if not @isValidPackageName(name)
    return false
  atom.packages.getAvailablePackageNames().indexOf(name) isnt -1

exports.isValidPackageName = (name) ->
  if not name
    return false
  /^[a-z0-9\-]+$/.test(name)

exports.isPackageEnabled = (name) ->
  not atom.packages.isPackageDisabled(name)

exports.togglePackage = (name) ->
  # TODO Warn and stop executing if the package has been removed from config?
  # TODO Warn and stop executing if it's an invalid package?
  if @isPackageEnabled(name)
    atom.packages.disablePackage(name)
  else
    atom.packages.enablePackage(name)
