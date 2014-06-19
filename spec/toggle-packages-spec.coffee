{WorkspaceView} = require 'atom'
TogglePackages = require '../lib/toggle-packages'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "TogglePackages", ->
  activationPromise = null

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    activationPromise = atom.packages.activatePackage('toggle-packages')

  describe "when the toggle-packages:toggle event is triggered", ->
    it "attaches and then detaches the view", ->
      expect(atom.workspaceView.find('.toggle-packages')).not.toExist()

      # This is an activation event, triggering it will cause the package to be
      # activated.
      atom.workspaceView.trigger 'toggle-packages:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(atom.workspaceView.find('.toggle-packages')).toExist()
        atom.workspaceView.trigger 'toggle-packages:toggle'
        expect(atom.workspaceView.find('.toggle-packages')).not.toExist()
