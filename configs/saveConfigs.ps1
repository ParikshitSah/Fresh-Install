
# Backup VSCode extensions and settings
$vscodeExtensionsFile = "configs\VSCode\extensions.txt"
$vscodeSettingsFile = "configs\VSCode"

code --list-extensions > $vscodeExtensionsFile
Copy-Item "$env:APPDATA\Code\User\settings.json" -Destination $vscodeSettingsFile

# Backup Oh My Posh configuration
$ohMyPoshConfigFile = "configs\OhMyPosh\config.json"
oh-my-posh config export --output $ohMyPoshConfigFile

oh-my-posh config export > $ohMyPoshConfigFile
Write-Host "VSCode extensions list saved to $vscodeExtensionsFile"
Write-Host "VSCode settings saved to $vscodeSettingsFile"
Write-Host "Oh My Posh configuration saved to $ohMyPoshConfigFile"