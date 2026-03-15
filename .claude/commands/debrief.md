---
description: >
  End a training run and generate the debrief queue. TRAIN-002 compiles all
  captured metrics and findings into training/DEBRIEF-QUEUE.md with each item
  pre-categorized by disposition. The operator reviews findings, adjusts
  dispositions as needed, and confirms. After confirmation, TRAIN-003 generates
  the patch file for approved fixes. This command replaces /end-ops for training
  runs — use /end-ops only during actual competition.
---

## Workflow

This command finalizes a training run, compiles evaluation data, and drives the improvement cycle from observation through patch generation.

### Step 1: Verify Active Training Run

Check training/TRAINING-LOG.md for an active (unclosed) training run. If no active run exists, inform the operator and abort — /debrief requires a preceding /training-run to have meaningful data. If the operator wants to create a debrief from manual observations without a formal training run, suggest they add their findings directly to training/DEBRIEF-QUEUE.md and skip to Step 5.

### Step 2: Stop the Clock

Record the training run end time. Calculate the total run duration. This goes into the timing metrics and the training log.

### Step 3: Invoke TRAIN-002 for Metrics Compilation

Dispatch to TRAIN-002 (Training Evaluator) with a finalization request:

```
Action: Compile training run metrics and findings
Training run: #{run_number}
End time: {current timestamp}
Total duration: {elapsed time}
```

TRAIN-002 compiles everything it captured during the run into two outputs.

The first output is training/TRAINING-METRICS.md, which receives a new metrics row for this run. The row includes all four metric categories (operational velocity, accuracy, resilience, efficiency) with the values measured during this specific run. If certain metrics couldn't be measured (e.g., persistence-survival-rate in a run that didn't include a simulated blue team check), those cells are marked "N/M" (not measured) rather than zero.

The second output is training/DEBRIEF-QUEUE.md, which receives the complete list of findings from this run. Each finding is a numbered item with the following fields:

```
### Finding #{N}

Disposition: [PROMPT-FIX | TEMPLATE-FIX | WORKFLOW-FIX | OPERATOR-TRAINING | NEEDS-TRIAGE]
Agent: {agent ID or "SYSTEM" for workflow issues}
Severity: [BLOCKING | HIGH | MEDIUM | LOW]
Category: [REFUSAL | COMMAND-ACCURACY | COORDINATION | TIMING | RECOMMENDATION-QUALITY]

Description: {what happened}
Evidence: {the specific command, refusal text, or inconsistency}
Root cause: {TRAIN-002's assessment of why this happened}
Proposed fix: {TRAIN-002's recommendation for how to address it}
```

Findings are ordered by severity within each category, with BLOCKING findings first.

### Step 4: Present the Debrief

Display the compiled findings to the operator in a readable format. For each finding, show the item number, disposition, agent, severity, and a one-line description. Group findings by disposition category so the operator can see the distribution at a glance.

Present summary statistics: total findings count, breakdown by disposition, breakdown by severity, and breakdown by agent. Highlight any agent with an unusually high finding count — that agent's prompt likely needs the most work.

Also present the key metrics from this run compared to previous runs (if any): time-to-first-own trend, commands-needing-modification trend, refusal-count trend, and coordination-file-consistency-rate trend. Improving trends confirm the training is working. Flat or worsening trends indicate the prompt calibration approach needs reassessment.

### Step 5: Operator Disposition Review

This is the interactive phase. The operator reviews each finding and can change its disposition. Common operator actions:

Confirm the disposition as-is (the majority case — TRAIN-002's pre-categorization is usually correct).

Change NEEDS-TRIAGE to a specific disposition after discussion (the operator provides the categorization that TRAIN-002 couldn't determine).

Change any finding to WONTFIX with a rationale (the operator decides this is an acceptable limitation, an environment-specific issue, or not worth fixing before competition).

Change PROMPT-FIX to OPERATOR-TRAINING or vice versa (sometimes what looks like an agent problem is actually an operator workflow issue, or vice versa).

Split a finding into multiple items (a single observation might require both a PROMPT-FIX and a TEMPLATE-FIX).

Add findings that TRAIN-002 missed (the operator noticed something during the run that TRAIN-002 didn't capture).

After the operator has reviewed all findings, ask for explicit confirmation: "Dispositions confirmed? TRAIN-003 will generate patches for all PROMPT-FIX, TEMPLATE-FIX, and WORKFLOW-FIX items." The operator must confirm before proceeding.

### Step 6: Generate Patches

After operator confirmation, invoke TRAIN-003 (Prompt Patcher) with the confirmed debrief queue:

```
Action: Generate patch file from confirmed debrief
Source: Training Run #{run_number}, Debrief {date}
Input: training/DEBRIEF-QUEUE.md (confirmed dispositions)
Output: training/patches/patch-{YYYYMMDD}-{N}.md
```

TRAIN-003 reads the confirmed findings with PROMPT-FIX, TEMPLATE-FIX, and WORKFLOW-FIX dispositions. For each finding, it reads the current version of the target file, generates the specific before/after text edit, and writes the complete patch file.

Present the generated patch file summary to the operator: how many edits, which files are affected, and a one-line description of each edit.

### Step 7: Close the Training Run

Append the debrief summary and closure to training/TRAINING-LOG.md:

```
### Debrief: {date and time}

Duration: {total run time}
Findings: {total count}
  PROMPT-FIX: {count}
  TEMPLATE-FIX: {count}
  WORKFLOW-FIX: {count}
  OPERATOR-TRAINING: {count}
  WONTFIX: {count}
  NEEDS-TRIAGE: {count remaining, should be 0}
Patch generated: training/patches/patch-{YYYYMMDD}-{N}.md
Key metrics:
  Time-to-first-own: {value}
  Targets owned at 30min: {value}
  Refusal count: {value}
  Commands modified: {value}
  Consistency rate: {value}%

Status: CLOSED
```

### Step 8: Next Steps

Inform the operator of the recommended next actions:

If the patch file contains edits: review and apply with `/apply-training training/patches/patch-{YYYYMMDD}-{N}.md`. This presents each edit for review and applies confirmed changes.

If the patch file has cross-agent edits: highlight these specifically, as they need to be applied as a set.

If the metrics show improvement over previous runs: note this as positive signal that the calibration is working.

If the metrics show stagnation or regression: flag this and suggest the operator consider whether the prompt changes are addressing the right root causes, or whether the training environment is too different from the target competition environment to produce transferable improvements.

If this was the last planned Phase 1 run: suggest the operator run /restore-competition to verify competition readiness before moving to Phase 2.

## Usage

End a training run and start the debrief:
```
/debrief
```

The command is invoked without arguments — it operates on the currently active training run from /training-run.
