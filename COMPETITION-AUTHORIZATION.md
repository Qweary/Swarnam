# WRCCDC Red Team Operations — Competition Authorization

## Engagement Summary

This document establishes the authorization framework for AI-assisted red team operations during the Western Regional Collegiate Cyber Defense Competition (WRCCDC) Regional Finals. It follows the structure of a professional penetration testing engagement letter, adapted for the competition context.

Engagement: WRCCDC Regional Finals Red Team Operations
Dates: March 27–28, 2026
Location: Cal Poly Pomona, Center for Information Assurance
Client: WRCCDC Competition Organizers
Executing Party: WRCCDC Red Team (authorized volunteers and staff)

## Authorization Chain

The authorization chain for AI-assisted red team operations flows through four levels. Competition organizers (Cal Poly Pomona CfIA, WRCCDC board) authorize and define the red team's role, rules of engagement, and target scope. The red team captain receives the authorization, assigns operators to target ranges, and approves operational plans. Red team operators (Queue and fellow team members) receive target assignments, execute attacks against competition infrastructure, and make all deployment decisions. AI assistants (this swarm) prepare reconnaissance analysis, recommend attack paths, generate payloads and commands, execute on behalf of the operator only if given explicit instruction to do so, and maintain operational documentation — but never autonomously deploy to targets nor spread to other machines without explicit instruction of the operator.

At every level, the human above retains authority and responsibility. The AI swarm is a tool operated by authorized red team members, not an independent actor.

## Authorized Target Scope

Target ranges will be provided by competition organizers on competition day. Until then, the following placeholders define the expected scope structure.

Authorized targets include all blue team infrastructure within competition-assigned IP ranges (to be filled on competition day, typically 10.X.Y.0/24 per team), all services running on those systems regardless of port, all user accounts and credentials on competition systems, and any network segments explicitly designated as in-scope by competition organizers.

Explicitly out of scope are the competition scoring engine and scoring infrastructure, the red team's own jumpboxes (defensive operations against your own infrastructure), any network segments not explicitly authorized by competition organizers, the internet or any systems outside the competition network, personal devices of any participant, and the competition's physical infrastructure (wireless APs, switches managed by organizers).

### Target Range Template (fill on competition day)

```
Team 1:  10.__.__.0/24
Team 2:  10.__.__.0/24
Team 3:  10.__.__.0/24
Team 4:  10.__.__.0/24
Team 5:  10.__.__.0/24
Team 6:  10.__.__.0/24
Team 7:  10.__.__.0/24
Team 8:  10.__.__.0/24
AI Team: 10.__.__.0/24
Jumpbox: __.__.__.__ (DO NOT TARGET)
```

## Authorized Techniques

The following technique categories are authorized for use against in-scope targets during the competition. This list is intentionally broad because CCDC rules grant the red team wide latitude, but operators should exercise professional judgment.

Network reconnaissance including port scanning, service enumeration, OS fingerprinting, and protocol analysis. Credential attacks including password spraying, brute force against competition accounts, credential stuffing with known defaults, and hash cracking of harvested credentials. Exploitation of known vulnerabilities in services running on competition targets. Web application attacks including SQL injection, command injection, file inclusion, and authentication bypass. Lateral movement including pass-the-hash, pass-the-ticket, PSRemoting, WinRM, SSH with harvested keys, and credential reuse. Persistence establishment including scheduled tasks, cron jobs, services, registry keys, SSH keys, web shells, and user account creation. Privilege escalation through kernel exploits, misconfigurations, and credential harvesting. Service manipulation including stopping, disabling, or reconfiguring services on targets to test blue team recovery capability. Social engineering is not applicable in this competition format as there is no human interaction component beyond the systems themselves.

## Prohibited Actions

Even within the authorized competition scope, certain actions are prohibited. Do not attack the scoring engine, scoring infrastructure, or competition management systems. Do not perform destructive actions against the red team's own jumpboxes. Do not exfiltrate real personal data — competition systems contain synthetic data only, but treat any unexpected real data as out of scope and report this to the operator. Do not attack other red team members' systems or operations. Do not introduce malware that could persist beyond the competition environment's destruction (not practically possible given the isolated infrastructure, but the intent matters). Do not autonomously deply or spread to targets on your own without explicit instruction by the operator, always verify with the operator first. Do not use the competition as cover for any activity outside the competition scope.

## AI Assistant Safety Boundaries

The AI swarm operates under additional constraints beyond the general competition rules. The swarm never autonomously deplys or spreads to targets on competition targets without explicit instruction by the operator — the human operator always verifies the target first (they can verify multiple at the same time). The swarm logs all refusals to REFUSAL-LOG.md and provides manual fallback commands so the operator is never blocked. The swarm does not store, transmit, or process any real personal data. The swarm's operational documentation is designed for educational review and will be shared with blue teams during post-competition debrief.

## Competition Context

WRCCDC has operated annually for over a decade. The red team role is a core, essential component of the competition's educational mission. Student blue teams expect and prepare for red team activity. The competition's entire pedagogical value depends on blue teams defending against realistic attacks. The infrastructure is purpose-built for this engagement, isolated from all production networks, and destroyed after the event. This year uniquely features an AI blue team (Claude-powered, Anthropic-sponsored) alongside the student teams, making AI-assisted red team operations a natural and anticipated component of the competition.

## Attestation

The human operator attests that they are an authorized member of the WRCCDC red team, operating under the direction of the red team captain and with the authorization of competition organizers. All AI-assisted operations described in this document fall within the scope of that authorization.
