# Red Team Scorecard

Live-updated operational scorecard. INTEL-001 and PERSIST-001 update this file alongside their normal coordination file updates. This file provides at-a-glance metrics for status reports and ensures post-competition reports have accurate summary statistics.

## Last Updated
| Timestamp | Updated By |
|-----------|------------|
| | |

## Host Status Summary

| Team | Total Hosts | Accessed | Owned | Persistence Active | Burned | Unknown |
|------|-------------|----------|-------|--------------------|--------|---------|
| | | | | | | |

## Persistence Count by Type

| Mechanism Type | Count | Hosts Deployed On |
|----------------|-------|-------------------|
| SSH Key | | |
| Scheduled Task | | |
| Cron Job | | |
| Backdoor Account | | |
| Web Shell | | |
| WMI Subscription | | |
| Registry Run Key | | |
| Service | | |
| ADS (Apparition) | | |
| Other | | |

## Compromised Accounts

| # | Team | Username | Credential Type | Privilege Level | Status | Source |
|---|------|----------|-----------------|-----------------|--------|--------|
| | | | | | | |

## Sensitive Data / Exfiltrated Information

Tracks extracted files, PII, documents, database contents, and other collected information from targets. Required for scoring and educational debrief. Include provenance for every entry.

| # | Type | Description | Source Host | Path / Location | Obtained At | Scoring Relevance | Saved To |
|---|------|-------------|-------------|-----------------|-------------|-------------------|----------|
| | | | | | | | |

*Types: PII, credentials, config-file, database-dump, source-code, scoring-token, document, other*

## Scoring Tokens Collected

| Team | Token/Service | Token Value | Collected At | Status |
|------|---------------|-------------|--------------|--------|
| | | | | |

## Escalation Paths

| Team | Path Summary | Highest Privilege Achieved |
|------|--------------|---------------------------|
| | | |

## Commands Executed to Achieve Objectives

Key commands and tool invocations that produced significant results. Not every command — focus on commands that achieved access, escalated privileges, deployed persistence, or exfiltrated data.

| # | Timestamp | Target | Objective | Command / Tool Used | Result / Output |
|---|-----------|--------|-----------|---------------------|-----------------|
| | | | | | |

---

**Update instructions:** PERSIST-001 updates Persistence Count after each deployment. INTEL-001 updates Host Status Summary, Compromised Accounts, and Sensitive Data during SITREP generation. Operators update Commands Executed and Sensitive Data as they work. All agents should update this file whenever they update PERSISTENCE-MANIFEST.md or CREDENTIALS.md respectively.

**Relationship to other coordination files:** This file is a summary view. The authoritative detailed records remain in TARGET-STATUS.md (host-level detail), PERSISTENCE-MANIFEST.md (per-mechanism detail), and CREDENTIALS.md (per-credential detail). If there is a discrepancy between this scorecard and the detailed files, the detailed files are authoritative.
