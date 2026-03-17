# Training Log — Swarnam Training Activity Record

Purpose: Chronological record of all training activities including PCAP analyses, training runs, debriefs, patches applied, and readiness checks. Serves as the audit trail for how the swarm evolved through training. Each entry is appended by the relevant training command or agent.

---

## Log Entries

No training activities recorded yet. Activities will be logged here as they occur:
- /analyze-pcap runs append PCAP analysis summaries

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
