# Burned Techniques Log

Maintained by EVADE-001. This is an append-only log of techniques that have been detected and remediated by defensive teams. Never delete entries — the historical record prevents the swarm from recommending burned techniques and provides educational material for post-engagement review.

Before recommending any technique on a target, check this file to ensure the technique (or its category) has not already been burned on that target.

## Log

| # | Timestamp | Target IP | Group | Technique Burned | Category | Detection Confirmed By | Suspected Detection Method | Remediation Observed | Alternative Recommended | Notes |
|---|-----------|-----------|------|-----------------|----------|----------------------|---------------------------|---------------------|------------------------|-------|
| | | | | | | | | | | |

## Category Reference

Categories for cross-referencing: TASK (scheduled tasks), REGISTRY (run keys), WMI (WMI subscriptions), SERVICE (service creation), CRON (cron jobs), SSHKEY (SSH keys), WEBSHELL (web shells), ACCOUNT (user accounts), CREDENTIAL (credential-based access after password change), NETWORK (network-based access after firewall change), TOOL (specific tool detected, e.g., Mimikatz signature), OTHER.

When a technique in a category is burned on a target, assume the defensive team checked for other techniques in the same category. Recommend alternatives from a different category.

## Defensive Team Detection Capability Assessment

Track observed detection capabilities per group to predict what will be detected in the future. Append assessments here as patterns emerge.
