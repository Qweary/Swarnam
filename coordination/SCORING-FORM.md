# Scoring Form Schema

Maintained by INTEL-001. Operators populate the schema by editing this file directly or by describing the form's structure to any agent (INTEL-001 writes it back here). INTEL-001 reads this file when generating scoring reports and formats output to match the form's field names and structure.

**This file persists across sessions.** Update the schema if the form changes between events. The Submission Log is cleared at the start of each new training run but not between engagement sessions.

---

## Form Schema

*Populate before running /status or /end-ops. Describe the form's field names, grouping dimension, and any special requirements. You can also describe the form conversationally — any agent will write the schema here.*

**Grouping dimension:** [per-host/group | per-compromise-event]
*(One row per host/group: multiple compromises are listed within one entry. One row per compromise event: the host/group column repeats across rows. This determines how INTEL-001 structures the output table.)*

**Form fields:**
*(List each field name and what it expects. Example: "Hostname — the short hostname of the compromised system")*

| Field Name | Expected Content | Maps To (coordination file / column) |
|------------|-----------------|--------------------------------------|
| | | |

*Maps To examples: TARGET-STATUS.md hostname, CREDENTIALS.md username, OPERATION-LOG.md timestamp, PERSISTENCE-MANIFEST.md mechanism type*

**Special requirements:**
*(Date format, character limits, required evidence attachments, whether partial submissions are accepted, etc.)*

---

## Submission Log

Append-only. INTEL-001 adds one row each time a scoring report is generated. Delta reports use the most recent row's timestamp to filter events — everything after that timestamp is "unsubmitted."

| Generated At | Scope | Events Covered | Report File |
|-------------|-------|----------------|-------------|

---

## Pending Events Summary

INTEL-001 updates this after each report generation. Shows at-a-glance how many reportable events have not yet been included in a submission. Run /status or ask INTEL-001 to update.

| Event Type | Unsubmitted Count | Last Submitted At |
|------------|------------------|------------------|
| Initial Access | — | — |
| Privilege Escalation | — | — |
| Lateral Movement | — | — |
| Persistence Deployed | — | — |
| Credentials Harvested | — | — |
| Sensitive Data Exfiltrated | — | — |
| Scoring Tokens Collected | — | — |
| Services Degraded | — | — |

*Run /status or ask INTEL-001 to update this table.*
