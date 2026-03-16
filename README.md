<div align="center">

# 🛡️ OpenClaw Security Starter
### Basic Edition — v1.0.0

**A production-ready, Docker-first security template for OpenClaw agents.**  
Deploy to any container hosting provider in minutes. No Node.js setup required.

[![License: Non-Commercial](https://img.shields.io/badge/License-Non_Commercial-red.svg)](#license)
[![Docker](https://img.shields.io/badge/Docker-ghcr.io%2Fopenclaw%2Fopenclaw-blue?logo=docker)](https://ghcr.io/openclaw/openclaw)

</div>

---

## 🛡️ The Pain Point: Safety in OpenClaw Agents

When leveraging advanced Autonomous Agents like **OpenClaw**, absolute power requires absolute control. The primary barrier to integrating AI fully is **Safety & Integrity Risk**:

*   🚨 **Prompt Injections**: Malicious commands triggering unauthorized acts.
*   💀 **Overprivileged Tooling**: Accidental system/file deletes due to lack of guardrails.
*   🔓 **Unauthorized Inbound Requests**: Insecure triggers without permission boundaries.

**This Starter exists to fix that.** It enforces air-tight layered defenses ensure your Agent stays safe, operates within guardrails, and defends itself against adversarial scenarios right out-of-the-box.

---

## 📦 What's Included

This template provides a **Multi-Layer Security Stack** for your OpenClaw agent, pre-configured and ready for production deployment on any platform fully supporting Docker.

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
├── zbpack.json                   # Optional: deployment triggers
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

## 🚀 Deployment Guide (Docker)

Since this template is fully containerized with **Docker**, you can deploy it on almost anything: from your **Local Machine (Mac / PC)**, a sitting **Home Server**, to any **Cloud VPS** or hosting provider.

### Option 1: Local / Homelab (Mac, PC, Linux)

Perfect for local testing and running on a local desktop or server setup.

#### 1. Fork or Clone This Repository
```bash
git clone https://github.com/your-org/openclaw-security-starter.git
cd openclaw-security-starter
```

#### 2. Run with Docker
Mount your local security configurations to the container and run:

```bash
docker build -t openclaw-security .

docker run -d \
  -p 18789:18789 \
  -v $(pwd)/security:/home/node/.openclaw/security \
  -v $(pwd)/config:/home/node/.openclaw/config \
  -e OPENCLAW_OWNER_ID="your_user_id" \
  -e OPENCLAW_AGENT_TOKEN="your_agent_token" \
  openclaw-security
```

---

### Option 2: Cloud Deploy (Example: Deploy with Zeabur)

This is a verified cloud deployment route using **Zeabur** to illustrate the ultimate template-syncing workflow. 

Rather than mounting local storage disk volumes, this project uses the `Dockerfile` to automatically bake in your config files (`COPY security/ /app/security/`) whenever building.

#### 1. Deploy the Base OpenClaw Template
1. Open your Zeabur dashboard or Marketplace.
2. Deploy the standard **OpenClaw** service first to verify the agent is alive and listening.

#### 2. Bind This Custom Repository
To apply your layered security rules, link this repository straight into your service:
1. Go to your Zeabur Dashboard -> Select your Project -> Select OpenClaw Service -> **Settings**.
2. Scroll to **Source** -> Click **"Bind GitHub Repository"**.
3. Pick your forked repository, specify the Branch (`main`), and click **Save & Redeploy**.

Zeabur will pick up the `Dockerfile` and bake your security policies directly into the operating layer. **No Persistent Volume configuration required!**

#### 3. Configure Environment Variables
In the Zeabur service settings dashboard, ensure the following remain set:

| Variable | Required | Description |
|----------|----------|-------------|
| `OPENCLAW_OWNER_ID` | ✅ Yes | Your Discord/platform user ID (grants OWNER access) |
| `OPENCLAW_AGENT_TOKEN` | ✅ Yes | The API token for the OpenClaw agent |

> ⚠️ **Security Warning:** Never commit `OPENCLAW_AGENT_TOKEN` or any credentials to your repository. Keep them as Environment Variables in your dashboard.

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

## 📄 License

This template is licensed for **Personal, Educational, and Non-Commercial Use** only.

*   ✅ **Allowed**: Technical testing, research, and deployment on **your own personal** non-profit OpenClaw agent nodes (e.g., local PC/Server).
*   ❌ **Prohibited**: **Any commercial setups, enterprise use for profit, or repackaging and resale** of these security files as a digital product template.

See `LICENSE` for full terms.

---

<div align="center">
  <p style="font-weight: bold; margin-bottom: 12px; font-size: 1.05em;">Grabee AI Automation</p>
  <a href="#">
    <img src="https://img.shields.io/badge/%E2%9C%A6%20Powered%20by-Grabee%20AI%20Studio-60defc?labelColor=131e2a&style=for-the-badge" alt="Powered by Grabee AI Studio">
  </a>
</div>
