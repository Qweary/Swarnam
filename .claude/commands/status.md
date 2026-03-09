---
name: "status"
description: "Generate a quick-reference operational status report. Shows what is owned, what persistence is active, what has been burned, and what needs immediate attention. Usage: /status [--team <N>] [--full]"
---

# /status — Operational Status Report

## Workflow

When the operator invokes /status, INTEL-001 generates a concise situation report from current coordination files.

### Step 1: Read All Coordination Files

Read TARGET-STATUS.md, PERSISTENCE-MANIFEST.md, BURNED-TECHNIQUES.md, and OPERATION-LOG.md to build the current operational picture.

### Step 2: Generate SITREP

Produce a situation report with the following sections.

Operational Summary: One-line status — "X of Y targets owned, Z persistence mechanisms active, W techniques burned. Phase: [1/2/3]."

Immediate Attention: Any items requiring urgent operator action. This includes targets where access has been lost since last check, persistence mechanisms that have not been verified recently (more than 1 hour), burned techniques on high-value targets requiring /rotate, and unowned Tier 1 targets that should be prioritized.

Access Map: A table showing all targets with their current status (unscanned/enumerated/accessed/owned/burned), access method, persistence count, and last verified time. This is drawn directly from TARGET-STATUS.md.

Recent Activity: The last 5–10 entries from OPERATION-LOG.md, showing what has happened since the last /status check.

Recommended Actions: The top 3 recommended next actions based on OPS-001's prioritization framework.

### Step 3: Optional Filters

If the operator specifies --team N, filter the report to show only targets within that team's range. If --full is specified, include detailed RECON-FINDINGS.md data for each target and the complete PERSISTENCE-MANIFEST.md.

## Example Invocations

```
/status
/status --team 3
/status --full
```
