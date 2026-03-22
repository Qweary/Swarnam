# Pass 1 - Network Topology Extraction
# 2026-quals WRCCDC  |  Competition Date: 2026-02-07  |  Analysis: 2026-03-15

## Capture Metadata
- Format: Linux cooked v2 (SLL2) — aggregated tap capture across multiple interfaces
- Proxmox VE virtual infrastructure (all server .2 MACs share bc:24:11: prefix)
- Total files: 851 PCAPs x ~319 MB each = ~266 GB
- Time span: 08:43–11:17 UTC-5 (EST)
- Analysis samples: files 1–5 (08:43–08:43, full detail) + every ~50th file for remainder

## IP Range Structure
- 10.100.100.0/24 — Shared services / aggregate monitoring segment (10.100.100.x hosts 6-65)
- 10.100.101.0/24 through 10.100.129.0/24 — 29 team subnets (one per team)
- 10.193.63.150 — Primary masscan host (red team / infrastructure scanner)
- 10.195.58.63 — Secondary masscan host (appears at 09:03, heavy scanning through 10:16)
- 10.2.1.5 — Scoring engine (checks SSH/22, RDP/3389, HTTP/80, 8080, 8082, 5000, 389)
- 10.129.141 — Red team Kali jumpbox (downloading tools via apt at competition start)

## Team Subnet Layout
Each team subnet 10.100.1XX.0/24 follows a consistent internal host scheme:
- .1  = Gateway (unique MAC per team, not Proxmox)
- .2  = Primary server (Proxmox VM, bc:24:11: prefix)
- .10 = Host with SSH open
- .11 = Host with SSH open
- .14 = Domain controller / LDAP server (port 389)
- .16 = Host connecting to github.com (blue team workstation)
- .20 = General server
- .22 = Windows host (WinRM on 5985)
- .23 = Host with SSH
- .24 = Host with SSH
- .26 = Host with SSH
- .28 = Host connecting to servers.openrct2.io (scored gaming service)
- .100 = Host with port 5000 open (unknown service)
- .240 = Host with SSH open (management interface?)

## Confirmed Team Subnets (ARP verified)
10.100.100–129.0/24 = 30 team subnets total

## Scoring Engine Targets (10.2.1.5 checks)
Services checked: SSH (22), RDP (3389), HTTP (80/8080/8082), LDAP (389), port 5000, HTTPS (443)
Confirmed by SYN packets from 10.2.1.5 to 10.100.101–129.x ranges

## Key Internal Infrastructure
- 10.100.103.2 — DNS (53/TCP+UDP), SSH (22), HTTPS (443) [confirmed SYN-ACK]
- 10.230.87.61 — C2 / payload server (HTTP port 80, serves ELF binary implants)
- 10.230.81.250 — HTTP server (port 80, recurring traffic from team .20 hosts)
- 10.202.96.103 — HTTP server (port 80)
- 10.235.228.45 — HTTPS server (port 443)
- 10.234.234.234 — WinRM management host (connects to .14 and .22 hosts on 5985)

## External Infrastructure Observed
- 140.82.112-114.3/4 — GitHub
- 104.21.46.33, 172.67.223.33 — Cloudflare CDN
- servers.openrct2.io — Scored gaming service (Open RollerCoaster Tycoon 2 server)
- http.kali.org, kali.download, kali.darklab.sh — Kali package mirrors
- 10.100.129.141 — Kali jumpbox downloading: burpsuite, impacket, certipy-ad, gvmd, chromium

## Scored Services (identified from scoring engine traffic)
1. SSH (port 22) — on .2, .10, .11, .20, .23, .24, .26, .240 in each team subnet
2. RDP (port 3389) — on .28 hosts (10.100.100.28 confirmed)
3. HTTP (port 80) — multiple hosts per team
4. WordPress (port 80 at /wordpress/) — on .20 hosts (e.g., 10.100.125.20)
5. OpenRCT2 game server — .28 hosts connecting to servers.openrct2.io (TLS)
6. Port 5000 — on .100 hosts in each team subnet
7. Port 8082 — on 10.100.100.26 (confirmed SYN-ACK, scoring engine checks /mqtt-ws)
8. Port 389 (LDAP) — on .14 hosts (domain controllers)
9. WinRM/5985 — on .14 and .22 Windows hosts
10. Victoria (domain) — HTTP service at /css/status_config.php on .22 hosts

## NTP Infrastructure
Teams' .240 hosts query external NTP servers (multiple IPs). NTP on UDP/123.
