# Persistence Manifest

Maintained by PERSIST-001. This is the authoritative record of all persistence mechanisms deployed to competition targets. Every entry includes the cleanup command so that all persistence can be accounted for during post-competition review.

## Manifest

| # | Target IP | Hostname | Type | Name/Path | Trigger | Payload Summary | Privilege Level | Deployed At | Last Verified | Status | Cleanup Command |
|---|-----------|----------|------|-----------|---------|-----------------|-----------------|-------------|---------------|--------|-----------------|
| | | | | | | | | | | | |

## Type Legend

Type values: TASK (scheduled task), REGISTRY (run key or other registry persistence), WMI (WMI event subscription), SERVICE (Windows service or systemd unit), CRON (cron job), SSHKEY (SSH authorized key), WEBSHELL (web shell file), ACCOUNT (backdoor OS user account), DB-ACCOUNT (backdoor database user — MySQL, MariaDB, PostgreSQL), ADS (Apparition Delivery System deployment), OTHER.

## Status Legend

Status values: ACTIVE (deployed and verified), UNVERIFIED (deployed but not recently verified), BURNED (detected and removed by blue team), DEGRADED (partially functional).

## Verification Schedule

High-value persistence (Tier 1 targets) should be verified every 30 minutes during active operations. Tier 2 persistence should be verified every 60 minutes. Tier 3 persistence can be verified on demand.

## Deployment Notes

Record deployment-specific observations here (unusual behavior during deployment, error messages, blue team activity during deployment window). Prepend each note with a timestamp.
