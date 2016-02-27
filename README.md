# Toggle Packages [![Build Status](https://travis-ci.org/robenkleene/toggle-packages.svg?branch=master)](https://travis-ci.org/robenkleene/toggle-packages)

A package for enabling and disabling packages.

![Toggle Packages](https://raw.githubusercontent.com/robenkleene/toggle-packages/master/docs/toggle-packages.gif)
*Enabling and disabling the built-in "Wrap Guide" and "Git Diff" packages.*

It displays the status of packages in the status bar. Disabled packages are dimmed. Clicking a package name toggles it.

It also creates commands for toggling packages.

![Toggle Packages](https://raw.githubusercontent.com/robenkleene/toggle-packages/master/docs/toggle-packages-status-and-commands.png)

A setting controls which packages to enable toggling for.

![Toggle Packages](https://raw.githubusercontent.com/robenkleene/toggle-packages/master/docs/toggle-packages-settings.png)

# Adding Key Bindings

Key bindings to toggle packages can be created by adding a binding for the appropriate command to your [keymap](https://atom.io/docs/v1.5.3/behind-atom-keymaps-in-depth).

For example, to add a shortcut to the built-in [Wrap Guide](https://github.com/atom/wrap-guide) package, you'd add the following:

```
'atom-text-editor':
  'ctrl-shift-r': 'toggle-packages:toggle-wrap-guide'
```
