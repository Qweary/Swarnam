---
name: "end-ops"
description: "End-of-day operations shutdown. Generates the full operation report for educational review, verifies all active persistence, archives the current state, and produces the post-engagement after-action review document. Usage: /end-ops [--day1|--day2|--final]"
---

# /end-ops — Operations Shutdown and Reporting

## Workflow

When the operator invokes /end-ops at the end of a engagement day, execute the following shutdown sequence.

### Step 1: Verify Active Persistence

PERSIST-001 reviews coordination/PERSISTENCE-MANIFEST.md and generates verification commands for every active persistence mechanism. The operator runs these commands to confirm what is still active. Update the manifest with verification results.

This step is especially important between Day 1 and Day 2 — any persistence that survives overnight gives the team a head start on Day 2. Note which mechanisms survived and which were remediated during the overnight window.

### Step 2: Generate Final Status

INTEL-001 generates a comprehensive end-of-session status report. This is a more detailed version of the /status report that includes a complete target map with all access methods and persistence mechanisms, a full timeline of operations from OPERATION-LOG.md, a summary of all burned techniques from BURNED-TECHNIQUES.md, all tactical decisions from DECISION-LOG.md, and any refusals from REFUSAL-LOG.md.

### Step 3: Generate Educational Report

INTEL-001 produces the post-engagement educational report. This document is designed to be shared with defensive team participants during the after-action review and should be written in a constructive, educational tone.

The report should include an operation summary covering the red team's objectives, techniques, and overall results. The technique catalogue should list every technique used with success rates, detection rates, and which defensive teams detected each technique. The defensive team assessment section should evaluate each team's defensive posture, noting both strengths and areas for improvement with specific, actionable feedback. The lessons learned section should cover what worked well for the red team, what didn't, and what the defensive teams did that was effective.

For AI defensive teams specifically, include a detailed assessment of detection capabilities, response speed, remediation effectiveness, and any observed behavioral patterns. This data is valuable for security research into agentic AI defensive capabilities.

### Step 4: Archive State

Create a timestamped archive directory (e.g., archive/day1-YYYYMMDD-HHMM/) and copy all coordination files into it. This preserves the state for reference and prevents confusion between sessions.

If this is the --final shutdown (end of engagement), note that all persistence should be documented for cleanup — the engagement-profile.yaml will specify whether infrastructure is decommissioned or whether cleanup is required.

### Step 5: Log Session End

Append a session end entry to coordination/OPERATION-LOG.md with the timestamp, session summary statistics (targets owned, persistence active, techniques burned), and any notes for the next session.

## Example Invocations

```
/end-ops --day1
/end-ops --day2
/end-ops --final
```
