# Operation Log — TRAINING

This is the training instance of OPERATION-LOG.md. Used during training runs instead of the competition file. Reset to template state before each training run.

Maintained by: INTEL-001 (Intelligence/Reporting) during training runs, with entries from all agents and the operator. Monitored by TRAIN-002.
Purpose: authoritative chronological record of all operations during training exercises. Every significant action (scan initiated, access established, persistence deployed, technique burned, rotation executed) gets a timestamped entry.

---

## Log

| Timestamp | Agent/Operator | Action | Target | Result | Notes |
|-----------|----------------|--------|--------|--------|-------|
| — | SYSTEM | Training run not yet started. Run /training-run to initialize. | — | — | — |

### Entry Guidelines

Timestamps should be HH:MM format (local time) for readability during fast-paced operations.

Agent/Operator values: OPS-001, RECON-001, EXPLOIT-001, PERSIST-001, EVADE-001, LATERAL-001, INTEL-001, PAYLOAD-001, or the operator's name for manual actions.

Action should be a brief verb phrase: "Initiated scan", "Credential spray successful", "Deployed schtask persistence", "Burned: scheduled task removed", "Rotated to WMI persistence", etc.

Result values: SUCCESS, FAILURE, PARTIAL, REFUSED (agent declined), PENDING (action initiated but not yet confirmed).

This log feeds INTEL-001's end-of-session report and TRAIN-002's timing measurements.
