# TOOL POLICY — Execution Permission Registry

**Version:** 1.0.0 (Basic Edition)
**Classification:** Public — Product Template

---

## 1. Purpose

This document defines the **Least Privilege execution model** for all tools available to this agent. Every tool is explicitly classified by permission tier, and no tool executes without a matching authorization check against the requesting principal's trust level.

---

## 2. Permission Tier Definitions

| Tier | Label | Description |
|------|-------|-------------|
| `T0` | **BLOCKED** | Physically disabled. Cannot be invoked under any circumstances. Remove from runtime configuration. |
| `T1` | **OWNER_ONLY** | Restricted to principals with `OWNER` trust level. |
| `T2` | **DELEGATE** | Available to `OWNER` and authenticated `DELEGATE` principals. |
| `T3` | **AUTHENTICATED** | Available to any authenticated (non-anonymous) principal. |
| `T4` | **PUBLIC** | Available to all principals, including unauthenticated ones. |

---

## 3. Tool Registry

### 3.1 System & Configuration Tools

| Tool Name | Default Tier | Justification |
|-----------|-------------|---------------|
| `reload_config` | `T1 — OWNER_ONLY` | Reloads security configuration from disk. Direct system impact. |
| `view_policy` | `T1 — OWNER_ONLY` | Exposes internal policy content. Must never be accessible to untrusted principals. |
| `set_permission` | `T1 — OWNER_ONLY` | Modifies trust levels of other principals. Critical escalation risk. |
| `audit_log_view` | `T1 — OWNER_ONLY` | Exposes recorded interaction history. Privacy-sensitive. |
| `shutdown` | `T1 — OWNER_ONLY` | Terminates the agent process. Availability impact. |

### 3.2 Operational Tools

| Tool Name | Default Tier | Justification |
|-----------|-------------|---------------|
| `run_command` | `T1 — OWNER_ONLY` | Executes arbitrary shell commands on the host. Maximum risk. |
| `read_file` | `T2 — DELEGATE` | Reads files from the agent's workspace. Scope-limited to `/workspace`. |
| `write_file` | `T1 — OWNER_ONLY` | Writes files. Potential for data destruction or malicious injection. |
| `delete_file` | `T0 — BLOCKED` | Deletion is irreversible. Disabled in Basic Edition. |
| `http_request` | `T2 — DELEGATE` | Outbound HTTP. Allowed only to domains listed in `security.config.json → allowed_domains`. |
| `web_search` | `T3 — AUTHENTICATED` | Web search. Permitted for authenticated users with keyword filtering applied. |

### 3.3 Communication Tools

> **Note:** Basic Edition contains no third-party communication integrations (Discord, LINE, Slack, etc.).
> These are available in the Professional and Enterprise editions.

| Tool Name | Default Tier | Justification |
|-----------|-------------|---------------|
| `send_message` | `T2 — DELEGATE` | Sends a message to the current conversation channel only. |
| `send_dm` | `T1 — OWNER_ONLY` | Sends a direct message. Potential for spam or harassment. |
| `send_webhook` | `T1 — OWNER_ONLY` | Triggers an outbound webhook to a configured URL. |

### 3.4 Data Tools

| Tool Name | Default Tier | Justification |
|-----------|-------------|---------------|
| `read_database` | `T2 — DELEGATE` | Reads from the connected database. Row-level filtering applied. |
| `write_database` | `T1 — OWNER_ONLY` | Writes to the connected database. High impact. |
| `run_query` | `T0 — BLOCKED` | Raw SQL execution. Disabled in Basic Edition to prevent injection. |
| `export_data` | `T1 — OWNER_ONLY` | Exports data to external storage. Data exfiltration risk. |

---

## 4. Tool Execution Flow

Every tool invocation follows this execution pipeline:

```
Principal Request
       │
       ▼
  ┌─────────────────────────┐
  │  1. SHIELD Auth Check   │  ◄── Validates principal trust level
  └─────────────┬───────────┘
                │ Pass
                ▼
  ┌─────────────────────────┐
  │  2. Injection Guard     │  ◄── Scans tool arguments for injection patterns
  └─────────────┬───────────┘
                │ Clean
                ▼
  ┌─────────────────────────┐
  │  3. Tool Policy Check   │  ◄── Verifies principal tier ≥ tool required tier
  └─────────────┬───────────┘
                │ Authorized
                ▼
  ┌─────────────────────────┐
  │  4. Execution + Audit   │  ◄── Runs tool, logs invocation to audit trail
  └─────────────────────────┘
```

---

## 5. Adding Custom Tools

When extending the agent with new tools, you MUST:

1. Add the tool to this registry before enabling it.
2. Assign a default tier using the **principle of least privilege** (start at `T1`, escalate only if required).
3. Document the justification for the assigned tier.
4. Update `security.config.json` to reflect the new tool's permission configuration.

---

## 6. Blocked Tool Enforcement

`T0 — BLOCKED` tools must be removed from the agent's tool list at the **runtime configuration level**, not just at the policy level. Policy-only blocking is insufficient — a sufficiently sophisticated injection attack could attempt to re-enable a policy-blocked tool. Physical removal from the tool registry is required.

---

*This document is part of the OpenClaw Security Starter — Basic Edition.*
*For commercial use and redistribution, see LICENSE.*
