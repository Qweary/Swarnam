# Burned Techniques Log — TRAINING

This is the training instance of BURNED-TECHNIQUES.md. Used during training runs instead of the competition file. Reset to template state before each training run.

Maintained by: EVADE-001 (Evasion Specialist) during training runs, monitored by TRAIN-002
Purpose: append-only log of techniques that have been detected and remediated by the blue team (or simulated remediation during training). Agents consult this log before recommending techniques to avoid repeating burned approaches on the same target.

---

## Burned Technique Log

This log is append-only. Entries are never removed or modified during a run. When a technique is burned on a target, EVADE-001 appends an entry here and PERSIST-001 / EXPLOIT-001 consult this log before recommending approaches for that target.

| Timestamp | Target IP | Technique | Category | Detection Method | Response Time | Recommended Alternative | Notes |
|-----------|-----------|-----------|----------|------------------|---------------|-------------------------|-------|
| — | — | No techniques burned yet. | — | — | — | — | — |

### Category Values

Same as PERSISTENCE-MANIFEST.md mechanism types: SCHTASK, SERVICE, WMI, REGISTRY, CRON, SSHKEY, WEBSHELL, ACCOUNT, ADS, OTHER. Additionally: CREDENTIAL (burned credential set), TOOL (specific tool detected and blocked), NETWORK (network path blocked).

### Usage Rules

When recommending a persistence mechanism or exploitation technique for a target, agents must check this log first. If a category has been burned on the target, recommend an alternative from a different category. Repeated use of the same category on the same target after a burn indicates a coordination failure.

Response Time is the elapsed time between deployment/use and detection — this metric feeds TRAIN-002's evaluation and OPS-001's timing model.
