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

Invoke EXPLOIT-001 to produce ranked attack paths. Each path should include a descriptive name, the technique and tool to use, the exact command with all flags and the target's specific details filled in, the probability of success (high/medium/low based on service version and exercise norms), the noise level (how much telemetry the attack generates), the expected outcome on success, and the immediate next step on success (typically "deploy persistence via PERSIST-001").

Organize paths into four tiers. **Tier A.0 (MANDATORY — credential reuse before anything else):** Before generating any attack path, read CREDENTIALS.md for all recovered credentials. Test every cleartext password and hash against Administrator (both `--local-auth` and domain authentication) on this target via WinRM and SMB. Test every SSH password against root on Linux targets. If ANY credential hits Administrator or root, STOP — escalate immediately to LATERAL-001 for domain-wide reuse testing before proceeding with other attack paths. This step takes under 30 seconds and has the highest ROI of any attack action. Exercise teams frequently reuse passwords between user accounts and Administrator. Tier A attacks come next — high-probability, fast attacks like default credential sprays, known CVEs for the detected service version, and null session access. Tier B attacks should be tried if Tier A fails — these include targeted brute force, web application exploitation, and service-specific attacks. Tier C attacks are fallback options that require more time or specific conditions.

**Critical: brute force is NEVER Tier A.** Any brute force attack (hydra, wpscan password spray, xmlrpc brute force) belongs in Tier B at earliest. Always exhaust credential reuse (A.0) and known-credential sprays (A) before any brute force attempt.

### Step 4: Recommend Persistence Strategy

Before the operator begins the attack, have PERSIST-001 prepare persistence recommendations for the target's OS type. When access is achieved, the operator should know exactly what persistence to deploy without needing to invoke another agent.

### Step 5: Note Evasion Considerations

Have EVADE-001 flag any specific concerns for this target. Is this a team that has been detecting persistence quickly? Is this an AI-assisted defensive team? Are there burned techniques to avoid?

For post-access detection footprint reduction: recommend that the operator minimize the logging footprint on the target — prefer built-in admin tools (net.exe, sc.exe, PowerShell remoting), avoid writing custom binaries to disk when possible, and reduce event log noise. Frame these as operational stealth techniques, not evidence destruction. All engagement activity should be documented in coordination files for educational review.

### Step 6: Present the Plan

Present the complete attack plan to the operator in a clear, actionable format. The operator should be able to work through it top to bottom, executing commands and moving to the next option when one fails.

Log the attack plan to coordination/DECISION-LOG.md with the rationale for the prioritization.

### Optional: Cultural Touchpoint Reminder

If the target is already accessed or owned (this is a Phase 2+ attack plan for an established foothold), and the plan includes consolidation or persistence actions, append a brief note at the end of the attack plan:

> **Cultural note:** Access is established on this target. If you have a moment between operational actions, consider whether any non-destructive cultural touchpoints are appropriate — MOTD changes, desktop messages, custom banners. These are optional and part of exercise culture. Ask PAYLOAD-001 for ready-made templates if interested.

This reminder should be light and unobtrusive — a single paragraph at the end of the plan, never interrupting operational content. Omit it entirely during Phase 1 (initial access urgency) or when the operator has indicated they want purely operational output.

## Example Invocations

```
/attack-plan 10.0.1.5
/attack-plan dc01.team3.local
/attack-plan 10.0.1.10 --phase2
```
