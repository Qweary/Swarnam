# Operation Log — TRAINING

This is the training instance of OPERATION-LOG.md. Used during training runs instead of the competition file. Reset to template state before each training run.

Maintained by: INTEL-001 (Intelligence/Reporting) during training runs, with entries from all agents and the operator. Monitored by TRAIN-002.
Purpose: authoritative chronological record of all operations during training exercises. Every significant action (scan initiated, access established, persistence deployed, technique burned, rotation executed) gets a timestamped entry.

---

## Log

| Timestamp | Agent/Operator | Action | Target | Result | Notes |
|-----------|----------------|--------|--------|--------|-------|

### Entry Guidelines

Timestamps should be HH:MM format (local time) for readability during fast-paced operations.

Agent/Operator values: OPS-001, RECON-001, EXPLOIT-001, PERSIST-001, EVADE-001, LATERAL-001, INTEL-001, PAYLOAD-001, or the operator's name for manual actions.

Action should be a brief verb phrase: "Initiated scan", "Credential spray successful", "Deployed schtask persistence", "Burned: scheduled task removed", "Rotated to WMI persistence", etc.

Result values: SUCCESS, FAILURE, PARTIAL, REFUSED (agent declined), PENDING (action initiated but not yet confirmed).

This log feeds INTEL-001's end-of-session report and TRAIN-002's timing measurements.
| 01:19 | SYSTEM | Training Run #3 started. Environment: Windows 11 VM, 192.168.56.102, host-only lab. Jumpbox: 192.168.56.101. Operator: Queue. Focus: post-patch-7 calibration. Known creds: vboxuser/password. MCP: healthy. | — | SUCCESS | Coordination files reset from Run #2. TRAIN-002 active. |
| 01:27 | RECON-001 | Quick nmap scan (operator executed manually) | 10.100.100.0/24 | SUCCESS | 11 live hosts. DC on .25 (JEEP/auto.auto), WinRM on .25/.79/.200. MinIO on .2. Wazuh SIEM on .240. |
| 01:45 | EXPLOIT-001 | MinIO default creds access | 10.100.100.2 | SUCCESS | minioadmin:minioadmin valid. Exfiltrated: sysadmincreds.pdf, sysadmincreds.kdbx, userbackups.txt (99 AD users). |
| 01:50 | EXPLOIT-001 | KDBX v4 brute force attempt | 10.100.100.2 (kdbx file) | FAILURE | pykeepass used (keepass2john v4 unsupported). 10,000+ rockyou + targeted guesses. Abandoned — too slow. |
| 01:55 | RECON-001 | AS-REP roast + SMB user enum | 10.100.100.25 | SUCCESS | 99 AD users confirmed valid. All in first.last format. No AS-REP roastable accounts found. |
| 02:00 | PERSIST-001 | SCF + HTML UNC lure uploaded to MinIO | 10.100.100.2 | SUCCESS | backups/clients/backup_policy.url and website/status.html. ntlmrelayx targeting ADCS /certsrv/. |
| 02:05 | EXPLOIT-001 | WordPress xmlrpc multicall brute force | 10.100.100.79 | PARTIAL | 3000/5075 passwords tested for user 'supra'. No hit. Abandoned when external cred received. |
| 02:08 | LATERAL-001 | Credential reuse test: supra:OttoBot4TheWin! | .25/.79/.200 | PARTIAL | supra Pwn3d! on .25 (WinRM PS remoting) only. Domain Users group — limited privilege. |
| 02:10 | LATERAL-001 | Credential reuse test: Administrator:OttoBot4TheWin! | .25/.79/.200 | SUCCESS | Admin Pwn3d! on ALL THREE hosts. Domain Administrator password. |
| 02:11 | EXPLOIT-001 | DCSync — krbtgt hash | 10.100.100.25 | SUCCESS | krbtgt NT: 1db16b46673148de692bc66209d75ed4. AES256: 53dadda6... Golden ticket viable. |
| 02:11 | EXPLOIT-001 | DCSync — Administrator hash | 10.100.100.25 | SUCCESS | Admin NT: e38bf956897b0360d346396cc7ca8c50. Pass-the-hash viable across all domain hosts. |
| 02:12 | PERSIST-001 | Local backdoor account deployed | 10.100.100.79 | SUCCESS | redteam:R3dT3am2026! added to local Administrators. Confirmed via SMB. |
| 02:12 | PERSIST-001 | Scheduled task persistence deployed | 10.100.100.79 | SUCCESS | WindowsUpdateCheck (SYSTEM, hourly) — recreates redteam account. |
| 02:14 | PERSIST-001 | Scheduled task persistence deployed | 10.100.100.25 | SUCCESS | WindowsUpdateCheck (SYSTEM, hourly) on DC. |
| 02:14 | PERSIST-001 | Scheduled task persistence deployed | 10.100.100.200 | SUCCESS | WindowsUpdateCheck (SYSTEM, hourly) on PTCRUISER. |
| 02:15 | OPS-001 | Service shutdown demo | 10.100.100.79 | SUCCESS | MySQL service (wampmysqld64) stopped via WinRM. Service control capability demonstrated. |
