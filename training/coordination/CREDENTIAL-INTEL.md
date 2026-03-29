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

### 2026 PRCCDC Regionals (Mar 2026) — Bugs/Insects Theme

- **Domain:** ESS.DEFENSE; DC: HARVESTMAN (.98); Secondary DC: wopr (.99)
- **Theme password:** BugsEverywhere! (confirmed: Administrator, root, Wazuh admin, Kimai admin, MySQL root)
- **Cross-team service account:** svc_wazuh:BugsEverywhere! valid as domain user on 10/11 teams (Team 2 exception). Each team's Wazuh at 10.100.1XX.100. Use for Kerberoasting to escalate.
- **Pattern:** Wazuh service accounts at CCDC events use the competition theme password — spray svc_wazuh (or equivalent) with the current theme password as a cross-team Tier A action.
- **Jenkins default:** administrator:BugsEverywhere! on port 8080 (LDAP auth — Groovy Script Console = RCE)
- **MySQL root:** root:BugsEverywhere! on birdmite (.42) port 3306 (skip-ssl)
- **Username format:** lowercase first-initial+lastname (e.g., ajohnson, mrodriguez)
- **AD service accounts (Kerberoast targets):** svc-web, svc-sql, svc-backup, svc-monitor, svc-admin, svc-app, svc_wazuh, svc_birdmite, svc_brownwidow, svc_katydid, jenkinssvc, dc_joiners, serviceant

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
