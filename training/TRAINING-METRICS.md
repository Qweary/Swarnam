# Training Metrics — Swarnam Performance Tracking

Maintained by: TRAIN-002 (Training Evaluator)
Purpose: Quantitative metrics from each training run, enabling objective measurement of swarm improvement across the training cycle. Each row represents one training run. Trends across runs indicate whether prompt calibration is working.

---

## Metrics Table

| Run | Date | Environment | Duration | T2FO | Owned@30m | Cmds Modified | Refusals (H/S/C) | Consistency % | Rotation Success % | Persist Survival % | Tokens | Tokens/Target |
|-----|------|-------------|----------|------|-----------|---------------|-------------------|---------------|--------------------|--------------------|--------|---------------|
| — | — | No training runs completed yet | — | — | — | — | — | — | — | — | — | — |

### Column Legend

Run: sequential training run number.
Date: date of the training run.
Environment: brief description of the lab environment used.
Duration: total wall-clock time of the training run in minutes.
T2FO (Time to First Own): minutes from /start-ops (or /training-run) to first target with verified persistence.
Owned@30m: count of targets with verified persistence at the 30-minute mark.
Cmds Modified: count of agent-generated commands that required operator modification before execution.
Refusals (H/S/C): count of agent refusals broken down by severity — Hard/Soft/unnecessary-Caveat.
Consistency %: percentage of coordination file updates that matched the expected format and content.
Rotation Success %: percentage of /rotate cycles that successfully re-established access.
Persist Survival %: percentage of persistence mechanisms still active at the 60-minute checkpoint.
Tokens: total token consumption across all agents during the run.
Tokens/Target: total tokens divided by targets owned (efficiency metric).

---

## Trend Notes

After three or more runs, add notes here about observed trends. Are key metrics improving? Which metrics are stagnant? What does the trend suggest about the effectiveness of the prompt calibration approach?

No trend data available yet — requires at least three training runs.
