# Target Status Board — TRAINING

This is the training instance of TARGET-STATUS.md. Used during training runs (/training-run) instead of the competition file (coordination/TARGET-STATUS.md). Reset to template state before each training run.

Maintained by: OPS-001 (Tactical Coordinator) during training runs, monitored by TRAIN-002
Purpose: live target tracking during training pipeline exercises

---

## Status Legend

UNKNOWN: not yet scanned.
SCANNED: reconnaissance complete, attack paths identified.
ATTEMPTING: active exploitation in progress.
ACCESSED: initial access established, persistence not yet deployed.
OWNED: persistent access established and verified.
PARTIAL: some access burned by blue team, partial persistence remains.
LOST: all access remediated by blue team, re-engagement needed.
BLOCKED: target unreachable (network change, shutdown, or firewall).

## Operator Claim

When multiple operators are training simultaneously, claim targets by adding your name to the Operator column before engaging. Do not engage targets claimed by another operator.

---

| IP | Hostname | OS | Role | Tier | Status | Access Method | Persistence | Last Verified | Operator | Notes |
|----|----------|----|------|------|--------|---------------|-------------|---------------|----------|-------|
| 10.100.100.25 | JEEP | Windows | AD Domain Controller (auto.auto) | 1 | OWNED | Administrator:OttoBot4TheWin! via WinRM; DCSync (krbtgt+Admin hashes) | schtask WindowsUpdateCheck (SYSTEM, hourly) | 2026-03-19 02:15 | Queue | Domain Admin. krbtgt NT: 1db16b46673148de692bc66209d75ed4. Golden ticket viable. |
| 10.100.100.79 | SUPRA | Windows | Web+DB (Apache/PHP 8.3, MySQL 9.1, WAMP) | 2 | OWNED | Administrator:OttoBot4TheWin! via WinRM | schtask WindowsUpdateCheck (SYSTEM, hourly) + local admin redteam:R3dT3am2026! | 2026-03-19 02:15 | Queue | MySQL (wampmysqld64) stopped. Backdoor local admin confirmed via SMB. |
| 10.100.100.200 | PTCRUISER | Windows | ASP.NET web server (Kestrel) | 2 | OWNED | Administrator:OttoBot4TheWin! via WinRM | schtask WindowsUpdateCheck (SYSTEM, hourly) | 2026-03-19 02:15 | Queue | WinRM Pwn3d!. Persistence deployed. |
| 10.100.100.2 | — | Linux | MinIO object storage | 2 | ACCESSED | minioadmin:minioadmin via MinIO S3 API/console | — | 2026-03-19 01:45 | Queue | FTP:21 returns 500 (MinIO stub) — use HTTP API :9000. Sensitive files exfiltrated. Lure files uploaded. |
| 10.100.100.88 | — | Windows | Web+DB (Apache/PHP 7.4, MySQL 5.6) | 2 | SCANNED | — | — | 01:27 | Queue | No WinRM. Older stack. |
| 10.100.100.240 | — | Linux (Ubuntu) | Monitoring/SIEM (OpenSearch Dashboards) | 2 | SCANNED | — | — | 01:27 | Queue | osd-name:explorer = likely Wazuh. Check default creds before spraying. |
| 10.100.100.60 | — | Windows | File sync (Syncthing 2.0.11) | 3 | SCANNED | — | — | 01:27 | Queue | No WinRM. Syncthing UI :80. |
| 10.100.100.30 | — | Linux | Web+DB (nginx, MySQL 5.6) | 3 | SCANNED | — | — | 01:27 | Queue | SSH+MySQL. Web app enum needed. |
| 10.100.100.12 | — | Unknown | Wiki.js documentation server | 3 | SCANNED | — | — | 01:27 | Queue | Wiki.js on :80/:443. Default admin creds. |
| 10.100.100.180 | — | Linux | Web server + Golang backend | 3 | SCANNED | — | — | 01:27 | Queue | Golang on :8443. Web enum needed. |
| 10.100.100.250 | — | Linux | Minimal Linux host | 3 | SCANNED | — | — | 01:27 | Queue | SSH+nginx only. Low-value. |
