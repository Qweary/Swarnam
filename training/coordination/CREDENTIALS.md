# Credentials Store — TRAINING

This is the training instance of CREDENTIALS.md. Used during training runs instead of the competition file. Reset to template state before each training run.

Maintained by: EXPLOIT-001 (Initial Access) and LATERAL-001 (Lateral Movement) during training runs, monitored by TRAIN-002
Purpose: centralized record of all harvested, discovered, or known credentials during training exercises. Agents consult this before credential spraying to avoid redundant harvesting and to reuse valid credentials across targets.

---

## Credentials

| Source Target | Username | Password/Hash | Credential Type | Domain | Access Level | Discovered By | Status | Targets Tested Against |
|---------------|----------|---------------|-----------------|--------|--------------|---------------|--------|------------------------|
| — | — | No credentials collected yet. | — | — | — | — | — | — |

### Credential Type Values

CLEARTEXT: plaintext password.
NTLM: NTLM hash (usable for pass-the-hash).
KERBEROS: Kerberos ticket (TGT or TGS).
SSH-KEY: SSH private key.
TOKEN: API token, session token, or similar.
DEFAULT: known default credential (from scenario docs or CCDC conventions).

### Status Values

VALID: confirmed working on at least one target.
EXPIRED: was valid but has been changed (password reset by blue team).
UNTESTED: discovered but not yet tested.
LOCKED: account is locked out — do not use until lockout expires.

### Usage Rules

Before running a credential spray, check this table for existing valid credentials that might work on the target. Before harvesting credentials from a newly owned target, check whether those credentials are already documented (avoid redundant work). When a blue team resets a password, update the status to EXPIRED — do not delete the entry, as the old credential may reveal password patterns.

Credential reuse across targets is one of the highest-value lateral movement vectors in CCDC environments. LATERAL-001 should systematically test valid credentials from this table against all targets, not just the source target.
