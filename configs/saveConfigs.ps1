# Declare all destination file paths
$vscodeExtensionsFile = "configs\VSCode\extensions.txt"
$vscodeSettingsFile = "configs\VSCode"
$flowLauncherFolder = "configs\FlowLauncher"
$ohMyPoshConfigFile = "configs\OhMyPosh\config.json"

# Backup VSCode extensions and settings
code --list-extensions > $vscodeExtensionsFile
Copy-Item "$env:APPDATA\Code\User\settings.json" -Destination $vscodeSettingsFile
Copy-Item "$env:APPDATA\Code\User\keybindings.json" -Destination $vscodeSettingsFile

# Backup Oh My Posh configuration
oh-my-posh config export > $ohMyPoshConfigFile
Write-Host "VSCode extensions list saved to $vscodeExtensionsFile"
Write-Host "VSCode settings saved to $vscodeSettingsFile"
Write-Host "Oh My Posh configuration saved to $ohMyPoshConfigFile"

# Backup FlowLauncher configuration
robocopy $env:APPDATA\FlowLauncher\Settings $flowLauncherFolder\Settings "/E"   
robocopy $env:APPDATA\FlowLauncher\Plugins $flowLauncherFolder\Plugins  "/E"         
