Param([string]$PackageName, [string]$PackageVersion)
$ErrorActionPreference = 'Stop'; # stop on all errors
Out-Host -inputObject "Start installation script: package=$PackageName, version=$PackageVersion"

if (-NOT $PackageName -OR -NOT $PackageVersion)
{
	throw "Arguments are missing."
}

# Check for Administrator privileges
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-NOT $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
	throw "You do not have Administrator rights to run this script!"
}

# InstallationFolders
$programFiles = $env:programfiles | resolve-path
$programFiles = Join-Path $programFiles "Walabot\$PackageName"
$programData = $env:programdata | resolve-path
$programData = Join-Path $programData "Walabot\$PackageName"

# Set access control for everyone
$acl = Get-ACL $programData
$everyone = New-Object System.Security.Principal.SecurityIdentifier([System.Security.Principal.WellKnownSidType]::WorldSid, $null)
$fullControl = [System.Security.AccessControl.FileSystemRights]::FullControl
$inheritanceFlag = [System.Security.AccessControl.InheritanceFlags]::ContainerInherit -bor [System.Security.AccessControl.InheritanceFlags]::Objectinherit
$propagationFlag = [System.Security.AccessControl.PropagationFlags]::None
$allow = [System.Security.AccessControl.AccessControlType]::Allow
$accessRule= New-Object System.Security.AccessControl.FileSystemAccessRule($everyone, $fullControl, $inheritanceFlag, $propagationFlag, $allow)
$acl.AddAccessRule($accessRule)
Set-Acl $programData $acl
Get-ChildItem -path $programData -Recurse | foreach { if($_.IsReadOnly) {$_.IsReadOnly = $False} }

# Create configuration file
$configFile = @"
[Setting]
path=$programData
"@
$configFilePath = Join-Path $programFiles "bin\.config"
$configFile | Out-File -filepath $configFilePath -encoding ASCII

# Create version file
$versionFile = @"
$PackageVersion
"@
$versionFilePath = Join-Path $programFiles "$packageName.version"
$versionFile | Out-File -filepath $versionFilePath -encoding ASCII

# Remove driver
$drvToRemove = pnputil -e |
	foreach { if ($_ -match "^Published name :.*oem.*\.inf$") { $curOem=$_.split(":")[1].trim()} ; $_ } |
	foreach { if ($_ -match "^Driver package provider :.*Walabot Inc$") { $curOem } }
if ($drvToRemove)
{
	$drvToRemove | foreach { Out-Host -inputObject "Remove driver $_" ; pnputil -f -d $_ }
}

# Install driver
Out-Host -inputObject "Install $PackageName driver"
pnputil -a $programFiles\Driver\walabot_usb.inf
if ($LASTEXITCODE -ne 0)
{
	throw "Failed to install driver."
}
