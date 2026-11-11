# BackupCleanup.ps1 Runbook

## Purpose
This runbook provides clear, repeatable instructions for safely executing the `BackupCleanup.ps1` script. The script automates the cleanup of CUCM and SBC backup files older than 90 days and logs the deletions.

---

## What It Does
- Scans defined backup directories
- Identifies `.tar` or `.tar.gz` files older than 90 days
- Deletes those files (in production mode)
- Logs deleted file names, sizes, and total storage freed in a monthly `.csv`

---

## When to Run
- **Automatically:** via Windows Task Scheduler (recommended monthly)
- **Manually:** during low disk space or audit reviews
- **Test Mode:** anytime before a production rollout

---

## Safe Test Mode
Run with `-WhatIf` to simulate deletions:
```powershell
.\BackupCleanup.ps1 -WhatIf
```
This will show what *would* be deleted without actually removing anything.

---

## How to Run (Production Mode)
From an elevated PowerShell terminal on the backup server:
```powershell
cd C:\Scripts\UCBackupCleanup
.\BackupCleanup.ps1
```
> Script will delete eligible files and write logs to `C:\Backups\Logs`.

---

## Pre-Execution Checklist
- [ ] Confirm backup folders are correct (CUCM/SBC paths)
- [ ] Confirm script path is accessible by Task Scheduler or admin user
- [ ] Run `-WhatIf` first if testing in a new environment
- [ ] Ensure log directory exists (script will attempt to create it)

---

## Output
- **Deleted Files CSV:**
  - Path: `C:\Backups\Logs\CUCM-SBC-CleanupLog-Apr-2025.csv`
  - Includes: File name, type, path, deletion date, size
- **Footer Log Summary:**
  - Total files deleted
  - Total storage freed in MB

---

## Monthly Automation Setup
Create a Task Scheduler job:
- Trigger: Monthly, first Monday
- Action: Start a program → `powershell.exe`
- Arguments:
  ```powershell
  -ExecutionPolicy Bypass -File "C:\Scripts\UCBackupCleanup\BackupCleanup.ps1"
  ```

---

## Troubleshooting
| Issue | Fix |
|-------|-----|
| Script doesn’t delete | Run as admin / check folder permissions |
| Files not found | Confirm backup paths in script match actual folders |
| Log file not created | Ensure `Logs` folder exists or let script create it |
| Disk still full | Check if backup frequency is too high / adjust retention |

---

## Security Notes
- Ensure only privileged users can modify the script
- Optional: add Teams webhook alert on script completion

---

## Maintainer
Jessica Anderson  
UC Infra Engineer
