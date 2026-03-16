# Pass 3 - Blue Team Response Detection
# 2026-quals WRCCDC  |  Competition Date: 2026-02-07  |  Analysis: 2026-03-15

## Methodology
Blue team response was inferred from service availability changes (SYN-ACK present vs absent),
RST storm patterns, and by comparing scoring engine success rates across time samples.
No direct firewall log or IDS traffic was visible in the capture (inline tap sees network-layer only).

## Service Availability Over Time (SSH and HTTP hosts responding)
Sample | SSH hosts up | HTTP hosts up | Notes
08:43  | 0            | 0             | First 5 files: no SYN-ACKs from 10.100.100.x (hosts down or scanning not yet initiated)
09:03  | 43           | 8             | Services visible — teams still in setup mode, some up
09:20  | 5            | 3             | Sharp drop — possible blue team firewall deployment or scanning skew
09:50  | 1            | 10            | Further SSH reduction; HTTP more stable
10:16  | 63           | 55            | Spike — scoring engine polling creates large SYN-ACK sample
10:38  | 20           | 10            | Reduction again — possible firewall activity
11:00  | 4            | 9             | Late-competition state; fewer SSH hosts responding
11:17  | 2            | 33            | SSH almost gone; HTTP more responsive

Interpretation: The reduction in SSH-responding hosts from 43 (09:03) to 5 (09:20) is the
clearest evidence of blue teams firewalling SSH access after initial red team scanning.
Multiple teams appear to have blocked inbound SSH within approximately 17 minutes of the 09:03
scanner surge.

## RST Activity Analysis
At 09:50, 10.100.119.28 generated 58 RST packets directed at 10.223.97.64 (the SSH brute-forcer
targeting team 119). Pattern: established TCP sessions (ACK+PSH observed) followed by RST flood.
This is consistent with either:
1. SSH service dropping connections on auth failure
2. Blue team deploying connection limiting or TCP RST injection (iptables --reject-with tcp-reset)

## Blue Team Firewall Response Indicators
- 10.100.119.28 RST storm against 10.223.97.64 at 09:50 (SSH brute force response)
- 10.100.100.26 sent RSTs at 09:50 (16 RSTs) — possible firewall rule on HTTP port
- 10.100.100.14 sent RSTs at 09:50 (14 RSTs)
- 10.100.119.14 received RSTs from 10.223.97.64 at 09:50 (auth failures on LDAP port)

## Response Time Estimates
- Red team masscan begins: 08:43:14
- First SSH scanning against specific hosts: 09:03:42 (onset of 10.249.134.51 SSH scan)
- First SSH brute-force (targeted, team 102/119): 09:12:53
- SSH availability drop (43→5 hosts): between 09:03 and 09:20 = 17 minutes
- Estimated blue team SSH firewall deployment: 09:05–09:10 (within ~20 minutes of scanning start)
- WinRM lateral movement visible at 10:38 (about 115 minutes after competition start)

## Blue Team Tool Signatures
- Windows hosts (10.100.122.22) connecting to settings-win.data.microsoft.com at competition start
  Indicates Windows Update or policy download — standard blue team hardening activity
- 10.100.126.28 connecting to ctldl.windowsupdate.com for certificate revocation list update
- 10.100.1xx.16 hosts connecting to github.com — possible blue team pulling security scripts
- Multiple .28 hosts connecting to servers.openrct2.io (required scored service connection)

## Score Impact Assessment
WordPress service (10.100.125.20 /wordpress/) responded with failed login:
"The password you entered for the username admin is incorrect"
at 11:00 — scoring engine could not log in. WordPress password had been changed from default.
At 11:17, scoring engine successfully checks 10.100.104.20 /wordpress/ via heartbeat endpoint.

Victoria domain (/css/status_config.php) was accessible at 11:00 on 10.100.101.22.
MQTT-WS (port 8082) on 10.100.100.26 responding at 10:38.

## C2 Detection Opportunity
The /JSyausLR/LinIUpdater beacon pattern (curl GET every ~30-60 seconds to 10.230.87.61:80)
is highly detectable. No evidence of blue teams blocking 10.230.87.61 was observed —
the C2 remained active through at least 10:38. This suggests blue teams did NOT detect
the implant callback in the first 115 minutes of competition.

## Notable: Red Team Lateral Spread Before Blue Team Response
Timeline of host compromise (by C2 beacon first appearance):
- 09:03 — 10.100.101.2, 10.100.101.20, 10.100.105.2 (three team hosts compromised)
- 10:38 — 10.100.105.20, 10.100.105.240, 10.100.106.23, 10.100.106.26, 10.100.108.23

The 95-minute gap between first compromise (09:03) and lateral spread (10:38) suggests
the red team used the first ~90 minutes to establish footholds and credential spray (10:32),
then deployed the implant to newly-compromised hosts.
