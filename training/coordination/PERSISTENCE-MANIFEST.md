# Persistence Manifest — TRAINING

This is the training instance of PERSISTENCE-MANIFEST.md. Used during training runs instead of the competition file. Reset to template state before each training run.

Maintained by: PERSIST-001 (Persistence Engineer) during training runs, monitored by TRAIN-002
Purpose: complete record of all persistence mechanisms deployed during training exercises, with cleanup commands for each

---

## Active Persistence

| Target IP | Mechanism Type | Mechanism Name | Deploy Time | Last Verified | Status | Cleanup Command | Operator |
|-----------|----------------|----------------|-------------|---------------|--------|-----------------|----------|
| 10.100.100.79 (SUPRA) | ACCOUNT | Local admin: redteam / R3dT3am2026! | 02:10 | 02:12 (SMB confirmed) | ACTIVE | net user redteam /delete | Queue |
| 10.100.100.79 (SUPRA) | SCHTASK | WindowsUpdateCheck (SYSTEM, hourly) — recreates redteam account | 02:12 | 02:12 (created confirmed) | ACTIVE | schtasks /delete /tn "WindowsUpdateCheck" /f | Queue |
| 10.100.100.25 (JEEP/DC) | SCHTASK | WindowsUpdateCheck (SYSTEM, hourly) — recreates redteam account | 02:14 | 02:14 (created confirmed) | ACTIVE | schtasks /delete /tn "WindowsUpdateCheck" /f | Queue |
| 10.100.100.200 (PTCRUISER) | SCHTASK | WindowsUpdateCheck (SYSTEM, hourly) — recreates redteam account | 02:14 | 02:14 (created confirmed) | ACTIVE | schtasks /delete /tn "WindowsUpdateCheck" /f | Queue |

### Status Values

ACTIVE: persistence verified and functioning.
UNVERIFIED: deployed but not yet verified.
BURNED: detected and removed by blue team — do not reuse on this target.
CLEANED: removed by red team as part of post-exercise cleanup.

### Mechanism Types

SCHTASK: Windows scheduled task.
SERVICE: Windows service.
WMI: WMI event subscription (filter + consumer + binding).
REGISTRY: registry run key or equivalent autorun location.
CRON: Linux cron job (user or system crontab).
SSHKEY: SSH authorized_keys injection.
WEBSHELL: web-accessible shell script.
ACCOUNT: backdoor user account.
PROFILE: shell profile modification (.bashrc, .profile).
ADS: NTFS Alternate Data Stream via Apparition Delivery System.
OTHER: any mechanism not in the above categories (describe in Notes).

## Cleanup Checklist

Before ending the training run, verify all entries above have been either BURNED (removed by blue team) or CLEANED (removed by red team). No persistence should remain on training VMs after the run concludes.
