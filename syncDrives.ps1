# ONLY COPIES FROM EXTERNAL DRIVE TO SYSEM DRIVE
$selectedDrive = Read-Host "Enter Backup Folder Path"
# List of valid Windows default folder names
$validFolderNames = @('Desktop', 'Documents', 'Downloads', 'Music', 'Pictures', 'Videos')
# robocopy options
$options = "/s /mt /zb"

# verify is backup path exists
while (!(Test-Path -Path $selectedDrive)){
    Write-Host "Invalid Drive Path"
    $selectedDrive = Read-Host "Enter Backup Folder Path"
}

# validate if folder structure is correct
$subfolders = Get-ChildItem -Path $selectedDrive -Directory | Select-Object -ExpandProperty Name
foreach ($folder in $subfolders) {
    if ($validFolderNames -notcontains $folder) {
        Write-Host "Invalid folder found: $folder. This folder will not be copied" -ForegroundColor Red
    } else {
        Write-Host "Valid folder: $folder" -ForegroundColor Green
        
        # robocopy folder to pc
        robocopy $selectedDrive\$folder $env:USERPROFILE\$folder $options
    }
}



