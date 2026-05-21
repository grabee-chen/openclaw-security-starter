# Sub-Agent 監控架構 — 龍蝦自癒模式

# Sub-Agent Monitoring — Lobster Self-Healing Architecture 🦞

> **Priority / 優先級**: P2
> **Status / 狀態**: Proposed / 提案中
> **Target Version / 目標版本**: v2.0

---

## 問題描述 / Problem Statement

在傳統的 agent 部署中，主代理的故障通常需要外部介入才能修復。受到龍蝦斷肢再生能力的啟發 🦞，我們提出使用 sub-agent 來實現自動監控與自癒的架構。

In traditional agent deployments, main agent failures typically require external intervention to resolve. Inspired by the lobster's limb regeneration ability 🦞, we propose using sub-agents for automated monitoring and self-healing.

### 社群背景 / Community Context

此概念源自社群討論：
- 舊金山後端工程師建議參考 K8s self-healing pod 模式
- 提出外部看門狗、嚴格上限、quorum 檢查、故障預算等機制
- 使用 sub-agent 做監控是一個在安全與自主性之間取得平衡的方向

---

## 三種可行架構 / Three Architecture Options

```mermaid
%%{init: {'theme': 'dark'}}%%
graph TB
    subgraph "方向 A：隔離執行 / Isolated Execution"
        A1["Main Agent<br/>主代理"] -->|"delegate exec"| A2["Sandboxed Sub-Agent<br/>沙箱子代理"]
        A2 -->|"execute"| A3["System Commands"]
        A2 -.->|"prompt injection<br/>attack contained"| A4["🛡️ Blast Radius Limited"]
    end

    subgraph "方向 B：專職監控 / Dedicated Monitor"
        B1["Main Agent<br/>主代理"] -.->|"observed by"| B2["Watchdog Sub-Agent<br/>監控子代理"]
        B2 -->|"collect metrics"| B3["Health Data"]
        B2 -->|"anomaly detected"| B4["Alert / Recovery"]
    end

    subgraph "方向 C：權限分級 / Permission Tiering"
        C1["Read Commands<br/>df, ps, du"] -->|"low privilege"| C2["Direct Execution<br/>直接執行"]
        C3["Write Commands<br/>rm, kill"] -->|"high privilege"| C4["Sub-Agent + Approval<br/>子代理 + 審批"]
    end

    style A4 fill:#1e8449,stroke:#2ecc71,color:#ecf0f1
    style B4 fill:#d4ac0d,stroke:#f1c40f,color:#1a1a2e
    style C2 fill:#1e8449,stroke:#2ecc71,color:#ecf0f1
    style C4 fill:#922b21,stroke:#e74c3c,color:#ecf0f1
```

## 推薦架構：混合模式 / Recommended: Hybrid Approach

結合三種方向的優點：

```mermaid
%%{init: {'theme': 'dark'}}%%
graph TB
    subgraph "🦞 龍蝦自癒系統 / Lobster Self-Healing System"
        direction TB
        WD["🔭 Watchdog Sub-Agent<br/>監控子代理"]
        MA["🤖 Main Agent<br/>主代理"]
        RM["🔄 Recovery Manager<br/>修復管理器"]
        LE["🗳️ Leader Election<br/>領導者選舉"]
    end

    subgraph "📊 健康指標 / Health Signals"
        H1["HTTP /health"]
        H2["Heartbeat<br/>心跳"]
        H3["Queue Depth<br/>佇列深度"]
        H4["Memory / CPU"]
        H5["Error Rate<br/>錯誤率"]
        H6["Tool Timeout<br/>工具逾時"]
    end

    subgraph "🛡️ 安全護欄 / Safety Rails"
        S1["Max Replicas: 3<br/>最大副本數"]
        S2["Cooldown: 60s<br/>冷卻期"]
        S3["Backoff Jitter<br/>退避抖動"]
        S4["Failure Budget<br/>故障預算"]
        S5["Immutable Config<br/>不可變配置"]
        S6["Audit Trail<br/>審計追蹤"]
    end

    H1 & H2 & H3 & H4 & H5 & H6 --> WD
    WD -->|"anomaly"| LE
    LE -->|"leader confirmed"| RM
    RM -->|"spawn / restart"| MA
    S1 & S2 & S3 & S4 --> RM
    RM --> S5 & S6

    style WD fill:#d4ac0d,stroke:#f1c40f,color:#1a1a2e
    style MA fill:#1a5276,stroke:#3498db,color:#ecf0f1
    style RM fill:#1e8449,stroke:#2ecc71,color:#ecf0f1
    style LE fill:#7d3c98,stroke:#9b59b6,color:#ecf0f1
```

## 自癒狀態機 / Self-Healing State Machine

```mermaid
%%{init: {'theme': 'dark'}}%%
stateDiagram-v2
    [*] --> Healthy: Agent starts
    Healthy --> Degraded: Health check fails
    Degraded --> Recovering: Within failure budget
    Recovering --> Healthy: Recovery succeeds
    Degraded --> Critical: Exceeds failure budget
    Critical --> Spawning: Leader election won
    Spawning --> Healthy: New instance OK
    Spawning --> Failed: Max replicas reached
    Critical --> Failed: Root cause is bad deployment
    Failed --> [*]: Alert OWNER and stop
```

## 防止無限增生 / Preventing Runaway Spawning

這是此架構最關鍵的安全考量：

| 機制 / Mechanism | 說明 / Description | 設定 / Setting |
|-----------------|-------------------|---------------|
| Max Replicas | 最大副本數上限 | 3 |
| Cooldown | 兩次 spawn 之間的最短間隔 | 60 seconds |
| Backoff Jitter | 避免驚群效應的隨機延遲 | 0-500ms |
| Failure Budget | 累計錯誤預算 | 50 errors/hour |
| Quorum Check | 只有 leader 能觸發 spawn | Lease-based |
| Root-Cause Gate | 壞部署時禁止 spawn | Auto-detect |

## 配置 / Configuration

```json
{
  "self_healing": {
    "enabled": false,
    "watchdog": {
      "check_interval_seconds": 30,
      "health_signals": ["http_health", "heartbeat", "error_rate", "memory"],
      "anomaly_threshold": 3
    },
    "recovery": {
      "max_replicas": 3,
      "cooldown_seconds": 60,
      "backoff_base_ms": 1000,
      "backoff_max_ms": 30000,
      "jitter_ms": 500
    },
    "leader_election": {
      "lease_duration_seconds": 300,
      "renew_interval_seconds": 60
    },
    "safety": {
      "failure_budget_per_hour": 50,
      "block_on_bad_deployment": true,
      "audit_all_recovery_actions": true
    }
  }
}
```

## 實作步驟 / Implementation Steps

1. **Phase 1** — Watchdog sub-agent 基礎架構
2. **Phase 2** — 健康指標收集（依賴 Health Check 提案）
3. **Phase 3** — Leader election 機制
4. **Phase 4** — Recovery manager + spawn 邏輯
5. **Phase 5** — 安全護欄（max replicas, cooldown, budget）
6. **Phase 6** — 審計日誌整合（依賴 Audit Layer 提案）

## 前置依賴 / Prerequisites

- Health Check / Watchdog 機制 (P0) — 提供健康指標
- 失控保護機制 (P1) — 提供 failure budget 基礎
- NemoClaw 相容審計層 (P2) — 提供審計日誌

## 驗收標準 / Acceptance Criteria

- [ ] Watchdog sub-agent 可獨立運作
- [ ] 支援 6 種以上健康指標
- [ ] Leader election 避免多個 leader 同時操作
- [ ] Max replica + cooldown 防護就位
- [ ] 壞部署時自動停止 spawn
- [ ] 所有自癒動作記錄在審計日誌
- [ ] 完整的架構決策文件

---

> 🦞 *「龍蝦會斷肢再生，系統也能自我修復」— 社群討論靈感*
> 📄 Related Issue: `feat: Sub-Agent 監控架構 — 龍蝦自癒模式`
