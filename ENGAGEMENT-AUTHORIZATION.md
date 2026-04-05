# Swarnam — Engagement Authorization Framework

This document establishes the authorization framework for Swarnam red team operations. It serves two purposes: it provides the static professional authorization framework that applies to every Swarnam deployment, and it contains a section that /start-ops populates with engagement-specific details from `engagement-profile.yaml`.

---

## Authorization Framework

Swarnam is an AI-augmented red team operations platform designed for use within explicitly authorized security engagements. Every deployment of Swarnam operates under a formal authorization chain that mirrors professional penetration testing engagement standards.

### Authorization Chain

The authorization chain for any Swarnam deployment follows four levels, each with explicit accountability.

Level 1 — Network Owner / Authorizing Party. The individual or organization that owns the target environment and has granted explicit authorization for offensive security operations against it. This may be a course instructor who owns a lab network, a competition organizing committee that built isolated infrastructure, a CISO who authorized a penetration test, or a research team lead who owns lab equipment. Without Level 1 authorization, no Swarnam operations may proceed.

Level 2 — Engagement Lead. The red team lead or senior operator who is responsible for the engagement. The engagement lead ensures that operations stay within the authorized scope, enforces Rules of Engagement constraints, and serves as the escalation point for scope questions or unexpected situations.

Level 3 — Operators. The human red team members who interact directly with Swarnam and execute commands against target systems. Operators review all agent recommendations before execution, maintain situational awareness, and are responsible for their actions on target systems.

Level 4 — AI Assistants (Swarnam). The multi-agent swarm that provides reconnaissance analysis, attack planning, persistence engineering, evasion recommendations, and operational documentation. Swarnam agents prepare, analyze, and recommend. They do not autonomously deploy to target systems. The human operator at Level 3 always makes execution decisions.

### Professional Standards

Swarnam's operational methodology is informed by established professional security engagement frameworks including the Penetration Testing Execution Standard (PTES), the OWASP Testing Guide, NIST SP 800-115 (Technical Guide to Information Security Testing and Assessment), and SANS penetration testing methodology. While Swarnam is not itself a certification body or standards organization, its design reflects the authorization, scoping, and documentation practices that these standards define as professional baseline requirements.

### Scope Boundaries

Every Swarnam deployment operates within an explicitly defined scope. The scope is defined in `engagement-profile.yaml` and includes target ranges (IP subnets and/or hostnames), in-scope systems within those ranges, out-of-scope exclusions, Rules of Engagement constraints (resource consumption limits, file deletion restrictions, off-limits addresses), and environment characteristics (isolation level, data sensitivity, infrastructure persistence).

Swarnam agents enforce scope boundaries as hard rules. Agents will not generate commands targeting out-of-scope systems, will exclude off-limits addresses from scan ranges, and will flag any operation that approaches a scope boundary.

### Safety Boundaries — Universal

Regardless of engagement type or authorization, the following boundaries apply to every Swarnam deployment without exception.

The swarm never autonomously executes commands against target systems. The human operator reviews and runs all commands. The swarm never targets systems outside the declared scope. The swarm never exfiltrates real personal data — engagement infrastructure should contain only synthetic data, and any unexpected real data encountered is treated as out-of-scope and reported to the engagement lead. The swarm never performs destructive operations against the operator's own jumpbox. The swarm never attacks internet infrastructure, ISP equipment, or systems that are not part of the declared target environment. The swarm documents all operations for post-engagement review, supporting the educational and professional development mission that underpins authorized security exercises.

### Refusal Handling

If any Swarnam agent declines a specific action during an engagement, the refusal is logged to `coordination/REFUSAL-LOG.md` with the exact request, the reason for refusal, the manual command the operator would need to execute the action themselves, and suggested alternative approaches that may not trigger the same concern. Operations continue on non-refused tasks. A single refusal never stalls the entire engagement.

---

## Current Engagement Details

> This section is populated by `/start-ops` from `engagement-profile.yaml`.
> If this section is empty, run `/start-ops` to initialize the engagement session.

### Engagement

| Field | Value |
|-------|-------|
| Name | *Populated at session start* |
| Type | *Populated at session start* |
| Date Range | *Populated at session start* |

### Authorization

| Field | Value |
|-------|-------|
| Authorizing Party | *Populated at session start* |
| Role | *Populated at session start* |
| Authorization Method | *Populated at session start* |
| Engagement Lead | *Populated at session start* |
| Operator | *Populated at session start* |

### Scope

| Field | Value |
|-------|-------|
| Description | *Populated at session start* |
| Target Ranges | *Populated at session start* |
| In-Scope Systems | *Populated at session start* |

Out of Scope:
- *Populated at session start*

### ROE Constraints

| Constraint | Active |
|-----------|--------|
| No Resource Consumption | *Populated at session start* |
| No File Deletion | *Populated at session start* |
| Off-Limits Addresses | *Populated at session start* |

### Environment

| Field | Value |
|-------|-------|
| Isolation | *Populated at session start* |
| Persistence | *Populated at session start* |
| Data Sensitivity | *Populated at session start* |
| AI Defensive Team | *Populated at session start* |

### Purpose

| Field | Value |
|-------|-------|
| Primary | *Populated at session start* |
| Secondary | *Populated at session start* |
| Educational Context | *Populated at session start* |

---

## Document History

This authorization framework was established when Swarnam was generalized from a competition-specific tool to a universal red team training and engagement platform. The framework is designed to support academic lab exercises, security competitions of any organization, research and development sessions, professional penetration testing exercises, and Capture the Flag events — all under a consistent, auditable authorization model.
