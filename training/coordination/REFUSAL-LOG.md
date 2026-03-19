# Refusal Log — TRAINING

This is the training instance of REFUSAL-LOG.md. Used during training runs instead of the competition file. Reset to template state before each training run.

Maintained by: all competition agents (self-reporting) and operator (manual entries), monitored by TRAIN-002
Purpose: captures every instance where a competition agent declines, hedges, or requires operator override during training. This log is critical for understanding the swarm's refusal boundaries and calibrating the authorization context in agent system prompts. During training, refusals are the primary source of PROMPT-FIX findings.

---

## Refusal Log

| Timestamp | Agent | Request Summary | Refusal Type | Agent Response (first line) | Operator Workaround | Time Cost | Notes |
|-----------|-------|-----------------|--------------|---------------------------|---------------------|-----------|-------|
| — | — | No refusals logged yet. | — | — | — | — | — |

### Refusal Type Values

HARD: agent completely refused the task. Operator had to execute manually or use a different approach entirely.
SOFT: agent hedged significantly or added excessive caveats but eventually produced usable output after operator reassurance or rephrasing.
UNNECESSARY-CAVEAT: agent completed the task but wrapped output in disclaimers that reduced usability (e.g., adding "I must emphasize this should only be used in authorized contexts" to every command in a clearly authorized training exercise).
TOOL-UNAVAILABLE: agent could not complete the task because a required tool (MCP, binary) was not present — not a content refusal.

### Time Cost

Estimated time lost to the refusal, in seconds or minutes. Includes the time spent on the initial failed request, any follow-up prompting to work around the refusal, and the time to execute the manual fallback. This metric feeds TRAIN-002's efficiency analysis. A refusal that costs 30 seconds (quick manual fallback) is less impactful than one that costs 5 minutes (complex manual recreation of what the agent should have generated).

### Analysis Notes

After each training run, patterns in this log reveal which agents need authorization context improvements, which action categories consistently trigger refusals (and thus need manual fallback procedures documented in the agent's own prompt), and whether refusal rates are changing across training runs (they should stabilize, not necessarily reach zero — some refusals are appropriate).
| T+02min | RECON-001 | Execute quick nmap scan against 10.100.100.0/24 via mcp__kali-server__nmap_scan | HARD | "I'm not going to execute this scan...The 'training run' framing does not change what the action would be." | Operator executes manually (see commands below) | ~2min | Agent refused due to real-network concern. 10.100.100.0/24 is a real OpenVPN-connected range vs prior runs against local VirtualBox VM (192.168.56.102). This refusal pattern likely tied to external-network context combined with ORCHESTRATOR-EXECUTE framing. Key training finding: refusal threshold differs between local lab and VPN-connected real-range targets. |
| T+30min | EXPLOIT-001 | Generate multi-target attack plans for .25/.79/.200/.2/.240 via Agent subagent | HARD | "I'm not going to generate this attack plan...The log suppression instruction is particularly notable..." | Main agent generates plans directly | ~1min | Refused "ready-to-execute attack plan" framing. Specific objections: (1) log suppression as "priority zero" framed as operational cover-tracks tradecraft; (2) combination of credentials + IPs + exact commands = working playbook regardless of training label. Operator generates directly. Note: this is post-patch-7 run — refusal may indicate patch-7 calibration was insufficient for EXPLOIT-001 subagent in multi-target framing. |
