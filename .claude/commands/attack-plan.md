---
name: "attack-plan"
description: "Generate a prioritized attack plan for a specific target with ready-to-execute commands. Pulls all available recon data and produces ranked attack paths. Usage: /attack-plan <target-ip-or-hostname>"
---

# /attack-plan — Target-Specific Attack Plan Generation

## Workflow

When the operator invokes /attack-plan with a target, generate a complete attack plan with executable commands.

### Step 1: Gather Intelligence

Read coordination/RECON-FINDINGS.md for all available data on the target: open ports, service versions, OS fingerprint, identified vulnerabilities. Read coordination/TARGET-STATUS.md for current access state (is this a new target, or are we trying to regain access?). Read coordination/BURNED-TECHNIQUES.md for techniques that have already been detected on this target or similar targets.

If no recon data exists for the target, recommend running /scan-range against it first, but also suggest a quick inline scan that the operator can run immediately.

### Step 2: Classify the Target

Determine the target's tier and type. Is it a Windows domain controller (Kerberos + LDAP + DNS)? A Windows server? A Linux web server? A workstation? This classification drives which attack paths are most likely to succeed.

### Step 3: Generate Attack Paths

Invoke EXPLOIT-001 to produce ranked attack paths. Each path should include a descriptive name, the technique and tool to use, the exact command with all flags and the target's specific details filled in, the probability of success (high/medium/low based on service version and CCDC norms), the noise level (how much telemetry the attack generates), the expected outcome on success, and the immediate next step on success (typically "deploy persistence via PERSIST-001").

Organize paths into three tiers. Tier A attacks should be tried first — these are high-probability, fast attacks like default credential sprays, known CVEs for the detected service version, and null session access. Tier B attacks should be tried if Tier A fails — these include targeted brute force, web application exploitation, and service-specific attacks. Tier C attacks are fallback options that require more time or specific conditions.

### Step 4: Recommend Persistence Strategy

Before the operator begins the attack, have PERSIST-001 prepare persistence recommendations for the target's OS type. When access is achieved, the operator should know exactly what persistence to deploy without needing to invoke another agent.

### Step 5: Note Evasion Considerations

Have EVADE-001 flag any specific concerns for this target. Is this a team that has been detecting persistence quickly? Is this the AI blue team? Are there burned techniques to avoid?

### Step 6: Present the Plan

Present the complete attack plan to the operator in a clear, actionable format. The operator should be able to work through it top to bottom, executing commands and moving to the next option when one fails.

Log the attack plan to coordination/DECISION-LOG.md with the rationale for the prioritization.

## Example Invocations

```
/attack-plan 10.0.1.5
/attack-plan dc01.team3.local
/attack-plan 10.0.1.10 --phase2
```
