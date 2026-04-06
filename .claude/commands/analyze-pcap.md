---
description: >
  Feed PCAP files from past exercise competitions (such as WRCCDC and other competition archives) to TRAIN-001 (PCAP Analyst) for
  intelligence extraction. Accepts a file path (single PCAP) or directory path
  (batch processing). Outputs structured findings to training/PCAP-INTELLIGENCE.md
  and generates agent prompt improvement recommendations. Run this before Phase 1
  training runs to embed exercise-specific knowledge into engagement agents.
arguments:
  - name: path
    description: Path to a PCAP file or directory containing PCAPs
    required: true
  - name: topology
    description: Optional path to the topology document for this exercise year
    required: false
  - name: year
    description: Exercise year for these captures (e.g., 2019)
    required: false
  - name: pass
    description: Run a specific analysis pass only (topology, redteam, blueteam, credentials). Omit for all four passes.
    required: false
---

## Workflow

This command orchestrates TRAIN-001 (PCAP Analyst) to extract operational intelligence from historical exercise packet captures (such as WRCCDC and other competition archives). The extracted intelligence feeds the engagement agents' system prompts during the training calibration cycle.

### Step 1: Validate Input

Verify the provided path exists. If it's a file, confirm it has a .pcap or .pcapng extension. If it's a directory, list all .pcap and .pcapng files within it (non-recursive) and report the count to the operator.

Verify tshark is available on the system. If tshark is not installed, report the installation command (`sudo apt install -y tshark`) and abort. Tshark is the primary analysis engine — tcpdump is used for supplementary checks but tshark is required.

If a topology document path was provided, note it for cross-referencing during Pass 1. If not, inform the operator that topology cross-referencing will be skipped (the analysis still works, but host role classification will be based entirely on port profiles rather than confirmed documentation).

### Step 2: Initialize Output

If training/PCAP-INTELLIGENCE.md does not exist or is in its initial template state, initialize it with the section headers defined in the template. If it already contains findings from a previous analysis run, append new findings under a dated subsection header so historical analysis is preserved.

Create a working directory for intermediate extraction files: training/analysis/{year}/ (or training/analysis/unknown/ if no year was specified). Tshark extraction outputs go here before being consolidated into the intelligence file.

### Step 3: Invoke TRAIN-001

Dispatch to TRAIN-001 (PCAP Analyst) with the following context:

```
PCAP source: {path}
Competition year: {year or "unknown"}
Topology document: {topology path or "none provided"}
Analysis passes requested: {pass or "all four"}
Working directory: training/analysis/{year}/
Output target: training/PCAP-INTELLIGENCE.md
```

If a specific pass was requested via the --pass argument, TRAIN-001 runs only that pass. Otherwise, TRAIN-001 runs all four passes in sequence: topology extraction, red team traffic identification, defensive team response detection, and credential extraction.

For directory inputs with multiple PCAP files, TRAIN-001 processes them in filename order (which typically corresponds to chronological order for exercise captures). If the total file count exceeds 10, TRAIN-001 applies its sampling strategy: process the first 3-5 files in full detail and sample the remainder.

### Step 4: Review Findings

After TRAIN-001 completes, display a summary of what was extracted:

Report the counts: how many unique hosts identified, how many services mapped, how many red team traffic patterns found, how many defensive team response events detected, how many credentials extracted, and how many agent prompt recommendations generated.

If any pass produced zero findings, flag it — this may indicate the PCAP doesn't contain the expected traffic (e.g., a capture that only includes scoring engine traffic would have no red team patterns).

### Step 5: Generate Prompt Recommendations

After extraction, TRAIN-001 produces a "Recommended Agent Prompt Additions" section in PCAP-INTELLIGENCE.md. Present these to the operator as a numbered list with the target agent, the proposed text, and the rationale.

The operator can approve, modify, or reject each recommendation. Approved recommendations feed into the next training debrief cycle as PROMPT-FIX items, or the operator can immediately invoke /apply-training to process them if there's no pending training run.

### Step 6: Log the Analysis

Append an entry to training/TRAINING-LOG.md recording the analysis:

```
## PCAP Analysis: {date}

Source: {path}
Exercise year: {year}
Passes run: {which passes}
Findings summary:
  Hosts identified: N
  Services mapped: N
  Red team patterns: N
  Defensive team responses: N
  Credentials extracted: N
  Prompt recommendations: N
Duration: {elapsed time}
```

## Usage Examples

Analyze a single PCAP from the 2019 exercise:
```
/analyze-pcap ~/wrccdc-training/pcaps/2019/day1/competition-day1-01.pcap --year 2019 --topology ~/wrccdc-training/topologies/2019-topology.pdf
```

Batch-analyze all Day 1 PCAPs from 2018:
```
/analyze-pcap ~/wrccdc-training/pcaps/2018/day1/ --year 2018
```

Run only the credential extraction pass on a specific capture:
```
/analyze-pcap ~/wrccdc-training/pcaps/2019/day1/competition-day1-03.pcap --pass credentials --year 2019
```

Run topology extraction to validate understanding of a new exercise year's network layout:
```
/analyze-pcap ~/wrccdc-training/pcaps/2017/day1/ --pass topology --year 2017 --topology ~/wrccdc-training/topologies/2017-blueteam-packet.pdf
```

## Notes

This command is idempotent for the same input — re-running it on the same PCAP appends findings under a new dated subsection rather than overwriting previous analysis. This allows the operator to run the same PCAP through different passes at different times without losing earlier findings.

The command does not modify any engagement files. All output stays within the training/ directory. Recommendations for agent prompt changes are proposals only — they are not applied until the operator approves them through the debrief and patching cycle.
