# Reconnaissance Findings

Maintained by RECON-001. Contains structured results from all reconnaissance operations. EXPLOIT-001, LATERAL-001, and OPS-001 read this file to inform attack planning and prioritization.

## Scan Output Directory

Raw scan output files are stored in coordination/scans/. Use consistent naming: discovery-teamN, services-teamN, full-teamN, smb-teamN, web-teamN, etc.

## ⚠ Pre-Engagement Assumed Topology (UNVERIFIED — Pattern A Carry-Over)

**Source:** Historical PCAP analysis (Pattern A). Assumed to apply if engagement cloud environment is the same base image.
**Status:** UNVERIFIED. Must be confirmed via test range scan or live engagement recon before committing.
**Verification:** See PRIVATE-PLAYBOOK.md "Quals Environment Carry-Over Intelligence" section for the confirmation checklist.
**If wrong:** Delete or mark as INVALID and use live scan results instead. Do not mix assumed and confirmed entries without clear labels.

### Assumed Network Scheme (UNVERIFIED)

| Range | Role | Notes |
|-------|------|-------|
| 10.100.100.0/24 | Group 0 — Test Range | NOT an engagement target; organizer/red team testing only |
| 10.100.101.0/24 | Group 1 (student) | ASSUMED — group number/IP mapping unverified |
| 10.100.102.0/24 | Group 2 (student) | ASSUMED |
| 10.100.103.0/24 | Group 3 (student) | ASSUMED |
| 10.100.104.0/24 | Group 4 (student) | ASSUMED |
| 10.100.105.0/24 | Group 5 (student) | ASSUMED |
| 10.100.106.0/24 | Group 6 (student) | ASSUMED |
| 10.100.107.0/24 | Group 7 (student) | ASSUMED |
| 10.100.108.0/24 | Group 8 (student) | ASSUMED |
| 10.100.109.0/24 | AI-Assisted Defensive Group (if present) | ASSUMED — treat as [AI-DT] if engagement-profile.yaml confirms |
| 10.2.1.5 | Scoring engine | CONFIRMED from Pattern A PCAP |

### Assumed Host Roles Per Group Subnet (UNVERIFIED — from Pattern A PCAP)

Pattern: `10.100.10N.X` where N = group number

| Host Suffix | Role | Services (Assumed) | Attack Priority | Confidence |
|-------------|------|--------------------|-----------------|------------|
| .1 | Gateway / Router | — | **OFF-LIMITS (ROE)** | CONFIRMED |
| .2 | Primary Linux server (Proxmox VM) | SSH/22 | P1 — first SSH spray target | HIGH |
| .3 | Defensive team jump box | — | **OFF-LIMITS (ROE)** | CONFIRMED |
| .10 | Secondary server | SSH/22 | P2 | HIGH |
| .11 | Secondary server | SSH/22 | P2 | HIGH |
| .14 | Windows Domain Controller | LDAP/389, SMB/445, WinRM/5985, RDP/3389 | P1 — DC = domain domination | HIGH |
| .16 | Defensive team workstation | SSH/22, RDP/3389 | P3 — often connects to GitHub | ASSUMED |
| .20 | WordPress / application server | HTTP/80, HTTPS/443 | P1 — CONFIRMED scoring credential | HIGH |
| .22 | Windows host | WinRM/5985, RDP/3389 | P1 — Windows foothold | HIGH |
| .23 | Service host | SSH/22 | P2 | ASSUMED |
| .24 | Service host | SSH/22 | P2 | ASSUMED |
| .26 | Service host | SSH/22 | P2 | ASSUMED |
| .28 | Gaming host (OpenRCT2) | game port | P3 | ASSUMED |
| .100 | Service host | 5000/tcp | P2 | ASSUMED |
| .240 | Management host | SSH/22, NTP | P2 — often forgotten by defensive teams | HIGH |

### Assumed Scoring Service Checks (UNVERIFIED — from Pattern A PCAP scoring engine traffic)

Services the scoring engine (10.2.1.5) was observed checking at quals:

| Service | Port | Path / Notes |
|---------|------|-------------|
| SSH | 22 | All .2 hosts |
| RDP | 3389 | Windows hosts |
| HTTP | 80 | General web |
| HTTPS | 443 | General web |
| Alt HTTP | 8080 | App server |
| MQTT-WS | 8082 | `/mqtt-ws` |
| LDAP | 389 | DC |
| Custom | 5000 | Service host |
| WordPress | 80 | `/wordpress/wp-login.php` (checks `admin:WaterIsWet??`) |
| Victoria | 80 | `/css/status_config.php` |
| WinRM | 5985 | Windows hosts |

**Implication:** Disrupting services on this list costs defensive teams SLA points. These are the highest-value disruption targets during the designated destructive phase.

---

## Host Inventory (Live — Updated by RECON-001 during operations)

**Instructions for RECON-001:** Add confirmed scan results below. Mark entries as CONFIRMED when directly observed. If entry matches an ASSUMED entry above, update the Confidence column but keep it in this section, not the assumed section.

| IP | Hostname | Group | OS Fingerprint | Open Ports (Service Versions) | Identified Vulns/Misconfigs | Attack Priority | Notes |
|----|----------|------|----------------|-------------------------------|----------------------------|-----------------|-------|
| | | | | | | | |

## Active Directory Domains

| Domain | DC IP(s) | Functional Level | Users Enumerated | Groups Enumerated | Trust Relationships | Notes |
|--------|----------|------------------|------------------|-------------------|---------------------|-------|
| rmwpra.hydration | TBD (assumed .14) | ASSUMED — unverified | No | No | Unknown | ASSUMED from Pattern A; verify at engagement start |

## Web Applications

| IP | URL | Technology | CMS/Framework | Version | Default Creds Tested | Vulns Found | Notes |
|----|-----|------------|---------------|---------|----------------------|-------------|-------|
| | | | | | | | |

## Credentials Discovered During Recon

| Source | Username | Password/Hash | Type | Validated On | Notes |
|--------|----------|---------------|------|-------------|-------|
| | | | | | |

## Network Topology Notes

Record multi-homed hosts, routing observations, segmentation boundaries, and pivot opportunities here. Prepend each note with a timestamp.
