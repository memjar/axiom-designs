# Palantir Apollo Platform — Comprehensive Technical Reference

> Research compiled: March 2026
> Sources: Palantir official docs, blog posts, SEC filings, Carahsoft, Microsoft partnership announcements, AWS/Azure marketplaces, developer conference talks

---

## Table of Contents

1. [What Is Apollo](#1-what-is-apollo)
2. [History & Origin](#2-history--origin)
3. [Architecture — Hub and Spoke](#3-architecture--hub-and-spoke)
4. [Continuous Delivery Pipeline](#4-continuous-delivery-pipeline)
5. [Release Channels & Promotion](#5-release-channels--promotion)
6. [Environment Management](#6-environment-management)
7. [Microservice Orchestration](#7-microservice-orchestration)
8. [Configuration Management](#8-configuration-management)
9. [Monitoring & Observability](#9-monitoring--observability)
10. [Security & Compliance](#10-security--compliance)
11. [Edge & Disconnected Deployments](#11-edge--disconnected-deployments)
12. [Apollo Product Specification & Kubernetes](#12-apollo-product-specification--kubernetes)
13. [Vulnerability Management](#13-vulnerability-management)
14. [Developer Experience](#14-developer-experience)
15. [Commercialization & Pricing](#15-commercialization--pricing)
16. [Customer Examples](#16-customer-examples)
17. [Performance Benchmarks](#17-performance-benchmarks)
18. [Apollo vs. Standard DevOps Tools](#18-apollo-vs-standard-devops-tools)
19. [Strategic Significance](#19-strategic-significance)
20. [Sources](#20-sources)

---

## 1. What Is Apollo

Palantir Apollo is the **continuous delivery and day-2 operations platform** that underlies every deployment of Palantir's software products — Foundry, Gotham, and AIP. It is the third pillar of the Palantir platform trilogy, alongside Gotham and Foundry, and is what makes both products deployable to virtually any environment on Earth (and beyond).

### Core Purpose

Apollo solves a problem unique to Palantir's market: **how do you deliver SaaS-quality software to environments that are fundamentally incompatible with normal SaaS?** Standard SaaS lives in a public cloud. Palantir's customers include intelligence agencies, military units in the field, and classified government networks — environments where the internet does not exist, connectivity is intermittent or nonexistent, and pushing updates from the outside is prohibited.

Apollo was built to answer: *how do you continuously deploy and operate hundreds of microservices across thousands of environments — from AWS to the inside of a submarine — from a single control plane?*

### In Palantir's Own Words

> "Apollo is used to upgrade, monitor, and manage every instance of Palantir's products in the cloud and in some of the world's most regulated and controlled environments, centrally managing software across independent environments regardless of their location or level of consistent connectivity."

Apollo provides:
- **Autonomous deployment** — software updates flow without human intervention, even to air-gapped environments
- **Compliance-aware change management** — built-in controls for FedRAMP, IL5, IL6, ITAR, CMMC
- **Single pane of glass** — monitor the entire fleet from one interface
- **Pull-based release model** — environments subscribe to channels; they pull when ready, not when pushed

### Relation to Foundry and Gotham

| Platform | Purpose | Apollo's Role |
|----------|---------|---------------|
| **Foundry** | Commercial and government data operations, ontology, AI workflows | Apollo deploys and manages all 300+ Foundry microservices across every customer environment |
| **Gotham** | Government/defense intelligence analytics | Apollo deploys Gotham to classified networks, on-prem data centers, and tactical edge |
| **AIP** | LLM/AI agent layer on top of Foundry | Apollo manages AIP rollouts with same pipeline as Foundry |
| **Apollo** | Deployment, operations, lifecycle management | Is the infrastructure that makes all of the above work across any environment |

Apollo is natively aware of Foundry's object model — deployments are not just bundles of code. They are **versioned, interlinked operational logic** including object types, actions, logic flows, policy rules, and UI definitions pushed through a governed release pipeline.

---

## 2. History & Origin

### Timeline

| Year | Event |
|------|-------|
| ~2015 | Palantir begins investing in internal platform engineering and infrastructure tooling |
| **~2017** | Apollo rolled out internally — Palantir's first foray into GitOps in production |
| 2017–2020 | Apollo scales linearly; by 2021 it reaches 10,000+ monthly pull requests |
| **September 2020** | First major public blog post: *"Palantir Apollo: Powering SaaS where no SaaS has gone before"* |
| **April 2022** | Palantir unveils Apollo as a standalone commercial product with new capabilities for third parties |
| **October 2022** | Palantir receives DoD IL6 provisional authorization via DISA |
| **July 2023** | Partnership with Carahsoft expands Apollo to entire U.S. public sector via GSA schedules |
| **August 2024** | Palantir + Microsoft partnership deploys Apollo into Azure Government Secret and Top Secret clouds |
| **December 2024** | Palantir granted **FedRAMP High Baseline Authorization** |
| **2025** | CMMC Level 2 certification achieved; PFCS Forward extended to on-premises and edge deployments |

### Why Apollo Was Built

In Palantir's early days, software was deployed on-premises with infrequent manual updates. As the company shifted toward SaaS with the creation of Foundry, they faced a unique challenge: most SaaS companies target a single public cloud. Palantir's customers span:

- Standard cloud (AWS, Azure, GCP)
- Purpose-built government or classified clouds
- Air-gapped military and intelligence networks
- Extreme disconnected environments (vehicles, submarines, satellites)

A traditional CI/CD pipeline cannot reach any of these environments. Apollo was born to solve this gap — it allowed Palantir to build once and deploy everywhere, without requiring separate engineering teams for each environment type.

---

## 3. Architecture — Hub and Spoke

Apollo uses a **Hub-and-Spoke architecture** where every Spoke Environment is a Kubernetes cluster.

```
┌─────────────────────────────────────────────────────┐
│                    APOLLO HUB                       │
│                                                     │
│  ┌──────────────────┐   ┌────────────────────┐     │
│  │ Orchestration    │   │  Product Catalog   │     │
│  │ Engine           │   │  (versioned        │     │
│  │                  │   │   Releases)        │     │
│  └────────┬─────────┘   └────────────────────┘     │
│           │                                         │
│  ┌────────▼─────────┐   ┌────────────────────┐     │
│  │ Plan Generator   │   │  Reported State    │     │
│  │ (constraint-     │   │  (from all Spokes) │     │
│  │  aware)          │   └────────────────────┘     │
│  └────────┬─────────┘                              │
└───────────┼─────────────────────────────────────────┘
            │  (Plans issued to agents)
    ┌───────┼──────────────────────────────────┐
    │       │                                  │
    ▼       ▼                                  ▼
┌──────┐ ┌──────┐                        ┌──────────────┐
│ Spoke│ │ Spoke│         ...            │ Spoke        │
│ Env  │ │ Env  │                        │ (Air-gapped) │
│ (K8s)│ │ (K8s)│                        │              │
└──────┘ └──────┘                        └──────────────┘
```

### Hubs

- **Hub Environments** receive telemetry and state information from Spokes
- Hubs issue **Plans** — units of work (config changes, release upgrades, rollbacks)
- A Hub can manage multiple Spokes
- A Hub can also **self-manage** (runs its own Spoke processes)
- Hubs can be **hierarchical** — a Hub can be managed by another Hub, enabling tiered control for complex multi-region deployments

### Spokes

- Each **Spoke Environment** is a Kubernetes cluster
- Runs a **Spoke Control Plane** that:
  - Reports state and telemetry back to the Hub
  - Executes Plans issued by the Hub
  - Polls continuously for new Plans
- Spokes can operate in **disconnected mode** — when not actively managed by a Hub (e.g., on vehicles), they continue operating on last-known state and re-sync when connectivity resumes

### Orchestration Engine

The Orchestration Engine is the decision-making core inside each Hub. It:

1. Monitors the **Product Catalog** for new Releases
2. Evaluates **Reported State** from all Spokes
3. Determines which Plans are safe to issue based on **Constraints**
4. Generates Plans and sends them to Spoke agents
5. Continuously evaluates Release Channel promotion criteria
6. Issues automatic rollback Plans when execution fails

### Plans and Constraints

**Plans** are the fundamental unit of change. Rather than applying changes directly, Apollo generates a Plan and evaluates all constraints before issuing it.

**Constraints** are preconditions that must be satisfied before a Plan executes:
- Maintenance window constraints (only deploy during configured time windows)
- Health constraints (environment must be healthy before upgrading)
- Dependency constraints (service A must be upgraded before service B)
- SAML approval workflows (humans must approve for certain environments)
- Regulatory constraints (changes must follow FedRAMP change management procedures)

This Plan-based paradigm provides **full transparency** — every change is visible, audited, and traceable.

---

## 4. Continuous Delivery Pipeline

Apollo implements a **pull-based** continuous delivery model, distinct from traditional push-based CI/CD:

```
Developer pushes code
       │
       ▼
CI builds artifacts (container images, Helm charts)
       │
       ▼
Publish to Apollo Product Catalog
       │
       ▼
Orchestration Engine evaluates against Release Channels
       │
       ▼
Release promoted DEV → RELEASE_CANDIDATE → RELEASE
       │
       ▼
Environment operators subscribed to channel receive update
       │
       ▼
Apollo agent pulls update when constraints satisfied
       │
       ▼
Blue/green upgrade deployed to Spoke
       │
       ▼
Health reported back to Hub
       │
       ▼
If healthy → promote to CANARY → STABLE
If unhealthy → automatic rollback + alert
```

### Key Pipeline Features

- **Immutable artifacts** — every Release is versioned and immutable (container images + Helm charts)
- **Semantic versioning** — version numbers determine which default Release Channels a Release is added to
- **CI integration** — publish to Apollo from any CI system using the Apollo CLI (`--helm-repository-url` flag)
- **Artifact registries** — Apollo supports external OCI-compliant registries (Artifactory, Harbor, etc.)
- **Automatic vulnerability gating** — Releases with CVEs are blocked from promotion

---

## 5. Release Channels & Promotion

### Default Release Channels

Apollo ships with three built-in default channels:

| Channel | Purpose |
|---------|---------|
| **DEV** | Bleeding edge, internal testing |
| **RELEASE_CANDIDATE** | Pre-production validation |
| **RELEASE** | General availability |

Organizations can add custom channels (e.g., CANARY, STABLE, PRODUCTION-US, PRODUCTION-EU).

### Promotion Pipelines

A **Release Promotion Pipeline** defines the sequence of channels a Release must traverse and the criteria at each stage. Configured per-product.

### Promotion Strategies

**1. Timed Promotion**
- Release must spend a configured **Duration** on the source channel before promoting
- Minimum: 0 seconds, Maximum: 13 days
- Used for soak testing

**2. Canary Promotion**
- Apollo selects **test Environments** via Entity filters
- Evaluates Release on those environments against conditions
- Promotes when ALL conditions are satisfied

**Health-based Conditions:**

| Condition | Behavior |
|-----------|---------|
| **Promote when healthy** | Promote once N entities have been healthy for duration D |
| **Recall when unhealthy** | Recall if N entities fail health checks after duration D |
| **Entities without health** | Falls back to liveness-only, time-based promotion |

### Automatic Recall

If unhealthy environments exceed the configured threshold during promotion:
1. Promotion is aborted
2. Release is **automatically recalled** from all environments where it was installed (including healthy test environments)
3. Development team is notified
4. Previous good version is reinstated

The Orchestration Engine evaluates promotion criteria **every minute** by default (configurable).

### Security-Gated Promotion

Apollo adds labels to Releases based on vulnerability scan outcomes:
- `vulnerability-scanner.palantir.build/security-scanned: true/false`
- `vulnerability-scanner.palantir.build/security-scan-outcome: pass/fail`

Teams can require `pass` before promotion to STABLE — preventing Releases with known CVEs from reaching production.

---

## 6. Environment Management

### Environment Types

| Type | Description | Examples |
|------|-------------|---------|
| **Public Cloud** | Standard SaaS deployment | AWS, Azure, GCP |
| **Government Cloud** | Purpose-built gov clouds | Azure Government, AWS GovCloud |
| **On-Premises** | Customer-controlled data centers | Enterprise data centers, DoD facilities |
| **Classified/Air-Gapped** | Networks with no internet connectivity | SIPR, JWICS, IL6 environments |
| **Edge** | Resource-constrained, often mobile | Vehicles, ships, satellites, factory floors |
| **Disconnected** | Intermittently connected | Remote outposts, mobile command centers |

Apollo currently manages **300+ unique environments** across all these types.

### Per-Environment Configuration

Each Environment stores:
- **Entity list** — what Products are installed and which Release Channels they subscribe to
- **Environment Config** — arbitrary top-level configuration (references by individual Entities)
- **Maintenance windows** — time windows during which changes are permitted
- **Entity-level maintenance windows** — finer-grained control per service
- **Release Channel subscriptions** — maps to desired feature velocity (DEV = fast, STABLE = conservative)

### Disconnected Environments

When a Spoke loses connectivity to its Hub:
- It enters **disconnected mode**
- Continues operating on last-known desired state
- Re-syncs with Hub when connectivity resumes
- Hub queues Plans during disconnection for eventual execution

This is critical for vehicles, ships, and remote edge deployments where network connectivity cannot be guaranteed.

### PFCS Forward: "Authorize Once, Deploy Everywhere"

The **Palantir Federal Cloud Service (PFCS) Forward** model extends existing IL5/IL6 accreditations to on-premises and edge deployments. DISA's authorization covers:

- Apollo, Gotham, Foundry, and AIP together
- Any environment — enterprise data centers to tactical edge nodes
- Hardware selected by the customer
- "Do Once, Use Many" — single ATO that adapts to any architecture

---

## 7. Microservice Orchestration

### Scale of Palantir's Microservice Fleet

AIP and Foundry together consist of **300+ microservices and assets**, all running in a highly available, autoscaling compute mesh atop zero-trust security infrastructure. Each microservice is owned by a dedicated development team.

Apollo manages the coordination of:

- **Independent release cycles** — each team releases independently on their own cadence
- **Dependency ordering** — services with dependencies are upgraded in the correct order
- **Parallel upgrades** — services without dependencies are upgraded simultaneously
- **Health-based gating** — a service upgrade does not proceed if its dependencies are unhealthy
- **Fleet-wide consistency** — the same version of each service runs across all environments subscribed to the same Release Channel

### Upgrade Mechanics

**Ramped Rollouts**: Staggered upgrades within a Release Channel. Rather than upgrading all environments simultaneously, upgrades are distributed across a configured time window — enabling early issue detection before the entire fleet is affected.

**Blue/Green Upgrades**: The new version is deployed alongside the old version. Traffic is shifted after the new version passes health checks. If the new version fails, traffic shifts back automatically.

**Automatic Rollback Conditions**:
1. Health check failures post-deployment
2. Liveness probe failures
3. Unhealthy threshold exceeded during promotion
4. Manual recall triggered by operator or developer

Rollback time benchmark: **4.9 minutes** (vs. hours previously).

---

## 8. Configuration Management

### Configuration Hierarchy

```
Environment Config (top-level, per environment)
    └── Entity Config (per service, per environment)
        └── Default Config (baked into Helm chart / Product Definition)
            └── Secret Material (auto-generated or injected)
```

### Apollo Product Definition

Each Product ships with an **Apollo Product Definition** containing:

- `configuration.yml` — default config sufficient to boot the service without manual setup
- Trait declarations — required attributes (memory, ports, TLS certs, etc.)
- Secret material specs — randomly generated credentials where appropriate
- Dependency declarations — other services this product depends on

### Configuration as Code

Apollo uses a **configuration-as-code** approach. All configuration is:
- Versioned alongside the Product Release (immutable per version)
- Declarative (desired state, not imperative scripts)
- Auditable (all changes tracked with timestamps and actors)

### Per-Environment Overrides

Environment operators can override default configuration at:
- **Environment level** — affects all entities in the environment
- **Entity level** — affects a specific service in a specific environment

Overrides are stored in the Hub and applied by the Spoke agent at deployment time.

### DISA STIG Compliance

PFCS Forward environments are maintained in strict accordance with:
- DISA Security Technical Implementation Guides (STIGs)
- DoD Cloud Computing SRG requirements
- Configuration-as-code to prevent drift
- Automated compliance validation for continuous baseline alignment

---

## 9. Monitoring & Observability

### Apollo's Observability Stack

Apollo integrates with industry-standard observability tools:
- **DataDog** — metrics and alerting
- **Prometheus** — metrics scraping
- **PagerDuty** — incident escalation
- **Slack** — developer notifications
- **Custom webhooks** — arbitrary REST endpoints for alerts

Developers can **bundle monitors with software** — when a new service is deployed, its monitoring configuration deploys automatically alongside it.

### Single Pane of Glass

Apollo provides a centralized **Software Control Center** dashboard showing:
- All environments and their current deployed versions
- Health status per environment and per service
- Active Plans (in-flight changes)
- Upcoming Plans (queued, pending constraints)
- Historical changes with full audit trail
- Vulnerability findings per environment

### Health Model

The Apollo health model is defined at the **service replica level**:

| State | Meaning |
|-------|---------|
| **HEALTHY** | Fully operational, no issues |
| **REPAIRING** | Degraded but capable of auto-recovery |

Health is reported via HTTP endpoint at `/status/health`, which must return a valid JSON body. The `expected-state-k8s` service in each cluster watches all Apollo-managed Pods, collects health via the `health.probe` annotation, and forwards to the Hub.

### Liveness and Readiness

Apollo uses standard Kubernetes liveness and readiness probes, automatically collected from all managed environments. This data feeds:
- Promotion criteria evaluation
- Automatic recall decisions
- Fleet health dashboards

### Centralized Incident Correlation

Apollo's centralization enables answering: *"Was this metric spike caused by a config change, an upgrade, or something environment-specific?"* By correlating deployment events with metric anomalies across the fleet, Apollo dramatically reduces mean time to diagnosis.

### AIP Observability Integration

For Foundry + AIP deployments, Apollo integrates with the AIP Observability layer:
- **Distributed tracing** — visualize execution flow across Functions, Actions, Language Models, Automations
- **Function monitoring** — alerts for function performance and failure rates
- **Action metrics** — analyze execution patterns
- **LLM usage tracking** — token usage, model request counts, latency
- **Log export** — export to Foundry streaming datasets for complex analysis

---

## 10. Security & Compliance

### Authorization Framework

Palantir holds the following authorizations for Apollo + Foundry + Gotham + AIP:

| Authorization | Level | Notes |
|---------------|-------|-------|
| **FedRAMP Moderate** | Cloud | Achieved early |
| **FedRAMP High** | Cloud | Granted December 2024 |
| **DoD IL4** | Cloud | Data up to CUI |
| **DoD IL5** | Cloud + On-Prem/Edge | National Security Systems |
| **DoD IL6** | Cloud + On-Prem/Edge | Classified data (only 6 CSPs hold this) |
| **CMMC Level 2** | All | NIST SP 800-171 compliance |
| **ITAR** | All | International Traffic in Arms Regulations |

Palantir is one of only **six cloud service providers** to achieve IL6 accreditation.

### NIST Control Families

Apollo directly addresses **six of the twenty NIST Control Families** that form the basis of IL6 requirements, including:

- **Audit and Accountability (AU)** — complete change history per service per environment
- **Configuration Management (CM)** — immutable, versioned configurations
- **System and Information Integrity (SI)** — vulnerability scanning, auto-recall of vulnerable releases
- **Risk Assessment (RA)** — CVE tracking, CVSS scoring, EPSS probability scoring
- **Incident Response (IR)** — automated rollback, sub-5-minute remediation
- **Change Management** — FedRAMP-specific reviewer guidance, maintenance windows, approval workflows

### FedRAMP-Specific Features

When a change is proposed in a FedRAMP environment, Apollo:
1. Guides the reviewer through FedRAMP-specific considerations
2. Surfaces optional actions based on the type of change
3. Saves a full history of changes for AU (Audit and Accountability) controls
4. Validates changes before applying during configured maintenance windows

### IL6 Environment Architecture

IL6 = DoD's highest unclassified tier, covering potentially classified data. Apollo's IL6 deployment architecture includes:
- Hardened, minimal, or distroless container images
- Configuration-as-code to prevent drift
- Automated compliance validation
- Multi-tenant isolation
- Secure network segmentation from enterprise data centers to tactical edge nodes

### Microsoft Partnership for Secret/Top Secret

Via the Palantir + Microsoft partnership (August 2024), Apollo is deployed in:
- **Azure Government** (FedRAMP High)
- **Azure Government Secret** (DoD IL6)
- **Azure Government Top Secret** (above IL6)

This is one of the deepest commercial software deployments into classified U.S. government networks ever publicly disclosed.

### Access Controls

The Foundry Ontology layer (managed by Apollo) implements three access control models simultaneously:
- **RBAC** (Role-Based Access Control)
- **ABAC** (Attribute-Based Access Control) — clearance level, need-to-know, organizational affiliation
- **CBAC** (Classification-Based Access Control) — data classification labels

---

## 11. Edge & Disconnected Deployments

### The Edge Problem

Traditional software deployment assumes:
1. Reliable internet connectivity
2. The ability to push updates from a central server
3. Standardized, homogeneous infrastructure

None of these hold at the edge. Apollo was built from day one to handle this.

### Deployment Environments Apollo Supports at the Edge

| Environment | Description |
|-------------|-------------|
| **Military vehicles** | Ruggedized server racks in Humvees, MRAPs |
| **Naval vessels** | Inside submarines, aircraft carriers, patrol boats |
| **Unmanned systems** | Drone fleets, autonomous vehicles |
| **Satellites** | Space-based computing platforms |
| **Factory floors** | IoT-adjacent industrial deployments |
| **Remote outposts** | Disconnected field operating bases |
| **Small form factor** | Compact, power-constrained edge devices |

### Apollo for the Edge (2022 Product Expansion)

In March 2022, Palantir released specific edge capabilities within Apollo:

- **Minimal footprint** — Apollo agent designed for resource-constrained devices
- **Offline-first operation** — continues operating without connectivity
- **Model/application orchestration** — manages AI models deployed to edge devices
- **Seamless upgrade orchestration** — queues updates, applies when connectivity permits
- **Resource optimization** — continuously optimizes edge device resource usage (storage, memory, CPU)
- **Selective installation control** — controls what is installed and uninstalled on each unique device

### Disconnected Operation Model

```
Connected Phase:
Hub → issues Plans → Spoke executes → reports state back

Disconnected Phase:
Hub → queues Plans (stored for later)
Spoke → operates on last-known desired state
Spoke → local health monitoring continues
Spoke → no external reporting

Reconnection:
Spoke → re-establishes trust with Hub
Hub → sends queued Plans
Spoke → applies accumulated updates
Spoke → reports state reconciliation
```

### PFCS Forward: Tactical Edge Authorization

DISA extended PFCS Forward IL5/IL6 accreditations to tactical edge deployments in 2025. This means:
- Full Foundry + AIP can run on edge hardware selected by the customer
- Same ATO covers enterprise data center AND vehicle-mounted hardware
- No separate authorization process per deployment location

---

## 12. Apollo Product Specification & Kubernetes

### The Kubernetes Complexity Problem

Kubernetes is powerful but overwhelming. A simple application requires knowledge of:
- Deployments, ReplicaSets, Pods
- Services, Ingresses
- ConfigMaps, Secrets
- PersistentVolumeClaims
- ResourceQuotas, LimitRanges
- NetworkPolicies, ServiceAccounts, RBAC

Forcing product developers to know all of this slows innovation and makes standardization difficult.

### Apollo's Solution: The Product Specification

Palantir tackled this by defining the **Apollo Product Specification** — a declarative API that abstracts Kubernetes complexity:

```
Developer writes Apollo Product Definition
            │
            ▼
    Apollo SDK validates
            │
            ▼
Apollo Service Management Plane
    converts to K8s native resources
            │
            ▼
    Kubernetes cluster deploys
```

Developers interact with Apollo concepts (Products, Traits, Entities) — never directly with raw Kubernetes YAML.

### Apollo Product Specification: Key Concepts

**Product Definition**:
- Versioned and immutable per Release
- Contains default configuration sufficient to boot without manual intervention
- Declares traits, secrets, dependencies
- Packaged as a Helm chart

**Traits**:
Represent required Product attributes:
- Memory allocations
- Service ports
- TLS certificate requirements
- Network exposure requirements
- Storage requirements

**Apollo SDK**:
- Helps developers leverage the declarative Product Spec API
- Handles versioning and packaging
- Integrates with CI systems for automated publishing

**Service Management Plane**:
- Converts Product Definitions into functioning sets of Kubernetes native resources
- Handles K8s API deprecations transparently (developers don't need to update when K8s evolves)
- Enables platform evolution without developer intervention

### Helm Chart Integration

Apollo treats Helm charts as the packaging format for Products:

- Product type declared in **Product Manifest** as `helm.v1`
- Published to Apollo Hub's artifact store or external OCI-compliant registry (Artifactory, Harbor)
- Container images must be declared in **artifacts manifest** for vulnerability scanning
- Versioned with semantic versioning (version number determines default Release Channel assignment)

### OCI Registry Support

Apollo supports external OCI-compliant container registries:
- Product Releases can reference artifacts directly from connected registries
- Vulnerability scanning applies to images from connected registries
- No need to re-push images to Apollo's internal store

### Local Development

Apollo provides tooling to run a local Kubernetes cluster for development:
- Full Hub + Spoke setup locally
- Test deployments before publishing to production channels
- Validate Product Definitions before CI publication

---

## 13. Vulnerability Management

### Scanning Stack

| Tool | Purpose |
|------|---------|
| **Trivy** | Container image vulnerability scanning |
| **ClamAV** | Virus/malware scanning |
| **MITRE CVE** | CVE database for known vulnerabilities |
| **CVSS v3.x** | Severity scoring standard |
| **EPSS** | Probability of exploitation in next 30 days |
| **CISA KEV** | US government catalog of known exploited vulnerabilities |

### Scanning Cadence

- All **latest Releases** scanned daily (default, configurable)
- All **installed Releases** scanned daily
- New Releases scanned automatically when published
- Scan results labeled on Release artifacts

### Vulnerability Findings

A **Finding** = a specific vulnerability in a specific artifact in a specific Release context.

Apollo tracks:
- CVE ID and description
- CVSS v3.x severity score
- EPSS probability score (0–1, probability of exploitation in 30 days)
- Known Exploit flag (from CISA KEV catalog)
- Affected artifact(s)
- Remediation guidance

### Automatic Recall on Vulnerability

By default, all Releases with **active vulnerabilities** are automatically recalled from all environments (unless suppressed by human override or grace period).

Recall strategy: **roll-forward** — rather than rolling back to an older vulnerable version, Apollo promotes to the newest clean version.

### Promotion Gating

Teams configure vulnerability tolerance per Release Channel:
- DEV channel: may allow known vulnerabilities for development speed
- STAGING: require clean scan
- PRODUCTION/STABLE: require clean scan + manual suppression for any exceptions

---

## 14. Developer Experience

### Core Philosophy: "Develop Once, Deploy Anywhere"

Developers:
1. Merge code to their repository
2. CI builds artifacts, publishes to Apollo
3. Apollo handles everything else

Developers do **not** need to know:
- What environments exist
- How to configure each environment
- How to handle air-gapped vs cloud deployments
- Kubernetes specifics
- Compliance requirements per environment

Apollo absorbs all operational complexity.

### Deployment Frequency Improvement

Apollo enables Palantir's 1,000+ engineers across 4–12 person teams to operate independently without coordination overhead. The result:
- **8,000 deploys/month → 360,000+ deploys/month** (45x improvement)
- **1 month → 3.5 minutes** average lead time (12,500x improvement)

### GitOps-Inspired Workflow

Apollo adopted GitOps principles starting in 2017:
- Desired state declared in version-controlled artifacts
- Systems continuously reconcile actual state with desired state
- All changes are auditable, reversible, and traceable
- Git as the source of truth for configuration and deployment intent

By 2021, Apollo had grown to **10,000+ monthly pull requests** across the platform.

### Developer Controls in Release Pipelines

Developers configure, per product:
- Which Release Channels exist
- Promotion sequence (DEV → RC → RELEASE → CANARY → STABLE)
- Health criteria for promotion (what counts as "healthy enough to promote")
- Vulnerability tolerance per channel
- Rollback triggers

### Operator Controls

Environment operators configure:
- Which Release Channel to subscribe to (speed vs. stability tradeoff)
- Maintenance windows (when changes are permitted)
- Entity-level overrides for specific services
- Approval workflows for sensitive changes

---

## 15. Commercialization & Pricing

### Apollo as a Standalone Product

Apollo was commercially launched as a standalone product in **2022**, available to any organization — not just Palantir Foundry/Gotham customers. Organizations can use Apollo to deploy their own software in the same way Palantir uses it internally.

### Pricing

| Tier | Price | Description |
|------|-------|-------------|
| **Apollo Core** | $100/installation/month | One installation = one service instance in one environment |

**Example**: Deploy one service across AWS, Azure, and on-prem = 3 installations = $300/month.

Apollo is also available on:
- **AWS Marketplace** (private pricing)
- **Azure Marketplace**
- **Carahsoft GSA Schedule** (public sector, NASA SEWP V, ITES-SW2, State/Local contracts)

### FedStart Program

**FedStart** allows SaaS companies to run their applications inside Palantir's already-accredited FedRAMP/IL5/IL6 infrastructure — bypassing the years-long and multi-million-dollar process of obtaining their own authorizations.

Value proposition: **rent Palantir's compliance posture** rather than building your own.

---

## 16. Customer Examples

### Government & Military

| Customer | Use Case |
|----------|---------|
| **U.S. Department of Defense** | Multiple programs, tactical and enterprise |
| **U.S. Army** | Field-deployable analytics, Apollo for edge hardware |
| **CIA & Intelligence Community** | Gotham deployed to classified networks via Apollo |
| **DISA** | Direct relationship; IL6 authorization grantor |
| **UK National Health Service** | Public health data operations via Foundry |
| **U.S. DHS** | Border security, immigration analytics |
| **U.S. FDA** | Drug and vaccine supply chain (COVID response) |

### Commercial

| Customer | Use Case |
|----------|---------|
| **Airbus** | Manufacturing analytics, supply chain, production |
| **BP** | Energy operations, refinery optimization |
| **Ferrari** | Manufacturing and race operations |
| **Rio Tinto** | Mining operations |
| **Fujitsu** | Enterprise IT operations |
| **JPMorgan Chase** | Financial operations and risk |
| **Credit Suisse** | Risk analytics |
| **Cisco** | Enterprise operations |
| **Sarcos** | Robot fleet management (Apollo manages robot software updates) |
| **Amazon** | Supply chain and logistics |
| **Panasonic** | Manufacturing |

### Total Scale

- **550+ companies** worldwide use Palantir products
- **~90 industries** represented globally
- **~100 air-gapped environments** managed
- **1,000 customer environments** total
- **2,500 products and services** deployed via Apollo
- **90,000 upgrades per week** across the fleet

---

## 17. Performance Benchmarks

| Metric | Before Apollo | With Apollo | Improvement |
|--------|--------------|-------------|-------------|
| Monthly deploys | 8,000 | 360,000+ | **45x** |
| Lead time (code → deployed) | 1 month | 3.5 minutes | **12,500x** |
| Patch/update time | Hours | 3.5 minutes avg | ~**100x** |
| Rollback time | Hours | 4.9 minutes | ~**50x** |
| Production issue remediation | Hours | < 5 minutes | **~50x** |
| Weekly upgrade operations | — | 90,000+ | — |
| Monthly pull requests | — | 10,000+ | — |
| Unique environments managed | — | 300+ | — |
| Engineers supported | — | 1,000+ | — |

---

## 18. Apollo vs. Standard DevOps Tools

| Capability | Apollo | Kubernetes/Helm | ArgoCD | Spinnaker |
|-----------|--------|----------------|--------|-----------|
| Air-gapped/disconnected deployment | Native | No | No | No |
| Compliance-aware change management | Native | No | No | No |
| FedRAMP/IL6 authorization | Yes | N/A | N/A | N/A |
| Edge (vehicle/satellite) deployment | Yes | Limited | No | No |
| Automated CVE-based recall | Yes | No | No | Partial |
| Fleet-wide canary with auto-recall | Yes | No | Partial | Yes |
| Multi-environment single pane of glass | Yes | Limited | Limited | Yes |
| Foundry object model awareness | Yes | No | No | No |
| Pull-based deployment model | Yes | No | Yes | No |
| Hub-and-Spoke hierarchy | Yes | No | No | No |
| Product Specification abstraction | Yes | No | No | No |

Apollo is not a replacement for Kubernetes — it sits **on top of Kubernetes**, abstracting it. It is also not a replacement for GitOps tools like ArgoCD — it incorporates GitOps principles while adding compliance, security, and edge capabilities that general-purpose tools cannot provide.

---

## 19. Strategic Significance

### The Trojan Horse Thesis

Industry analysts have described Apollo as Palantir's "Trojan Horse" — the platform that, once deployed in an organization, creates deep operational lock-in. Every software system the organization runs through Apollo becomes dependent on Apollo's orchestration, health management, and compliance machinery. The switching cost is enormous.

### Total Addressable Market

Apollo's TAM is theoretically **any organization that writes software** — which is effectively every enterprise on Earth. The $100/installation/month pricing model scales with organizational complexity. A large enterprise with 200 services across 10 environments = $240,000/year just for Apollo Core.

### The "Develop Once, Deploy Everywhere" Moat

The deeper strategic moat is Apollo's ability to extend Palantir deployments into environments no other software can reach: classified networks, air-gapped systems, tactical edge. This is not a feature competitors can easily replicate — it requires years of government relationships, security authorizations (only 6 CSPs hold IL6), and purpose-built infrastructure.

### Platform Network Effects

Every new environment connected to Apollo adds value to the platform:
- More telemetry for health models
- Wider coverage for vulnerability scanning
- More data for optimizing deployment strategies
- More customers benefiting from Palantir's compliance investments

### AIP Amplifier

Apollo is the delivery mechanism for AIP (Palantir's AI layer). As AIP adoption grows — and organizations increasingly want to run LLM-powered workflows in classified or on-prem environments — Apollo's ability to deploy AIP anywhere becomes a critical differentiator. No other AI platform can be deployed to IL6 or inside a submarine.

---

## 20. Sources

### Palantir Official Documentation
- [Apollo Introduction](https://www.palantir.com/docs/apollo/core/introduction)
- [How Apollo Works](https://www.palantir.com/docs/apollo/core/how-apollo-works)
- [Apollo Core Overview](https://www.palantir.com/docs/apollo/core/overview)
- [Apollo Getting Started](https://www.palantir.com/docs/apollo/apollo-getting-started/getting-started-with-apollo)
- [Apollo Glossary](https://www.palantir.com/docs/apollo/apollo-getting-started/glossary)
- [Core Concepts: Release Channels](https://www.palantir.com/docs/apollo/core/release-channels)
- [Core Concepts: Plans and Constraints](https://www.palantir.com/docs/apollo/core/plans-and-constraints)
- [Core Concepts: Environments](https://www.palantir.com/docs/apollo/core/environments)
- [Managing Release Channels: Promotion Pipeline](https://www.palantir.com/docs/apollo/managing-release-channels/configure-promotion-pipeline)
- [Managing Vulnerabilities: Overview](https://www.palantir.com/docs/apollo/managing-vulnerabilities/overview)
- [Managing Vulnerabilities: Scanning](https://www.palantir.com/docs/apollo/managing-vulnerabilities/vulnerability-scanning)
- [Managing Vulnerabilities: Promotion Evaluation](https://www.palantir.com/docs/apollo/managing-vulnerabilities/promotion-evaluation-security)
- [Apollo Product Specification: Health](https://www.palantir.com/docs/apollo/apollo-product-specification/health)
- [Apollo Product Specification: Product Types](https://www.palantir.com/docs/apollo/apollo-product-specification/product-types)
- [Apollo Service Management Plane](https://www.palantir.com/docs/apollo/apollo-service-management/)
- [Liveness and Readiness](https://www.palantir.com/docs/apollo/core/liveness-and-readiness)
- [Publishing Versioned Helm Charts](https://www.palantir.com/docs/apollo/core/publishing-versioned-helm-charts)
- [Spoke Environment Prerequisites](https://www.palantir.com/docs/apollo/managing-environments/spoke-environment-prerequisites)
- [Connect a Spoke Environment](https://www.palantir.com/docs/apollo/core/connect-spoke)
- [Apollo What's New](https://www.palantir.com/docs/apollo/core/whats-new)

### Palantir Platform Pages
- [Apollo Platform](https://www.palantir.com/platforms/apollo/)
- [Apollo Product Overview](https://www.palantir.com/platforms/apollo/product/)
- [Apollo Pricing](https://www.palantir.com/platforms/apollo/pricing/)
- [Apollo Solutions](https://www.palantir.com/platforms/apollo/solutions/)
- [Palantir FedStart](https://www.palantir.com/offerings/fedstart/)

### Palantir Blog Posts
- [Palantir Apollo: Powering SaaS where no SaaS has gone before](https://blog.palantir.com/palantir-apollo-powering-saas-where-no-saas-has-gone-before-7be3e565c379)
- [How Palantir Meets IL6 Security Requirements with Apollo](https://blog.palantir.com/how-palantir-meets-il6-security-requirements-with-apollo-f6c3f0c51fe)
- [How Palantir Apollo Saves Developer Time on Kubernetes](https://blog.palantir.com/how-palantir-apollo-saves-developer-time-on-kubernetes-71d51a5d24df)
- [Palantir Apollo: Innovations in Software Deployment to the Edge](https://blog.palantir.com/palantir-apollo-innovations-in-software-deployment-to-the-edge-61711ef601c1)
- [Introducing PFCS Forward: Authorize Once, Deploy Everywhere](https://blog.palantir.com/introducing-pfcs-forward-d8755d34c429)

### Investor & Press
- [Palantir FedRAMP High Authorization Press Release](https://investors.palantir.com/news-details/2024/Palantir-Granted-FedRAMP-High-Baseline-Authorization/)
- [Palantir IL6 Accreditation Press Release](https://www.prnewswire.com/news-releases/palantir-announces-expansion-of-federal-cloud-service-with-dod-il6-accreditation-301644149.html)
- [Palantir CMMC Level 2 Certification](https://investors.palantir.com/news-details/2025/Palantir-Technologies-Achieves-Cybersecurity-Maturity-Model-Certification-CMMC-Level-2/)
- [Palantir 2024 Annual Report (10-K)](https://investors.palantir.com/files/2024%20FY%20PLTR%2010-K.pdf)

### Partners & Marketplace
- [Microsoft + Palantir Classified Network Partnership](https://news.microsoft.com/source/2024/08/08/palantir-and-microsoft-partner-to-deliver-enhanced-analytics-and-ai-services-to-classified-networks-for-critical-national-security-operations/)
- [Palantir + Carahsoft Public Sector Partnership](https://www.carahsoft.com/news/palantir-expands-partnership-with-carahsoft-to-deliver-apollo-platform-to-the-public-sector)
- [Apollo on AWS Marketplace](https://aws.amazon.com/marketplace/pp/prodview-yrpdgwgwxsu5g)
- [Apollo on Azure Marketplace](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/palantirtechnologies1585670280063.palantir_apollo)
- [Carahsoft Apollo Solution Overview (PDF)](https://static.carahsoft.com/concrete/files/6616/8615/9340/Whitepaper_-_Palantir_Apollo_-_Solution_Overview.pdf)
- [PFCS Forward DISA Authorization](https://www.executivebiz.com/articles/disa-palantir-pfcs-forward-onpremise-edge)

### Developer Conference
- [How Palantir Built Their GitOps Internal Developer Platform](https://platformengineering.org/talks-library/palantir-gitops-internal-developer-platform)

### Analysis
- [Palantir's Apollo, the Trojan Horse](https://www.palantirbullets.com/p/palantirs-apollo-the-trojan-horse)
- [System Soft Technologies: Real-Time Deployment with Palantir Apollo](https://sstech.us/real-time-deployment-with-palantir-apollo/)
- [FedScoop: Microsoft + Palantir AI for National Security](https://fedscoop.com/microsoft-palantir-ai-analytics-products-intelligence-defense-natsec/)

---

*Document compiled by Cortana research agent — March 2026*
*For internal use: AXE Platform research series*
