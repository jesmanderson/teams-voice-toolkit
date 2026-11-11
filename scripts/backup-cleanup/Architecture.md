# Backup Rotation Architecture

## Purpose
This document describes the architecture and flow of the UC Backup Cleanup system used to rotate CUCM and SBC backups on a centralized Windows server. The system is designed to automatically delete backup files older than 90 days and log the results for audit and compliance purposes.

---

## High-Level Architecture

```text
+-----------------+         (SFTP Transfer)        +------------------------+
| CUCM / SBC Node | -----------------------------> | Windows Backup Server |
+-----------------+                                 +------------------------+
                                                            |
                                                            | (Runs monthly)
                                                            v
                                           +--------------------------------+
                                           | BackupCleanup.ps1 (PowerShell) |
                                           +--------------------------------+
                                                            |
       +----------------------------------------------------+---------------------------------------------------+
       |                                                                                                            |
+-------------------------+                                                               +--------------------------+
| Deletes Old Backups     |                                                               | Logs Deleted Files       |
| >90 Days Old            |                                                               | to Monthly CSV           |
+-------------------------+                                                               +--------------------------+
                                                                                                  |
                                                                                                  v
                                                                                 C:\Backups\Logs\CUCM-SBC-Log-Apr-2025.csv
```

---

## Components

### CUCM & SBC Devices
- Upload `.tar` or `.tar.gz` backup files via SFTP to the centralized Windows server

### Windows Backup Server
- Shared server that stores all backup files and runs the cleanup script
- Contains:
  - `CUCM` folder
  - `SBC` folder
  - `Logs` folder for `.csv` logs

### PowerShell Script (BackupCleanup.ps1)
- Runs via Task Scheduler or GitHub Actions
- Deletes files older than 90 days
- Logs file name, size, deletion time, and total freed space

### GitHub Repo
- Hosts script source code, documentation, changelog, and SOP
- Optional: CI/CD pipeline to run the script from GitHub Actions

---

## Rotation Policy
- Backup files older than **90 days** are removed
- Log is appended monthly with deleted file info and summary stats

---

## Security
- Backup folders have restricted NTFS permissions
- Script is read-only to non-admin users
- (Optional) Future: Alerts to Teams via Webhook or email

---

## Next Steps
- Integrate storage check (available vs used)
- Add email alert or Teams webhook on successful deletion
- Build scheduler dashboard with run logs

---

## Notes
- Script does **not** delete `.csv` logs (historical records are preserved)
- You can simulate deletion using `-WhatIf`
- Useful for CUCM, SBC, or any SFTP-based backup process

---

**Maintained by:** Jessica Anderson  
