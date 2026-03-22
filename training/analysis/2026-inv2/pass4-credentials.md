# Pass 4: Credential Extraction - 2026-inv2

## Graylog API Token (HTTP Basic Auth)
- Service: Graylog SIEM on .170 hosts, port 9000
- Token (all teams identical): 12afjthotgefe01fv714tec0ag9qeuf3qup9a36bcecicbo11fj0
- Auth format: token:token (Basic Auth base64-encoded)
- URL: http://10.100.XXX.170:9000/api/search/universal/relative
- This is the SCORING ENGINE token used to query Graylog for log shipping verification

## Keycloak User Credentials (from /realms/master/protocol/openid-connect/token)
Service: Keycloak IAM on .103 hosts, port 8080
Extracted from HTTP POST bodies (URL-encoded, hex-encoded in tshark output)

| Username | Password (original) | Password (changed) | Notes |
|---|---|---|---|
| ajordan | CAREBEAR12? | (unchanged) | Special char + number |
| arexford | OMGaTREX1? | | Competition-themed (T-REX) |
| cbaines | juliarobertyoen | | Name-based |
| codom | schenckexner1 | Gap-Tarot-15 | Changed ~T+60min |
| dlopez | candycanelane12@ | | Song lyric + special |
| epark | creampuff041205x | L-ease9TrainTuned | Changed ~T+60min |
| eyu | 2fast2furious | | Movie title |
| flin | 12tisaquamarine4@31 | OMGaTREX1? | Changed mid-comp |
| gcruz | blingbling | | Simple word |
| hzhang | katherine | That-Spite5-Mountain | Changed ~T+21min |
| jteller | popcorn1? | | Simple + special |
| kkashani | wildcats | | Simple word |
| knixon | floricienta | | Spanish word |
| lchoi | mickeymouse | | Disney character |
| macosta | bobesponja | That-Spite5-Mountain | Changed (same as hzhang new?) |
| mcole | popcorn1? | (unchanged) | Shared with jteller, mrodriguez |
| menwright | securitea123? | | Infosec pun |
| mrodriguez | popcorn1? | H5ckB5ckJ5ck | Changed ~T+60min |
| oaziz | poohbear1 | | Disney character |
| rnormandy | capricornio | | Spanish zodiac |
| rpatel | bubbles102291 | CookieMuncherFinger1! | Changed ~T+60min |

## NTLM Authentication
- Domain: great.cretaceous
- Machine account observed: TREX$ (DC joining domain)
- Username: Administrator (scoring engine checks, red team reuse target)
- Source: 10.2.1.5 (scoring), 10.192.102.209 (red team?), 10.234.234.234 (infra)

## Credential Pattern Analysis

### Password Patterns (original/weak)
1. Cartoon/Disney characters: mickeymouse, poohbear1, blingbling, bobesponja (SpongeBob Spanish)
2. Food/candy: popcorn1?, candycanelane12@, creampuff041205x
3. Pop culture: 2fast2furious (movie), floricienta (telenovela), capricornio (zodiac)
4. Simple English: wildcats, katherine
5. Competition-themed: arexford's OMGaTREX1? (T-Rex), menwright's securitea123? (infosec pun)
6. Multi-user same password: popcorn1? used by mcole, jteller, mrodriguez simultaneously

### Password Patterns (changed/stronger)
- Passphrase style: That-Spite5-Mountain, Gap-Tarot-15, L-ease9TrainTuned
- Leet-speak: H5ckB5ckJ5ck
- Complex: CookieMuncherFinger1!

### Comparison to Prior Competitions
- inv5: passwords were service-based (udderstrength.gym themed), simpler overall
- quals: passwords not directly observed (no Keycloak HTTP)
- inv2: MORE diverse passwords; multiple users with SAME password (popcorn1?)
  - Significant: shared credentials mean spraying one password compromises multiple accounts
  - "popcorn1?" appears for mcole, jteller, mrodriguez across multiple teams simultaneously

### Key Spray Targets for Keycloak
High-value spray passwords based on frequency:
1. popcorn1? (3 accounts use it)
2. mickeymouse
3. blingbling
4. poohbear1
5. wildcats
6. bobesponja
7. OMGaTREX1? (competition-themed, likely across years)

## MySQL 3306
- 192.168.220.70 connects to 192.168.220.76:3306 (MySQL in internal subnet)
- Credentials not captured (TLS or binary protocol not decoded)

## No Cleartext FTP/SNMP/Telnet
- No FTP sessions detected
- No SNMP community strings
- No Telnet sessions
