# Pass 2: Red Team Traffic - 2026-inv2

## Known Red Team IPs (from high SYN sender analysis)
Multiple IPs in 10.192-255.x range appear to be red team infrastructure:
- 10.192.40.230 — Active in early files (scoring checks + red team overlap?)
- 10.192.102.209 — SMB (135/445) against 10.100.101.12 (DC) 
- 10.193.206.63 — Connected to 10.100.100.2 UDP 4789 (VXLAN traffic)
- 10.194.166.241 — Massive full-/24 masscan of 10.100.100.0/24 shared services (10,708 SYNs in one ~60s file at 09:38)
- 10.217.186.203, 10.244.209.247, 10.248.116.210, 10.243.32.138, 10.253.204.170 — Scoring engine IPs (high SYN counts to known service ports)

## DNS C2 Beacon (Pre-planted Backdoor)
- All .12 (DC) hosts beacon to log.jacobseunglee.com every 5 seconds
- Format: [hex_id].[b58_suffix].log.jacobseunglee.com
- Each host has a unique subdomain label (different team fingerprint per DNS query)
- Beacons active from 09:03 (capture start) through at least 10:06 (capture end) for most teams
- C2 resolver: 1.1.1.1 (Cloudflare public DNS)
- Active at T+0: all 32 teams beaconing
- Only 1 team (10.100.118.12) stopped beaconing before 09:15 (within first 12 minutes)
- 4 additional teams stopped between 09:31 and 09:38 (teams 105, 112, 116, 124)
- 29+ teams still beaconing at 10:06 (67+ minutes in)

## Compromised Host Scanning (Pivot from Owned Hosts)
- 10.100.106.76 — Used as scanning pivot (43,176 SYNs in file 091530)
  - Target: 192.16.220.0/24 full sweep, all ports (masscan-style from inside)
  - Indicates internal subnet mapping; .76 Graylog/gallery host used as tunnel
- 10.100.130.20 — Scanning pivot at 09:52 (144 SYNs, target: port 443 on internal IPs)
- 10.100.125.37, 10.100.126.20 — Limited scanning activity at various points

## Port 8081 Service Denial Pattern
- Multiple .103 hosts RST-ing 10.198.215.112:8081 starting ~09:07
- Port 8081 NOT accepting in file 1 (09:03) but generating RSTs in file 5 (09:08)
- Indicates a service scoring check on 8081 that doesn't respond (new scored service)

## SMB/NTLM Activity
- 10.2.1.5 → 10.100.100.12: Administrator/TREX$ NTLM auth (scoring engine checking DC)
- 10.192.102.209 → 10.100.101.12: Administrator auth on 135/445 at 12:04:13 EST
  - This is not the primary scoring IP, appears to be red team infrastructure
- 10.234.234.234 → 10.100.100.37: Administrator auth on 445 at 12:01:38 EST

## Masscan Characteristics
- 10.194.166.241 scan: ~10,700 SYNs in ~60 seconds = 178 SYN/sec
- Target: 10.100.100.0/24 full host range, random high ports
- Timing: appeared at 09:38 (35 minutes into competition)
- Pattern: random port selection per dest (not sequential) = masscan default

## Red Team Tool Signatures NOT Observed
- No PSEXESVC SMB file creation (Impacket PSExec)
- No Metasploit staged payload ports (4444-4450)
- No WinRM exploitation observed
