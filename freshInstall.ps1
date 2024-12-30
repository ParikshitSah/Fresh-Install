. .\variables.ps1
# Check if winget is installed, if not, install it
if (!(Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "WinGet is not installed. Installing WinGet..."
    $progressPreference = 'silentlyContinue'
    Invoke-WebRequest -Uri https://aka.ms/getwinget -OutFile Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
    Add-AppxPackage -Path Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
    Remove-Item Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
}

# Install software using winget
winget install --id=Python.Python.3.13  -e
winget install Git.Git
winget install OpenJS.NodeJS
winget install "Flow Launcher"
winget install Obsidian.Obsidian
winget install Spotify.Spotify
winget install --id=TheBrowserCompany.Arc -e
# winget install WhatsApp.WhatsApp
winget install Microsoft.PowerToys
winget install Bitwarden.Bitwarden
winget install --id=ArduinoSA.IDE.stable  -e
winget install Microsoft.VisualStudioCode
winget install --id=DigitalScholar.Zotero  -e
winget install JanDeDobbeleer.OhMyPosh
winget install Microsoft.WindowsTerminal
winget install KiCad.KiCad

# Refresh environment variables
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# Install fonts
oh-my-posh font install Agave
oh-my-posh font install FiraCode

# Install pip (if not already installed with Python)
python -m ensurepip --upgrade

# Walabot might not install properly make sure to add it to Programs > Walabot and then add bin to PATH
# TODO

# Install Python packages from requirements.txt
$pythonPackages = ".\Python Packages\packages.txt"
pip install -r $pythonPackages

# Install pnpm using npm (comes with Node.js)
npm install -g pnpm

# Setup All Configs

# vscode extensions
# Read the list of extensions from the file
$extensions = Get-Content -Path $vscodeExtensionsFile

# Loop through each extension and install it
foreach ($extension in $extensions) {
    Write-Host "Installing $extension..."
    code --install-extension $extension
}

Write-Host "VSCode Extensions Installation complete!"
# # vscode configs

# Copy backedup configs to vscode directory
Copy-Item "$vscodeSettingsFile -Destination $env:APPDATA\Code\User\settings.json"
Copy-Item "$vscodeKeyBindingsFile -Destination $env:APPDATA\Code\User\keybindings.json"

# # OhMyPosh configs
if (!(Test-Path -Path $PROFILE)) {
    # Profile doesn't exist, so create it
    New-Item -ItemType File -Path $PROFILE -Force
    Write-Host "PowerShell profile created at: $PROFILE"
}
Write-Host "Profile path: $PROFILE"

oh-my-posh init pwsh --config $ohMyPoshConfigFile | Invoke-Expression
. $PROFILE

# Copy Backup Files from Backup SSD to PC
# TODO
# Generate and Copy SSH key to clipboard
# TODO