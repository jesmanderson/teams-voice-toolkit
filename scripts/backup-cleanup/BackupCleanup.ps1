# BackupCleanup.ps1
# Description: Deletes CUCM and SBC backup files older than 90 days
# and logs deletions into a monthly CSV file with summary.
# This script is intended to be used for routine monthly cleanup.

# === CONFIGURATION ===
# Define the directories containing CUCM and SBC backup files
$backupPaths = @{
    'CUCM' = "C:\Backups\CUCM"        # Path to CUCM backups
    'SBC'  = "C:\Backups\SBC"         # Path to SBC backups
}

# Generate dynamic log filename based on the current month and year
# This allows rotating logs each month without overwriting the previous logs
$monthYear = Get-Date -Format "MMM-yyyy"
$logPath = "C:\Backups\Logs\CUCM-SBC-CleanupLog-$monthYear.csv"

# Define how old the files must be (in days) before being deleted
$retentionDays = 90

# Create the log directory if it doesn't exist
$logDir = Split-Path $logPath
if (-not (Test-Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir -Force
}

# === MAIN CLEANUP SCRIPT ===
$now = Get-Date
$deletedFiles = @()                   # Stores list of deleted files for logging
$totalFreedSpaceMB = 0               # Track total space saved in MB

# Loop through each backup type defined in $backupPaths
foreach ($type in $backupPaths.Keys) {
    $path = $backupPaths[$type]

    if (Test-Path $path) {
        # Find .tar and .tar.gz files older than $retentionDays
        $files = Get-ChildItem -Path $path -Recurse -Include *.tar, *.tar.gz | Where-Object {
            $_.LastWriteTime -lt $now.AddDays(-$retentionDays)
        }

        foreach ($file in $files) {
            # Get file size in MB before deleting
            $fileSizeMB = [math]::Round($file.Length / 1MB, 2)

            # Log file metadata for recordkeeping
            $deletedFiles += [PSCustomObject]@{
                FileName      = $file.Name
                FilePath      = $file.FullName
                BackupType    = $type
                FileSizeMB    = $fileSizeMB
                DeletedDate   = $now
            }

            # Add file size to the total freed space counter
            $totalFreedSpaceMB += $fileSizeMB

            # Delete the file from disk
            Remove-Item $file.FullName -Force
        }
    }
}

# === LOGGING ===
# If files were deleted, export the records to a monthly CSV file
if ($deletedFiles.Count -gt 0) {
    # Save file details to CSV log
    $deletedFiles | Export-Csv -Path $logPath -Append -NoTypeInformation

    # Add summary footer at the end of the CSV file
    Add-Content -Path $logPath -Value "Total Files Deleted: $($deletedFiles.Count)"
    Add-Content -Path $logPath -Value "Total Storage Freed (MB): $totalFreedSpaceMB"

    # Display summary in the PowerShell console
    Write-Host "Deleted $($deletedFiles.Count) files. Log saved to $logPath"
    Write-Host "Total storage freed: $totalFreedSpaceMB MB"
} else {
    # No files were deleted — nothing to log
    Write-Host "No files older than $retentionDays days were found."
}

# === END OF SCRIPT ===
