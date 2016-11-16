module.exports =
  testCommandCallCount: 0

  activate: ->
    @disposable = atom.commands.add 'atom-workspace', 'package-with-command:test-command', =>
      @testCommandCallCount++

  deactivate: ->
    @disposable?.dispose()
