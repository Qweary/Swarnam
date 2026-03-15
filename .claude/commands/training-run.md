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

Check each file in training/coordination/ against its template. If any file contains data from a previous training run (non-template content), ask the operator whether to reset or preserve. The default is reset — training runs should start from clean coordination state to produce comparable metrics.

Reset files to their templates:
- training/coordination/TARGET-STATUS.md → clean template with headers only
- training/coordination/RECON-FINDINGS.md → clean template with headers only
- training/coordination/PERSISTENCE-MANIFEST.md → clean template with headers only
- training/coordination/BURNED-TECHNIQUES.md → clean template with "No techniques burned yet" entry
- training/coordination/OPERATION-LOG.md → clean template, session start entry will be added below
- training/coordination/DECISION-LOG.md → clean template with headers only
- training/coordination/REFUSAL-LOG.md → clean template with "No refusals logged" entry
- training/coordination/CREDENTIALS.md → clean template with headers only

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

### Step 8: Record Session Start

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
