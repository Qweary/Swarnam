---
name: "rotate"
description: "Respond to defensive team detection and remediation on a target. Logs the burned technique, recommends alternative approaches, and coordinates re-access. Usage: /rotate <target-ip> [--technique <what-was-burned>]"
---

# /rotate — Technique Rotation After Detection

## Workflow

When the operator detects that defensive team has remediated access or detected a technique on a target, invoke /rotate to coordinate the response.

### Step 1: Confirm the Burn

Ask the operator (or accept from the command arguments) what target was affected and what access was lost or detected. Determine: which specific persistence mechanism was removed (scheduled task? user account? SSH key?), whether the defensive team changed passwords (which invalidates credential-based access), whether the defensive team added firewall rules (which blocks network-based access), and whether the defensive team deployed additional monitoring (which changes the stealth calculus).

### Step 2: Log the Burned Technique

EVADE-001 appends an entry to coordination/BURNED-TECHNIQUES.md with the timestamp, target, technique that was burned, how detection was confirmed, and any inferred information about the defensive team's detection capability. This prevents the swarm from recommending the same technique on the same target.

Update TARGET-STATUS.md to reflect the current access state (downgrade from "owned" to "burned" if all access is lost, or note partial remediation if some persistence remains).

### Step 3: Check Remaining Access

Review coordination/PERSISTENCE-MANIFEST.md for any remaining persistence on the target that was not remediated. If the defensive team found one mechanism but others remain, verify the remaining mechanisms before assuming total loss. Recommend verification commands for the operator.

### Step 4: Generate Alternative Approach

Coordinate EXPLOIT-001, PERSIST-001, and EVADE-001 to produce a rotation plan.

EVADE-001 advises on what technique categories to avoid on this target (the same category as the burned technique, plus any related techniques the defensive team likely checked while remediating). EXPLOIT-001 recommends alternative access methods, prioritizing approaches from different technique categories and using different tools than the original access method. PERSIST-001 recommends alternative persistence mechanisms from a different category than what was burned.

The rotation plan should explicitly state what to avoid on this target, the recommended new access approach with exact commands, the recommended new persistence approach with exact commands, the timing recommendation (how long to wait before re-engaging, based on how recently the defensive team was actively remediating), and any diversionary actions to deploy on other targets to draw attention away.

### Step 5: Assess Strategic Impact

OPS-001 assesses whether this target is worth re-engaging immediately or whether the operator's time is better spent on other targets. If the defensive team has demonstrated strong detection capability on this target, it may be more efficient to focus on other targets and return later with a novel technique.

Log the rotation decision to coordination/DECISION-LOG.md.

## Example Invocations

```
/rotate 10.0.1.5
/rotate 10.0.1.5 --technique "scheduled task removed"
/rotate 10.0.3.10 --technique "password changed, SSH key removed"
```
