# Swarnam Changelog

## [Unreleased] — Vocabulary Refactoring: CCDC-Specific → General Engagement Platform

This change set refactors the Swarnam platform from WRCCDC/CCDC-specific competition vocabulary to a general-purpose red team training and engagement platform vocabulary. Authorization context was preserved at equivalent strength throughout — no authorization language was weakened or removed. All PCAP-derived tactical intelligence was retained under generalized pattern labels.

### Terminology Mapping Applied

| Old Term | New Term |
|---|---|
| CCDC / WRCCDC / PRCCDC | removed (or "exercise" / "historical exercise"; retained only as PCAP data source label in training agents) |
| competition | engagement (or "exercise" in training/historical contexts) |
| blue team (as adversary) | defensive team |
| AI blue team / Team 9 / Anthropic | AI-Assisted Defensive Group (configured via `engagement-profile.yaml`) |
| CCDC default passwords | Universal Exercise Defaults / common default credentials |
| scoring tickets | findings |
| WRCCDC-specific network layouts | historical exercise layout patterns A–F |
| competition organizers | authorizing party / engagement coordinators |
| quals / inv2 / inv3 / inv4 / inv5 / inv6 | Pattern A / B / C / D / E / F |
| firing range | pre-engagement access window / test range |
| black team | engagement organizers |
| gold team | engagement organizers and reviewers |
| Team N | Group N |
| competition files | engagement files |

---

### Files Changed

#### Agents

**`.claude/agents/tactical-coordinator.md`**
- description: "competition phases" → "engagement phases", "manage the competition timeline" → "manage the engagement timeline"
- "During competition operations" → "During engagement operations"
- "blue team remediation", "blue teams", "cost blue teams points" → "defensive team" equivalents throughout
- "competition scope / phase" → "engagement scope / phase"
- C2 channel note: `inv5` → `Pattern E`, "teams" → "groups", "competition" → "exercise"
- Post-destruction log, alerts, decision framework: all "blue team" → "defensive team"

**`.claude/agents/recon-specialist.md`**
- "During competition operations" → "During engagement operations"
- "evening before competition day" → "evening before engagement day"
- "blue teams frequently overlook" → "defensive teams frequently overlook"
- "checking if blue team has changed services" → "defensive team"

**`.claude/agents/initial-access.md`**
- "During competition operations" → "During engagement operations"
- "cross-competition pattern" → "cross-exercise pattern"

**`.claude/agents/training-evaluator.md`**
- Authorization context: updated from WRCCDC/CCDC to general platform language
- "competition agents" → "engagement agents" (description, role, refusals, command accuracy sections)
- "live competition operations" → "live engagement operations"
- "which past competition year" → "which past exercise year"
- "competition coordination files" → "engagement coordination files"
- "On competition day" → "During live engagements"

**`.claude/agents/prompt-patcher.md`**
- Authorization context: updated from WRCCDC/CCDC to general platform language
- description: "competition agent system prompts" → "engagement agent system prompts", "pre-competition" → "pre-engagement", "live competition operations" → "live engagement operations"
- "CCDC-specific knowledge (WRCCDC configuration)" → "exercise-specific knowledge"
- "non-WRCCDC contexts" → "other contexts"
- "In WRCCDC environments specifically" → "In this engagement environment specifically"
- "WRCCDC authorization language" → "authorization language"
- Coordination/handoff sections: "competition files", "competition agents" → "engagement" equivalents
- "On competition day" → "During live engagements"

**`.claude/agents/pcap-analyst.md`**
- description: "WRCCDC packet capture intelligence extraction specialist" → "Historical exercise packet capture intelligence extraction specialist", "past WRCCDC competitions" → "past exercise competitions (including WRCCDC archives)"
- Authorization context: updated from WRCCDC/CCDC to general platform language
- "pre-competition preparation" → "pre-engagement preparation", "live competition operations" → "live engagement operations"
- "WRCCDC competition packet captures" → "historical exercise packet captures (including WRCCDC archives)"
- "competition agents smarter" → "engagement agents smarter"
- "WRCCDC competition network architecture" → "WRCCDC exercise network architecture"
- "each competition year" → "each exercise year" (all occurrences)
- "blue team administrative traffic" → "defensive team administrative traffic"
- "blue team response times" → "defensive team response times"
- "competition wordlist generator" → "engagement wordlist generator"
- "each competition agent's system prompt" → "each engagement agent's system prompt"
- "competition coordination files", "competition agent definitions" → "engagement" equivalents
- "competition infrastructure" → "exercise infrastructure"; "across competitions" → "across exercises"
- "competition agents directly", "during competition" → "engagement" equivalents

#### Commands

**`.claude/commands/rotate.md`**
- All "blue team" → "defensive team" (replace_all)

**`.claude/commands/blue-team-handoff.md`**
- description: "post-competition educational archive for blue teams" → "post-engagement educational archive for defensive teams"
- Heading: "Post-Competition Blue Team Package" → "Post-Engagement Defensive Team Package"
- Purpose section and orientation document: "blue teams" → "defensive teams" throughout
- COMPETITION-TIMELINE.md → ENGAGEMENT-TIMELINE.md (all references and bash cp command)
- Step 4 wall-clock table: "Team" column → "Group"
- Sanitize step: "competition infrastructure is still accessible" → "exercise infrastructure"
- C2 note: "after the competition" → "after the engagement"
- Excluded section: "not educational for blue teams in the handoff context" → "defensive teams"
- Step 6 log entry: updated
- Notes: "CCDC is designed for" → "Security exercises exist for learning"

**`.claude/commands/restore-competition.md`**
- "engagement coordination files" → used consistently throughout
- "competition-specific data" → "engagement-specific data"
- "competition prompts" → "engagement prompts"
- "competition release" → "engagement release"
- "before competition" / "before competition day" → "before engagement" / "before engagement day"
- "competition operations" → "engagement operations"
- "competition directory" → "engagement directory"
- "competition readiness" description: "Restore the swarm to competition-ready state" retained (command name), body updated
- "CCDC-specific configurations" → "exercise-specific configurations"
- Structure validation tests: updated file references
- Training isolation step: "competition" → "engagement" / "live engagements"

**`.claude/commands/training-run.md`**
- description: "so competition files stay clean" → "so engagement files stay clean"
- "normal competition pipeline" → "normal engagement pipeline"
- "competition year's infrastructure" → "exercise year's infrastructure"
- "simulated blue team activity" → "simulated defensive team activity"
- "competition files clean" → "engagement files clean"
- "competition commands" → "engagement commands"
- "competition agents" → "engagement agents"
- "competition template at coordination/CREDENTIAL-INTEL.md" → "engagement template"
- Startup brief: "competition files untouched" → "engagement files untouched"
- Step 10: "as they would during competition" → "as they would during a live engagement"
- Post-initialization note: "normal competition pipeline", "real competition run", "competition operations" → engagement equivalents
- `/tmp/ccdc-wordlist.txt` → `/tmp/engagement-wordlist.txt`
- Usage examples: "WRCCDC" exercise description language generalized

**`.claude/commands/analyze-pcap.md`**
- description: "from past WRCCDC competitions" → "from past exercise competitions (including WRCCDC archives)"
- "embed WRCCDC-specific knowledge into competition agents" → "embed exercise-specific knowledge into engagement agents"
- Body: "WRCCDC packet captures" → "historical exercise packet captures (including WRCCDC archives)"
- "feeds the competition agents' system prompts" → "feeds the engagement agents' system prompts"
- Four passes: "blue team response detection" → "defensive team response detection"
- "competition captures" → "exercise captures"
- "blue team response events detected" → "defensive team response events detected"
- Log template: "Competition year" → "Exercise year", "Blue team responses" → "Defensive team responses"
- Usage examples: "2019 competition" → "2019 exercise", "new competition year's" → "new exercise year's"
- Notes: "competition files" → "engagement files"
- Argument descriptions: "this competition year" → "this exercise year"

**`.claude/commands/apply-training.md`**
- "applying each edit to the competition files" → "engagement files"

**`.claude/commands/debrief.md`**
- "use /end-ops only during actual competition" → "use /end-ops only during live engagements"
- "simulated blue team check" → "simulated defensive team check"
- "not worth fixing before competition" → "before the next engagement"
- "target competition environment" → "target engagement environment"
- "verify competition readiness" → "verify engagement readiness"

**`.claude/commands/scan-range.md`**
- "time-critical competition window" → "time-critical engagement window"

#### Coordination Files

**`coordination/TARGET-STATUS.md`**
- "Fill on competition day" → "Confirm at session start (from engagement-profile.yaml or engagement coordinator briefing)"
- Group labels: "Team 1/2/.../AI Team" → "Group 1/2/.../AI-Assisted Defensive Group"
- Status legend: "blue team remediated" → "defensive team remediated"
- Column header: "Blue Team Activity" → "Defensive Team Activity"

**`coordination/CREDENTIAL-INTEL.md`**
- Header: "CCDC competitions" → "security exercises and engagements"
- Section: "Universal CCDC Defaults" → "Universal Exercise Defaults"
- Confidence tiers: "competition-specific and unverifiable pre-competition" → "engagement-specific and unverifiable pre-engagement"
- Pattern A carry-over section: all "blue teams" → "defensive teams", "every team" → "every group"
- Spray order label: "(quals-optimized)" → "(Pattern A optimized)"
- Event-named sections renamed: quals→Pattern A, inv2→Pattern B, inv3→Pattern C, inv4→Pattern D, inv5→Pattern E, inv6→Pattern F
- "Blue team reset templates" → "Defensive team reset templates"
- Password Pattern Notes: cross-competition → cross-exercise, "Each competition" → "Each exercise"

**`coordination/CREDENTIALS.md`**
- "CCDC" → "security exercises and engagements"
- "team's infrastructure" → "group's infrastructure"
- "Team N" → "Group N" throughout
- `| # | Team |` column headers → `| # | Group |`
- "ROTATED — blue team changed this password" → "defensive team"
- "blue team password rotation timing" → "defensive team password rotation timing"

**`coordination/RECON-FINDINGS.md`**
- Pre-engagement topology section: "WRCCDC Quals Carry-Over" → "Pattern A Carry-Over"
- Source: "2026 WRCCDC Quals PCAP analysis" → "Historical PCAP analysis (Pattern A)"
- Verification references: "firing range scan or live competition recon" → "test range scan or live engagement recon"
- Network scheme table: Team 0–9 → Group 0–9, "Firing Range" → "Test Range", "Team N (student)" → "Group N (student)", "Team 9 (AI — Anthropic)" → "AI-Assisted Defensive Group (if present)"
- Scoring engine attribution: "from quals PCAP" → "from Pattern A PCAP"
- Assumed Host Roles section: "Per Team Subnet" → "Per Group Subnet", "N = team number" → "N = group number"
- "Blue team jump box" → "Defensive team jump box", "Blue team workstation" → "Defensive team workstation"
- "often forgotten by blue teams" → "defensive teams"
- Scoring service section: "from Pattern A PCAP scoring engine traffic"
- "costs blue teams SLA points" → "costs defensive teams SLA points"
- "Release the Kraken" → "the designated destructive phase"
- Host inventory: Team → Group column
- AD domains: "verify at competition start" → "verify at engagement start"

**`coordination/PERSISTENCE-MANIFEST.md`**
- "deployed to competition targets" → "engagement targets"
- "post-competition review" → "post-engagement review"
- Status: "BURNED (detected and removed by blue team)" → "defensive team"
- Notes: "blue team activity during deployment window" → "defensive team"

**`coordination/BURNED-TECHNIQUES.md`**
- "detected and remediated by blue teams" → "defensive teams"
- "post-competition review" → "post-engagement review"
- Column header: "Team" → "Group"
- "blue team checked" → "defensive team checked"
- Section: "Blue Team Detection Capability Assessment" → "Defensive Team Detection Capability Assessment"

**`coordination/DECISION-LOG.md`**
- "post-competition review" → "post-engagement review"
- Example rationale: "competition phase, blue team behavior" → "engagement phase, defensive team behavior"

**`coordination/OPERATION-LOG.md`**
- "during the competition" → "during the engagement"
- "student blue teams to learn from" → "student defensive teams"
- "post-competition educational debrief" → "post-engagement educational debrief"

**`coordination/RED-TEAM-SCORECARD.md`**
- "post-competition reports" → "post-engagement reports"

**`coordination/REFUSAL-LOG.md`**
- "authorized competition scope" → "authorized engagement scope"

**`coordination/SCORING-FORM.md`**
- "between competition sessions" → "between engagement sessions"
- Grouping dimension: "per-host/team" → "per-host/group"

**`coordination/PRIVATE-PLAYBOOK.md`**
- Title: "WRCCDC Regionals 2026" → "Engagement-Specific Intelligence"
- All "blue team" → "defensive team" (replace_all)
- All "competition" → "engagement" (replace_all)
- Quals carry-over: "WRCCDC Quals reference" → "Pattern A"
- "Team 0 = 10.100.100.0/24 (firing range)" → "Group 0 (test range)"
- Team topology: "Teams 1–8", "Team 9 = AI defensive team (Anthropic)" → "Groups 1–8", "Group 9 = AI-Assisted Defensive Group (if present per engagement-profile.yaml)"
- "Universal CCDC Defaults" → "Universal Exercise Defaults"
- "WRCCDC Gold Team" → "Engagement organizers and reviewers"
- Scoring objective section rewritten
- "Special Targets (Black Team Pre-Disclosure)" → "Engagement Organizer Pre-Disclosure"
- "black team has confirmed" → "engagement organizers have confirmed"
- "Cameras" section: "explicitly sanctioned... by the black team" → "by the engagement organizers"
- "Notes on AI Blue Team" → "Notes on AI-Assisted Defensive Teams"
- DNS Manipulation: "Historically disruptive at WRCCDC" → "in exercise environments"
- Zerologon: "WRCCDC environments" → "exercise environments"

**`coordination/wordlists/README.md`**
- Title: "WRCCDC Regionals 2026" → "Exercise Intelligence (Pattern A)"
- "for competition use" → "for engagement use"
- "universal CCDC defaults" → "universal exercise defaults"
- "Updating during competition" → "Updating during engagement"

---

### Files Intentionally Not Changed

- **`training/`** directory — all files (TRAINING-LOG.md, TRAINING-METRICS.md, patches/, analysis/, PCAP-INTELLIGENCE.md, DEBRIEF-QUEUE.md, etc.) are immutable historical training records
- **`COMPETITION-AUTHORIZATION.md`** — legacy file retained as historical artifact; `ENGAGEMENT-AUTHORIZATION.md` is the active authorization document
- **`ENGAGEMENT-AUTHORIZATION.md`** — uses "competition" as a generic engagement type descriptor (e.g., "In a competition context, this is the competition organizing body") — this is appropriate general usage
- **`engagement-profile.yaml`** — uses "competition" as a valid engagement type value (`type: competition`) alongside pentest, ctf, etc. — these are enum values
- **`archive/`** directory — excluded from refactoring scope

### Intentionally Preserved References

- **WRCCDC as data source** in `pcap-analyst.md` — the agent literally analyzes WRCCDC PCAPs; domain-specific references ("WRCCDC archive", "WRCCDC organizers", "WRCCDC exercise network architecture") are accurate and necessary
- **Literal PCAP file names** in `analyze-pcap.md` usage examples — `competition-day1-01.pcap` and `competition-day1-03.pcap` are the actual naming convention used in WRCCDC archives
- **Command name `/restore-competition`** and **command name `/blue-team-handoff`** — command names are stable identifiers and changing them would break operator muscle memory; "competition-ready state" in the restore-competition description refers to the command's function
- **`tactical-coordinator.md` parenthetical examples** — "multiple defensive teams in a competition" and "disqualification from a competition or exercise" use "competition" as a generic engagement type description, which is accurate
