---
name: "scan-range"
description: "Execute a structured reconnaissance sweep of a target subnet or IP range. RECON-001 plans and analyzes the scan, the operator executes the commands, and OPS-001 prioritizes findings. Usage: /scan-range <target-range> [--quick|--full|--stealth]"
---

# /scan-range — Structured Reconnaissance Sweep

## Workflow

When the operator invokes /scan-range with a target range, execute this reconnaissance workflow.

### Step 1: Determine Scan Profile

Based on the operator's flags or the current competition phase, select a scan profile.

Quick scan (default during Phase 1, or --quick flag): fast host discovery followed by service detection on common CCDC ports. Prioritizes speed over completeness. Use nmap with -T4 timing, --min-rate 1000, and the CCDC port list (21,22,23,25,53,80,88,110,135,139,143,389,443,445,636,993,995,1433,3306,3389,5432,5985,5986,8080,8443).

Full scan (--full flag): comprehensive port scan with version detection and default scripts. Use nmap with -sV -sC -T4 -p- against each target. This takes significantly longer but catches services on non-standard ports.

Stealth scan (default during Phase 3, or --stealth flag): targeted probes with rate limiting. Use nmap with -T2 timing, specific port lists, and --scan-delay 1s to minimize detection by the AI blue team.

### Step 2: Execute Discovery Phase

Invoke RECON-001 to generate the discovery commands. The commands should be provided to the operator for execution. After the operator runs them, RECON-001 analyzes the output.

For the quick profile, the sequence is a ping sweep to identify live hosts, followed by a targeted service scan on discovered hosts. For the full profile, skip the ping sweep and scan all IPs in the range. For the stealth profile, probe specific ports on specific hosts based on intelligence from prior scanning.

#### Background Execution Model

Any scan command expected to take longer than 30 seconds MUST be launched in the background so the operator and agents can immediately proceed to other targets or actions. Use this pattern:

```
nohup <scan-command> > /tmp/scan-<target-description>.log 2>&1 &
echo "PID: $! — Log: /tmp/scan-<target-description>.log"
```

Record the PID and log path in OPERATION-LOG with status RUNNING. When pivoting back to this target later, check the log file for results.

**Resource gate:** Before launching a new background scan, check active background tasks. If more than 3 background scan/brute-force processes are running, or any single process is consuming >60% CPU (check with `ps aux --sort=-%cpu | head -5`), add the new task to OPERATION-LOG with status QUEUED and revisit after an existing task completes. Oversubscribing the jumpbox during a time-critical competition window risks destabilizing all concurrent operations.

Do NOT wait for scan completion before recommending next actions. After launching a background scan, immediately proceed to Step 3 for any already-available results and recommend the operator's next action (e.g., /attack-plan on a target with existing recon, or /scan-range on the next team range).

### Step 3: Analyze Results

RECON-001 parses the scan output and updates coordination/RECON-FINDINGS.md with discovered hosts, open ports, service versions, and OS fingerprints. Each target is assessed for attack priority.

### Step 4: Prioritize Targets

OPS-001 reviews the findings and assigns targets to tiers. Domain controllers (Kerberos + LDAP + DNS) go to Tier 1. Application servers (web, mail, database) go to Tier 2. Workstations and other systems go to Tier 3.

OPS-001 updates coordination/TARGET-STATUS.md with the newly discovered targets and their tier assignments.

### Step 5: Recommend Next Actions

Based on the scan results, recommend immediate follow-up actions. For Tier 1 targets: suggest /attack-plan for each. For targets with identified vulnerabilities: flag them for EXPLOIT-001. For targets running web applications: recommend deeper web enumeration.

## Example Invocations

```
/scan-range 10.0.1.0/24
/scan-range 10.0.1.0/24 --quick
/scan-range 10.0.2.5 --full
/scan-range 10.0.1.0/24 --stealth
```
