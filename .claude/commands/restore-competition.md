---
description: >
  Restore the swarm to competition-ready state after training. Verifies that
  competition coordination files are clean templates, diffs current agent prompts
  against pre-training baselines to show exactly what training changed, runs
  structure validation tests, and generates a pre-competition readiness report.
  Training agents and commands remain available but are clearly non-operational.
  Run this before Phase 2, before the dress rehearsal, and before competition day.
---

## Workflow

This command ensures the swarm is clean, validated, and competition-ready. It performs four verification passes and generates a readiness report that the operator signs off on before tagging a competition release.

### Step 1: Verify Competition Coordination Files

Read each file in coordination/ (the competition directory, not training/coordination/) and verify it matches its clean template state. The competition coordination files should contain only their template headers and any pre-populated data that is part of the baseline (format documentation, legend entries, "No entries yet" placeholders).

Files to check:
- coordination/TARGET-STATUS.md — should have column headers, legend, no target entries
- coordination/RECON-FINDINGS.md — should have section headers, no scan data
- coordination/PERSISTENCE-MANIFEST.md — should have column headers, no mechanism entries
- coordination/BURNED-TECHNIQUES.md — should have header and "No techniques burned yet" entry
- coordination/OPERATION-LOG.md — should have header, no operation entries
- coordination/DECISION-LOG.md — should have column headers, no decision entries
- coordination/REFUSAL-LOG.md — should have header and "No refusals logged" entry
- coordination/CREDENTIALS.md — should have column headers, no credential entries

If any competition coordination file contains training data (entries that reference training targets, training timestamps, or training operators), flag this as a CONTAMINATION finding. The operator must review and confirm that the file should be reset to its template. Offer to re-initialize from the template.

If a competition coordination file has been intentionally modified (e.g., pre-populated with competition-specific data like target ranges received from organizers), the operator should confirm that these modifications are intentional and not training artifacts.

### Step 2: Diff Agent Prompts Against Baselines

Read each competition agent file in .claude/agents/ and compare it against the corresponding baseline in training/baselines/. The baselines were captured before training began (via the baseline snapshot process).

For each agent, produce a readable diff showing exactly what training changed. Categorize each change as:

KNOWLEDGE-ADDITION: new domain knowledge added to the agent (e.g., CCDC-specific configurations, tool syntax corrections, timing calibrations). These are the intentional improvements from training.

DECISION-FRAMEWORK-CHANGE: modifications to how the agent prioritizes, recommends, or sequences actions. These are tactical improvements from training.

AUTHORIZATION-CHANGE: any modification to authorization context. These should be rare and are flagged as HIGH-ATTENTION — authorization context should generally only be added to, not modified.

STRUCTURAL-CHANGE: modifications to the agent's section organization, handoff boundaries, or coordination file references. These may have cross-agent implications.

Present each agent's diff with the change count and categories. The operator reviews to confirm that all changes are intentional training improvements and no training-specific artifacts (environment IPs, test passwords, temporary workarounds) leaked into the competition prompts.

If baselines don't exist (the snapshot was never taken), skip this step and warn the operator that there's no baseline to diff against. Recommend running the baseline snapshot process before any further training modifications.

### Step 3: Run Structure Validation Tests

Execute the structure validation tests from the test framework (Category 1) against the current swarm state:

Test 1.1 (Project Structure Completeness): verify all expected files exist. All eight competition agents, all six competition commands, all eight coordination files, CLAUDE.md, COMPETITION-AUTHORIZATION.md, settings.json.

Test 1.2 (Agent Definition Validity): verify each agent has YAML frontmatter, required fields, authorization context, and role boundary definitions.

Test 1.3 (Command Definition Validity): verify each command has frontmatter, description, and workflow steps.

Test 1.4 (Settings.json Validity): verify valid JSON, permissions structure, critical allows, and critical denies.

Test 2.1 (Cross-Reference Integrity): verify every coordination file referenced by agents exists, and every agent references the files it should.

Report the results: total tests passed, total tests failed, and details on any failures. Any failure in these structural tests is a BLOCKING issue that must be resolved before competition.

### Step 4: Verify Training Isolation

Confirm that training infrastructure exists but does not interfere with competition operations:

The training/ directory exists and contains training-specific files. This is fine — training data is isolated.

The training agents (.claude/agents/pcap-analyst.md, .claude/agents/training-evaluator.md, .claude/agents/prompt-patcher.md) exist. This is fine — they won't be invoked during competition unless the operator explicitly calls them.

The training commands (.claude/commands/analyze-pcap.md, .claude/commands/training-run.md, .claude/commands/debrief.md, .claude/commands/apply-training.md, .claude/commands/restore-competition.md) exist. This is fine — they won't be invoked during competition operations.

No training agents are referenced by competition commands or competition agents. Verify by searching competition files for "TRAIN-001", "TRAIN-002", "TRAIN-003", "pcap-analyst", "training-evaluator", or "prompt-patcher". If any competition file references a training agent, that's a CONTAMINATION finding.

### Step 5: Generate Readiness Report

Compile all findings into a readiness report displayed to the operator:

```
SWARNAM PRE-COMPETITION READINESS REPORT
Generated: {date and time}

COORDINATION FILES
  Status: [CLEAN | CONTAMINATED]
  Details: {per-file status}

AGENT PROMPT INTEGRITY
  Agents diffed against baseline: {count}
  Total training changes: {count across all agents}
  Changes by category:
    Knowledge additions: {count}
    Decision framework changes: {count}
    Authorization changes: {count}
    Structural changes: {count}
  Baseline available: [YES | NO]

STRUCTURE VALIDATION
  Tests passed: {count}
  Tests failed: {count}
  Blocking issues: {count}

TRAINING ISOLATION
  Status: [CLEAN | CONTAMINATED]
  Details: {any cross-references found}

TRAINING SUMMARY
  Total training runs completed: {count from TRAINING-LOG}
  Total patches applied: {count from TRAINING-LOG}
  Key metric trends:
    Time-to-first-own: {first run} → {last run}
    Commands needing modification: {first run} → {last run}
    Refusal count: {first run} → {last run}

OVERALL STATUS: [READY | ISSUES FOUND]
```

If the overall status is READY (no contamination, no blocking test failures, no unauthorized changes to agent prompts), present the operator with a confirmation prompt: "Swarm is competition-ready. Tag release? (e.g., v1.0-finals)"

If the operator confirms, create a git tag with the release name. If git is not available, record the readiness confirmation in training/TRAINING-LOG.md with the timestamp and operator name.

If issues were found, list each issue with a recommended resolution and do not offer to tag a release until the issues are resolved.

## Usage

Standard competition readiness check:
```
/restore-competition
```

The command runs all five steps automatically. The operator intervenes only when contamination is found or when confirming the release tag.
