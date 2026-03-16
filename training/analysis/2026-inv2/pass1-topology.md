# Pass 1: Network Topology - 2026-inv2

## Capture Metadata
- Date: 2025-11-02, 09:03-10:08 EST (65 minutes, 124 files x ~500 MB)
- Capture method: VXLAN tap at 10.1.3.20 (inner + outer headers visible)

## IP Range Scheme
- 10.100.100.0/24 — Shared services / admin segment (contains DC .12, scoring?)
- 10.100.101–132.0/24 — 32 team subnets (teams 01-32)
- 10.100.200.0/24 — Additional shared services (contains .25, .60, .79, .88, .250 hosts)
- 192.168.220.0/24 — Appears in VXLAN tunnels; internal subnet for some teams/hosts
- 192.16.220.0/24 — Scan target discovered via compromised .76 pivot

## Scoring / Infrastructure IPs
- 10.2.1.5 — Primary scoring engine (SMB/NTLM checks against shared services)
- 10.198.215.112 — Secondary scoring engine (SSH checks .103 hosts, port 8081 checks)
- 10.234.234.234 — Tertiary infrastructure (connects to team DCs on SMB/NTLM)

## VXLAN Tunnel Structure
- 10.1.3.20 = Capture tap (appears in outer header; inner IPs decoded separately)
- 10.1.3.1 = VXLAN VTEP serving teams 103, 108, 113, 114, 118, 123, 128
- 10.1.3.2 = VXLAN VTEP serving teams 100, 104, 109
- 10.1.3.3 = VXLAN VTEP serving teams 106, 111, 116, 121, 126, 131
- 10.1.3.5 = VXLAN VTEP serving teams 102, 107, 112, 117, 122, 127, 132
- 10.1.3.6 = VXLAN VTEP serving teams 101, 105, 110, 115, 119, 120, 124, 125, 129, 130

## Team Subnet Internal Layout (10.100.XXX.0/24)
All 32 teams share identical host layout:
- .1 = Gateway
- .12 = Domain Controller / LDAP (ports 135, 389, 445, 5985, 49667, 49671)
  - AD domain: great.cretaceous
  - Machine account: TREX$
- .20 = Linux host with SSH (port 22)
- .37 = Fernbank web server (WordPress port 80, MediaWiki port 8080) — "fernbank.greatXX.cretaceous"
- .70 = Unknown service (port 3000, 8082) — likely a Node.js/web app
- .76 = Dinosaur image gallery web server (port 9000, 22) — static file server
- .103 = Keycloak IAM server (port 8000/queue API, 8001/rides API, 8080/Keycloak OIDC, 22)
- .104 = Park/Shop ecommerce server (port 80, 22) — "park.greatXX.cretaceous", "shop.greatXX.cretaceous"
- .170 = Graylog SIEM server (port 9000, 22) — Graylog API on 9000

## Shared Services (10.100.200.x)
- .25 — Outbound TLS connections
- .60 — Outbound TLS (Splunk?)
- .79, .88, .250 — Various outbound connections

## Competition Theme
- Theme: "Cretaceous" (dinosaurs / Jurassic Park)
- AD Domain: great.cretaceous
- Service names: fernbank, park, shop, hatchery, hellcreek, fossil, tarpit, laboratory, badlands, trex
- DNS domain for scoring: greatXX.cretaceous and wccomps.org CNAME
- Machine account: TREX$

## Notable Finding: Pre-planted DNS C2 Beacon
ALL 32 team DCs (.12 hosts) are beaconing to log.jacobseunglee.com via DNS
- Beacon interval: exactly 5 seconds
- DNS label format: [16-char hex][4-char hex][20-char b58?].log.jacobseunglee.com
- This appears to be a red-team-deployed backdoor already active at capture start (09:03)
- At competition start, all 32 DCs were beaconing simultaneously
