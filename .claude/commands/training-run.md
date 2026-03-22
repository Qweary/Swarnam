---
description: >
  Initialize a training pipeline run against a lab environment. Similar to
  /start-ops but uses training-specific coordination files (training/coordination/
  instead of coordination/) so competition files stay clean. Sets up TRAIN-002
  (Training Evaluator) to monitor the session and records training environment
  details. After initialization, the operator runs the normal competition pipeline
  (/scan-range, /attack-plan, execute, /status, /rotate) while TRAIN-002 observes.
arguments:
  - name: environment
    description: Description of the training environment (e.g., "2016 WRCCDC, 3 VMs, host-only network")
    required: true
  - name: focus
    description: Optional focus area for this run (e.g., "persistence timing", "credential spray accuracy", "coordination file flow")
    required: false
  - name: operator
    description: Operator name for the training log
    required: false
---

## Workflow

This command initializes a training pipeline run. It mirrors /start-ops for the competition pipeline but routes all coordination file activity to training/coordination/ and activates TRAIN-002 to observe the session.

### Step 1: Determine Run Number

Read training/TRAINING-LOG.md to determine the next sequential run number. If the file doesn't exist or contains no run entries, this is Run #1.

### Step 2: Reset Training Coordination Files

The training coordination files in training/coordination/ must start clean for each run. Reset them to their template state:

**Path A — Session Resume (check first):**

Before resetting anything, check training/TRAINING-LOG.md for an active (unclosed) run. A run is active if it has a `Started:` line but no `Status: CLOSED` line. If found:

1. Present the active run's number, start date, environment, and current state.
2. Ask: **"Resume Training Run #N or start a new run?"**
   - **RESUME:** Skip all file resets. Add a SESSION RESUMED entry to training/coordination/OPERATION-LOG.md with the resume time, reason (crash/shutdown/day-change), and a brief state snapshot (owned count, persistence verified/unverified, techniques burned). Re-activate TRAIN-002 with existing run context. Skip to Step 5 (Initialize TRAIN-002).
   - **NEW RUN:** Increment the run number and proceed with Path B below.

**Path B — New Run (full reset):**

CRITICAL: "reset" means truncating ALL data rows below the header/template structure — not just clearing the header. Every table must have column headers preserved but ALL data rows removed. Every log section must have section headers preserved but ALL log entries removed. Residual IPs, timestamps, or findings from previous runs contaminate metrics and confuse agents.

Reset each file with complete clean template content:
- training/coordination/TARGET-STATUS.md → column headers only, zero data rows
- training/coordination/RECON-FINDINGS.md → column headers only, zero data rows
- training/coordination/PERSISTENCE-MANIFEST.md → column headers only, zero data rows
- training/coordination/BURNED-TECHNIQUES.md → "No techniques burned yet" entry only
- training/coordination/OPERATION-LOG.md → column headers only, zero data rows; session start entry added in Step 8
- training/coordination/DECISION-LOG.md → column headers only, zero data rows
- training/coordination/REFUSAL-LOG.md → "No refusals logged" entry only
- training/coordination/CREDENTIALS.md → column headers only, zero data rows

**Post-reset validation (mandatory):** After writing all template files, verify:
1. No IP addresses from any 10.x.x.x range appear in any data row (stale targets)
2. No timestamps from previous dates appear in any data row (stale log entries)
3. Each file contains only template headers/structure and placeholder entries
If any check fails, re-write the file. Report validation results before proceeding.

### Step 3: Verify Environment

Display the training environment description back to the operator and ask them to confirm or amend. Prompt for any details not provided:

What competition year's infrastructure is deployed? How many target VMs are running and what are their roles (DC, web server, workstation, etc.)? What network topology is in use (IP ranges, which segment is the Kali jumpbox on)? Is there any simulated blue team activity, or is this a static target environment? Are there any known default credentials from the scenario documentation?

### Step 4: Configure Agent Routing

The critical distinction between /training-run and /start-ops is that all coordination file reads and writes during the training run must use training/coordination/ instead of coordination/. This keeps competition files clean.

Inform the operator of this routing. During the training run, when they invoke competition commands (/scan-range, /attack-plan, /status, /rotate), the agents will be instructed to read from and write to training/coordination/ instead of coordination/. The operator should pass the `--training` flag (or the equivalent convention) to competition commands, or should be aware that the training session has established this routing.

In practice, the simplest approach is for the operator to set the working context: at the start of the training run, explicitly tell the competition agents to use training/coordination/ for all coordination file operations. The /training-run command establishes this context.

### Step 5: Initialize TRAIN-002

Invoke TRAIN-002 (Training Evaluator) with initialization context:

```
Training Run: #{run_number}
Date: {current date and time}
Environment: {environment description}
Focus areas: {focus areas or "general calibration"}
Operator: {operator name or "unspecified"}
Coordination file path: training/coordination/
```

TRAIN-002 begins its observation role. It will passively monitor the training session, capturing refusals, command accuracy issues, coordination file inconsistencies, and timing measurements.

### Step 6: Verify MCP Connectivity

Same as /start-ops: check whether the MCP Kali server is available. If not, report the status but allow the run to continue — some training value (coordination file flow, agent recommendation quality) can be captured even without MCP tool execution.

### Step 7: Generate Competition Wordlist

Same as /start-ops: generate or verify the competition wordlist at /tmp/ccdc-wordlist.txt. If PCAP analysis has produced credential patterns (in training/PCAP-INTELLIGENCE.md), incorporate those patterns into the wordlist for this training run.

### Step 7b: Review Credential Intelligence File

Check if `training/coordination/CREDENTIAL-INTEL.md` exists (note: training runs use the training/coordination/ path). If it does, summarize its contents for the operator. If it does not exist, copy or create it from the competition template at `coordination/CREDENTIAL-INTEL.md`. Ask the operator if they have training-environment-specific credentials to add (e.g., passwords from the training scenario documentation, known defaults for the lab VMs). Additions go in the "Operator-Added Entries" section.

### Step 8: Record Session Start

**Environment verification note:** After the first /scan-range completes during this training run, update the environment description in TRAINING-LOG.md (the Run entry created below) with confirmed details: actual target count, verified IP ranges, discovered host roles, and any differences from the initial environment description provided by the operator. The initial description is a best-guess; the post-scan update ensures the training log accurately reflects what was actually tested.

Append a session start entry to training/TRAINING-LOG.md:

```
## Training Run #{run_number}

Started: {date and time}
Environment: {environment description}
Focus: {focus areas}
Operator: {operator name}
Coordination path: training/coordination/
MCP status: {available|unavailable}
Wordlist: {path and entry count}

### Run Notes
[operator adds notes during the run]
```

Append a session start entry to training/coordination/OPERATION-LOG.md:

```
| {timestamp} | SYSTEM | Training run #{run_number} started. Environment: {description}. Operator: {name}. |
```

### Step 9: Brief the Operator

Present a startup brief:

```
TRAINING RUN #{run_number} INITIALIZED
Environment: {description}
Focus: {areas}
Coordination files: training/coordination/ (competition files untouched)
TRAIN-002: Active and observing

NEXT STEPS:
1. Run /scan-range against target ranges (agents will use training/coordination/)
2. Run /attack-plan for discovered targets
3. Execute recommended commands
4. Run /status for operational picture
5. When finished, run /debrief to compile findings

REMINDERS:
- All coordination file activity routes to training/coordination/
- TRAIN-002 is passively observing — operate normally
- Note any issues verbally; TRAIN-002 will capture what it can automatically
- Time starts now for timing metrics
```

### Step 10: Start the Clock

Record the exact start time. TRAIN-002 uses this as the baseline for all timing measurements. The operator is now in the training pipeline and should proceed with /scan-range, /attack-plan, etc. as they would during competition.

## Post-Initialization

After initialization, the operator runs the normal competition pipeline. The only differences from a real competition run are that coordination files are in training/coordination/, TRAIN-002 is observing, and the operator should call /debrief when the training run is complete (instead of /end-ops, which is reserved for competition operations).

If the operator wants to end the training run early (e.g., encountered a blocking issue), they should still call /debrief to capture whatever metrics and findings were generated during the partial run.

## Usage Examples

Start a Phase 1 calibration run:
```
/training-run --environment "2016 WRCCDC, 4 VMs (DC, web, mail, workstation), host-only 10.0.1.0/24" --operator Queue
```

Start a focused run on persistence timing:
```
/training-run --environment "Win11 VirtualBox lab, single target 192.168.56.101" --focus "persistence deployment timing and survival" --operator Queue
```

Start a Phase 2 scrimmage:
```
/training-run --environment "2019 WRCCDC full topology, 8 targets, NAT network 10.200.X.0/24" --focus "operational tempo and multi-target prioritization" --operator Queue
```
