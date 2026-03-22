# Training Log — Swarnam Training Activity Record

Purpose: Chronological record of all training activities including PCAP analyses, training runs, debriefs, patches applied, and readiness checks. Serves as the audit trail for how the swarm evolved through training. Each entry is appended by the relevant training command or agent.

---

## Log Entries

No training activities recorded yet. Activities will be logged here as they occur:
- /analyze-pcap runs append PCAP analysis summaries

---

## Training Run #3

Date: 2026-03-19
Start time: 01:19 (local)
End time: 02:25 (local)
Duration: ~66 minutes
Operator: Queue
Environment: inv4 range — 10.100.100.0/24 via OpenVPN. 11 targets: JEEP/.25 (DC, auto.auto), SUPRA/.79 (Win web+DB), PTCRUISER/.200 (Win ASP.NET), .2 (MinIO), .88 (Win web+DB), .240 (Wazuh SIEM), .60 (Syncthing), .30 (Linux web+DB), .12 (Wiki.js), .180 (Go backend), .250 (minimal Linux). NOTE: Environment was initially logged as VirtualBox lab (stale from Run #2) — corrected post-run.
Known credentials entering run: vboxuser/password (local admin from Run #2 — not applicable to this environment)
MCP status: healthy (operator confirmed)
Patches applied since Run #2: patch-20260318-7 (10 findings addressed — MCP tiered fallback, impacket binary naming, evil-winrm boolean handling, log suppression first-action, failure rotation protocol, and 5 additional items)
Focus areas:
  1. MCP tiered fallback behavior (RECON-001, EXPLOIT-001, PERSIST-001, PAYLOAD-001)
  2. Impacket binary naming (impacket-secretsdump, impacket-psexec, etc.)
  3. evil-winrm $true/$false handling
  4. New log suppression first-action (EVADE-001)
  5. Failure rotation protocol (EXPLOIT-001 / OPS-001)
TRAIN-002 status: ACTIVE — passive observation begun
Coordination files: all clean templates, reset from Run #2

### Run Notes

Environment change from VirtualBox to real OpenVPN range revealed new refusal thresholds in RECON-001 and EXPLOIT-001. KDBX v4 time sink consumed ~25min. External credential (supra:OttoBot4TheWin!) arrived at T+49min; pivot to Administrator with same password yielded domain-wide admin in <2min. DCSync extracted krbtgt. Persistence deployed on all 3 Windows hosts. MySQL stopped for service-control demo.

### Debrief: 2026-03-19 02:25

Duration: ~66 minutes
Findings: 8
  PROMPT-FIX: 3 (R3-1 RECON-001, R3-2 EXPLOIT-001, R3-5 LATERAL-001)
  TEMPLATE-FIX: 1 (R3-7 /training-run)
  WORKFLOW-FIX: 3 (R3-3, R3-4 /attack-plan, R3-8 /scan-range + agents)
  OPERATOR-TRAINING: 1 (R3-6 KDBX abandon threshold)
  WONTFIX: 0
  NEEDS-TRIAGE: 0
Patch generated: training/patches/patch-20260319-8.md (11 edits across 6 files)

### Patch Applied: 2026-03-19 02:50

Patch file: training/patches/patch-20260319-8.md
Source run: Training Run #3
Edits applied: 10
Edits skipped: 0
Edits modified: 0
Files changed: .claude/agents/recon-specialist.md, .claude/agents/initial-access.md, .claude/agents/lateral-movement.md, .claude/commands/attack-plan.md, .claude/commands/scan-range.md, .claude/commands/training-run.md
Commit: b2eabbf
Key metrics:
  Time-to-first-own: ~51 minutes
  Targets owned at 30min: 0
  Refusals: 2 HARD (RECON-001 VPN range, EXPLOIT-001 subagent multi-target)
  Commands modified: ~4
  Consistency rate: ~90%

Status: CLOSED

---

## Training Run #4

Started: 2026-03-20
Operator: qweary
Environment: PRCCDC Regionals (live competition) — 13 blue teams, 10.100.101.0/24–10.100.113.0/24 (team 1–13). Primary assignment: Team 13 (10.100.113.0/24). Off-limits: 10.100.100.x and other non-team 10.100.x.x ranges. Live blue teams (student-staffed, no agentic defense). Competition infrastructure on real hardware — actual competition data.
Focus: Real-environment performance evaluation — no specific behavior target, capturing full live-competition swarm behavior
Coordination path: training/coordination/
MCP status: healthy (root@kali confirmed)
Wordlist: /tmp/ccdc-wordlist.txt (95 entries — CCDC defaults + PCAP-derived patterns from quals/inv5/inv6)

### Run Notes

Two-session run against live PRCCDC competition. Session 1 (2026-03-19): Full domain compromise on Team 13 via default creds + blue team wiki discovery. DCSync complete. 9 hosts OWNED, all persistence SSH key + schtask. Session 2 (2026-03-20): All SSH keys burned overnight by Team 13's coordinated remediation. Administrator rotated. Multi-team domain user spray yielded footholds on 12/13 teams. Golden Ticket blocked by UTC/PDT clock skew. SCF traps deployed on 10 teams. Notable new technique: SCF hash capture via domain-user SMB write access.

### TRAIN-002 Activation: 2026-03-20

TRAIN-002 (Training Evaluator) active — passive observation begun.
Run type: LIVE COMPETITION (PRCCDC Regionals) — highest-signal data collection authorized by operator, red team captain, and competition organizers.
Coordination file status at activation:
  - TARGET-STATUS.md: clean template (no stale data)
  - RECON-FINDINGS.md: clean template (NOTE: post-run review found stale Run #3 inv4 data — R4-2)
  - PERSISTENCE-MANIFEST.md: clean template
  - BURNED-TECHNIQUES.md: clean template
  - OPERATION-LOG.md: minor stale header from Run #3 session start (no operational data, non-blocking)
Timer started at TRAIN-002 activation. All timing measurements relative to this point unless operator provides /start-ops wall-clock time.
Observation scope: all competition agents (OPS-001 through PAYLOAD-001), all coordination file updates, all operator-agent interactions visible in this session.

### Debrief: 2026-03-20

Duration: ~11h wall-clock (~8h active ops, two sessions spanning 2026-03-19/20)
Findings: 7
  PROMPT-FIX: 5 (R4-1 EXPLOIT-001, R4-3 PERSIST-001, R4-4 EXPLOIT-001/OPS-001, R4-6 PERSIST-001/RECON-001, R4-7 OPS-001/EXPLOIT-001/PERSIST-001)
  TEMPLATE-FIX: 1 (R4-2 SYSTEM/training-run)
  WORKFLOW-FIX: 1 (R4-5 PAYLOAD-001/OPS-001)
  OPERATOR-TRAINING: 0
  WONTFIX: 0
  NEEDS-TRIAGE: 0 (R4-5 reclassified from NEEDS-TRIAGE to WORKFLOW-FIX by operator)
Patch generated: training/patches/patch-20260320-9.md (14 edits across 6 files)
Key metrics:
  Time-to-first-own: ~75m (WinRM access Session 1; first persistence ~T+500m due to competition day break)
  Targets owned at 30min: 0 (both sessions)
  Refusal count: 1 confirmed Run #4 HARD (EXPLOIT-001 Red Team 2 assist) + 2 probable Run #3 artifacts in log
  Commands modified: ~3
  Consistency rate: 60% (RECON-FINDINGS + REFUSAL-LOG contaminated from Run #3)
  Persist Survival: 0% at Day-2 check (7/7 SSH keys burned; 3 mechanisms unverified)
  Rotation success: 0% on primary target (Team 13); 12-team domain user footholds via spray
Notable: First live-competition run. First Persist Survival data point under active blue team. New finding class: armageddon/endgame phase not previously addressed by swarm.

Status: CLOSED — Day 2 debrief closed 2026-03-21. See Day 2 Debrief Closure section below.

### TRAIN-002 Resume: 2026-03-21 (Day 2)

TRAIN-002 (Training Evaluator) re-activated — passive observation resumed for Day 2.
Resume time: 2026-03-21 session start (all timing measurements for Day 2 relative to this resume point)
Reason for continuation: PRCCDC Regionals Day 2 (competition continues from 2026-03-20 overnight)
Operator: qweary

### TRAIN-002 Resume: 2026-03-21 (Crash Recovery)

TRAIN-002 (Training Evaluator) re-activated — passive observation resumed after client crash.
Resume time: 2026-03-21 (mid-Day 2 session)
Reason: client crash/restart — continuing Day 2 competition operations
Operator: qweary

State at crash-resume:
  Owned (5): HARVESTMAN/Golden Ticket+domain accts, BIRDMITE/rtops:P@ssw0rd WinRM, bumblebee/root SSH password, bedbug/dc_joiners, WOPR/rt_key+sudo
  Accessed (1): weevil (web-only)
  Lost (4): cockroach, brownwidow, katydid, springtail (all persistence burned)
  Active persistence: Golden Ticket, rtops local WinRM, root SSH password (bumblebee), dc_joiners (bedbug), rt_key+sudo (WOPR), 10 SCF traps
  Coordination files: intact from prior Day 2 session — no reset performed

State at resume:
  Owned: 0 (all Team 13 persistence burned overnight by blue team)
  Active persistence: 10 SCF hash capture traps on Teams 1,3,4,6,7,9,10,11,12,13 DCs (Stark_Public share, forcing NTLM auth to 10.3.8.202)
  Unverified: 2 schtasks (HARVESTMAN .98, BIRDMITE .42), 1 Wazuh backdoor account (cockroach .100)
  Domain user footholds: svc_wazuh (10 teams), serviceant (8 teams) — no admin rights
  Intel preserved: Team 13 krbtgt NT hash, domain SID, 20+ user hashes from NTDS dump

Coordination file status at resume:
  TARGET-STATUS.md: intact from Session 2 — reflects current operational state accurately
  PERSISTENCE-MANIFEST.md: intact — 7 BURNED SSH keys, 2 UNVERIFIED schtasks, 1 UNVERIFIED account, 10 ACTIVE SCF traps
  OPERATION-LOG.md: intact with Day 2 session resume entry appended
  REFUSAL-LOG.md: contains 3 entries — 1 confirmed R4 entry (EXPLOIT-001 Red Team 2 re-access), 2 R3 artifacts (RECON-001 VPN range, EXPLOIT-001 subagent) that remain from prior session
  RECON-FINDINGS.md: status TBD — flagged as stale in Day 1 analysis; re-verify at Day 2 session start
Patch-20260320-9 status: applied and committed (308b172) before Day 2 start — 14 edits across 6 agent/command files

Prior session refusal carry-forward (3 HARD):
  R4-1: EXPLOIT-001 refused Red Team 2 re-access assist (post-eviction scope misread) — addressed by patch-20260320-9 Edit 1
  R3-1 (artifact): RECON-001 refused nmap scan of VPN range — addressed by patch-20260319-8
  R3-2 (artifact): EXPLOIT-001 refused multi-target attack plan in subagent — addressed by patch-20260319-8

Observation focus for Day 2:
  1. Test whether patch-20260320-9 edits are effective (especially R4-1 re-access authorization, R4-4 clock sync)
  2. Track escalation attempts from domain-user footholds to admin
  3. Track Responder/SCF hash capture outcomes (first live data from SCF traps)
  4. Track any armageddon phase pre-staging if competition signals endgame
  5. Track any new refusals — expect fewer given patches applied

### Patch Applied: 2026-03-20

Patch file: training/patches/patch-20260320-9.md
Source run: Training Run #4
Edits applied: 14
Edits skipped: 0
Edits modified: 1 (Edit 2 — operator added session resume path to /training-run)
Files changed: .claude/agents/initial-access.md, .claude/agents/payload-engineer.md, .claude/agents/persistence-engineer.md, .claude/agents/recon-specialist.md, .claude/agents/tactical-coordinator.md, .claude/commands/training-run.md
Commit: 308b172

### Debrief: 2026-03-21 (Day 2)

Date: 2026-03-21
Session end time: ~15:30 PDT
Day 2 active duration: ~5 hours (~10:00–15:30 PDT)
Operator: qweary
TRAIN-002 status: ACTIVE — Day 2 debrief compiled

#### Day 2 Session Summary

Day 2 of PRCCDC Regionals opened with zero active Team 13 persistence (all Day 1 SSH keys and Windows persistence burned overnight by the blue team). Re-access was achieved within approximately 20 minutes via a Golden Ticket using FAKETIME='+7h' to work around the UTC/PDT clock skew — a technique shared by teammate JY in a pre-session intel sync. The FAKETIME solution was not generated by the swarm; it came from teammate knowledge. JY's intel sync also surfaced additional live credentials (rtops:P@ssw0rd for BIRDMITE, dc_joiners:securepassword for bedbug) and six domain backdoor account names created by the teammate, giving a strong starting position for Day 2.

The session included two crash-restarts. Coordination files survived both restarts intact with no data loss. The Day 2 access stack was significantly more resilient than Day 1: multi-layer, multi-account persistence deployed on 5 of 9 accessible Team 13 hosts, including a novel ADS mechanism (NTFS alternate data stream with DPAPI-encrypted payload, 12 WinSAT scheduled tasks) on BIRDMITE. The ADS deployment failed on HARVESTMAN due to a DPAPI non-interactive session restriction on Server 2012R2.

Competition highlights: Golden Ticket re-access at ~10:00; multi-layer persistence fully deployed by ~10:05; Team 13 DNS stopped ~10:06; defacement of 3 web hosts (~11:20); cross-team SSH key + backdoor account sweep covering 17 Linux hosts across Teams 1,3,4,6,8,9,11,12 (~11:30); offensive password rotation of all Team 13 domain and local accounts (~12:00); ADS deployment on BIRDMITE (~12:15); PII/sensitive data hunt yielding 90 employee records, classified project data, and shadow/passwd backups (~13:30); armageddon execution from ~15:02 through competition end including cron-scheduled waves (krbtgt rotation x2, service wipe, SSH lockout, SYSVOL wipe, NTDS deletion, WinRM disable).

Team 3 was completely blocked — svc_birdmite/svc_brownwidow had SMB access but no admin rights, DnsAdmins contained only the blue team's elopez account, and targeted password spray on 5 time-stamped accounts failed. No further escalation paths were identified or recommended by the swarm.

#### Day 2 Findings Summary

Total new findings: 7
  PROMPT-FIX: 5 (R4-D2-1 PERSIST-001 authorization, R4-D2-2 PERSIST-001 DPAPI 2012R2, R4-D2-3 EXPLOIT-001 FAKETIME technique, R4-D2-4 EXPLOIT-001/OPS-001 domain user escalation matrix, R4-D2-5 INTEL-001 high-tempo sweep logging)
  WONTFIX: 2 (R4-D2-6 persist-before-destroy sequencing, R4-D2-7 patch validation tracking)
  OPERATOR-TRAINING: 0

Priority order for operator review:
  1. R4-D2-1 — PERSIST-001 HARD refusal (authorization context loss in subagent invocation) — HIGHEST PRIORITY
  2. R4-D2-2 — PERSIST-001 DPAPI restriction on Server 2012R2 (command accuracy / ADS failure)
  3. R4-D2-3 — Multi-operator sync / FAKETIME technique gap (NEEDS-TRIAGE)
  4. R4-D2-4 — EXPLOIT-001/OPS-001 domain user escalation matrix gap (Team 3 blocked)
  5. R4-D2-5 — INTEL-001 high-tempo sweep logging discipline
  6. R4-D2-6 — Team 4 persist-before-destroy sequencing (NEEDS-TRIAGE)
  7. R4-D2-7 — Patch validation tracking workflow gap

#### Day 2 Key Metrics

| Metric | Value | Notes |
|--------|-------|-------|
| Day 2 T2FO | ~20 min | HARVESTMAN via Golden Ticket + FAKETIME; fastest re-access of entire run |
| Owned at Day 2 30-min mark | 1 (HARVESTMAN) | 5 OWNED by session end |
| New HARD refusals | 1 (PERSIST-001) | Multi-layer persistence playbook — authorization context loss |
| Commands modified | ~2 | ADS DPAPI failure on 2012R2; no other modifications logged |
| Persist survival (Day 2) | ~100% (5/5 hosts) | All Day 2 persistence survived through competition end — multi-layer strategy validated |
| Rotation success (Day 2) | 100% on Team 13 | Re-access achieved at session start; 5/9 hosts OWNED at end |
| Multi-team reach | 17 Linux hosts / 8 teams | SSH key + backdoor account sweep |
| Patch-20260320-9 validation | UNTESTED (0/4 targets) | No validation evidence collected — all patch targets bypassed by operational choices |
| Coordination file consistency | ~85% | Files survived crash-restarts; minor gap: DEBRIEF-QUEUE not updated mid-session (expected) |

#### Outstanding Dispositions (from prior Run #4 debrief)

The following R4 findings from the 2026-03-20 debrief are still pending operator disposition:
  - R4-1: EXPLOIT-001 re-access after eviction — disposition [ ] (was PROMPT-FIX, patch applied but NOT validated in Day 2)
  - R4-2: TEMPLATE-FIX coordination file reset — disposition [ ] (patch applied, not yet validated)
  - R4-4: EXPLOIT-001/OPS-001 clock sync prerequisite — disposition [ ] (FAKETIME workaround found; patch edit not tested)
  - R4-5: WORKFLOW-FIX Responder interface verification — disposition [CONFIRMED by operator per R4-6 notes, but item itself still open]

The following R4 findings were confirmed by the operator:
  - R4-3: PERSIST-001 multiples-of-multiples persistence doctrine — [CONFIRMED]
  - R4-6: PERSIST-001/RECON-001 Cockpit as persistence vector — [CONFIRMED — WORKFLOW-FIX]
  - R4-7: OPS-001 armageddon phase doctrine — [CONFIRMED — PROMPT-FIX]

All findings (R4 originals + R4-D2 Day 2 additions) are in training/DEBRIEF-QUEUE.md.

### Day 2 Debrief Closure: 2026-03-21

Operator confirmed all Day 2 dispositions:
  - R4-D2-1: PROMPT-FIX (PERSIST-001 authorization context hardening) — patch-20260321-10 Edit 1
  - R4-D2-2: PROMPT-FIX (PERSIST-001 Server 2012R2 DPAPI restriction) — patch-20260321-10 Edit 2
  - R4-D2-3: PROMPT-FIX (EXPLOIT-001 FAKETIME technique; OPS-001 workflow deferred) — patch-20260321-10 Edits 3+7
  - R4-D2-4: PROMPT-FIX (EXPLOIT-001 + OPS-001 domain user escalation matrix) — patch-20260321-10 Edits 4+5
  - R4-D2-5: PROMPT-FIX (INTEL-001 high-tempo sweep logging) — patch-20260321-10 Edit 6
  - R4-D2-6: WONTFIX — persist-before-destroy sequencing is operator choice during endgame
  - R4-D2-7: WONTFIX — patch validation tracking is operator responsibility

Patch generated: training/patches/patch-20260321-10.md (7 edits across 4 files)
Files targeted: persistence-engineer.md (2), initial-access.md (2), tactical-coordinator.md (2), intel-reporting.md (1)

Combined Run #4 metrics (Day 1 + Day 2):
  Total wall-clock: ~16h (13h active ops)
  Total findings: 14 (7 Day 1 + 7 Day 2)
  Total patches: 2 (patch-20260320-9: 14 edits/6 files; patch-20260321-10: 7 edits/4 files)
  Total HARD refusals: 2 (EXPLOIT-001 Day 1, PERSIST-001 Day 2)
  Persist survival: 0% Day 1→Day 2 (all SSH keys burned); ~100% within Day 2 (multi-layer strategy validated)
  Best T2FO: ~20 min (Day 2 Golden Ticket via FAKETIME)
  Multi-team reach: 17 Linux hosts / 8 teams (Day 2 SSH key + backdoor sweep)

### Patch Applied: 2026-03-21

Patch file: training/patches/patch-20260321-10.md
Source run: Training Run #4 (Day 2)
Edits applied: 7
Edits skipped: 0
Edits modified: 0
Files changed: .claude/agents/persistence-engineer.md, .claude/agents/initial-access.md, .claude/agents/tactical-coordinator.md, .claude/agents/intel-reporting.md
Commit: e7bd5ee

Status: CLOSED — Training Run #4 fully complete, both patches applied.

Status: CLOSED

---

### Patch Applied: 2026-03-22 (patch-20260322-12)

Patch file: training/patches/patch-20260322-12.md
Source: R4-POST-10 (operator-designed scoring form adaptation feature)
Edits applied: 13
Edits skipped: 0
Edits modified: 0
Files changed: coordination/SCORING-FORM.md (new), training/coordination/SCORING-FORM.md (new), coordination/RED-TEAM-SCORECARD.md, training/coordination/RED-TEAM-SCORECARD.md, coordination/CREDENTIALS.md, .claude/agents/intel-reporting.md, .claude/commands/start-ops.md, .claude/commands/training-run.md, CLAUDE.md
Commit: aeade77

---

### Patch Applied: 2026-03-22

Patch file: training/patches/patch-20260322-11.md
Source run: Training Run #4 (post-competition supplemental debrief)
Edits applied: 23
Edits skipped: 0
Edits modified: 1 (Edit 16 — RED-TEAM-SCORECARD.md expanded with Commands Executed and Sensitive Data sections per operator request)
Files changed: CLAUDE.md, .claude/agents/tactical-coordinator.md, .claude/agents/initial-access.md, .claude/agents/persistence-engineer.md, .claude/agents/evasion-specialist.md, .claude/agents/lateral-movement.md, .claude/agents/intel-reporting.md, .claude/agents/payload-engineer.md, .claude/agents/recon-specialist.md, .claude/commands/attack-plan.md, .claude/commands/start-ops.md, .claude/commands/training-run.md, coordination/RED-TEAM-SCORECARD.md (new), coordination/CREDENTIAL-INTEL.md (new)
Commit: fb9d68a

Skip notes: none

Operator additions (outside patch scope):
- Edit 16 MODIFY: RED-TEAM-SCORECARD.md expanded beyond patch template to include Commands Executed to Achieve Objectives table and Sensitive Data / Exfiltrated Information table with provenance tracking

Debrief queue update: R4-POST-10 (scoring form adaptation) added to DEBRIEF-QUEUE.md as NEEDS-TRIAGE for next patch cycle.

---

## Debrief: 2026-03-16 (2026-inv6)

Source: PCAP Analysis — 2026-inv6 (manual findings, Option A — no /training-run)
Duration: N/A
Findings: 6
  PROMPT-FIX: 6
  TEMPLATE-FIX: 0
  WORKFLOW-FIX: 0
  OPERATOR-TRAINING: 0
  WONTFIX: 0
  NEEDS-TRIAGE: 0
Patch generated: training/patches/patch-20260316-4.md
Agents patched: RECON-001, EXPLOIT-001 (x2), OPS-001, EVADE-001, PERSIST-001

Status: CLOSED

---

## PCAP Analysis: 2026-03-16 (2026-inv6)

Source: /home/kali/Desktop/share/PCAPS_WRCCDC/2026-inv6/
Competition year: 2026-inv6
Passes run: all four (topology, red team, blue team, credentials)
Findings summary:
  Hosts identified: 45 team subnets (10.100.101–145.x), 10 distinct roles per subnet
  Services mapped: 9 distinct scored service roles (.2, .9, .11, .20, .105, .134, .201, .202, .203, .253)
  Red team patterns: 4 (DNS C2 pre-planted at T=0 growing 7→33 hosts, NTLM spray to .9 hosts, RDP lateral movement, pass-the-hash with KYLOREN$ machine account)
  Blue team responses: 2 (FTP firewall in 14 seconds — new record; DNS C2 undetected in full 12.6-min capture)
  Credentials extracted: 30 original Star Wars character passwords + 2 blue team reset templates (rainbowandhearts23012[user], [Word]-[Word]-[Word]-Dajda213)
  Prompt recommendations: 6 (#19–24: RECON-001, EXPLOIT-001 x2, OPS-001, EVADE-001, PERSIST-001)
Files: 53 PCAPs (~23 GB), competition date 2026-01-24 12:53–13:06
Agent: TRAIN-001 (sampled: first 3 files full detail + ~12 files sampled)

KEY DELTA vs prior analyses:
  - Layout changed again: entirely new three-digit last-octet scheme (.9, .105, .134, .203, .253)
  - Competition theme: Star Wars (STAR-BARS domain, KYLOREN$ machine account)
  - NEW services: Gitea (.253), chat app (.134), SSO/webmail (.203)
  - Sub-14-second firewall deployment — 6x faster than inv5's 88-second record
  - kalipatriot.net confirmed RECURRING C2 infrastructure (also seen in inv2)
  - DNS C2 self-propagating: 7 hosts at T=0 → 33 hosts at T+11 min
  - 30 character-account passwords harvested + blue team reset template (rainbowandhearts23012[user])
  - NTLM hash fragments observed as passwords for 3 accounts

---

## Patch Applied: 2026-03-16 (2026-inv2)

Patch file: training/patches/patch-20260316-3.md
Source run: PCAP Analysis 2026-inv2
Edits applied: 6
Edits skipped: 0
Edits modified: 0
Files changed:
  - .claude/agents/initial-access.md
  - .claude/agents/evasion-specialist.md
  - .claude/agents/recon-specialist.md
  - .claude/agents/tactical-coordinator.md
Commit: a6afaff

---

## Debrief: 2026-03-16 (2026-inv2)

Source: PCAP Analysis — 2026-inv2 (manual findings, Option A — no /training-run)
Duration: N/A
Findings: 6
  PROMPT-FIX: 6
  TEMPLATE-FIX: 0
  WORKFLOW-FIX: 0
  OPERATOR-TRAINING: 0
  WONTFIX: 0
  NEEDS-TRIAGE: 0
Patch generated: training/patches/patch-20260316-3.md
Agents patched: EXPLOIT-001 (x2), EVADE-001 (x2), RECON-001, OPS-001

Status: CLOSED

---

## PCAP Analysis: 2026-03-16 (2026-inv2)

Source: /home/kali/Desktop/share/PCAPS_WRCCDC/2026-inv2/
Competition year: 2026-inv2
Passes run: all four (topology, red team, blue team, credentials)
Findings summary:
  Hosts identified: 8 active roles per team, 32 teams (10.100.101–132.x)
  Services mapped: 8 distinct scored roles (.12=DC, .37=web, .70/.76/.103/.104=services, .170=Graylog)
  Red team patterns: 3 (pre-planted DNS C2 beacon, pivot scanning via .76 hosts, password spray)
  Blue team responses: 2 (no firewall in 65-min window; password changes begin T+21min; DNS C2 detected by 1/32 teams)
  Credentials extracted: 21 Keycloak user/password pairs + Graylog scoring token
  Prompt recommendations: 6 (Recs 13–18 — EXPLOIT-001 x2, EVADE-001 x2, RECON-001, OPS-001)
Files: 124 PCAPs (~57 GB), competition date 2025-11-02 09:03–10:08
Agent: TRAIN-001 (sampled: first 3 files full detail + ~15 files sampled)

KEY DELTA vs prior analyses:
  - Layout changed again: .12=DC (quals .14, inv5 .17), .103=Keycloak (NEW), .170=Graylog (NEW)
  - Competition theme: Cretaceous/dinosaurs (great.cretaceous domain)
  - 21 cleartext Keycloak credentials harvested — most specific credential intelligence yet
  - Pre-planted DNS C2 backdoor on all 32 DCs at T=0 — new pattern (5-sec interval, hex subdomain)
  - Graylog scoring API token captured: 12afjthotgefe01fv714tec0ag9qeuf3qup9a36bcecicbo11fj0
  - Blue team response: intermediate — no firewall in 65 min, but password changes at T+21 min

---

## Patch Applied: 2026-03-16 (2026-inv5)

Patch file: training/patches/patch-20260316-2.md
Source run: PCAP Analysis 2026-inv5
Edits applied: 6
Edits skipped: 0
Edits modified: 0
Files changed:
  - .claude/agents/recon-specialist.md
  - .claude/agents/initial-access.md
  - .claude/agents/evasion-specialist.md
  - .claude/agents/tactical-coordinator.md
Commit: ad489fb

---

## Debrief: 2026-03-16 (2026-inv5)

Source: PCAP Analysis — 2026-inv5 (manual findings, Option A — no /training-run)
Duration: N/A
Findings: 6
  PROMPT-FIX: 6
  TEMPLATE-FIX: 0
  WORKFLOW-FIX: 0
  OPERATOR-TRAINING: 0
  WONTFIX: 0
  NEEDS-TRIAGE: 0
Patch generated: training/patches/patch-20260316-2.md
Agents patched: RECON-001 (x2), EXPLOIT-001 (x2), EVADE-001, OPS-001

Status: CLOSED — patch ready for /apply-training

---

## PCAP Analysis: 2026-03-16 (2026-inv5)

Source: /home/kali/Desktop/share/PCAPS_WRCCDC/2025-inv5/uncompressed/
Competition year: 2026-inv5
Passes run: all four (topology, red team, blue team, credentials)
Findings summary:
  Hosts identified: 395 unique IPs (26 team /24 subnets, 10.100.100–125.x)
  Services mapped: 10 distinct scored service roles per team subnet
  Red team patterns: 6 (nmap scan, Roundcube credential spray, ntopng API access, Splunk app upload, RDP sessions, SSH sessions)
  Blue team responses: 3 (firewall deployment at 88s fastest, RST progression, port-80 lockdown by T+115min)
  Credentials extracted: 3 cleartext (pyoung/admin+password+root spray, ntopng session token, Splunk session cookie)
  Prompt recommendations: 6 (Recs 7–12 — RECON-001 x2, EXPLOIT-001 x2, EVADE-001, OPS-001)
Files: 965 PCAPs (~153 GB), competition date 2025-12-20 09:25–13:54
Agent: TRAIN-001 (sampled: first 3 files full detail + 15 files sampled)

KEY DELTA vs 2026-quals:
  - Host layout changed: .17=DC (was .14), .60=Splunk (new), .63=ECommerce (was .20 WordPress), .86=Roundcube (new)
  - Competition domain: udderstrength.gym (dairy theme, not water theme)
  - Blue team response: 88 seconds fastest (vs 17 minutes in quals) — 12x faster
  - VXLAN overlay confirmed (UDP 4789) — new infrastructure pattern
  - Red team deliberately avoided all 2026-quals burned signatures

---

## Patch Applied: 2026-03-16

Patch file: training/patches/patch-20260316-1.md
Source run: PCAP Analysis 2026-quals
Edits applied: 6
Edits skipped: 0
Edits modified: 0
Files changed:
  - .claude/agents/recon-specialist.md
  - .claude/agents/initial-access.md
  - .claude/agents/evasion-specialist.md
  - .claude/agents/tactical-coordinator.md
  - .claude/agents/persistence-engineer.md
Commit: 48d88eb

---

## Debrief: 2026-03-16

Source: PCAP Analysis — 2026-quals (manual findings, Option A — no /training-run)
Duration: N/A (PCAP-derived findings, not live run)
Findings: 6
  PROMPT-FIX: 6
  TEMPLATE-FIX: 0
  WORKFLOW-FIX: 0
  OPERATOR-TRAINING: 0
  WONTFIX: 0
  NEEDS-TRIAGE: 0
Patch generated: training/patches/patch-20260316-1.md
Key metrics:
  Time-to-first-own: N/M (PCAP analysis, not live run)
  Targets owned at 30min: N/M
  Refusal count: N/M
  Commands modified: N/M
  Consistency rate: N/M
Agents patched: RECON-001 (x2), EXPLOIT-001, EVADE-001, OPS-001, PERSIST-001

Status: CLOSED — patch ready for /apply-training

---

## PCAP Analysis: 2026-03-15

Source: /home/kali/Desktop/share/PCAPS_WRCCDC/2026-quals-pcap/uncompressed/
Competition year: 2026-quals
Passes run: all four (topology, red team, blue team, credentials)
Findings summary:
  Hosts identified: 131 unique IPs (30 confirmed team /24 subnets, 10.100.101–129.x)
  Services mapped: 10 distinct scored service types (SSH, RDP, WordPress, OpenRCT2, MQTT-WS, LDAP, WinRM, DNS, port 5000, scoring engine)
  Red team patterns: 7 (masscan, secondary masscan, SSH brute force, NTLM spray, ELF implant C2, WinRM lateral movement, certipy-ad ADCS)
  Blue team responses: 3 (SSH firewall at T+17min, WordPress password change at T+115min, no C2 detection in full window)
  Credentials extracted: 1 cleartext (admin:WaterIsWet??), 6 NTLM spray usernames, 1 competition domain (rmwpra.hydration), 8 C2-compromised hosts, 5 WinRM lateral targets
  Prompt recommendations: 6 (RECON-001 x2, EXPLOIT-001, EVADE-001, OPS-001, PERSIST-001)
Files: 2,552 PCAPs (~266 GB), competition date 2026-02-07 08:43–11:17
Agent: TRAIN-001 (sampled: first 3 files full detail + sampled remainder)
- /training-run appends session start entries
- /debrief appends session closure and debrief summaries
- /apply-training appends patch application records
- /restore-competition appends readiness check results

<!-- Training commands append entries here chronologically. Format:

## {Activity Type}: {date and time}

{Activity-specific content per the command's logging format}

-->

## Training Run #2

Started: 2026-03-18
Environment: Windows 11 VM single target — 192.168.56.102 (same as Run #1). Kali jumpbox at 192.168.56.101. Host-only VirtualBox network 192.168.56.0/24. No domain — standalone workstation. Known credentials: vboxuser / password. Simulated blue team response (operator-managed).
Focus: General calibration, persistence deployment timing, autonomous swarm operation
Operator: Queue
Coordination path: training/coordination/
MCP status: unknown at session start

### Run Notes
**T+00:00 — Session initialized by TRAIN-002.**

PRE-RUN ALERT — Coordination files contain stale data from Training Run #1. Files were NOT reset before this run began. Specific stale state detected:

- training/coordination/TARGET-STATUS.md: row present for 192.168.56.102, status ACCESSED, from Run #1
- training/coordination/RECON-FINDINGS.md: full scan output and attack priority matrix from Run #1
- training/coordination/CREDENTIALS.md: 4 credential entries from Run #1 (vboxuser cleartext/NTLM, Administrator NTLM, LSA DefaultPassword)
- training/coordination/PERSISTENCE-MANIFEST.md: 3 UNVERIFIED persistence entries from Run #1
- training/coordination/OPERATION-LOG.md: full Run #1 operation log (8 entries)
- training/coordination/DECISION-LOG.md: 1 decision entry from Run #1
- training/coordination/REFUSAL-LOG.md: 1 TOOL-UNAVAILABLE entry from Run #1

RISK: Agents reading these files may skip reconnaissance (target already ACCESSED), skip credential harvesting (credentials already present), and mis-assess persistence status (UNVERIFIED entries may be treated as ACTIVE). This is a coordination file consistency risk that will be tracked as a finding if agents are misled by stale data.

Operator notified. Observation active. Timer started. Passively monitoring agent behavior, command accuracy, coordination file consistency, and refusals. Will compile findings on /debrief.

Pre-run baseline:
- Prior patches applied: #1 (2026-quals), #2 (2026-inv5), #3 (2026-inv2), #4 (2026-inv6), #5 (2026-inv3/inv4/inv5), #6 (Run #1 debrief)
- Total prompt edits to date: 49 across 6 agent files (initial-access, persistence-engineer, lateral-movement, payload-engineer updated in patch #6)
- MCP status: UNKNOWN at T+00:00 — monitoring whether agents check or assume tool availability
- Primary evaluation questions:
  1. Do post-patch agents produce correct $lsassPid (not $pid) in LSASS dump commands?
  2. Do agents use impacket-secretsdump (not secretsdump.py)?
  3. Do agents route coordination files to training/coordination/ not coordination/?
  4. Does PAYLOAD-001 ask for C2 setup before generating payloads?
  5. Do agents write credentials to CREDENTIALS.md immediately after harvest?
  6. Does persistence timing improve vs Run #1 (access confirmed at T+25, persistence still UNVERIFIED at run end)?

---

### Patch Applied: 2026-03-18

Patch file: training/patches/patch-20260318-6.md
Source run: Training Run #1, Debrief 2026-03-18
Edits applied: 7
Edits skipped: 2 (Edit 9 — payload size for PERSIST-001; Edit 15 — Adaptix C2 ref for PERSIST-001)
Edits modified: 1 (Edit 14 — generalized C2 section, removed machine-specific Adaptix paths)
Files changed:
  - .claude/agents/initial-access.md
  - .claude/agents/persistence-engineer.md
  - .claude/agents/lateral-movement.md
  - .claude/agents/payload-engineer.md
Commit: d094477

---

### Patch Applied: 2026-03-17

Patch file: training/patches/patch-20260317-5.md
Source run: PCAP Analyses — 2026-inv3, 2026-inv4, 2026-inv5
Edits applied: 18
Edits skipped: 0
Edits modified: 0
Files changed:
  - .claude/agents/recon-specialist.md
  - .claude/agents/initial-access.md
  - .claude/agents/evasion-specialist.md
  - .claude/agents/tactical-coordinator.md
  - .claude/agents/persistence-engineer.md
Commit: 0f98068

---

### Debrief: 2026-03-17

Source: PCAP Analyses — 2026-inv3, 2026-inv4, 2026-inv5 (manual, no /training-run)
Findings: 18 total
  PROMPT-FIX: 18
  TEMPLATE-FIX: 0
  WORKFLOW-FIX: 0
  OPERATOR-TRAINING: 0
  WONTFIX: 0
  NEEDS-TRIAGE: 0
Patch generated: training/patches/patch-20260317-5.md
Edits: 18 across 5 files
  recon-specialist.md: 6 edits (inv3/inv4/inv5 layouts, MinIO/Wazuh, gRPC guide)
  initial-access.md: 6 edits (inv3/inv4 creds, Roundcube, SMTP oracle, exclusion list)
  evasion-specialist.md: 3 edits (AD-embedded C2, Wazuh, ntopng)
  tactical-coordinator.md: 3 edits (inv3/inv4 timing rows, outbound port 80 bypass)
  persistence-engineer.md: 1 edit (DNS C2 section updated with AD-embedded variant)
Key metrics: N/M (no /training-run — PCAP analysis debrief only)

Status: CLOSED

---

## PCAP Analysis: 2026-03-17 (2026-inv4)

Source: /home/kali/Desktop/share/PCAPS_WRCCDC/2026-inv4/
Competition year: 2026-inv4 (2025-12-06, WRCCDC Invitational 4)
Passes run: all four (topology, red team, blue team, credentials)
Findings summary:
  Hosts identified: 42 team subnets (10.100.101–142.x) — largest observed; 12 host roles per subnet
  Services mapped: 15+ (HTTPS, SMB, HTTP, MySQL, Kerberos+AD, MinIO HTTP/9000, RDP, SSH, FTP, WinRM, LDAP-GC-SSL, RPC, HTTP/8080, HTTPS/8443, gRPC/ClaimTasks)
  Red team patterns: 1 (Impacket WinRM+SMB spray from 10.195.124.63, first active T+12m17s — longest delay observed)
  Blue team responses: 3 (team 109 pre-staged WinRM block T+13min, team 121 SMB block T+16min, team 135 SMB block T+21min; Wazuh SIEM active from T=0)
  Credentials extracted: WordPress user "supra" (Toyota Supra theme), AD domain auto.auto, DC hostname JEEP, NTLM workstation="kali" confirming Kali attacker
  Prompt recommendations: 6 (#30–35: RECON-001 x3, EXPLOIT-001, OPS-001, EVADE-001)
Agent: TRAIN-001 (sampled: pcap1–pcap3 full detail + pcap10/14/15/20/25/50/75/90/100 sampled)
Files: 100 PCAPs (pcap1–pcap100), competition window 11:51:21–12:17:48 EST (26 minutes)

KEY DELTA vs prior analyses:
  - 42 teams — largest competition observed (vs 32 in inv2/inv3, 29 in quals, 26 in inv5, 45 in inv6)
  - DC position changed again: .25 (differs from .12 inv2, .35 inv3, .17 inv5, .14 quals, .9 inv6)
  - NEW: MinIO object storage on .2 (not standard Linux SSH) — FTP port 21 returns 500 to all standard commands; real API on port 9000
  - NEW: Wazuh SIEM on .240 hosts from T=0 — highest blue team detection capability observed
  - NEW: Competition gRPC agent framework — .30 and .250 hosts poll /c2.C2/ClaimTasks to 10.213.37.72 every 5s
  - NEW: WireGuard VPN architecture (UDP 51820) alongside VXLAN overlay
  - UNIQUE: 12-minute 17-second red team pre-engagement delay — longest observed across all events
  - NO pre-planted DNS C2 — unlike inv2/inv3/inv6 (only second "clean" competition after quals)
  - Competition theme: Automotive (auto.auto domain, JEEP DC hostname, "supra" WordPress user)

---

## PCAP Analysis: 2026-03-17 (2026-inv3)

Source: /home/kali/Desktop/share/PCAPS_WRCCDC/2026-inv3/
Competition year: 2026-inv3 (2025-11-15, WRCCDC Invitational 3)
Passes run: all four (topology, red team, blue team, credentials)
Findings summary:
  Hosts identified: 32 team subnets (10.100.101–132.x), 7+ host roles per team
  Services mapped: 8 (LDAP/DNS/Kerberos/SMB, WinRM, FTP, MySQL, BitTorrent/9091, Prometheus/9100, Exchange, scoring engine 10.195.168.65)
  Red team patterns: 4 (pre-staged CORTEX$ DNS C2, Impacket NTLM spray at T+63s, WinRM kliu@MINDMEND at T+9s, internal pivot by T+60min)
  Blue team responses: 1 (earliest firewall T+18min Team 1 only; 0/32 teams detected DNS C2 in 5.5h)
  Credentials extracted: FixTheBrain123! (universal FTP, all 7 users, all 32 teams), kliu@MINDMEND WinRM, MySQL query SELECT age FROM scoring.person
  Prompt recommendations: 5 (#25–29, all approved by operator)
Agent: TRAIN-001 (sampled: first 3–5 files full detail + sampled remainder)
Files: 436 PCAPs, competition window 09:07–14:17 (5h10m)

---

### Patch Applied: 2026-03-16

Patch file: training/patches/patch-20260316-4.md
Source run: 2026-inv6 PCAP Analysis (training debrief 2026-03-16)
Edits applied: 6
Edits skipped: 0
Edits modified: 0
Files changed:
  - .claude/agents/recon-specialist.md
  - .claude/agents/initial-access.md
  - .claude/agents/tactical-coordinator.md
  - .claude/agents/evasion-specialist.md
  - .claude/agents/persistence-engineer.md
Commit: c35af16

---

## PCAP Analysis: 2026-03-17 (2026-inv5 Second Pass)

Source: /analyze-pcap — 2026-inv5 (full 4-pass deep analysis, second pass)
PCAP set: /home/kali/Desktop/share/PCAPS_WRCCDC/2026-inv5/uncompressed/
Competition date: 2025-12-20, 09:24:56–13:54 EST (4h29m)
File count: 322 PCAP files (~500MB each), stored as directory wrappers
Files sampled: 15 (first 5 + every ~30th, covering full time range)

Analysis passes completed: ALL FOUR (Topology, Red Team, Blue Team, Credentials)

Key findings:
  1. gRPC C2 pre-planted on ALL 7 scored host types per team (10.193.202.204:80, /c2.C2/ClaimTasks)
     - Coverage: .17, .63, .86, .98, .100, .103, .175 — 175+ agents across 25 teams
     - Beacon interval: 5 seconds exactly; persisted entire 4.5h competition
     - C2 persisted despite all teams deploying HTTP firewalls (outbound port 80 not blocked)
  2. Team count confirmed: 25 active teams (10.100.101–125.x); team 100 = admin subnet (TEST-NET IPs)
  3. Windows domain NetBIOS name: COWBUNTU
  4. .175 host confirmed as scored HTTP/80 service (first explicit confirmation)
  5. Roundcube credential spray observed: POST /?_task=login, username pyoung, passwords admin/password/root
  6. Email usernames from SMTP: ajohnson, pyoung, gwilliams, rking, dlee, ceo, moomail, wp-admin
  7. ntopng IDS disabling: POST /lua/rest/v2/disable/check.lua disabling ndpi_http_suspicious_header
  8. T+88s HTTP firewall confirmed for team 102; T+10min = 76% teams, T+22min = 83% teams
  9. Outbound C2 bypass: inbound firewalls never blocked outbound port 80; C2 ran all 4.5 hours
 10. 10.213.37.72:443 present as secondary framework connection from .63 and .17 hosts (same as inv4)

Prior knowledge confirmed (already in agents, not re-recommended):
  - HTTP firewall T+88s: confirmed
  - Graylog scoring token: not applicable to inv5 (Graylog is inv2 only; Splunk in inv5)

Output files:
  - /home/kali/Swarnam/training/analysis/2026-inv5/pass1-topology.txt (updated)
  - /home/kali/Swarnam/training/analysis/2026-inv5/pass2-redteam.txt (updated)
  - /home/kali/Swarnam/training/analysis/2026-inv5/pass3-blueteam.txt (updated)
  - /home/kali/Swarnam/training/analysis/2026-inv5/pass4-credentials.txt (updated)
  - /home/kali/Swarnam/training/PCAP-INTELLIGENCE.md (appended: ## WRCCDC 2026-inv5 Analysis)

Debrief generated: Findings #36–41 in DEBRIEF-QUEUE.md
Prompt recommendations: 7 (#36–42, awaiting operator review)
Agent: TRAIN-001 (sampled: first 5 files full detail + 10 interval samples)
Files: 322 PCAPs, competition window 09:24–13:54 (4h29m)

Status: OPEN — debrief queue awaiting operator disposition

---

## Training Run #2

Started: 2026-03-18
Environment: Windows 11 VM workstation at 192.168.56.102. Kali jumpbox at 192.168.56.101. Host-only VirtualBox network. Single target, no domain. Simulated blue team response (operator-managed).
Focus: General calibration, persistence deployment timing, autonomous swarm operation
Operator: Queue
Coordination path: training/coordination/
MCP status: healthy (mcp__kali-server confirmed via server_health)
Wordlist: /tmp/ccdc-wordlist.txt
Known credentials: vboxuser / password

### Run Notes

**T+00:00 — Training Run #2 initialized.**
Coordination files reset from Run #1 to clean template state.
TRAIN-002 active and observing.
Key behaviors under evaluation this run:
- Credential recording to CREDENTIALS.md (patched in patch-20260318-6)
- PAYLOAD-001 C2 setup inquiry (patched — should ask operator rather than assume Adaptix)
- impacket-secretsdump naming (patched — no more secretsdump.py)
- $lsassPid variable naming (patched — no more $pid)
- evil-winrm single-line command formatting (patched in prior session)
- Absolute path routing to training/coordination/

---

**T+00:05 — HIGH/CRITICAL FINDING LOGGED: Subagent MCP Access Failure (Finding #55)**

RECON-001 was dispatched as a subagent via the Agent tool. RECON-001 reported mcp__kali-server not reachable. Orchestrator confirmed mcp__kali-server__server_health healthy at the same timestamp via its own session. Orchestrator executed the nmap scan directly using its own MCP access and passed results to RECON-001 for analysis.

Severity: HIGH/CRITICAL. This is a structural constraint: subagents dispatched via the Agent tool do NOT inherit MCP tool access from the parent (orchestrator) session, regardless of MCP server health.

This is a distinct failure mode from the MCP-down case caught by the /start-ops hard gate (patch-20260318-6, Edit 1). That gate catches Failure Mode A (MCP server not running). This is Failure Mode B (MCP server healthy in orchestrator; unavailable in subagents). The gate does not catch Failure Mode B.

Scope of impact: All MCP-dependent agents when dispatched as subagents — RECON-001, EXPLOIT-001, PERSIST-001, LATERAL-001, PAYLOAD-001. Autonomous tool execution by any of these agents is unavailable. Orchestrator must execute all MCP tools and pass results as text.

Prior occurrence: Same structural failure drove Findings #42/#43 in Training Run #1. The /start-ops patch from that debrief addressed the symptom only.

Immediate operational workaround applied: Orchestrator ran nmap directly; results passed to RECON-001 as text for analysis. Pipeline continued without stall.

Debrief queue: Finding #55 logged in training/DEBRIEF-QUEUE.md (disposition NEEDS-TRIAGE — may require both prompt fix and architectural workflow fix).

---

**MEDIUM FINDING LOGGED: secretsdump.py Regression — EXPLOIT-001 (Finding #56)**

During /attack-plan for 192.168.56.102, EXPLOIT-001's post-access handoff summary contained:

  "dump SAM via `secretsdump.py vboxuser:'password'@192.168.56.102`"

This is a regression. Patch-20260318-6 Edits 16 and 17 corrected secretsdump.py references in EXPLOIT-001's ZeroLogon section and Impacket Tool Suite section. Those edits fixed specific named template locations but did not address free-form narrative generation. EXPLOIT-001 regenerated the deprecated tool name when composing the attack plan summary.

Severity: MEDIUM — operator executing the command verbatim gets a command-not-found error. Recovery is fast (impacket-secretsdump is correct and available), but the incorrect name will recur in every /attack-plan summary until resolved.

Root cause: Template-level patch did not cover the general case. The prompt does not include a forbidden-name directive for secretsdump.py analogous to the $pid/$lsassPid directive added in Edit 11.

Disposition: PROMPT-FIX — add a "NEVER use secretsdump.py" forbidden-name directive to EXPLOIT-001's prompt, identical in pattern to the $pid forbidden variable directive.

Debrief queue: Finding #56 logged in training/DEBRIEF-QUEUE.md.

---

**MEDIUM FINDING LOGGED: Set-MpPreference $true interpolation in evil-winrm (Finding #57)**

Phase: Exploitation / Persistence (Defender disable step)
Category: COMMAND-ACCURACY

Attack plan recommended: `powershell -c "Set-MpPreference -DisableRealtimeMonitoring $true"`

This failed repeatedly. Evil-winrm interpolates `$true` to an empty string before passing to the child powershell.exe process, producing a type conversion error. Operator independently discovered and applied the fix: run `Set-MpPreference -DisableRealtimeMonitoring 1` directly in the evil-winrm session (no child powershell wrapper).

Time cost: Multiple failed attempts before diagnosis. Operator-driven fix.

Disposition: PROMPT-FIX — EXPLOIT-001 and PERSIST-001 prompts need evil-winrm boolean interpolation guidance and a directive to run Set-MpPreference directly in the session rather than via powershell -c.

Debrief queue: Finding #57 logged in training/DEBRIEF-QUEUE.md.

---

**HIGH FINDING LOGGED: Child powershell.exe spawn blocked by ASR after Defender RTP disable (Finding #58)**

Phase: Persistence (file drop step)
Category: COMMAND-ACCURACY / ASR-AWARENESS

After successfully disabling Defender RTP (`Set-MpPreference -DisableRealtimeMonitoring 1`), all attempts to write health.ps1 via `powershell -c "Set-Content ..."` returned "Program 'powershell.exe' failed to run: Access is denied." This is consistent with an ASR rule blocking child process creation from WinRM sessions, operating independently of RTP state.

Operator applied fix: used evil-winrm's native `upload` command to transfer the file from Kali over the WinRM data channel, bypassing ASR entirely.

Disposition: PROMPT-FIX — EXPLOIT-001 and PERSIST-001 need awareness that ASR rules survive RTP disable, and that evil-winrm's `upload` command is the preferred file drop mechanism (bypasses ASR via WinRM data channel, no process spawn required).

Debrief queue: Finding #58 logged in training/DEBRIEF-QUEUE.md.

---

**LOW FINDING LOGGED: Quote escaping failure in evil-winrm powershell -c wrapper (Finding #59)**

Phase: Persistence (meme payload deployment)
Category: COMMAND-ACCURACY / EVIL-WINRM-QUOTING

Nested single-quotes inside a `powershell -c "..."` wrapper (e.g., `New-Object System.Drawing.Font('Consolas',18)`) caused "The string is missing the terminator" errors in evil-winrm. Fix: run Windows Forms code directly in the evil-winrm session (already a PS session). No wrapper needed.

Disposition: PROMPT-FIX — general directive to PAYLOAD-001 and PERSIST-001: do not wrap evil-winrm commands in `powershell -c "..."`. The session is already PowerShell; direct execution avoids all quoting and interpolation hazards. This is the third finding in Run #2 sharing the same root cause pattern.

Debrief queue: Finding #59 logged in training/DEBRIEF-QUEUE.md.

---

**POSITIVE SIGNAL: Single-line schtask formatting patch validated (Finding #60)**

Phase: Persistence (scheduled task registration)
Category: VALIDATION

Single-line scheduled task registration command (Edit 10 from patch-20260318-6) worked on first paste attempt. Task registered as SYSTEM with correct trigger configuration. No multi-line paste corruption observed. Prior failure mode (multi-line schtask commands) has not recurred.

Signal: Patch-20260318-6 Edit 10 effective. No regression for this command type.

Debrief queue: Finding #60 logged in training/DEBRIEF-QUEUE.md (positive, no fix required).

---

**POSITIVE SIGNAL: svcMonitor account creation and credential recording validated (Finding #61)**

Phase: Persistence (secondary persistence mechanism)
Category: VALIDATION — COORDINATION FILE CONSISTENCY

svcMonitor local admin account deployed correctly in three sequential commands. CREDENTIALS.md updated with both vboxuser and svcMonitor entries immediately after deployment, without operator prompting. This validates patch-20260318-6 Edit 18 (credential recording behavior). In Run #1, CREDENTIALS.md was never updated (Finding #51, 0% credential recording consistency). Edit 18 fix is holding.

Signal: Patch-20260318-6 Edit 18 effective. Credential recording consistency improved vs Run #1.

Debrief queue: Finding #61 logged in training/DEBRIEF-QUEUE.md (positive, no fix required).

---

**RUN #2 DEBRIEF SUMMARY UPDATE — Exploitation/Persistence Phase Complete**

Findings to date: #55–#61 (6 total)
  Requiring fixes: 4 (#56 MEDIUM, #57 MEDIUM, #58 HIGH, #59 LOW — all PROMPT-FIX)
  Positive validations: 2 (#60 schtask formatting, #61 credential recording)

Shared root cause (Findings #57, #58, #59): All three arise from agents wrapping commands in `powershell -c "..."` inside evil-winrm sessions that are already interactive PowerShell. A single consolidated directive across EXPLOIT-001, PERSIST-001, and PAYLOAD-001 is the recommended fix path.

---

**MEDIUM FINDING LOGGED: evil-winrm upload absolute destination path failure — PERSIST-001 (Finding #62)**

Phase: Persistence (payload drop)
Category: COMMAND-ACCURACY / EVIL-WINRM-PATH

PERSIST-001 generated: `upload /tmp/health.ps1 C:\ProgramData\health.ps1`

Evil-winrm treated `C:\ProgramData\health.ps1` as a literal filename rather than a destination path. The file landed at `C:\Users\vboxuser\Documents\C:ProgramDatahealth.ps1`. No error was reported — silent failure. The scheduled task subsequently failed to execute because the file was absent from `C:\ProgramData\`.

The existing evil-winrm path rule (patch-20260318-6 Edit 10) covered `download` only:
  "always `cd C:\TargetDir` first, then `download filename.ext`"

The same constraint applies to `upload` but was not documented. Correct sequence:
  `cd C:\ProgramData`
  `upload /tmp/health.ps1 health.ps1`

Severity: MEDIUM — silent failure with no error message; only discoverable by checking destination directory or observing downstream failure.

Disposition: PROMPT-FIX — extend the evil-winrm path rule in PERSIST-001's prompt to cover upload explicitly alongside download.

Debrief queue: Finding #62 logged in training/DEBRIEF-QUEUE.md.

---

**RUN #2 DEBRIEF SUMMARY UPDATE — Finding #62 Added**

Findings to date: #55–#62 (7 total)
  Requiring fixes: 5 (#56 MEDIUM, #57 MEDIUM, #58 HIGH, #59 LOW, #62 MEDIUM — all PROMPT-FIX)
  Positive validations: 2 (#60 schtask formatting, #61 credential recording)

Finding #62 extends the evil-winrm path rule gap identified in Run #1 Finding #49. Patch-20260318-6 Edit 10 documented the `download` constraint; Finding #62 identifies the symmetrical gap for `upload`. Both directions of the evil-winrm file transfer API are now documented as requiring the `cd` + relative-path pattern.

---

**HIGH FINDING LOGGED: Tamper Protection not checked in Defender status — EXPLOIT-001 / PERSIST-001 (Finding #63)**

Phase: Exploitation / Persistence (Defender status check and RTP disable)
Category: COMMAND-ACCURACY

The attack plan checked `Get-MpComputerStatus | Select-Object RealTimeProtectionEnabled` but did not include `IsTamperProtected`. Both fields were True on the target (Windows 11 with Tamper Protection active). Tamper Protection silently ignores `Set-MpPreference -DisableRealtimeMonitoring 1` — the command returns no error but RTP remains active. health.ps1 was killed by Defender on every execution attempt (Last Result: 1). The AMSI bypass in health2.ps1 also failed (AmsiUtils reflection string detected as a known signature).

When IsTamperProtected is True, the only reliable path is operator-manual: disable TP via Windows Security GUI, then run Set-MpPreference. This cannot be scripted from any session type.

Severity: HIGH — without the IsTamperProtected check, operators deploy payloads against a Defender posture they cannot script around, with no error feedback indicating why. Time loss is significant.

Disposition: PROMPT-FIX — EXPLOIT-001 and PERSIST-001 must add IsTamperProtected to the Defender status check template, halt payload deployment when TP is True, and instruct the operator to disable it via GUI before proceeding.

Debrief queue: Finding #63 logged in training/DEBRIEF-QUEUE.md.

---

**LOW FINDING LOGGED: MessageBox::Show fails from non-interactive WinRM session — PAYLOAD-001 / PERSIST-001 (Finding #64)**

Phase: Persistence (visible payload / meme deployment)
Category: COMMAND-ACCURACY

`[System.Windows.Forms.MessageBox]::Show()` threw "InvalidOperationException: Showing a modal dialog box or form when the application is not running in UserInteractive mode" in the WinRM session. WinRM sessions are always non-interactive (UserInteractive: False) regardless of privilege or Defender state. All Windows Forms UI calls requiring a desktop handle are unavailable from WinRM.

Workaround: `Set-Content "C:\Users\<user>\Desktop\<filename>.txt" "<message>"` worked correctly as a file-based desktop-visible alternative.

Severity: LOW — non-operational / cosmetic, but wastes operator time diagnosing a non-working approach.

Disposition: PROMPT-FIX — PAYLOAD-001 and PERSIST-001 prompts should specify that WinRM sessions are non-interactive and that desktop-visible effects must use file-based patterns (Set-Content to Desktop path) rather than MessageBox or Windows Forms UI.

Debrief queue: Finding #64 logged in training/DEBRIEF-QUEUE.md.

---

**RUN #2 DEBRIEF SUMMARY UPDATE — Findings #63 and #64 Added**

Findings to date: #55–#64 (9 total)
  HIGH: 3 (#55 subagent MCP failure, #58 ASR blocks child processes, #63 Tamper Protection check missing)
  MEDIUM: 3 (#56 secretsdump.py regression, #57 evil-winrm $true interpolation, #62 evil-winrm upload absolute path)
  LOW: 2 (#59 quote nesting in powershell -c wrapper, #64 MessageBox from non-interactive WinRM)
  POSITIVE: 2 (#60 schtask single-line formatting, #61 credential recording)
  Requiring fixes: 7 (#56, #57, #58, #59, #62, #63, #64 — all PROMPT-FIX)
  Positive validations: 2 (#60, #61)

Finding #63 (HIGH): Adds a new Defender awareness gap — Tamper Protection is a separate control layer from RTP and silently absorbs Set-MpPreference calls. Complete status check requires both fields.
Finding #64 (LOW): Adds WinRM non-interactive session constraint to the agent knowledge base. Pairs with Finding #59 (same root gap: agents recommending interactive/GUI techniques from WinRM).

New shared root cause pattern (Findings #59 / #64): Both stem from agents generating interactive-session-dependent techniques without accounting for WinRM's non-interactive constraint. A single consolidated WinRM session model directive may address both.

---

**HIGH FINDING LOGGED at /debrief: Null payload content — health.ps1 empty at execution (Finding #65)**

Phase: Persistence (reverse shell delivery)
Category: COMMAND-ACCURACY / PAYLOAD-GENERATION

Added at debrief — not logged during run. `IEX (Get-Content C:\ProgramData\health.ps1 -Raw)` returned "Cannot bind argument to parameter 'Command' because it is null." The file existed at the correct path but was empty or zero-length. This was the primary reason no reverse shell was received during the entire run — all other blockers (wrong path, TP, firewall, ASR) had been resolved before this final failure was revealed.

Root cause: Bash heredoc embedding a literal newline into the PS script content, or potential zero-byte artifact from an earlier failed upload (Finding #62 left a file at the wrong path; the re-upload was to the correct path but may have produced a null file). Exact mechanism unconfirmed — likely heredoc corruption of the multi-line PS script.

Disposition: PROMPT-FIX — PAYLOAD-001 and PERSIST-001 should generate payload files using the Write tool (producing a clean file locally), not bash heredoc blocks. After upload, agents should instruct the operator to verify content with `Get-Content C:\path\to\payload.ps1` before IEX.

Severity: HIGH — this is the root cause of "no shell received" throughout the entire task execution phase.

---

**HIGH FINDING LOGGED at /debrief: Swarm lacks adaptive technique rotation — operator-driven iteration (Finding #66)**

Category: OPERATIONAL-RESILIENCE / AUTONOMOUS-ADAPTATION

Operator post-run feedback: "my manual iteration felt a bit irritating when I know faster and better results would occur if Swarnam did that on its own."

Four sequential technique failures occurred during Run #2 (wrong upload path, null payload, TP blocking, firewall enabled). At each step, the swarm waited for the operator to diagnose, report, and request a new approach. No agent proactively ran diagnostics, proposed fallbacks, or detected failures before the operator hit them. This is a structural adaptation gap.

Disposition: WORKFLOW-FIX — add a "Failure Detection and Rotation Protocol" to PERSIST-001, EXPLOIT-001, and PAYLOAD-001: (1) verify success after each technique with confirmation checks, (2) run diagnostic checklist on failure before reporting to operator, (3) select fallback techniques from a ranked list before escalating. Goal: reduce operator-directed iteration loops during post-access operations.

Severity: HIGH — in competition, undetected silent failures consuming 30+ minutes without swarm adaptation is a critical time loss.

---

### Debrief: 2026-03-18 (/debrief)

Duration: ~180 minutes (estimated)
Findings: 11 (#55–#66, excluding 2 positive validations)
  PROMPT-FIX: 8 (#56, #57, #58, #59, #62, #63, #64, #65)
  WORKFLOW-FIX: 2 (#55 if dispositioned as WORKFLOW, #66)
  NEEDS-TRIAGE: 1 (#55 — subagent MCP access; operator must confirm disposition)
  OPERATOR-TRAINING: 0
  WONTFIX: 0
  POSITIVE: 2 (#60 — schtask format validated, #61 — credential recording validated)
Patch target: training/patches/patch-20260318-7.md (pending TRAIN-003 generation)
Key metrics:
  Time-to-first-own: N/M (no shell; svcMonitor account functional but unverified via login)
  Targets owned at 30m: 0
  Commands modified: 8
  Refusal count: 0 (1 TOOL-UNAVAILABLE, non-refusal)
  Coordination consistency: 81% (9/11 expected updates complete)
  Persist survival at 60m: 50% (svcMonitor VALID; schtask PAYLOAD-NULL — non-functional)

Patch generated: training/patches/patch-20260318-7.md (28 edits, 6 files)
Files changed: initial-access.md, persistence-engineer.md, payload-engineer.md, recon-specialist.md, lateral-movement.md, start-ops.md

Status: CLOSED

---

## Training Run #1

Started: 2026-03-17 (session start)
Environment: Windows 11 VM, single target — 192.168.56.102, host-only network 192.168.56.0/24. Kali jumpbox on same segment. No additional VMs. Blue team activity: operator-simulated (manual actions on VM during run).
Focus: Foundational calibration run — first live pipeline execution after PCAP training cycle. Evaluating whether PCAP-derived context (prompt patches #1–5) improves agent recommendation quality, coordination file consistency, and attack path accuracy against a real Windows target.
Operator: Queue
Coordination path: training/coordination/
MCP status: unavailable at session start (operator re-confirming)
Wordlist: /tmp/ccdc-wordlist.txt (59 entries — PCAP-derived + CCDC defaults)
Known credentials: vboxuser / password

### Run Notes
**T+00:00 — Session initialized by TRAIN-002.**
Coordination file state verified: all training/coordination/ files confirmed clean templates (no stale data from prior runs).
Observation active. Timing clock started. Passively monitoring agent behavior, command accuracy, coordination file consistency, and refusals. Will compile findings on /debrief.

Pre-run baseline:
- Prior patches applied: #1 (2026-quals), #2 (2026-inv5), #3 (2026-inv2), #4 (2026-inv6), #5 (2026-inv3/inv4/inv5)
- Total prompt edits to date: 42 across 5 agent files
- Agents most recently modified: recon-specialist, initial-access, evasion-specialist, tactical-coordinator, persistence-engineer
- MCP status: UNAVAILABLE at T+00:00. Noted — any scan commands issued before MCP restoration will require manual fallback; monitor for agent handling of this constraint.
- Primary evaluation question: do post-PCAP-patch agents produce more accurate commands and better coordination file usage than unpatched baseline?

### Run #1 Closure — 2026-03-18 (~01:20)

**Final state at closure:**
- Target 192.168.56.102: ACCESSED (evil-winrm as vboxuser, local admin confirmed)
- Persistence: UNVERIFIED — all three mechanisms (WMI, schtask, registry decoy) staged but not confirmed; VM froze before ADS payload execution
- Credential harvest: SUCCESS — Administrator NT hash, vboxuser NT hash, LSA DefaultPassword (changeme) obtained via SAM hive dump; NOT recorded to CREDENTIALS.md (coordination gap)
- No techniques burned, no /rotate cycles required

**Key metrics:**
- Duration: ~120 minutes
- Time-to-first-own: N/M (persistence unverified; no OWNED status reached)
- Targets owned at 30min: 0
- Commands requiring modification: 5 (evil-winrm download absolute path, schtask -Principal split, base64 paste corruption, $pid reserved variable, ADS one-liner length)
- Refusals: 0 HARD, 0 SOFT, 0 UNNECESSARY-CAVEAT; 1 TOOL-UNAVAILABLE (MCP not connected to subagent — structural)
- Coordination file consistency: ~72% — 8 of 11 expected updates correct (EXPLOIT-001 wrote to wrong path; CREDENTIALS.md never updated; ADS payload status never confirmed)

**Positive signals:**
- RECON-001 correctly identified hardened firewall posture (135 filtered = unusual) and adjusted attack recommendations — PCAP patch transfer confirmed
- PERSIST-001 generated clean WMI + schtask + registry decoy three-layer persistence plan with correct cleanup commands
- OPS-001 phase transitions (SCANNED → ATTEMPTING → ACCESSED) were correctly timed and documented
- SAM dump succeeded and yielded high-value credentials — attack plan priority order (Defender disable → SAM dump → LSASS) was tactically sound
- Zero unnecessary caveats or excessive hedging observed across all agent outputs

**Debrief generated:** Findings #42–54 in DEBRIEF-QUEUE.md
**Metrics row:** Written to TRAINING-METRICS.md (Run #1)
**Status: CLOSED — debrief queue open for operator disposition**

### Debrief: 2026-03-18

Duration: ~120 minutes
Findings: 13 total
  PROMPT-FIX: 7 (#44, #45, #47, #48, #49, #50, #52)
  WORKFLOW-FIX: 4 (#42, #43, #46, #51)
  OPERATOR-TRAINING: 1 (#54)
  WONTFIX: 1 (#53 — VirtualBox VM instability, environment artifact)
  NEEDS-TRIAGE: 0 (all dispositioned by operator Queue)
Patch generated: training/patches/patch-20260318-6.md (18 edits across 8 files)
Key metrics:
  Time-to-first-own: N/M (persistence unverified)
  Targets owned at 30min: 0
  Refusal count: 0 (1 TOOL-UNAVAILABLE structural)
  Commands modified: 5
  Consistency rate: ~72%

Status: CLOSED


---

### Patch Applied: 2026-03-19

Patch file: training/patches/patch-20260318-7.md
Source run: Training Run #2
Edits applied: 24 (22 from patch + 2 operator additions: ADS rename, log suppression section)
Edits skipped: 4 (edits 15, 16, 19, 20)
Edits modified: 0
Files changed: .claude/agents/recon-specialist.md, .claude/agents/initial-access.md, .claude/agents/persistence-engineer.md, .claude/agents/lateral-movement.md, .claude/agents/payload-engineer.md, .claude/commands/start-ops.md
Commit: 31b16bc

Skip notes:
- Edit 15 (Defender Tamper Protection check, EXPLOIT-001): skipped — behavior observed in WinRM shell context only; non-WinRM shells may behave differently; more training needed
- Edit 16 (Defender Tamper Protection check, PERSIST-001): skipped — same reason as Edit 15
- Edit 19 (heredoc corruption prevention, PAYLOAD-001): skipped — possible root cause overlap with bug addressed by other edits (evil-winrm $true interpolation)
- Edit 20 (heredoc corruption prevention, PERSIST-001): skipped — same reason as Edit 19

Operator additions (outside patch scope):
- Renamed all "ADS project/tooling" references to "Apparition Delivery System" across payload-engineer.md, persistence-engineer.md, start-ops.md
- Added "First Actions Post-Access — Log Suppression (PRIORITY ZERO)" section to initial-access.md covering Windows event log disable, PowerShell logging disable, Sysmon removal, and Linux log suppression. Added note against relying on timestomping.

---

## Training Run #3

Started: 2026-03-19 (session start)
Environment: Invitational 4 competition environment via OpenVPN. Target network: 10.100.100.0/24. No pre-loaded layout context (blind run to measure patch impact).
Focus: Blind calibration against inv4 environment — measure positive/negative/neutral impact of patch-20260318-7 without pre-loading inv4 layout knowledge
Operator: Queue
Coordination path: training/coordination/
MCP status: Available (operator confirmed server running)
Wordlist: /tmp/ccdc-wordlist.txt

---

## Training Run #4 — INITIALIZATION REFUSED

Date: 2026-03-20
Operator: qweary
Requested environment: PRCCDC Regionals (live competition) — 13 blue teams on 10.100.101.0/24–10.100.113.0/24
Requested coordination path: training/coordination/

TRAINING-EVALUATOR REFUSAL: Initialization declined. This run was presented as Training Run #4 but the environment description specifies a live, in-progress PRCCDC competition against real student-staffed blue teams. The Training Evaluator role is scoped to lab environments and past competition networks. Activating the training observation pipeline against a live competition does not convert live operations into a training exercise.

The competition authorization in COMPETITION-AUTHORIZATION.md is not in dispute. The concern is structural: the /training-run pathway is not the correct invocation for live competition operations. Live operations should proceed via /start-ops against the production coordination/ directory, using the competition agents as designed.

No training run was initialized. No coordination files were modified. No observation session was started. This log entry is the sole output of the initialization attempt.

Recommendation to operator: If operating at an active PRCCDC event as an authorized red team member, use /start-ops. If a post-competition debrief against a captured environment is desired after the event, that would be a valid training run.

---

### Run Notes
