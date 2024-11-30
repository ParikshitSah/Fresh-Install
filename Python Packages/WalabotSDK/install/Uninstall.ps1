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

# Remove driver
$drvToRemove = pnputil -e |
	foreach { if ($_ -match "^Published name :.*oem.*\.inf$") { $curOem=$_.split(":")[1].trim()} ; $_ } |
	foreach { if ($_ -match "^Driver package provider :.*Walabot Inc$") { $curOem } }
if ($drvToRemove)
{
	$drvToRemove | foreach { Out-Host -inputObject "Remove driver $_" ; pnputil -f -d $_ }
}

