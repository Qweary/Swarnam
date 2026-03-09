---
name: "start-ops"
description: "Initialize a competition operations session. Verifies MCP connectivity, creates required directories, generates the competition wordlist, loads or initializes coordination files, checks for existing state from prior sessions, and briefs the operator on recommended priorities. Run this at the beginning of every competition session."
---

# /start-ops — Competition Session Initialization

## Workflow

When the operator invokes /start-ops, execute the following initialization sequence.

### Step 1: Verify Environment

Confirm we are running on a Kali Linux jumpbox with MCP access to Kali tools. Check that mcp-kali-server is reachable by running a simple command through MCP (such as `which nmap`). If MCP is unavailable, warn the operator and note that all tool execution will need to be done manually — the swarm can still generate commands but cannot execute them.

Verify direct tool availability on the jumpbox by checking for critical binaries:

```bash
for tool in nmap netexec hydra sqlmap msfconsole impacket-secretsdump evil-winrm smbclient ldapsearch snmpwalk hashcat john gobuster; do
    which $tool 2>/dev/null && echo "[OK] $tool" || echo "[MISSING] $tool"
done
```

Report any missing tools so the operator can install them before operations begin.

### Step 2: Create Required Directories and Infrastructure

Create the scans output directory and any missing coordination files:

```bash
mkdir -p coordination/scans
mkdir -p archive
```

Initialize any coordination files that don't already exist from the project templates. If coordination files already exist (resuming a session), do not overwrite them.

### Step 3: Generate Competition Wordlist

Generate the competition-specific password wordlist at `/tmp/ccdc-wordlist.txt`. This wordlist is referenced by EXPLOIT-001 for credential spraying and should include CCDC-common defaults plus competition-specific patterns.

```bash
cat > /tmp/ccdc-wordlist.txt << 'WORDLIST'
Password1!
P@ssw0rd
P@ssw0rd!
Changeme123
Changeme123!
Spring2026!
Winter2025!
Winter2026!
WRCCDC2026!
WRCCDC2026
Ccdc2026!
Password123
Password123!
Admin123!
Admin2026!
Welcome1!
Welcome123!
Company123!
Letmein123!
Qwerty123!
Summer2025!
Fall2025!
March2026!
P@ss1234
Passw0rd!
!@#$%^&*
Toor
toor
password
admin
root
changeme
default
WORDLIST
echo "[OK] Competition wordlist generated at /tmp/ccdc-wordlist.txt ($(wc -l < /tmp/ccdc-wordlist.txt) entries)"
```

Ask the operator if they have additional competition-specific passwords to add (organizer-provided defaults, passwords observed in prior invitationals, etc.) and append them.

### Step 4: Prepare Listener Infrastructure

Brief the operator on listener setup. They will need listeners ready before payloads are deployed. Recommend:

```bash
# Terminal 1: General-purpose netcat listener on a common callback port
rlwrap nc -lvnp 4444

# Terminal 2: Metasploit multi/handler for multiple simultaneous sessions
msfconsole -q -x "use exploit/multi/handler; set PAYLOAD windows/x64/meterpreter/reverse_tcp; set LHOST $(ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'); set LPORT 4445; set ExitOnSession false; exploit -j"

# Terminal 3: Secondary netcat for Linux targets
rlwrap nc -lvnp 4446
```

Record the jumpbox IP address for use in payloads throughout the session:

```bash
JUMPBOX_IP=$(ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
echo "[*] Jumpbox IP: $JUMPBOX_IP"
echo "JUMPBOX_IP=$JUMPBOX_IP" > /tmp/session-vars.txt
```

### Step 5: Load or Initialize Target Ranges

Ask the operator to confirm the target ranges for this session. The operator should provide the IP ranges assigned by competition organizers. Record these in coordination/TARGET-STATUS.md as the authorized scope.

If resuming a session, read the existing TARGET-STATUS.md to restore the operational picture. Report the current state: how many targets are owned, what persistence is active, and what needs immediate attention.

### Step 6: Check Existing State

Read all coordination files to assess current operational state. Specifically check TARGET-STATUS.md for owned systems that may need persistence verification, PERSISTENCE-MANIFEST.md for active persistence mechanisms, BURNED-TECHNIQUES.md for techniques to avoid, and OPERATION-LOG.md for the last recorded action.

If resuming from a prior session (especially Day 2 morning after an overnight gap), PERSIST-001 should generate verification commands for all active persistence. Any persistence that survived overnight is extremely valuable and should be validated immediately.

### Step 7: Verify ADS Tooling (Optional)

Check if the ADS project's tooling is available in the workspace (look for src/ADS-OneLiner.ps1 or payloads/ccdc-library.ps1). If available, note this for PERSIST-001 and PAYLOAD-001 integration.

### Step 8: Claim Operator Assignment

Ask the operator for their name/initials and which team ranges they will be working. Record this in TARGET-STATUS.md. If multiple operators are sharing the swarm, each should claim their assigned ranges to prevent duplication of effort. The convention is that an operator who begins work on a team range owns it until they explicitly release it or the session ends.

### Step 9: Brief the Operator

Produce a session startup brief that includes the current competition phase (estimate based on time of day and any existing operational state), the jumpbox IP and listener port assignments, a summary of the current operational picture (targets owned, persistence active, techniques burned), recommended immediate priorities based on the target tier framework, a reminder of the /scan-range → /attack-plan → persistence workflow, and any issues requiring operator attention.

### Step 10: Log Session Start

Append a session start entry to coordination/OPERATION-LOG.md with the timestamp, operator name, and session objectives.

## Example Invocation

```
/start-ops
```

The operator will then be prompted for target ranges if this is a new session, or will receive a state restoration brief if resuming.
