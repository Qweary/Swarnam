# Decision Log — TRAINING

This is the training instance of DECISION-LOG.md. Used during training runs instead of the competition file. Reset to template state before each training run.

Maintained by: OPS-001 (Tactical Coordinator) during training runs, monitored by TRAIN-002
Purpose: records tactical decisions and their rationale during training exercises. Why did OPS-001 prioritize target A over target B? Why did EVADE-001 recommend waiting before re-engaging? Why did the operator override a swarm recommendation? This log captures the reasoning so it can be reviewed during the debrief.

---

## Decisions

| Timestamp | Decision Maker | Decision | Rationale | Outcome | Debrief Notes |
|-----------|----------------|----------|-----------|---------|---------------|
| 01:35 | OPS-001 | Attack order: .2 (MinIO) → .240 (SIEM) → .25 (DC) → .79/.200 (reuse DC creds) | MinIO and SIEM are near-zero-noise quick-wins with default creds. DC is highest value but takes longest; start spray + AS-REP roast in parallel while SIEM/MinIO are confirmed. DC creds unlock .79 and .200 via credential reuse — no separate spray needed. | — | — |
| 01:35 | OPS-001 | Tier 1 attack mix: WinRM spray + AS-REP roast simultaneously on DC | AS-REP roast requires no creds and runs fast. WinRM spray tests creds directly. Running both in parallel maximizes early access probability without doubling noise on a single protocol. | — | — |

### Decision Maker Values

OPS-001: tactical prioritization decisions (target ordering, phase transitions, resource allocation).
EVADE-001: evasion timing decisions (when to re-engage, when to back off).
OPERATOR: human override of swarm recommendation (document what was overridden and why).
CONSENSUS: decision reached through multiple agent inputs.

### Debrief Notes Column

Leave blank during the training run. Fill in during /debrief with hindsight assessment: was the decision correct? Would a different choice have been better? This column feeds TRAIN-002's recommendation quality assessment.
