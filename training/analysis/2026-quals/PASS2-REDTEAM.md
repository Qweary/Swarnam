# Pass 2 - Red Team Traffic Identification
# 2026-quals WRCCDC  |  Competition Date: 2026-02-07  |  Analysis: 2026-03-15

## Scanner Inventory

### 10.193.63.150 — Primary Masscan (Full Competition Duration)
- Active from 08:43 through at least 11:17 (entire capture window)
- Rate: ~180 pps (effective ~90 unique ports/sec, masscan sends 2 SYNs per port)
- Confirmed masscan signature: paired SYN packets ~40µs apart to same dst:port
- Target: all hosts in 10.100.100.0/24 (at least .6 through .65)
- Port profile: random high ports + targeted DNS (53), HTTPS (443)
- 3,783 unique destination ports in first file alone
- SYN count in first file (91 seconds): 16,517 SYNs = 180.8 pps
- No SYN-ACK responses observed (either host-down or masscan dropping responses)
- Likely running: masscan --rate 100 -p 0-65535 10.100.100.0/24

### 10.195.58.63 — Secondary Masscan (Appears 09:03, High Volume)
- First seen at 09:03, high activity at 09:12 (9,102 SYNs observed), 10:16 (37,194 SYNs)
- Targets: 10.100.100.x segment (same as primary scanner)
- Includes: 10.100.100.97, .99, .240, .28, .2, .26, .24, .22
- Port profile: random high ports, similar masscan signature
- Peak burst 10:16: 37,194 SYNs in one file (~same 91-sec window)

### 10.249.134.51 — SSH-Only Scanner (Appears 09:03)
- Targets: 10.100.114–115.x on port 22 only
- Scanning pattern: 2 SYNs per host (masscan or targeted nmap -T4 --open)
- Scope: sequential host scan within single team subnet

### 10.192.188.151 — SSH Targeted (Appears 09:03)
- Repeated SSH SYNs to single host: 10.100.117.28 port 22
- ~10+ SYN attempts suggesting brute force or persistent SSH attempt

### 10.201.151.129 — SSH Scanner (Appears 09:12)
- Targets 10.100.104–105.x on port 22
- 56 SYNs in sample = systematic host enumeration

### 10.242.143.7 — SSH Focus (09:12)
- 48 SYNs to 10.100.102.28 port 22 only = targeted brute force

### 10.223.97.64 — SSH Brute Force (09:50)
- 42 SSH SYNs to 10.100.119.28
- Generates RSTs after established sessions (auth failures)
- Single team subnet focus (10.100.119.0/24)

### 10.237.187.1 — SSH Mass Brute (10:32 Surge)
- 13,028 SYNs in sample at 10:32 — largest single-file count
- Target: 10.100.114.28 (7,371 SYNs) and 10.100.114.22 (5,607 SYNs) + .14
- Port 22 only = SSH credential spray
- Extremely aggressive: thousands of attempts against two hosts

### 10.232.197.173 — Multi-Service Scanner (10:32)
- 1,516 SYNs targeting multiple ports: SSH (22), HTTP (80), port 5000, HTTPS (443), LDAP (389)
- Targets: 10.100.114.x and 10.100.129.100
- Broad service enumeration rather than mass port scan

### 10.230.108.32 — LDAP + SSH Scanner (10:32)
- Targets .14 hosts (domain controllers) on LDAP/389
- Also scans .22, .23, .28 on SSH/22
- Systematic per-subnet targeting

### 10.230.48.74, 10.203.72.83, 10.229.134.175 — NTLM Spray Hosts (10:32)
- Multiple sources doing NTLM authentication sprays against .14 (LDAP/domain controller) hosts
- See Pass 4 for full credential details

### 10.194.171.183 — SSH Scanner (10:38)
- 116 SYNs, SSH only, targeting 10.100.106–108.x hosts
- Pairs of SYNs per host = masscan SSH targeting

### 10.207.89.168 — SSH + HTTP (10:38)
- SSH against 10.100.111.22, 10.100.126.23
- HTTP port 80 against 10.100.125.28

## C2 Infrastructure

### 10.230.87.61 — C2 Payload Server
- Serves ELF Linux binary via HTTP at GET /JSyausLR/LinIUpdater
- User-Agent: curl (versions 7.88.1, 8.12.1, 8.14.1, 8.18.0)
- Response: HTTP 200 with raw ELF binary (Linux x86-64 implant)
- Transfer-Encoding: chunked
- First C2 beacon: 09:03 from 10.100.105.2 (team 105 primary server — first compromise)
- Expanded to: 10.100.101.2, 10.100.101.20 (also 09:03)
- Second wave (10:38): 10.100.105.20, 10.100.105.240, 10.100.106.23, 10.100.106.26, 10.100.108.23
- Pattern: curl HTTP GET, short interval, suggests cron-based persistence
- C2 traffic volume: 27,208 packets at 09:03; 44,621 packets at 10:38

### 10.234.234.234 — WinRM Lateral Movement Host
- Connects to team hosts via WinRM (port 5985) POST /wsman
- Targets: 10.100.113.14, 10.100.125.22, 10.100.123.22, 10.100.126.14, 10.100.126.22
- Activity visible from 10:38 onward
- Non-standard IP (10.234.234.234) — likely red team pivot host or implant

## Red Team Tool Footprint Summary
- Masscan: ~180 pps effective rate, paired SYNs, random port order
- SSH brute force: repeated SYNs to port 22, many sources targeting different team subnets
- NTLM credential spray: domain `rmwpra.hydration`, multiple usernames (see Pass 4)
- WinRM execution: POST /wsman from 10.234.234.234
- Implant delivery: ELF binary via HTTP GET from curl, path /JSyausLR/LinIUpdater
- Impacket usage inferred: WinRM POST pattern consistent with impacket winrm or evil-winrm

## Operational Timeline
- 08:43 — Competition start. 10.193.63.150 masscan begins immediately
- 08:43 — 10.100.129.141 Kali box downloading tools (burpsuite, impacket, certipy-ad)
- 09:03 — 10.195.58.63 secondary masscan starts. C2 beacon first seen on 10.100.105.2
- 09:03 — 10.100.101.2 and 10.100.101.20 also beaconing to C2 (earliest compromised hosts)
- 09:03 — 10.100.103.2 responding SSH/22, 53, 443 (scoring engine confirms service)
- 09:12 — SSH scanners (10.201.151.129, 10.242.143.7) begin targeting teams 104/105
- 09:50 — 10.223.97.64 SSH brute force on team 119
- 10:16 — 10.195.58.63 peak activity (37,194 SYNs in 91s)
- 10:32 — Coordinated multi-IP attack surge: 10+ red team IPs active simultaneously
- 10:32 — NTLM credential spray begins against .14 (DC) hosts across all teams
- 10:38 — C2 beacon spreads to teams 105/106/108 hosts (.20/.23/.26/.240)
- 10:38 — WinRM lateral movement begins (10.234.234.234)
- 11:00+ — Scoring engine continues checking; WordPress on team .20 hosts

## Masscan Detection Signature
Pattern: two SYN packets to same dst host:port within 100 microseconds, no options beyond MSS,
window size 1024, TTL 36, no SACK PERM option (noted by tshark expert info).
Rate: consistent ~160-180 pps over sustained periods.
