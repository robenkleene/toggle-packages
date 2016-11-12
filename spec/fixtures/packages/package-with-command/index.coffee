module.exports =
  testCommandCallCount: 0

  activate: ->
    @disposable = atom.commands.add 'atom-workspace', 'test-command', =>
      @testCommandCallCount++

  deactivate: ->
    @disposable?.dispose()