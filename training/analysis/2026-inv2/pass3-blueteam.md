# Pass 3: Blue Team Response - 2026-inv2

## DNS C2 Beacon Remediation Timeline
Competition started at ~09:03 EST. Beacon active on all 32 DCs from start.
Remediation measured by absence of DNS queries from specific hosts.

| Approx Time | Event |
|---|---|
| 09:03 | All 32 teams beaconing (T=0, competition start) |
| 09:15 | Team 118 remediated — ONLY team in first 12 min. Fastest responder. |
| 09:24-09:31 | Teams 110, 114, 118, 130 missing from file 092436 (but inconsistent) |
| 09:31 | 29 teams still beaconing |
| 09:38 | Teams 105, 112, 116, 124 added to remediated list (4 more removed) |
| 10:06 | ~29 teams STILL beaconing (majority never remediated during 65-min capture) |

Fastest single-team DNS C2 response: ~12 minutes (team 118)
Median response: beacon not remediated within 65-minute capture window for ~90% of teams
Blue team detection rate for DNS C2: ~10% within 65 minutes

## Password Change Events (Keycloak credentials)
Multiple user accounts changed passwords mid-competition:
- hzhang: katherine → That-Spite5-Mountain (seen at 09:24 EST)
  - New password format: passphrase-style (word-word-number)
- flin: 12tisaquamarine4@31 → OMGaTREX1? (seen in later files, then reverted?)
- macosta: bobesponja → That-Spite5-Mountain (last file, possibly compromise response)
- codom: schenckexner1 → Gap-Tarot-15 (last file)
- epark: creampuff041205x → L-ease9TrainTuned (last file)
- mrodriguez: popcorn1? → H5ckB5ckJ5ck (last file)
- rpatel: bubbles102291 → CookieMuncherFinger1! (last file)

The new passwords all follow a passphrase/memorable pattern, NOT the original weak passwords.
This suggests a blue team security improvement effort mid-competition (changing weak passwords).

## Firewall / Service Changes
- No clear RST storms indicating firewall deployment on a single host
- Port 8081 RSTs from .103 hosts to scoring engine = service not yet deployed at competition start
- Port 443 on some .37 hosts generating RSTs in file 5 (new TLS config or firewall)

## Response Timing Comparison
| Competition | DNS C2 Detection (fastest) | Password Changes |
|---|---|---|
| 2026-quals | N/A (no DNS C2 observed) | ~17 min (firewall rules) |
| 2026-inv5 | N/A | 88 seconds (fastest response) |
| 2026-inv2 | ~12 minutes (team 118 only) | 09:24+ for most teams |

KEY INSIGHT: inv2 blue teams were significantly slower than inv5 (88 sec) and similar to quals (17 min).
The DNS C2 was essentially undetected/unremediated for 90% of teams throughout the 65-minute capture.
This is an invitational with different/less-experienced teams than inv5.

## Blue Team Activity Patterns
- Scoring engine (10.2.1.5) performs NTLM checks against DCs every ~60-70 seconds
- Blue teams were active (Keycloak login activity from their workstations seen throughout)
- No evidence of IDS/firewall blocking scanning IPs
- No evidence of blue teams identifying the DNS C2 (except team 118)
