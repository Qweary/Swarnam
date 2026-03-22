# Pass 4 - Credential Extraction
# 2026-quals WRCCDC  |  Competition Date: 2026-02-07  |  Analysis: 2026-03-15

## Cleartext Credentials

### WordPress (HTTP POST - Scoring Engine Credential)
Service: WordPress at /wordpress/wp-login.php
Source: 10.2.1.5 (scoring engine)
Target: 10.100.125.20 (team 125 web server)
Username: admin
Password: WaterIsWet??
Context: Scoring engine uses this credential to verify WordPress is functional.
This IS the expected/scored credential for WordPress. Blue teams must preserve it.
Note: At 11:00, login FAILED for team 125 (password changed). Succeeded at 11:17 for team 104.

### Scoring Engine WordPress Domain
WordPress site title observed: "Our Wet Blog" (from HTML response)
WordPress theme/config: ClassicPress-based

## NTLM Authentication (Credential Spray Activity)
All NTLM activity at 10:32 from red team hosts targeting .14 (domain controller) hosts.
Domain: rmwpra.hydration

Usernames observed being sprayed (all targeting 10.100.10x.14 DC hosts):
- DENIS_FITZGERALD
- EVELYN_HOUSTON
- BILLIE_HOUSE
- CASSANDRA_JOYNER
- Administrator
- backup
- NULL (anonymous/null session attempts)

Source IPs doing NTLM spray:
- 10.234.133.57 — sprays teams 101, 102, 103, 105
- 10.194.221.185 — sprays teams 101, 102, 103, 105
- 10.203.72.83 — sprays teams 101–110 (most comprehensive)
- 10.229.134.175 — sprays teams 101–108
- 10.247.168.97 — sprays team 109

Notable: "backup" and "Administrator" are high-value targets (built-in accounts).
NULL session attempts indicate checking for anonymous LDAP/SMB bind access.

## Service Scoring Credential
Victoria domain service check:
- URL: /css/status_config.php?cache_key=88ae429a4ed7a3ca14a5523b97bcb065
- Host header: victoria
- Accessible at 11:00 on 10.100.101.22

## WinRM Activity
10.234.234.234 using WinRM (POST /wsman) to connect to:
- 10.100.113.14 (domain controller, team 113)
- 10.100.125.22 (Windows host, team 125)
- 10.100.123.22 (Windows host, team 123)
- 10.100.126.14 (domain controller, team 126)
- 10.100.126.22 (Windows host, team 126)
WinRM activity is authenticated — credentials used are not visible in cleartext at this layer.

## Credential Pattern Analysis

### Domain Name
Competition domain: rmwpra.hydration
Pattern: random-word.theme-word (hydration theme consistent with "Our Wet Blog" site name)
This suggests the competition organizers themed all services around a "water/hydration" concept.

### Username Convention
Competition usernames are FirstName_LastName format (all caps underscore-separated).
Observed names: DENIS_FITZGERALD, EVELYN_HOUSTON, BILLIE_HOUSE, CASSANDRA_JOYNER
Service accounts: Administrator, backup
Pattern: real-sounding US names, not "user1/user2" style

### WordPress Password
admin:WaterIsWet?? — matches the competition water/hydration theme.
Password complexity: mixed case + special chars (??) = moderate complexity.
Base word is thematic. Teams that reset this break scoring.

### Kali Tool Set (from HTTP downloads on 10.100.129.141)
Tools actively downloaded at competition start:
- burpsuite (web app testing)
- python3-impacket (AD/SMB attacks)
- certipy-ad (Active Directory Certificate Services attacks)
- gvmd (OpenVAS vulnerability scanner)
- chromium (browser-based testing)
- gcc-mingw-w64 (Windows cross-compilation = payload generation)
- apache2 (web server = possibly C2 staging)
- sudo (privilege escalation prerequisite)

## Implied Credentials (Not Directly Captured)
The ELF binary delivered via /JSyausLR/LinIUpdater was executed by multiple team hosts.
The implant likely provides:
- Shell access back to 10.230.87.61
- Possible credential harvesting capability
- Linux implant targeting Linux services (.2 primary servers)

## Summary Counts
- Cleartext credential pairs extracted: 1 (WordPress admin:WaterIsWet??)
- NTLM usernames observed in spray: 6 (DENIS_FITZGERALD, EVELYN_HOUSTON, BILLIE_HOUSE,
  CASSANDRA_JOYNER, Administrator, backup)
- Domain identified: rmwpra.hydration
- C2 sessions confirmed: 8 unique compromised hosts
- WinRM targets: 5 Windows hosts in teams 113, 123, 125, 126
