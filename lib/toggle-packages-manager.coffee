exports.isValidPackage = (name) ->
  if not name
    return false
  if name.indexOf(' ') > -1
    return false
  atom.packages.getAvailablePackageNames().indexOf(name) isnt -1

exports.isPackageEnabled = (name) ->
  not atom.packages.isPackageDisabled(name)

exports.togglePackage = (name) ->
  # TODO Warn and stop executing if the package has been removed from config?
  # TODO Warn and stop executing if it's an invalid package?
  if @isPackageEnabled(name)
    atom.packages.disablePackage(name)
  else
    atom.packages.enablePackage(name)
