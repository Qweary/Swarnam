# Reconnaissance Findings — TRAINING

This is the training instance of RECON-FINDINGS.md. Used during training runs instead of the competition file. Reset to template state before each training run.

Maintained by: RECON-001 (Reconnaissance Specialist) during training runs, monitored by TRAIN-002
Purpose: structured reconnaissance results from training pipeline exercises

---

## Scan Results

**Last updated:** 2026-03-19 01:27
**Scan status:** COMPLETE — nmap -sV quick scan against 10.100.100.0/24
**Live hosts found:** 11

| Target IP | Hostname | OS | Open Ports / Services | Role Guess | Attack Priority | Recommended Vectors |
|-----------|----------|----|-----------------------|------------|-----------------|---------------------|
| 10.100.100.25 | JEEP | Windows | 22(SSH-Win), 53(DNS), 80(IIS), 88(Kerberos), 135(RPC), 139(NetBIOS), 389(LDAP auto.auto), 443(HTTPS), 445(SMB), 636(LDAPS), 3389(RDP), 5985(WinRM) | AD Domain Controller — Domain: auto.auto | HIGH — TIER 1 | WinRM credential spray (5985), SMB PtH, Kerberoasting, DCSync if admin reached |
| 10.100.100.79 | — | Windows | 22(SSH-Win), 80(Apache/PHP 8.3), 135(RPC), 139(NetBIOS), 445(SMB), 3306(MySQL 9.1), 3389(RDP), 5985(WinRM), 8080(IIS) | Web+DB server (Apache PHP, likely WordPress) | HIGH — TIER 2 | WinRM spray (5985), WordPress admin login (/wp-admin), MySQL default creds (3306) |
| 10.100.100.200 | — | Windows | 22(SSH-Win), 80(Kestrel/ASP.NET), 135(RPC), 139(NetBIOS), 445(SMB), 3389(RDP), 5985(WinRM) | ASP.NET web application server | HIGH — TIER 2 | WinRM spray (5985), SMB shares, web app enumeration |
| 10.100.100.2 | — | Linux | 21(MinIO FTP), 22(SSH), 53(dnsmasq), 80(nginx), 8080(MinIO Console Go), 9000(MinIO S3 API Go) | MinIO object storage | MEDIUM — TIER 2 | MinIO default creds minioadmin/minioadmin on :9000 API and :8080 console; FTP returns 500 to all commands — use HTTP API only |
| 10.100.100.88 | — | Windows | 22(SSH-Win), 80(Apache/PHP 7.4.33), 135(RPC), 139(NetBIOS), 445(SMB), 3306(MySQL 5.6), 3389(RDP) | Web+DB server (Apache PHP, older stack) | MEDIUM — TIER 2 | WordPress/web app login, MySQL default creds, SMB null session; no WinRM |
| 10.100.100.240 | — | Linux (Ubuntu) | 21(vsftpd 3.0.5), 22(SSH), 80(nginx), 443(HTTPS — redirects /app/login, osd-name:explorer), 8080(nginx) | Monitoring/SIEM dashboard (OpenSearch Dashboards on 443) | MEDIUM — TIER 2 | Default creds on web dashboard (:443), FTP anonymous check, SSH spray |
| 10.100.100.60 | — | Windows | 22(SSH-Win), 80(Syncthing 2.0.11), 135(RPC), 139(NetBIOS), 445(SMB), 3389(RDP) | File sync server (Syncthing) | LOW — TIER 3 | Syncthing web UI default creds (:80), SMB shares; no WinRM |
| 10.100.100.30 | — | Linux | 22(SSH), 80(nginx), 3306(MySQL 5.6) | Web+DB server | LOW — TIER 3 | MySQL default creds (3306), SSH spray, web app enum |
| 10.100.100.12 | — | Unknown | 80(HTTP — Wiki.js), 443(HTTPS — Wiki.js) | Wiki.js documentation server | LOW — TIER 3 | Wiki.js admin default creds, web app enumeration |
| 10.100.100.180 | — | Linux | 22(SSH), 80(nginx), 443(HTTPS nginx), 8443(HTTPS Go) | Web server + Golang backend | LOW — TIER 3 | Web app enum on :80/:8443, SSH spray |
| 10.100.100.250 | — | Linux | 22(SSH), 80(nginx) | Minimal Linux host | LOW — TIER 3 | SSH spray, web enum |

## Key Findings

**Domain confirmed:** auto.auto (from LDAP banner on .25)
**DC hostname confirmed:** JEEP (from nmap service fingerprint)
**WinRM-accessible Windows hosts:** .25 (DC), .79 (web), .200 (web)
**MinIO FTP WARNING:** Port 21 on .2 returns 500 to all FTP commands — this is NOT a broken FTP server, it is MinIO's partial FTP implementation. Use the HTTP API on :9000 instead.
**Monitoring platform on .240:** osd-name:explorer in response headers = OpenSearch Dashboards — likely a SIEM. Check default creds before spraying.
