# Persistence Manifest — TRAINING

This is the training instance of PERSISTENCE-MANIFEST.md. Used during training runs instead of the competition file. Reset to template state before each training run.

Maintained by: PERSIST-001 (Persistence Engineer) during training runs, monitored by TRAIN-002
Purpose: complete record of all persistence mechanisms deployed during training exercises, with cleanup commands for each

---

## Active Persistence

| Target IP | Mechanism Type | Mechanism Name | Deploy Time | Last Verified | Status | Cleanup Command | Operator |
|-----------|----------------|----------------|-------------|---------------|--------|-----------------|----------|
| — | — | No persistence deployed yet. | — | — | — | — | — |

### Status Values

ACTIVE: persistence verified and functioning.
UNVERIFIED: deployed but not yet verified.
BURNED: detected and removed by blue team (or simulated remediation). Move details to BURNED-TECHNIQUES.md.
DEGRADED: partially functional (e.g., callback works but elevated privileges lost).
REMOVED: intentionally removed by operator during cleanup.

### Mechanism Type Categories

SCHTASK: Windows scheduled tasks.
SERVICE: Windows service creation.
WMI: WMI event subscriptions.
REGISTRY: Registry run key or other autostart entries.
CRON: Linux cron jobs.
SSHKEY: SSH authorized_keys deployment.
WEBSHELL: Web shell deployment.
ACCOUNT: User account creation or credential modification.
ADS: Apparition Delivery System persistence (NTFS Alternate Data Streams).
OTHER: mechanisms not covered by the above categories.

---

## Cleanup Checklist

Before ending a training run, verify all persistence has been documented. During competition, this manifest feeds the /end-ops report and post-competition cleanup. During training, it feeds TRAIN-002's persistence survival rate metric.

No cleanup items pending.
