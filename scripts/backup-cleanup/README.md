# UC Backup Cleanup Script

Automates the rotation of CUCM and SBC backup files older than 90 days. Designed to run on a centralized Windows server where backup files are stored via SFTP. This script improves storage efficiency and ensures compliance with retention policies.

---

## Features
- Deletes `.tar` and `.tar.gz` backup files older than 90 days
- Logs each deletion with file name, path, size, and date
- Calculates and logs total freed space
- Includes `-WhatIf` safety mode for dry runs
- Produces monthly `.csv` logs

---

##  Project Structure
```
uc-backup-cleanup/
│
├── BackupCleanup.ps1           # Main PowerShell script
├── Runbook.md                  # Operational runbook for usage
├── Architecture.md             # Visual architecture and flow
├── README.md                   # You are here
└── /docs                       # Additional documentation (optional)
```

---

## Safe Testing Mode
Use `-WhatIf` for a simulation without deleting any files:
```powershell
.\BackupCleanup.ps1 -WhatIf
```


