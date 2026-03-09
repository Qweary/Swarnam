---
name: "start-ops"
description: "Initialize a competition operations session. Verifies MCP connectivity, loads or initializes coordination files, checks for existing state from prior sessions, and briefs the operator on recommended priorities. Run this at the beginning of every competition session."
---

# /start-ops — Competition Session Initialization

## Workflow

When the operator invokes /start-ops, execute the following initialization sequence.

### Step 1: Verify Environment

Confirm we are running on a Kali Linux jumpbox with MCP access to Kali tools. Check that mcp-kali-server is reachable by running a simple command through MCP (such as `which nmap`). If MCP is unavailable, warn the operator and note that all tool execution will need to be done manually — the swarm can still generate commands but cannot execute them.

Check that the coordination directory exists and contains the expected files. If this is a fresh session (no existing coordination files), initialize them from the templates in this project.

### Step 2: Load or Initialize Target Ranges

Ask the operator to confirm the target ranges for this session. The operator should provide the IP ranges assigned by competition organizers. Record these in coordination/TARGET-STATUS.md as the authorized scope.

If resuming a session, read the existing TARGET-STATUS.md to restore the operational picture. Report the current state: how many targets are owned, what persistence is active, and what needs immediate attention.

### Step 3: Check Existing State

Read all coordination files to assess current operational state. Specifically check TARGET-STATUS.md for owned systems that may need persistence verification, PERSISTENCE-MANIFEST.md for active persistence mechanisms, BURNED-TECHNIQUES.md for techniques to avoid, and OPERATION-LOG.md for the last recorded action (helps the team pick up where they left off).

### Step 4: Verify ADS Tooling (Optional)

Check if the ADS project's tooling is available in the workspace (look for src/ADS-OneLiner.ps1 or payloads/ccdc-library.ps1). If available, note this for PERSIST-001 and PAYLOAD-001 integration.

### Step 5: Brief the Operator

Produce a session startup brief that includes the current competition phase (estimate based on time of day and any existing operational state), a summary of the current operational picture, recommended immediate priorities based on the target tier framework, and any issues requiring operator attention (MCP connectivity problems, unverified persistence, burned techniques on high-value targets).

### Step 6: Log Session Start

Append a session start entry to coordination/OPERATION-LOG.md with the timestamp, operator name (ask if not known), and session objectives.

## Example Invocation

```
/start-ops
```

The operator will then be prompted for target ranges if this is a new session, or will receive a state restoration brief if resuming.
