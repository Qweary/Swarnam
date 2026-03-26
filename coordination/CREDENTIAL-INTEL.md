# Credential Intelligence (Pre-Loaded)

Pre-loaded credential intelligence for CCDC competitions. EXPLOIT-001 reads this file at session start and when generating attack plans. Operators should review and supplement this file before starting operations.

**This file is DISTINCT from CREDENTIALS.md.** CREDENTIALS.md tracks credentials *harvested during the current operation* (SAM dumps, LSASS extracts, ticket captures). This file holds *pre-loaded intelligence*: known defaults, PCAP-derived passwords, historical patterns, and operator-supplied entries that exist BEFORE the operation begins. Both files are important; do not merge them.

## Universal CCDC Defaults

These passwords work across nearly all CCDC events regardless of theme or year. Spray these first against every target.

| Username | Password | Notes |
|----------|----------|-------|
| Administrator | Password1! | Most common Windows default |
| Administrator | P@ssw0rd | Second most common |
| Administrator | Changeme123 | Third most common |
| admin | admin | Universal web app default |
| root | toor | Kali-derived; common in student labs |
| root | password | Generic Linux default |
| admin | password | Generic web app default |
| tomcat | tomcat | Tomcat Manager default |
| tomcat | s3cret | Tomcat Manager alternate |
| admin | changeme | Splunk / generic app default |
| admin | admin123 | Generic admin default |
| minioadmin | minioadmin | MinIO factory default |

## Per-Event Known Credentials

Organize by event name. Include all credentials confirmed via PCAP analysis, scoring engine observation, or direct testing. Operators: add new event sections as intelligence becomes available.

---

### ⚠ WRCCDC REGIONALS 2026 — Quals Carry-Over Priority Spray

**IMPORTANT: This section assumes the regionals cloud environment is the quals base image. This is UNVERIFIED until the operator confirms topology match via firing range scan or live competition recon. Read the confidence tiers before acting on any entry.**

Confidence tiers used in this section:
- **CONFIRMED** — Directly verified (PCAP analysis, scoring engine observation, live test)
- **HIGH** — Strongly implied by environment reuse; likely valid at T=0; unverified at regionals
- **ASSUMED** — Logically extrapolated from quals pattern; may not hold
- **UNKNOWN** — Structure is known but values are competition-specific and unverifiable pre-competition

**Verification gate:** Run Team Zero NMAP tonight during firing range. If `.14` answers on 389/445/5985, `.20` answers on 80 (WordPress), and `.2` shows `bc:24:11:` MAC prefix → treat HIGH entries as operationally valid for T=0 spray. If topology does not match quals, fall back to Universal CCDC Defaults below and run standard recon in Phase 1.

| Confidence | Target | Username | Password | Service | Notes |
|------------|--------|----------|----------|---------|-------|
| CONFIRMED | every team `.20` | admin | WaterIsWet?? | WordPress `/wordpress/wp-login.php` | Scoring engine verifies this — blue teams CANNOT change it without losing SLA. Valid T=0 through end of competition. |
| HIGH | every team `.22` | Administrator | WaterIsWet?? | WinRM/5985 | Quals base image default; blue teams change this early |
| HIGH | every team `.14` | Administrator | WaterIsWet?? | SMB/445, LDAP/389 | Same image assumption; highest-value target if valid |
| HIGH | every team `.2` | root | WaterIsWet?? | SSH/22 | Spray this first — fastest initial access path |
| HIGH | every team `.10`,`.11` | root | WaterIsWet?? | SSH/22 | Secondary servers; same image |
| HIGH | every team `.240` | root | WaterIsWet?? | SSH/22 | Management host; often forgotten by blue teams |
| ASSUMED | every team `.14` | rmwpra\Administrator | WaterIsWet?? | WinRM/5985 | Domain admin via WinRM; format: `DOMAIN\user` |
| ASSUMED | every team services | admin | WaterIsWet?? | Web apps, APIs | Theme password sprayed against all web admin interfaces |
| ASSUMED | every team `.14` | (see AD section) | WaterIsWet?? variants | LDAP/Kerberos | AD user spray; format FIRSTNAME_LASTNAME |

**Spray order for T=0 (quals-optimized):**
1. SSH `.2` with `root:WaterIsWet??` — fastest shell, establishes beachhead
2. WordPress `.20` with `admin:WaterIsWet??` — CONFIRMED; get this even if SSH fails
3. WinRM `.22` with `Administrator:WaterIsWet??` — Windows foothold
4. SMB `.14` with `Administrator:WaterIsWet??` — DC access; pivot to domain domination
5. SSH `.240` with `root:WaterIsWet??` — management host; often overlooked by blue teams

**If quals carry-over is NOT confirmed:** skip this section, use Universal CCDC Defaults below, and run standard Phase 1 recon before spray.

**AD Intel (HIGH confidence if topology confirmed):**
- Domain: `rmwpra.hydration` (NetBIOS: `RMWPRA`)
- Username format: `FIRSTNAME_LASTNAME` (all caps, underscore separator)
- Password pattern: `[ThemeWord][Adjective][SpecialChars]` — see wordlist at `coordination/wordlists/quals-2026-passwords.txt`
- DO NOT change `admin:WaterIsWet??` on WordPress — scoring engine uses it

---

### 2026 WRCCDC Qualifiers (Feb 2026) — Hydration Theme

- **Domain:** rmwpra.hydration
- **Confirmed credential:** admin:WaterIsWet?? (WordPress on .20 hosts; verified by scoring engine)
- **AD username format:** FIRSTNAME_LASTNAME (all caps, underscore separator)
- **Password pattern:** [ThemeWord][Adjective][SpecialChars]
- **Spray priority:** SSH (.2) -> LDAP/SMB (.14 DC) -> WordPress (.20) -> WinRM (.22)
- **IMPORTANT:** Do NOT change admin:WaterIsWet?? on WordPress — scoring engine uses this credential

### 2026-inv6 (Jan 2026) — Star Wars Theme

- **Domain:** STAR-BARS; email: star-bars.local; DC: KYLOREN
- **SSO endpoint:** POST http://10.100.XXX.203/sso/login?url=/webmail/ (email=[user]@star-bars.local&pw=[password])
- **Chat endpoint:** POST http://10.100.XXX.134/api/login (JSON: {"username":"[user]","password":"[pass]","roomId":2,"roomPassword":""})
- **Credential reuse:** .134 and .203 share same passwords
- Confirmed accounts: H.Solo/T4!@A9Z6, b.kenobi/R9@!E6Sd, r2d2/F6#A9w!R, chewie/D4!9#K2E, leia/M4@Kp7Wc2, jango/M7!KZ3@8, asoka/A9@F!7Cw, woody/J8!4S@LQ, smalone/K2M#A9x!, gmtarkin/A7f!Q9zL, maul/T9#E!C2F, yoda/Z9#eF6A2m, c3po/P5@N2v!L, fett/S8@R6A!P, hutt/Z6!@K8F3, vader2/L3!8RZ@M, palpatine/R8!xS3Tq, moes/C7D!3sE4, strooper2/K5@!S7C9, strooper3/Z!9M6A#E, strooper4/E7@!K2P4, strooper5/C9!R@6S, strooper6/F@8!2MZK, strooper7/A#4!7R9E, strooper8/S!M9@6Z, strooper9/K!8R3@9F, strooper10/P@6F!D8R, stormtrooper101/W!4Z8A@6, L.Skywalker/P7!@M8K2
- **Blue team reset templates (spray at T+5):** rainbowandhearts23012[username], [Word]-[Word]-[Word]-Dajda213

### 2026-inv5 (Dec 2025) — Dairy/Farm Theme

- **Domain:** COWBUNTU / udderstrength.gym
- **Confirmed usernames (SMTP harvest):** ajohnson, pyoung, gwilliams, rking, dlee
- **Username format:** lowercase first-initial+lastname
- **Roundcube webmail on .86:** POST /?_task=login (requires CSRF token from GET /)
- **Splunk on .60:** admin/changeme (factory default)
- **ntopng on .2:** admin/admin (factory default)
- **Scoring accounts (DO NOT brute-force):** moomoo, ceo, ajohnson

### 2026-inv3 (Nov 2025) — MindMend / Mental Health Theme

- **Domain:** MINDMEND / mindmend.ai; DC: CORTEX
- **Universal FTP password:** FixTheBrain123! (all users on .103:21)
- **FTP usernames:** dgonzalez, ajohnson, anguyen, kliu, achi, ATHENA, jsmith
- **Pre-staged WinRM:** kliu@MINDMEND on .97:5985 (active at T+9 seconds)

### 2026-inv4 (Dec 2025) — auto.auto / Automotive Theme

- **Domain:** auto.auto (NetBIOS: AUTO); DC: JEEP
- **WordPress scored user:** supra on .63:80
- **MinIO default:** minioadmin/minioadmin on .2:9000 and .2:9001
- **Wazuh default:** admin/admin on .240 (dashboard); wazuh/wazuh (API)

### 2026-inv2 (Nov 2025) — Keycloak / Dinosaur Theme

- **Keycloak endpoint:** POST http://10.100.XXX.103:8080/realms/master/protocol/openid-connect/token
- **21 confirmed accounts** with passwords including: popcorn1? (mcole, jteller, mrodriguez), mickeymouse (lchoi), poohbear1 (oaziz), blingbling (gcruz), wildcats (kkashani), bobesponja (macosta), OMGaTREX1? (arexford), 2fast2furious (eyu), capricornio (rnormandy), floricienta (knixon)
- **Graylog scoring token (DO NOT rotate):** 12afjthotgefe01fv714tec0ag9qeuf3qup9a36bcecicbo11fj0

## ICS / OT / Camera Default Credentials

For use against ICS, HMI, historian, IP camera, and building management targets. See PRIVATE-PLAYBOOK.md special targets section for context.

### Generic ICS / HMI / Historian

| Username | Password | Platform / Notes |
|----------|----------|-----------------|
| admin | admin | Generic HMI / web interface default |
| admin | password | Generic HMI alternate |
| administrator | administrator | Historian / engineering workstation |
| root | root | Embedded Linux ICS devices |
| guest | guest | Read-only HMI access |
| operator | operator | Common ICS operator account |
| engineer | engineer | Common ICS engineering account |
| USER | USER | Some Allen-Bradley / Rockwell HMIs |
| Admin | 1234 | GE / Emerson HMI default |
| admin | 1234 | Schneider Electric / Modicon HMI |
| admin | 0000 | Various embedded HMI panels |

### IP Cameras (RTSP / Web UI)

| Username | Password | Brand / Notes |
|----------|----------|---------------|
| admin | admin | Hikvision, Dahua (very common) |
| admin | 12345 | Hikvision alternate |
| admin | password | Generic IP camera |
| admin | (blank) | Axis cameras default (no password) |
| root | root | Axis / embedded Linux cameras |
| admin | 888888 | Dahua alternate |
| admin | 666666 | Dahua alternate |
| root | (blank) | Some Hikvision / generic |
| supervisor | supervisor | Some NVR interfaces |

**RTSP stream URL formats:**
- Hikvision: `rtsp://<user>:<pass>@<IP>:554/Streaming/Channels/101`
- Dahua: `rtsp://<user>:<pass>@<IP>:554/cam/realmonitor?channel=1&subtype=0`
- Generic: `rtsp://<IP>:554/` or try via VLC/ffplay

### BACnet / Building Management (for light/siren target)

BACnet typically does not require authentication. Access is via protocol directly:
- Discover devices: `bacnet_scan` or `nmap --script bacnet-info -p 47808 -sU <target>`
- Write object values to control outputs (lights, alarms): use `bacnet_write` or similar tool
- No default credentials — access is protocol-level

## Operator-Added Entries

Add your own credentials, event-specific intelligence, and custom wordlist entries below. Format is flexible — use whatever structure is clearest for your needs. EXPLOIT-001 will parse this section for additional spray candidates.

| Username | Password | Context / Notes |
|----------|----------|-----------------|
| | | |

*Free-form notes:*


## Password Pattern Notes

Cross-competition patterns observed across all 2026 events:

- Each competition uses a thematic password (WaterIsWet??, FixTheBrain123!, etc.) except inv6 which used per-account unique passwords
- General pattern: [ThemeWord][Verb/Adjective][Digits][Special] or [ThemeVerb][ThemeNoun][Digits][Special]
- Blue team reset patterns tend to be formulaic: rainbowandhearts23012[user], [Word]-[Word]-[Word]-Dajda213
- Username formats vary by event: FIRSTNAME_LASTNAME (quals), first-initial+lastname (inv2/inv5), character names (inv6)
- Always try BOTH username formats during initial spray — the format may change at any event
