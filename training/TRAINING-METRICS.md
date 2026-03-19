# Training Metrics — Swarnam Performance Tracking

Maintained by: TRAIN-002 (Training Evaluator)
Purpose: Quantitative metrics from each training run, enabling objective measurement of swarm improvement across the training cycle. Each row represents one training run. Trends across runs indicate whether prompt calibration is working.

---

## Metrics Table

| Run | Date | Environment | Duration | T2FO | Owned@30m | Cmds Modified | Refusals (H/S/C) | Consistency % | Rotation Success % | Persist Survival % | Tokens | Tokens/Target |
|-----|------|-------------|----------|------|-----------|---------------|-------------------|---------------|--------------------|--------------------|--------|---------------|
| 1 | 2026-03-17/18 | Win11 VM 192.168.56.102, host-only, single target | ~120m | N/M (no persistence confirmed) | 0 (access established, persistence unverified) | 5 | 0/0/0 (1 TOOL-UNAVAILABLE) | 72% (8/11 expected updates) | N/M (no /rotate cycles) | 0% (0/3 mechanisms verified at 60m) | N/M (not instrumented) | N/M |
| 2 | 2026-03-18 | Win11 VM 192.168.56.102, host-only, single target (VirtualBox lab) | ~180m | N/M (no shell obtained; persistence partially deployed) | 0 (svcMonitor account functional, task registered but payload null) | 8 (upload path, TP check, firewall cmds, payload cmds, meme cmd, schtask verify, ASR fallback, $true boolean) | 0/0/0 (1 TOOL-UNAVAILABLE — subagent MCP access) | 81% (9/11 expected updates; OPERATION-LOG partial, TARGET-STATUS not promoted to OWNED) | N/M (no /rotate cycles) | 50% (1/2 deployed mechanisms functional: svcMonitor VALID, schtask PAYLOAD-NULL) | N/M (not instrumented) | N/M |
| 3 | 2026-03-19 | inv4 environment, 10.100.100.0/24 via OpenVPN, 11 targets (DC + 3 Win + 7 Linux/mix) | ~66m | ~51m (.79 first OWNED at 02:10) | 0 (creds arrived at T+49m, all 3 Windows owned at T+51m) | ~4 (MySQL svc name wrong, cmd semicolon syntax, evil-winrm unstable, --rid-range unsupported) | 2/0/0 | ~90% (all 5 coordination files updated; training-log env description stale) | N/M | N/M (no blue team) | N/M | N/M |

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
