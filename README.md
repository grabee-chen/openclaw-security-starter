<div align="center">

# 🛡️ OpenClaw Security Starter
### Basic Edition — v1.0.0

**A production-ready, Docker-first security template for OpenClaw agents.**  
Deploy to Zeabur in minutes. No Node.js setup required.

[![Deploy on Zeabur](https://zeabur.com/button.svg)](https://zeabur.com)
[![License: Commercial](https://img.shields.io/badge/License-Commercial-blue.svg)](#license)
[![Docker](https://img.shields.io/badge/Docker-ghcr.io%2Fopenclaw%2Fopenclaw-blue?logo=docker)](https://ghcr.io/openclaw/openclaw)

</div>

---

## 📦 What's Included

This template provides a **Multi-Layer Security Stack** for your OpenClaw agent, pre-configured and ready for production deployment on Zeabur.

| Layer | File | Description |
|-------|------|-------------|
| **SHIELD** | `security/SHIELD.md` | Primary access boundary & authentication model |
| **Agent Rules** | `security/AGENT_RULES.md` | Behavioral constitution — what the AI can and cannot do |
| **Injection Guard** | `security/PROMPT_INJECTION_GUARD.md` | Defense against adversarial prompt injection attacks |
| **Tool Policy** | `security/TOOL_POLICY.md` | Least-privilege tool execution permission registry |

---

## 🏗️ Project Structure

```
openclaw-security-starter/
├── Dockerfile                    # Docker-first deployment (inherits official image)
├── zbpack.json                   # Zeabur build configuration
├── .gitignore                    # Protects secrets and runtime data
│
├── security/
│   ├── SHIELD.md                 # Layer 1: Access control boundary
│   ├── AGENT_RULES.md            # Layer 2: Behavioral rules
│   ├── PROMPT_INJECTION_GUARD.md # Layer 3: Injection defense
│   └── TOOL_POLICY.md            # Layer 4: Tool permissions
│
├── config/
│   └── security.config.json      # Runtime security parameters
│
└── docs/
    └── architecture.md           # System architecture diagram
```

---

## 🚀 Deployment Guide (Zeabur)

### Prerequisites

- A [Zeabur](https://zeabur.com) account
- A Zeabur project with a **Persistent Volume** configured

### Step 1: Fork or Clone This Repository

```bash
git clone https://github.com/your-org/openclaw-security-starter.git
cd openclaw-security-starter
```

### Step 2: Create a New Service on Zeabur

1. Open your Zeabur project dashboard.
2. Click **"Add Service"** → **"Git"**.
3. Connect this repository.
4. Zeabur will automatically detect `zbpack.json` and use the **Dockerfile** build method.

### Step 3: Configure Environment Variables

In the Zeabur service settings, set the following environment variables:

| Variable | Required | Description |
|----------|----------|-------------|
| `OPENCLAW_OWNER_ID` | ✅ Yes | Your Discord/platform user ID (grants OWNER access) |
| `OPENCLAW_AGENT_TOKEN` | ✅ Yes | The API token for the OpenClaw agent |
| `OPENCLAW_LOG_LEVEL` | Optional | Log verbosity: `error`, `warn`, `info` (default: `info`) |

> ⚠️ **Security Warning:** Never commit `OPENCLAW_AGENT_TOKEN` or any credentials to your repository. Always set them as Zeabur environment variables.

### Step 4: Mount the Persistent Volume

Configure a Zeabur Persistent Volume mounted at:

```
/home/node/.openclaw/
```

Copy your security configuration to the volume:

```
/home/node/.openclaw/config/security.config.json
/home/node/.openclaw/security/SHIELD.md
/home/node/.openclaw/security/AGENT_RULES.md
/home/node/.openclaw/security/PROMPT_INJECTION_GUARD.md
/home/node/.openclaw/security/TOOL_POLICY.md
```

### Step 5: Deploy

Click **Deploy** in the Zeabur dashboard. The agent will start on **port 18789**.

---

## 🔐 Security Layers Explained

### Layer 1 — SHIELD (Access Boundary)

Controls **who** can interact with the agent. By default, only the designated OWNER can issue commands. Enforces `@mention` requirement to prevent accidental activation.

### Layer 2 — Agent Rules (Behavioral Constitution)

Defines **what** the agent will and will not do. Contains absolute rules (unchangeable) and configurable rules (adjustable via `security.config.json`). The agent always chooses rules over runtime instructions in case of conflict.

### Layer 3 — Prompt Injection Guard

Defends against adversarial inputs designed to **hijack** the agent's behavior. Detects keyword patterns, structural anomalies, and encoded attack payloads.

### Layer 4 — Tool Policy (Least Privilege)

Controls **which tools** can be executed and by **whom**. Uses a T0–T4 permission tier system. High-risk tools like `delete_file` and `run_query` are physically disabled (`T0 — BLOCKED`) in the Basic Edition.

---

## ⚙️ Customization

Edit `config/security.config.json` to adjust security parameters:

```json
{
  "access_control": {
    "owner_only_mode": true,        // Set to false to enable DELEGATE access
    "require_mention": true,         // Set to false to disable @mention requirement
    "delegate_enabled": false        // Set to true to allow delegate principals
  },
  "rate_limiting": {
    "requests_per_minute_per_user": 10,
    "injection_attempt_threshold": 3
  }
}
```

---

## 🛡️ What This Edition Does NOT Include

The **Basic Edition** is intentionally minimal. The following are available in Professional and Enterprise editions:

- ❌ Discord Bot integration
- ❌ LINE messaging integration
- ❌ n8n workflow triggers
- ❌ Custom skill extensions
- ❌ Multi-agent orchestration

---

## 📄 License

This template is licensed for **commercial use** by the purchaser only. Redistribution or resale of the template itself is prohibited. See `LICENSE` for full terms.

---

<div align="center">
  <p style="font-weight: bold; margin-bottom: 12px; font-size: 1.05em;">Grabee AI Automation</p>
  <a href="#">
    <img src="https://img.shields.io/badge/%E2%9C%A6%20Powered%20by-Grabee%20AI%20Studio-60defc?labelColor=131e2a&style=for-the-badge" alt="Powered by Grabee AI Studio">
  </a>
</div>
