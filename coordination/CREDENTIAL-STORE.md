# Credential Store

Maintained by EXPLOIT-001, LATERAL-001, and PERSIST-001. This is the centralized record of all harvested credentials. Every agent that discovers, harvests, or uses credentials must update this file. LATERAL-001 reads this file to plan credential reuse attacks. EVADE-001 reads it to track which credentials have been rotated by blue teams.

## Why This File Exists

Credentials are the most valuable operational asset in CCDC. A single Domain Admin hash can own an entire team's infrastructure. This file ensures no credential is lost between agent invocations, no operator wastes time re-harvesting credentials that are already known, and the team can instantly answer "what credentials do we have for Team N?"

## Plaintext Credentials

| # | Team | Username | Password | Domain | Source (where harvested) | Validated On (target IPs) | Admin? | Status | Discovered At | Notes |
|---|------|----------|----------|--------|--------------------------|---------------------------|--------|--------|---------------|-------|
| | | | | | | | | | | |

## NTLM Hashes

| # | Team | Username | NT Hash | Domain | Source | Validated On | Admin? | Status | Discovered At | Notes |
|---|------|----------|---------|--------|--------|-------------|--------|--------|---------------|-------|
| | | | | | | | | | | |

## Kerberos Tickets

| # | Team | Username | Ticket Type | Ticket File Path | Domain | Expiry | Source | Status | Notes |
|---|------|----------|-------------|------------------|--------|--------|--------|--------|-------|
| | | | | | | | | | |

## SSH Keys

| # | Team | Key File Path | Key Type | Associated User | Deployed To | Source | Status | Notes |
|---|------|---------------|----------|-----------------|-------------|--------|--------|-------|
| | | | | | | | | |

## Service/Application Credentials

| # | Team | Service | Username | Password | Target IP | Port | Source | Status | Notes |
|---|------|---------|----------|----------|-----------|------|--------|--------|-------|
| | | | | | | | | | |

Covers database credentials (MySQL root, MSSQL sa, PostgreSQL postgres), web application admin accounts (WordPress, phpMyAdmin, Tomcat Manager, Roundcube), SNMP community strings, and any other service-specific authentication tokens.

## Status Legend

ACTIVE — credential works right now (last validated within the current session). UNVERIFIED — harvested but not tested on all targets yet. ROTATED — blue team changed this password; credential no longer works. PARTIAL — works on some targets but not others (possibly different local admin passwords). CRACKING — hash harvested but plaintext not yet recovered.

## Credential Reuse Matrix

When a new credential is harvested, LATERAL-001 should test it against all targets in the team's range and record validation results in the "Validated On" column. Use NetExec for efficient mass validation:

```
netexec smb 10.X.Y.0/24 -u <user> -p '<password>' --continue-on-success
netexec smb 10.X.Y.0/24 -u <user> -H '<hash>' --continue-on-success
```

## Offline Cracking Status

Track hashes sent to hashcat/john for cracking:

| Hash Type | Hash Count | Wordlist/Rules Used | Cracked Count | Cracking Host | Notes |
|-----------|------------|---------------------|---------------|---------------|-------|
| | | | | | |

## Notes

Record credential-related observations here: password policy patterns observed (minimum length, complexity requirements, rotation frequency), common password patterns across a team's infrastructure, blue team password rotation timing (how quickly they change passwords after compromise detection).
