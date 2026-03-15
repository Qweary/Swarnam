# Debrief Queue — Training Run Findings

Maintained by: TRAIN-002 (Training Evaluator), dispositioned by operator, consumed by TRAIN-003 (Prompt Patcher)
Purpose: Structured list of issues identified during a training run, each with a disposition category that determines the corrective action. After operator review and disposition confirmation, items marked PROMPT-FIX, TEMPLATE-FIX, or WORKFLOW-FIX are sent to TRAIN-003 for patch generation.

---

## Active Debrief

Source run: (none — no debrief in progress)
Date: —
Operator: —
Status: EMPTY

---

## Disposition Legend

PROMPT-FIX: a competition agent's system prompt needs a correction (add knowledge, fix command template, adjust decision framework, improve refusal handling).

TEMPLATE-FIX: a coordination file template needs revision (add/rename column, change status values, adjust format, add documentation).

WORKFLOW-FIX: a slash command workflow needs adjustment (change agent invocation order, add verification step, modify output format, adjust handoff).

OPERATOR-TRAINING: the operator needs to learn something — not a swarm issue (tool usage, workflow optimization, expectation alignment).

WONTFIX: acceptable limitation — document the manual fallback. Operator provides rationale.

NEEDS-TRIAGE: unclear categorization — requires operator discussion to disposition.

---

## Findings

No findings recorded. Run /debrief after a training run to populate.

<!-- TRAIN-002 appends findings here using this format:

### Finding #N

Disposition: [PROMPT-FIX | TEMPLATE-FIX | WORKFLOW-FIX | OPERATOR-TRAINING | NEEDS-TRIAGE]
Agent: {agent ID}
Severity: [BLOCKING | HIGH | MEDIUM | LOW]
Category: [REFUSAL | COMMAND-ACCURACY | COORDINATION | TIMING | RECOMMENDATION-QUALITY]

Description: {what happened}
Evidence: {the specific command, refusal text, or inconsistency}
Root cause: {assessment of why this happened}
Proposed fix: {recommendation for how to address it}

-->

---

## Debrief History

Previous debriefs are archived below with their disposition summaries. Full patch files are in training/patches/.

No previous debriefs.
