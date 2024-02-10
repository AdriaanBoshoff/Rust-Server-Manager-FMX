# Plugin Manager

Plugin Manager Unit `ufrmPluginManager.pas`

Houses the modules to install and manage plugins.

## Sub Module Creation

In the `TfrmPluginManager.FormCreate` event it executes the `CreateModules` procedure. The `CreateModules` procedure is responsible for creating all the sub modules. After creation it simulates the user clicking on the `Installed Plugins` tab.