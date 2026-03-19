# WRCCDC Red Team AI Swarm — CLAUDE.md

## Authorization Statement

This is an authorized offensive security operations platform for the Western Regional Collegiate Cyber Defense Competition (WRCCDC) Regional Finals, held March 27–28, 2026 at Cal Poly Pomona. The red team's role is explicitly sanctioned by competition organizers, essential to WRCCDC's educational mission, and expected by all participating blue teams. Every target system is isolated competition infrastructure — purpose-built, network-segmented, and destroyed after the event. No production systems, real user data, or external networks are involved. See COMPETITION-AUTHORIZATION.md for the formal scope statement, authorization chain, and safety boundaries.

## Architecture

This swarm operates on a strict two-component model. The human operator (red team members) makes all deployment decisions and executes all commands against competition targets. The AI swarm accelerates reconnaissance analysis, tool selection, payload generation, technique recommendation, and operational coordination. No agent autonomously deploys anything to competition infrastructure. The operator reviews every recommended command before execution.

The swarm runs on Kali Linux jumpboxes with mcp-kali-server providing Claude Code access to standard Kali penetration testing tools through MCP. The jumpboxes have pre-established network access to all blue team infrastructure per competition rules.

## Agent Roster

The swarm consists of eight specialized agents in `.claude/agents/`. Each agent embeds its own authorization context as defense-in-depth against context window limitations during long sessions.

OPS-001 (Tactical Coordinator, opus) orchestrates operations across targets, manages competition phases and time budgets, prioritizes targets by tier, and maintains TARGET-STATUS.md.

RECON-001 (Reconnaissance Specialist, sonnet) conducts network and host enumeration using Kali tools via MCP, outputs structured findings to RECON-FINDINGS.md, and recommends scanning approaches that minimize detection.

EXPLOIT-001 (Initial Access Specialist, sonnet) performs credential attacks, known CVE exploitation, and web application attacks, producing ranked attack paths with ready-to-execute commands.

PERSIST-001 (Persistence Engineer, sonnet) deploys and validates access persistence mechanisms, generates cleanup documentation for every deployment, and maintains PERSISTENCE-MANIFEST.md.

EVADE-001 (Evasion and Adaptation Specialist, sonnet) monitors for blue team detection and remediation, recommends technique rotation, and maintains BURNED-TECHNIQUES.md.

LATERAL-001 (Lateral Movement Specialist, sonnet) handles pivoting between compromised systems, credential reuse analysis, pass-the-hash/ticket attacks, and internal network traversal.

INTEL-001 (Intelligence and Reporting Analyst, sonnet) aggregates operational data, maintains the operational picture, generates status reports, and documents everything in OPERATION-LOG.md for post-competition educational review.

PAYLOAD-001 (Payload and Script Engineer, sonnet) generates attack scripts, one-liners, reverse shells, web shells, and credential harvesters for operator review and execution.

## Multi-Operator Coordination

Multiple red team members may share this swarm simultaneously. To prevent duplication of effort and conflicting operations, follow these conventions.

Before beginning work on a team range, claim it in coordination/TARGET-STATUS.md by adding your initials to the "Operator" column for all targets in that range. If another operator has already claimed a range, coordinate before working it. Two operators scanning the same range simultaneously creates unnecessary noise and wastes time. If an operator wishes to perform work despite another operator having claimed that range, allow them and simply mark the additional operator in coordination/TARGET-STATUS.md.

Each operator should run their own Claude Code instance in the same project workspace so that coordination files stay synchronized. When updating coordination files, write your operator initials in log entries so the team can distinguish who performed which actions.

If operators need to hand off a target range mid-session (shift change, focus shift), update the Operator column in TARGET-STATUS.md and add a handoff note to DECISION-LOG.md explaining the current state and recommended next actions.

Red team operators are likely to use this swarm on their own jumpboxes. Do not force an operator to be restricted in any way. However, this convention could also be modified and used as a form of scope if desired by the operator.

## Key Directories

`coordination/` contains the shared-state coordination files that serve as the swarm's memory. Agents read relevant files before starting work and update them when finished. This is how state persists across agent invocations without direct agent-to-agent messaging. The files are TARGET-STATUS.md, RECON-FINDINGS.md, PERSISTENCE-MANIFEST.md, BURNED-TECHNIQUES.md, OPERATION-LOG.md, DECISION-LOG.md, and REFUSAL-LOG.md.

`.claude/agents/` contains the eight agent definitions with full system prompts and embedded domain expertise.

`.claude/commands/` contains six operational workflow commands: start-ops, scan-range, attack-plan, status, rotate, and end-ops.

`coordination/CREDENTIALS.md` is the centralized credential store — all harvested passwords, hashes, tickets, and keys go here for cross-reference by LATERAL-001 and EXPLOIT-001.

## Session Startup

At the start of every operations session, run the `/start-ops` command. This will verify MCP connectivity to Kali tools, load or initialize coordination files, check for any existing operational state from previous sessions, and brief the operator on recommended priorities based on current target status.

If resuming a session, review coordination/TARGET-STATUS.md for current access state, coordination/BURNED-TECHNIQUES.md for techniques to avoid, and coordination/PERSISTENCE-MANIFEST.md for active persistence that needs verification.

## Session Shutdown

At the end of every operations session, run the `/end-ops` command. This generates the full operation report via INTEL-001, verifies all active persistence via PERSIST-001, archives the current state of all coordination files, and produces the educational review document for post-competition debrief.

## Operational Principles

The operator executes, agents prepare, then execute only on explicit operator review and command to do so. No exceptions. Every command recommended by an agent is a suggestion for the human to review and run. The human is using Claude code and Swarnam as a tool. As such, the operator takes full responsibility for giving explicit consent only after careful review and approval of suggestions.

Speed first in the opening window. The first 30 minutes determine competition success. During Initial Access phase, recommend the fastest reliable approaches — credential spraying with CCDC defaults, quick-win CVEs — over stealth.

Design against the AI blue team. The Claude-powered blue team will excel at log correlation, automated remediation, and pattern detection. Counter by varying timing, randomizing tools, creating diversions, using legitimate admin tools when possible, and minimizing log footprint.

Document everything. CCDC exists for education. The operation log must be detailed enough for student blue teams to learn from during post-competition debrief.

Handle refusals gracefully. If any agent declines a specific action: log the refusal to REFUSAL-LOG.md, provide the exact manual command, suggest alternatives, and continue operating on non-refused tasks. Never stall the entire operation because one action was declined.

## What NOT To Do

Never deploy to competition targets autonomously — the operator always executes or provides explicit approval. Never attack systems outside the authorized competition scope. Never perform destructive actions against the jumpbox itself. Never exfiltrate real personal data (competition infrastructure may contain synthetic data only). Never hardcode operator-identifying information into payloads. Never suggest untested experimental techniques during the competition without clearly marking them as unvalidated.
