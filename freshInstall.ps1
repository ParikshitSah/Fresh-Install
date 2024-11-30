# Check if winget is installed, if not, install it
if (!(Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "WinGet is not installed. Installing WinGet..."
    $progressPreference = 'silentlyContinue'
    Invoke-WebRequest -Uri https://aka.ms/getwinget -OutFile Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
    Add-AppxPackage -Path Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
    Remove-Item Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
}

# Install software using winget
winget install Python.Python
winget install Git.Git
winget install OpenJS.NodeJS
winget install "Flow Launcher"
winget install Obsidian.Obsidian
winget install Spotify.Spotify
winget install --id=TheBrowserCompany.Arc -e
winget install WhatsApp.WhatsApp
winget install Microsoft.PowerToys
winget install Bitwarden.Bitwarden
winget install Arduino.IDE
winget install Microsoft.VisualStudioCode
winget install Zotero.Zotero
winget install JanDeDobbeleer.OhMyPosh
winget install Microsoft.WindowsTerminal
winget install KiCad.KiCad

# Refresh environment variables
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# Install pip (if not already installed with Python)
python -m ensurepip --upgrade

# Walabot might not install properly make sure to add it to Programs > Walabot and then add bin to PATH

# Install Python packages from requirements.txt
$pythonPackages = ".\Python Packages\packages.txt"
pip install -r $pythonPackages

# Install pnpm using npm (comes with Node.js)
npm install -g pnpm

# test commit