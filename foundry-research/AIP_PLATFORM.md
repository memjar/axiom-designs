# Palantir AIP (Artificial Intelligence Platform)
## Comprehensive Technical White Paper

**Compiled:** March 2026
**Sources:** Palantir official documentation, SEC 10-K filings, press coverage, developer community, analyst reports

---

## Table of Contents

1. [What Is AIP](#1-what-is-aip)
2. [Architecture: AIP on Top of Foundry's Ontology](#2-architecture-aip-on-top-of-foundrys-ontology)
3. [AIP Logic: Low-Code AI Workflow Builder](#3-aip-logic-low-code-ai-workflow-builder)
4. [AIP Assist: Developer Copilot](#4-aip-assist-developer-copilot)
5. [LLM Integration & Model Orchestration](#5-llm-integration--model-orchestration)
6. [Ontology-Aware AI: Grounding LLMs in Enterprise Reality](#6-ontology-aware-ai-grounding-llms-in-enterprise-reality)
7. [Tool Use / Function Calling: LLMs Acting on the Ontology](#7-tool-use--function-calling-llms-acting-on-the-ontology)
8. [AIP for Defense & Government](#8-aip-for-defense--government)
9. [AIP Mesh: Multi-Agent Coordination](#9-aip-mesh-multi-agent-coordination)
10. [Guardrails & Safety: Hallucination Prevention](#10-guardrails--safety-hallucination-prevention)
11. [Real Customer Examples](#11-real-customer-examples)
12. [Competitive Positioning](#12-competitive-positioning)
13. [Go-to-Market: AIP Bootcamp Strategy](#13-go-to-market-aip-bootcamp-strategy)
14. [Financial Performance & Business Impact](#14-financial-performance--business-impact)
15. [Key Developer Tools & SDKs](#15-key-developer-tools--sdks)

---

## 1. What Is AIP

### Launch & Origin

Palantir's **Artificial Intelligence Platform (AIP)** was launched in **April 2023**. It was initially rolled out to select customers, with broader onboarding accelerating through the second half of 2023 and into 2024. The launch was announced with a letter from Palantir titled *"Our New Platform: Bending Artificial Intelligence to Our Collective Will"*, positioning AIP as a direct response to the emergence of large language models (LLMs) and the enterprise need to operationalize them safely.

Palantir was founded in 2003 and had already spent two decades building Gotham (for government/intelligence agencies) and Foundry (for commercial enterprises). AIP sits on top of both, acting as the AI/LLM orchestration layer.

### Core Purpose

AIP **connects AI with your data and operations** — it is not a standalone LLM application. Its fundamental design principle is that LLMs are most powerful (and least dangerous) when grounded in an organization's actual operational data rather than operating on general knowledge alone.

From Palantir's 2024 10-K SEC filing:

> *"AIP leverages the power of existing machine learning technologies alongside generative AI models, including large language models ("LLMs"), directly within Gotham and/or Foundry to help operationalize AI on enterprise data."*

### What AIP Is Not

AIP is explicitly differentiated from:
- **Chat interfaces** (it is a platform for building workflows, not a chatbot)
- **Standalone LLM APIs** (AIP adds ontology grounding, security, audit, and action)
- **AI add-ons** (it is an end-to-end operating system for AI across the enterprise)

### Positioning

Palantir positions AIP as an **AI Operating System** — a layer that sits between raw LLMs and enterprise operations, providing:
- Governed access to a wide range of LLMs
- Grounding in the company's actual operational data (via the Ontology)
- The ability to take real-world actions (not just generate text)
- Full audit trails, access controls, and governance
- Human-in-the-loop workflow integration

From the official platform page:
> *"AIP provides a full set of capabilities for building with generative AI and connecting AI to operations."*

---

## 2. Architecture: AIP on Top of Foundry's Ontology

### The Three-Platform Stack

Palantir's full platform consists of three interlocking layers:

| Platform | Role |
|----------|------|
| **Foundry** | Data operations platform — ingests, transforms, models, and visualizes data |
| **AIP** | AI/LLM orchestration layer — connects LLMs to the Ontology and enables agentic workflows |
| **Apollo** | Deployment and operations platform — manages software delivery across all environments |

These three platforms together form what Palantir calls the **AI Mesh** — an architecture capable of delivering AI-driven products from cloud applications to mobile apps using vision-language models to edge deployments with embedded local AI.

### The Ontology: The Foundation of Everything

The **Ontology** is Palantir's central architectural innovation and is the key differentiator of the entire AIP system. It is a **semantic layer** that sits on top of raw data and maps data to its real-world operational meaning.

Key properties of the Ontology:

- **Objects**: Represent real-world entities (a patient, a tank, an oil well, a shipment)
- **Properties**: Attributes of those objects (location, status, fuel level, timestamp)
- **Links**: Relationships between objects (a patient is linked to their doctor, their ward, their medications)
- **Actions**: Operations that can be performed on objects (approve a transfer, update a status, reroute a shipment)
- **Functions**: Logic that can be executed on objects (calculate bed availability, score a lead, flag an anomaly)

The Ontology is described by Palantir as a **digital twin of the organization** — capturing not just data but the *decisions* the organization needs to make and the real-world processes it operates.

From official documentation:
> *"The Ontology sits on top of the digital assets integrated into the Palantir platform (datasets and models) and connects them to their real-world counterparts — ranging from physical assets like plants, equipment, and products to concepts like customer orders or financial transactions."*

### How AIP Sits on the Ontology

AIP adds the AI layer to the Ontology:

```
┌─────────────────────────────────────────────────────────┐
│                    USERS / APPLICATIONS                  │
├─────────────────────────────────────────────────────────┤
│   AIP Agent Studio │ AIP Logic │ AIP Assist │ Workshop  │
├─────────────────────────────────────────────────────────┤
│                      AIP LAYER                          │
│  LLM Access │ Orchestration │ Evals │ Automate │ MCP    │
├─────────────────────────────────────────────────────────┤
│                    ONTOLOGY LAYER                        │
│    Objects │ Actions │ Functions │ Links │ Security      │
├─────────────────────────────────────────────────────────┤
│                   FOUNDRY LAYER                         │
│  Datasets │ Pipelines │ Models │ Code Workspaces         │
├─────────────────────────────────────────────────────────┤
│              DATA SOURCES / INTEGRATIONS                │
│   Databases │ APIs │ Streams │ Files │ Enterprise Systems│
└─────────────────────────────────────────────────────────┘
```

AIP's end-to-end architecture covers 12 capability categories:

1. **Secure LLM Integration** — Governed access to commercial and open-source models
2. **Context Engineering** — Tools for integrating data, logic, and actions into the Ontology
3. **Agent Lifecycle Management** — Build, orchestrate, evaluate, deploy agents
4. **Operational Automation** — Schedule-based, event-driven, and API-driven automations
5. **End-to-End Observability** — Monitoring and tracing for all AI-driven workflows
6. **No-Code Builder Tools** — AIP Logic, Agent Studio
7. **Low-Code Builder Tools** — Workflow Builder, Pipeline Builder with AIP
8. **Pro-Code Developer Tools** — Code Workspaces, OSDK, TypeScript/Python functions
9. **Evaluation Frameworks** — AIP Evals for testing and benchmarking
10. **Human-in-the-Loop Controls** — Approval workflows, action staging
11. **Security & Governance** — Role-based access, audit trails, encryption
12. **External Integration** — Palantir MCP, OSDK for external apps

### AIP + Apollo: Deployment Anywhere

Apollo manages how Foundry and AIP software is deployed across environments — cloud, on-premises, air-gapped classified networks, or edge devices. This is critical for defense customers who need AI capabilities in classified or disconnected environments. AIP and Foundry operate as a shared service mesh, powered by Apollo and deployed within Rubix (Palantir's cloud infrastructure layer).

---

## 3. AIP Logic: Low-Code AI Workflow Builder

### Overview

**AIP Logic** is the primary no-code/low-code development environment within AIP. It allows builders — not just engineers — to create LLM-powered functions that read and write to the Ontology without needing to write API code.

From official documentation:
> *"AIP Logic is a no-code development environment for building, testing, and releasing functions powered by LLMs. It enables you to build feature-rich AI-powered functions that leverage the Ontology without the complexity typically introduced by development environments and API calls."*

### The Block-Based Model

AIP Logic functions are composed of **blocks** — discrete units of computation that take inputs and produce outputs. Blocks can be chained together to create complex workflows:

| Block Type | Purpose |
|-----------|---------|
| **Use LLM** | The core block — sends a prompt to an LLM with optional tools |
| **Execute Function** | Calls an existing Foundry function (TypeScript, Python, or another Logic function) |
| **Apply Action** | Triggers an Ontology write operation via an Action |
| **Branch (If/Else)** | Conditional logic based on previous block outputs |
| **Loop** | Iterates over a collection of objects, applying transformations |
| **Transforms** | Data manipulation (filter, map, reduce) without LLM involvement |

The output of any block can be passed as input to subsequent blocks, enabling complex multi-step AI workflows.

### The Use LLM Block: Tool-Augmented Generation

The Use LLM block is the heart of AIP Logic. It consists of:

1. **Prompt**: System prompt + user input (can include Ontology objects as variables)
2. **Tools**: Ontology-driven tools the LLM can call (data queries, function calls, actions)
3. **Output**: A return value (text, object, or Ontology edit)

The LLM does not have direct access to tools — it can only *request* tool calls. AIP Logic executes those tool calls within the invoking user's permissions. This is a critical security control.

### Tools Available to LLMs in AIP Logic

Three categories of tools:

**Data Tools:**
- Object queries (load specific objects by ID or filter)
- Object set queries (search across object collections)
- Semantic search (find relevant objects by similarity)
- Full-text search
- Function outputs (run a TypeScript/Python function and inject results)

**Logic Tools:**
- Call Function (invoke another Foundry function)
- Execute condition
- Call another Logic function

**Action Tools:**
- Apply Action (write to the Ontology — modify objects, trigger workflows)
- The LLM proposes the action; it is staged for human review or auto-applied based on configuration

### Security Model

AIP Logic inherits Palantir's full platform security:
- LLMs can only access data the invoking user has permission to see
- Actions can only be applied if the user has the required permissions for that Action
- All LLM calls are logged with full input/output for audit purposes
- Platform controls are not bypassable from within AIP Logic

### Automation Integration

Logic functions can be published and integrated with **Automate** to:
- Run on a schedule (e.g., nightly batch processing)
- Trigger on events (e.g., a new object is created, a data threshold is crossed)
- Stage proposed Ontology edits for human review rather than auto-applying them

### 2024 Feature Evolution

Major updates shipped throughout 2024:

- **April 2024**: Execute block for deterministic function calls; branching support
- **May 2024**: Consolidated Uses panel; action creation reduced from 12 clicks to 4
- **September 2024**: OSDK package with AIP Logic integration for external apps
- **November 2024**: External LLM integration (bring your own model via TypeScript function interface)
- **November 2024**: Workflow Builder (beta) — visual graph-based workflow design tool

---

## 4. AIP Assist: Developer Copilot

### Overview

**AIP Assist** is the AI-powered assistant embedded throughout the Palantir platform. It operates across all platform surfaces — code editors, pipeline builders, ontology editors, data exploration tools — providing contextual, real-time AI assistance.

From official documentation:
> *"AIP Assist is an LLM-powered support tool designed to help users navigate, understand, and generate value with the Palantir platform. Users can ask AIP Assist questions in natural language and receive real-time help with their queries."*

### Core Feature Set

**Code Generation & Assistance (Code Repositories / VS Code):**

- **Code Autocomplete**: Parses the currently-open file and generates contextually relevant code completions; accepted with Tab
- **Inline Code Assistance**: Highlight any code snippet to get Explain, Find Bugs, or Ask a Question options inline
- **Code Explanation**: Explain the purpose of code snippets or entire files in natural language
- **Code Debugging**: Identify bugs, suggest fixes, trace errors
- **Code Translation**: Convert code between Python, SQL, Mesa, Java, and TypeScript
- **Context-Aware Attachments**: Attach code snippets, files, or repositories to enrich AI Assist responses

**Pipeline Builder Assist:**
- **Explain**: Describe what a pipeline step does, suggest names/descriptions
- **Regex Helper**: Generate custom regular expressions in natural language
- **Transform Assist**: Create and edit regex patterns, cast strings to timestamp formats

**Platform Navigation:**
- Natural language questions about Palantir documentation
- Contextual help within any platform application

### VS Code Integration: Continue Extension

For developers working in VS Code workspaces, Palantir integrates **Continue** — an open-source AI code generation extension for VS Code. Palantir pre-configures Continue with:

- Palantir-provided language models
- Knowledge of the Ontology structure
- Context about relevant Palantir SDKs (OSDK, Python Transforms, TypeScript functions)
- Understanding of the organization's data structures

This gives developers a GitHub Copilot-like experience but grounded in Palantir's platform-specific context.

Continue is automatically available in VS Code workspaces when AIP is enabled — no additional installation required.

### Palantir MCP (Model Context Protocol)

Palantir has implemented the **Model Context Protocol (MCP)** standard — connecting external AI IDEs and agents to the Palantir platform. Through MCP, external development tools can:

- Query data from the Ontology
- Access Palantir platform documentation
- Build and interact with Foundry applications
- Give external AI coding assistants (like Claude Code or Cursor) context about Palantir's specific platform

This significantly lowers the barrier for developers who prefer external tools over Palantir's built-in editors.

---

## 5. LLM Integration & Model Orchestration

### Model-Agnostic Platform

AIP is explicitly **model-agnostic** — it does not bet on any single LLM provider. From official documentation:

> *"AIP enables secure access to the full range of commercial LLMs (e.g., GPT, Gemini, Claude, Grok) and open-source models (e.g., Llama), through Palantir-managed infrastructure that ensures that no transmitted data is retained by third-party providers, and no transmitted data is used for retraining by model providers."*

### Supported Model Providers

| Provider | Models |
|----------|--------|
| **OpenAI** | GPT-4, GPT-4 Turbo, GPT-4o, GPT-4 Vision |
| **Anthropic** | Claude 3 Sonnet, Claude 3 Opus, Claude 3 Haiku |
| **Google** | Gemini Pro, Gemini Pro Vision |
| **Meta** | Llama 2 70B Chat, Llama 3 variants |
| **Mistral AI** | Mixtral 8x7B |
| **xAI** | Grok models |
| **Custom / Fine-tuned** | Customer's own models, domain-specific models |

### How Models Are Accessed

Models are served through **Palantir-managed infrastructure**, meaning:
- No raw API keys needed in application code
- Data transmitted to LLMs is isolated and not retained
- Data is not used for model retraining by providers
- All model calls are logged for audit

For regulated industries (healthcare, defense, finance), this is a critical guarantee. Enterprise customers can also configure regional availability — for example, routing EU customer data only to EU-hosted model endpoints.

### Bring Your Own Model (BYOM)

AIP supports first-class integration for customers who want to use their own LLMs:

- Fine-tuned models (e.g., a domain-specific medical LLM)
- Models accessed through existing enterprise subscriptions (e.g., Azure OpenAI)
- Custom models hosted on customer infrastructure

BYOM models are integrated via a TypeScript function implementing the LLM interface primitive, making them available in the `useLLM` board in AIP Logic alongside Palantir-managed models.

### LLM Capacity Management

Palantir provides administrators with granular controls over LLM usage:

- **Token quotas** per user, team, or function
- **Model routing rules** — define which models can be used in which contexts
- **Cost tracking** and usage analytics
- **Regional restrictions** — enforce data residency requirements

### AIP Evals: Cross-Model Testing

**AIP Evals** is the integrated evaluation framework for testing AI functions and agents across different models. Key capabilities:

- Create test cases with expected inputs/outputs
- Run the same prompt/agent configuration across multiple LLMs
- Compare performance, cost, latency, and accuracy across models
- Analyze variance across multiple executions of the same model
- Grid search over parameter combinations to find optimal configurations
- Debug and iterate on agent definitions before production deployment

---

## 6. Ontology-Aware AI: Grounding LLMs in Enterprise Reality

### The Fundamental Problem AIP Solves

Standard LLM deployments face a core tension: LLMs are trained on general internet data, but enterprises need them to reason about *specific operational data* — data that is proprietary, constantly changing, and lives in internal systems.

Without grounding:
- LLMs hallucinate enterprise-specific facts
- Responses are generic, not operationally useful
- The LLM cannot take actions in the real world
- There is no audit trail linking AI responses to source data

### The Ontology as the Grounding Mechanism

Palantir's Ontology solves this by serving as the **structured operational context** that gets injected into LLM prompts. Instead of feeding raw text (as in traditional RAG), AIP injects **Ontology objects** — structured, typed, validated data entities.

From the Palantir engineering blog:
> *"Rather than feeding text, OAG injects ontology objects themselves into the LLM context. The advantage: deterministic reasoning with structured data, dramatically reducing hallucination potential."*

The Ontology language models the **"nouns" and "verbs"** of operational processes:
- **Nouns** = Objects (patients, shipments, aircraft, financial transactions)
- **Verbs** = Actions (transfer a patient, reroute a shipment, flag a transaction)

### RAG vs. OAG

| | **Traditional RAG** | **Palantir OAG** |
|--|---------------------|------------------|
| **Data Source** | Unstructured text chunks (PDFs, documents) | Structured Ontology objects |
| **Retrieval** | Semantic similarity search over vectors | Ontology queries (typed, filtered, linked) |
| **Hallucination Risk** | High — LLM interprets ambiguous text | Low — LLM receives typed, validated data |
| **Actions** | None — read-only context | Write operations via Actions |
| **Audit** | Limited — hard to trace what text was used | Full — every object access is logged |
| **Permissions** | Usually flat | Role-based per object type and action |

### OAG Technical Mechanics

In AIP Logic, the OAG process works as follows:

1. User triggers a Logic function (from an application, automation, or manually)
2. AIP Logic injects Ontology metadata into the prompt — describing what object types exist and what properties they have
3. LLM generates a request to query the Ontology (a search query or object lookup)
4. AIP Logic executes the query, respecting the user's permissions
5. Results (Ontology objects) are injected back into the LLM context
6. LLM reasons over structured objects to generate a response or proposed action
7. Chain-of-thought steps are surfaced to the user — showing which objects were accessed and why

This process is called **Ontology Augmented Generation (OAG)** — an evolution beyond retrieval-augmented generation.

### Grounding Example: Hallucination Prevention

From Palantir's engineering blog:
> *"When an AIP Logic function is run without ontology grounding, the model generates responses based on what it predicts is most likely — and this output can be a hallucination. For example, enterprise data may indicate that a company operates in specific smaller cities, while the model fabricates entirely different locations."*

With OAG, the LLM is constrained to reason only about the actual cities in the Ontology — hallucination is prevented by not giving the model an opportunity to guess.

### Precision Reasoning Within Defined Boundaries

A critical design principle of AIP:

> *"AIP does not scan the entire ontology or attempt to understand the full enterprise at once — it reasons inside the boundaries you give it. Ontology objects passed into AIP Logic act like variables, defining what the model should consider and what it should ignore."*

This keeps reasoning focused, reliable, and scoped to the specific operational context.

---

## 7. Tool Use / Function Calling: LLMs Acting on the Ontology

### The Action Architecture

One of AIP's most powerful capabilities is enabling LLMs to **take real-world actions** — not just generate text. This is implemented through the Ontology's Action system.

The security model is critical here:
> *"LLMs do not have direct access to tools; LLMs can only ask to use tools, and these tool calls are then executed by AIP Logic within the invoking user's permissions."*

This means the LLM proposes actions, but the platform enforces authorization before executing them.

### Types of Tool Calls Available to LLMs

**Read Operations:**

| Tool | Description |
|------|-------------|
| Object Query | Fetch a specific object by ID |
| Object Set Query | Filter/search across a collection of objects |
| Semantic Search | Find similar objects by embedding similarity |
| Full-Text Search | Search across text properties |
| Execute Function | Run a TypeScript/Python function and use its output |
| Call Logic Function | Invoke another AIP Logic function |

**Write Operations:**

| Tool | Description |
|------|-------------|
| Apply Action | Execute an Ontology Action (create, modify, or delete objects; trigger downstream workflows) |

### Human-in-the-Loop Design for Actions

Actions have configurable execution modes:

- **Auto-apply**: Changes are immediately applied to the Ontology (for low-risk, routine operations)
- **Stage for review**: The LLM's proposed changes are surfaced to a human operator who can inspect, modify, or reject before applying
- **Confirmation prompt**: The agent asks the user to confirm before executing

This creates a **control plane** where humans retain decision authority over consequential actions while routine automation runs autonomously.

### Native vs. Prompted Tool Calling

**Prompted Tool Calling:**
- Works with all models, including those without native function-calling support
- Instructions for tool use are injected into the prompt
- Agents call tools sequentially (one at a time)
- Slower for complex multi-step operations

**Native Tool Calling:**
- Uses built-in function-calling capabilities of supported models (e.g., GPT-4, Claude 3)
- Greater token efficiency
- Agents can call multiple tools in parallel
- Improved speed and performance for complex queries

### The Agent-as-Function Pattern

A fully built AIP Agent can be published as a **function** and pulled into AIP Automate — enabling agents to be triggered by schedules or events, operating autonomously without user initiation. This is the foundation of fully autonomous agent operation in AIP.

### Loops for Bulk Actions

AIP Logic supports **loops** that iterate over collections of objects and apply transformations or actions to each:

- Useful for bulk Ontology updates (e.g., flag all shipments with a specific condition)
- Can be configured to auto-apply or stage all edits for batch human review
- If branches inside a loop return Ontology edits, all branches must explicitly handle the action (either execute or explicitly specify "no action")

---

## 8. AIP for Defense & Government

### Overview

Palantir's defense heritage predates AIP by two decades. The company's original product (Gotham) was built for intelligence agencies post-9/11. AIP brings LLM capabilities into this existing defense platform, enabling:

- Natural language interfaces to complex intelligence data
- AI-assisted decision-making for military operators
- Drone reconnaissance analysis and targeting support
- Communications intelligence
- Multi-domain operational data fusion

### Classification Support

AIP is designed for deployment across all classification levels, including:
- **Unclassified**
- **SECRET**
- **Secure Compartmented Information (SCI)**
- **Special Access Programs (SAP)**

Apollo manages deployment into air-gapped, classified environments — ensuring that classified data never leaves the secure enclave while still benefiting from AI capabilities.

### TITAN Contract ($178 Million)

The most significant defense deployment of AIP to date is **TITAN (Tactical Intelligence Targeting Access Node)** — the U.S. Army's next-generation AI-defined intelligence ground station.

**Contract details:**
- Awarded: March 2024
- Value: $178 million
- Systems: 10 AI-defined ground systems
- First deliveries: March 2025

**What TITAN does:**
- Connects Army units to high-altitude and space sensors
- Provides targeting data to soldiers using AI/ML fusion
- Integrates data from the Joint All-Domain Command and Control (JADC2) architecture
- Enables Multi-Domain Operations (MDO) by synthesizing data from multiple platforms

**Two variants:**
1. **Advanced variant** (5 systems): Mounted on tactical trucks, direct space sensor downlink
2. **Basic variant** (5 systems): Mounted on Joint Light Tactical Vehicles (JLTVs), partial space data access

**Significance:** First time a software company (not a traditional defense hardware prime) won a significant hardware program. Palantir beat defense giant RTX Corporation.

From Palantir SVP Bryant Choung:
> *"TITAN greatly increases capability, but we want the software and AI to decrease complexity."*

**Modular Open System Architecture (MOSA):** Palantir's TITAN uses an open architecture standard, allowing future sensor integrations and capability upgrades without starting from scratch.

### Palantir + Anduril Alliance (December 2024)

In December 2024, Palantir and **Anduril Industries** formed a strategic alliance to merge their respective AI capabilities for defense customers:

- **Palantir contributes**: AIP's data management, cloud-based AI tooling, and decision-support software
- **Anduril contributes**: Edge computing capabilities, autonomous systems (drones, underwater vehicles), and hardware integration

The partnership is designed to address two key military challenges:
1. **Data readiness**: Structuring, labeling, and preparing defense data for AI training
2. **Processing at scale**: Running AI inference at the tactical edge in degraded-network environments

### Broader Defense Customers & Applications

- **U.S. Army**: TITAN, battlefield logistics, personnel management
- **U.S. Air Force**: Aircraft maintenance optimization, mission planning
- **NATO allies**: Intelligence sharing and operational coordination
- **Israeli Defense Forces**: Reported use in conflict operations (controversial)
- **Special Operations**: Target identification and mission support

### AIP in Defense: Key Use Cases

| Use Case | AIP Capability |
|----------|---------------|
| Target identification | Computer vision + LLM reasoning over sensor data |
| Logistics optimization | Ontology-grounded supply chain AI |
| Threat intelligence | LLM-powered document analysis and synthesis |
| Communications analysis | NLP over signals intelligence |
| Battle damage assessment | Multi-source data fusion |
| Operator decision support | Natural language interface to operational data |

---

## 9. AIP Mesh: Multi-Agent Coordination

### The AI Mesh Concept

Palantir uses the term **AI Mesh** to describe the architectural paradigm in which AIP, Foundry, and Apollo operate together as an interconnected system capable of:

- Deploying AI-driven products from cloud to edge
- Coordinating multiple specialized agents toward shared objectives
- Weaving human oversight into autonomous workflows
- Maintaining consistent security and governance across all agent interactions

The AI Mesh is not a single product but an architectural design philosophy.

### AIP Agent Studio

**AIP Agent Studio** is the primary tool for building, deploying, and managing AI agents in AIP. From official documentation:

> *"AIP Agent Studio allows users to build interactive assistants, known as AIP Agents, that are equipped with enterprise-specific information and tools, deployable internally in the platform and externally through the Ontology SDK and platform APIs."*

Agents are powered by:
- LLMs (any supported model)
- The Ontology (for grounding and action)
- Documents (for knowledge retrieval)
- Custom tools (user-defined functions)

### Agent Deployment Tiers

| Tier | Description | Tools |
|------|-------------|-------|
| **Ad-hoc** | Quick document analysis, one-off queries | AIP Threads |
| **Task-specific** | Reusable agents with specific context | Agent Studio |
| **Agentic Application** | Agents integrated into Workshop or OSDK apps | Agent Studio + Workshop/OSDK |
| **Automated** | Agents published as functions for autonomous workflows | Agent Studio + AIP Automate |

### Multi-Agent Architecture

The Ontology serves as the **shared knowledge layer** for multiple agents operating in coordination. Key patterns:

**Orchestrator-Worker Pattern:**
- A primary "orchestrator" agent decomposes a complex task
- Sub-agents handle specific subtasks (e.g., data retrieval, analysis, reporting)
- The orchestrator synthesizes results and proposes final actions

**Human-AI Teaming:**
- Agents create proposals; humans review and approve
- Approval workflows are built into Workshop applications
- Approved actions are automatically applied to the Ontology

**Agent-as-Function:**
- Agents can be published as callable functions
- Other agents or automations can call them as tools
- Enables composable multi-agent workflows

### Machinery: Process Orchestration (2025)

**Machinery** is a new capability (introduced in 2025) for modeling and managing operational processes:

- Models real-world workflows as structured processes
- Identifies unwanted behavior and bottlenecks
- Supports building custom supervision applications
- Enables humans to intervene at specific steps
- Provides real-time monitoring of AIP-driven workflows

### AIP Automate

**AIP Automate** is the automation engine that runs agents and Logic functions without user initiation:

- **Schedule-based**: Run on cron schedules (nightly, hourly, etc.)
- **Event-driven**: Trigger on Ontology events (object created, property changed, threshold crossed)
- **API-driven**: Trigger via external webhook or API call
- Outputs can be auto-applied or staged for human review

### External Agent Integration via MCP

Palantir MCP (Model Context Protocol) allows external AI agents — including those built with frameworks like LangChain, AutoGen, or custom agent systems — to connect to Palantir's Ontology. External agents can:

- Query Ontology data
- Access documentation
- Build and interact with Foundry applications
- Operate with the same permissions controls as internal agents

---

## 10. Guardrails & Safety: Hallucination Prevention

### The Three-Layer Safety Architecture

Palantir's approach to AI safety operates at three levels:

**Layer 1: Ontology Grounding (Structural Prevention)**
The Ontology prevents hallucination by giving the LLM only validated, structured data to reason about. The LLM cannot fabricate facts it isn't given — if it needs information about a supplier, it must query the Ontology, which either has the data or returns nothing.

**Layer 2: Permission Controls (Access Governance)**
LLMs can only access data that the invoking user has permission to see. This prevents both unauthorized data access and responses based on unauthorized context. From documentation:
> *"Platform security controls grant an LLM access only to what is necessary to complete a task."*

**Layer 3: Action Gating (Consequence Control)**
All write operations require either explicit human approval or are configured with auto-apply rules by platform administrators. LLMs cannot directly modify the Ontology — they can only propose modifications through the Action system.

### OAG vs. RAG: The Hallucination Comparison

| Scenario | RAG Response | OAG Response |
|----------|-------------|-------------|
| LLM asked about cities where company operates | May hallucinate plausible-sounding cities | Queries Ontology, returns actual cities from data |
| LLM asked about inventory levels | May guess based on training data | Queries real-time inventory objects |
| LLM proposes a shipment reroute | No action capability | Proposes specific Action, staged for human review |

### Chain-of-Thought Transparency

AIP Logic surfaces the LLM's chain-of-thought reasoning to users, showing:
- Which Ontology objects were queried and why
- Which functions were executed
- What the LLM's intermediate reasoning steps were
- Which data sources informed the final response

This "show your work" capability builds organizational trust in AI outputs by making them traceable and auditable.

### Audit & Compliance

Every AI interaction in AIP is logged:
- Full input/output of every LLM call
- Which user triggered the function
- Which Ontology objects were accessed
- Which Actions were proposed and whether they were applied
- Timestamps and session metadata

This creates a complete audit trail — essential for regulated industries (healthcare, finance, defense) and AI governance compliance.

### No Data Used for Retraining

A critical enterprise guarantee: Palantir's managed LLM infrastructure ensures that:
- No enterprise data transmitted to LLMs is retained by model providers
- No enterprise data is used for model retraining
- Data stays within the agreed-upon geographic and regulatory boundaries

---

## 11. Real Customer Examples

### Healthcare

**Cleveland Clinic:**
- 75% reduction in time spent calculating bed capacity
- AIP deployed to dynamically surface clinical, operational, and financial information
- AI-powered Patient Card proactively highlights missing or outdated information
- Automated alerts for critical updates

**Nebraska Medicine:**
- Presented at AIPCon as an active AIP customer
- Healthcare workflow optimization and clinical decision support

**MaineHealth:**
- Presented at AIPCon 8 (2024)
- Healthcare operations and clinical data integration

**Novartis:**
- Pharmaceutical R&D acceleration
- Drug discovery and clinical trial data integration

### Energy

**BP (British Petroleum):**
- Reported $1 billion in savings through optimized oil and gas operations
- Foundry deployed as enterprise analytics platform
- Presented at AIPCon 8 alongside AIP workflow demonstrations
- ERP integration and supply chain analytics

### Aerospace & Defense

**Airbus:**
- Operational efficiency through Foundry data integration
- Manufacturing and supply chain optimization
- One of Palantir's most cited reference customers

### Finance

**CAZ Investments:**
- Processed 100x more leads using AIP
- 90% reduction in lead processing time
- Demonstrates AIP's applicability to high-volume analytical workflows

**Global Bank (unnamed):**
- Transaction monitoring alerts resolved 60% faster
- 90% lower cost per resolved alert
- AML (Anti-Money Laundering) workflow automation

**Morgan Stanley:**
- Data integration and analytics

### Manufacturing & Automotive

**Ferrari:**
- Foundry integration for manufacturing operations
- Race car performance data analytics

**Fiat Chrysler Automobiles (now Stellantis):**
- Supply chain and manufacturing data

### Utilities & Infrastructure

**PG&E (Pacific Gas & Electric):**
- Grid operations and wildfire risk management

**Waste Management:**
- Presented at AIPCon 8
- Fleet optimization and logistics

### Enterprise AIP Use Cases (Broad)

| Industry | Use Case | AIP Capability |
|----------|----------|---------------|
| Healthcare | Bed management | Real-time Ontology + LLM reasoning |
| Energy | Drilling optimization | Predictive analytics + AI recommendations |
| Finance | Lead scoring | High-volume LLM processing at scale |
| Retail | Inventory management | Supply chain Ontology + AI automation |
| Manufacturing | Quality control | Vision models + defect classification |
| Logistics | Route optimization | Constraint satisfaction + LLM planning |

### AIPCon: The Customer Conference

Palantir runs **AIPCon** — a regular conference where customers publicly demo their AIP deployments. AIPCon 8 (2024) featured 70+ enterprise giants including:
- American Airlines
- BP
- Novartis
- MaineHealth
- Waste Management
- Lumen
- TWG Motorsports

These public demos serve both as validation and as sales collateral — demonstrating production-grade use cases across industries.

---

## 12. Competitive Positioning

### The Competitive Landscape

AIP competes across multiple dimensions depending on the buyer and use case:

| Competitor | How They Compete |
|-----------|-----------------|
| Microsoft Copilot / Fabric | Productivity AI + existing M365 ecosystem |
| Databricks | Open ML/AI engineering platform + Lakehouse |
| Snowflake Cortex | SQL-first, cloud-native AI within data warehouse |
| Salesforce Einstein | CRM-embedded AI |
| ServiceNow | IT operations AI |
| AWS SageMaker | ML development platform |
| Google Vertex AI | Full-stack ML/AI on GCP |

### Palantir AIP vs. Microsoft Copilot / Fabric

**Microsoft's position:**
- Invested $13B in OpenAI; exclusive early access to GPT-4
- Copilot embedded across all M365 apps (Word, Excel, Teams, Outlook)
- Fabric: unified data platform competing with Foundry
- Argument: "Why pay for Foundry when Fabric + Copilot is in your Enterprise Agreement?"
- Azure Government Top Secret (classified cloud) — encroaching on Gotham's territory
- Spending $100B+ in capex on GPU infrastructure

**Palantir's counter:**
- Microsoft Copilot is **productivity AI** (helps write emails, summarize meetings)
- AIP is **operational AI** (takes actions, modifies systems, controls physical processes)
- Ontology provides a depth of context Microsoft cannot replicate with general RAG
- Defense/classified environment capabilities that Azure cannot currently match at scale
- Purpose-built for complex, multi-source operational data environments

**Reality check:** Microsoft's ubiquity and bundling strategy is the biggest commercial threat to AIP. Many enterprises will accept "good enough" AI from Microsoft rather than pay Palantir's premium.

### Palantir AIP vs. Databricks

**Databricks' position:**
- Founded by creators of Apache Spark; acquired MosaicML for $1.3B (LLMops)
- 60% YoY revenue growth in Q3 2024; $3B+ annualized run rate
- Open lakehouse architecture built for data engineers and data scientists
- Delta Lake + MLflow + Unity Catalog as the open data stack
- Strong open-source community (Spark, Delta, MLflow all open-sourced)

**Key difference:**
- Databricks targets **data engineering and ML teams** — people who build models and pipelines
- Palantir targets **enterprise operations and business teams** — people who use AI to make decisions
- Databricks is "bring your own AI framework"; Palantir is "AI out of the box on your data"

**Overlap zone:** Both compete for the "enterprise AI platform" budget, but serve different personas within organizations.

### Palantir AIP vs. Snowflake Cortex

**Snowflake's position:**
- 11,000+ customers including 740+ of Forbes Global 2000
- Cortex AI: LLM capabilities embedded directly in Snowflake SQL
- CORTEX ANALYST: Natural language queries over data warehouse
- Argument: "AI should come to the data, not the data to AI" — negating the need for Palantir's processing layer
- 126% net revenue retention rate

**Key difference:**
- Snowflake is a data warehouse with AI features added on
- Palantir is an operational platform with AI at its core
- Snowflake Cortex works well for **analytical queries** ("Show me Q3 sales by region")
- AIP works well for **operational decisions** ("Based on current inventory, reroute this shipment and notify the logistics team")

**Overlap zone:** Both can handle natural language data queries, but AIP's ability to take write actions is not replicated by Snowflake.

### Palantir's Moat: The Ontology

The key question for all competitive analysis is whether Palantir's **Ontology** — the structured, operational, decision-centric model of the enterprise — represents a durable moat or a complexity tax.

**Bull case:** Once the Ontology is built (a significant implementation investment), it becomes the authoritative model of the enterprise. Replacing it means rebuilding years of organizational knowledge. The Ontology enables AI to take consequential actions that pure data platforms cannot safely do.

**Bear case:** Competitors are developing their own ontology-like capabilities. Microsoft's Graph API, Databricks' Unity Catalog, and Salesforce's semantic layer all provide some of the same grounding benefits. If these mature sufficiently, Palantir's ontology becomes less differentiated.

### Head-to-Head Feature Comparison

| Capability | Palantir AIP | Microsoft Copilot | Databricks | Snowflake Cortex |
|-----------|-------------|------------------|------------|-----------------|
| LLM grounding | Ontology (structured objects) | SharePoint / M365 data | Feature Store / Delta tables | Warehouse tables |
| Write actions | Yes (via Actions) | Limited | No (inference only) | No |
| Multi-agent | Yes (Agent Studio + Automate) | Limited | Via external frameworks | No |
| No-code AI builder | AIP Logic | Copilot Studio | Databricks AI Assistant | Cortex Analyst |
| Defense / classified | Yes (Apollo + air-gap) | Azure Gov (expanding) | Limited | No |
| Audit trail | Full (per-object, per-action) | Limited | Partial | Limited |
| Hallucination prevention | OAG architecture | Standard RAG | Standard RAG | SQL-constrained |
| Pricing | Premium contract | Often bundled | Usage-based | Usage-based |

---

## 13. Go-to-Market: AIP Bootcamp Strategy

### The Bootcamp Model

Palantir's most significant go-to-market innovation with AIP is the **AIP Bootcamp** — an intensive 1-to-5-day workshop where potential customers build live AI applications on their own data. From the official bootcamp page:

> *"Customers go from 0 to use case in 5 days."*

This is a radical departure from traditional enterprise software sales cycles (3-12 months of discovery, pilot, evaluation, procurement, implementation).

### How Bootcamps Work

1. Palantir's Forward Deployed Engineers (FDEs) arrive on-site (or virtually)
2. Customer brings their actual operational data
3. FDEs work with the customer to identify a high-value AI use case
4. Over 1-5 days, the team builds a working prototype on AIP
5. Customer leaves with a functional AI application and a clear path to production

### Scale & Growth

| Period | Bootcamps |
|--------|-----------|
| 2022 | 0 (pilots only) |
| H2 2023 | ~414 bootcamps |
| Full 2023 | 560 bootcamps across 465 organizations |
| 2024 (projected) | 3,000 bootcamps |
| Q4 2024 cumulative | 1,300+ completed |

Key quote from CRO Ryan Taylor (2023):
> *"We're on track to conduct boot camps for more than 140 organizations by the end of November, nearly half of those are taking place this month alone... We almost tripled the number of AIP users last quarter and nearly 300 distinct organizations have used AIP since our launch just five months ago."*

### Conversion Economics

- 5-10% of new AIP users convert to revenue-generating customers within 3-6 months
- Bootcamps have achieved a reported **~75% conversion rate** by 2025
- Representative outcomes: Fortune 500 industrial company expanded 5x from initial engagement; Fortune 100 retailer converted pilot to $12M annual contract value

### Developer Tier (2024)

In 2024, Palantir introduced a **Developer Tier** — free, limited access to Foundry and AIP for individual developers in the US and select countries. This creates a bottom-up adoption pathway (developers explore → propose to enterprise → enterprise buys).

### Why Bootcamps Work

1. **Speed**: Customers see value in days, not months
2. **Risk reduction**: No upfront cost or long commitment to validate the concept
3. **Real data**: Working on actual customer data produces real insights, not demos
4. **Stickiness**: By the time customers leave, they've invested time and built organizational knowledge on AIP
5. **Land-and-expand**: Initial use cases naturally expand as teams see what's possible

---

## 14. Financial Performance & Business Impact

### FY 2024 10-K Key Financials

| Metric | FY 2024 | YoY Change |
|--------|---------|-----------|
| Total Revenue | $2.87B | +29% |
| Gross Profit | $2.30B | — |
| Gross Margin | 80% | — |
| Operating Income | $310M | +159% (from $120M) |
| Net Income | $468M | +115% (from $217M) |
| Operating Cash Flow | $1.2B | — |
| Cash & Equivalents | $5.2B | — |
| Total Customers | 711 | — |
| Revenue per Top 20 Customers | $64.6M (avg) | +18% |
| Total Remaining Deal Value | $5.4B | — |

### Revenue Mix

- **Government**: 55% (~$1.58B)
- **Commercial**: 45% (~$1.29B)
- **US Revenue**: 66% of total

### US Commercial Growth (AIP-driven)

US commercial revenue is almost entirely driven by AIP adoption:
- Q1 2025: US commercial revenue +71% YoY — pushing the segment to >$1B annualized run rate
- FY 2024: US commercial customer count grew 65% YoY by end of 2025
- AIP is the primary driver of all new commercial customer acquisition

### Balance Sheet Strength

- **Zero debt** as of December 31, 2024
- **$500M undrawn credit facility**
- Palantir is fully self-funding; no capital raises needed

### AIP Bootcamp Revenue Impact

The bootcamp strategy has demonstrated:
- Dramatically lower customer acquisition costs vs. traditional enterprise sales
- Faster time-to-revenue (weeks vs. months)
- Higher conversion rates (75% reported by 2025)
- Land-and-expand mechanics that grow accounts over time

---

## 15. Key Developer Tools & SDKs

### Ontology SDK (OSDK)

The **Ontology SDK** allows developers to build external applications that integrate with AIP and the Ontology. Available in:

- **TypeScript**
- **Python**
- **Java**
- **OpenAPI spec** (for any other language)

OSDK provides:
- Auto-generated type-safe clients for Ontology objects
- Access to AIP Logic functions
- Ability to execute Actions (write operations)
- Full support for object queries and subscriptions

### Code Workspaces

**Code Workspaces** are Foundry's built-in development environment, supporting:
- Python notebooks (Jupyter-compatible)
- TypeScript/JavaScript
- SQL
- AIP-accelerated code generation and assistance

Code Workspaces have direct access to Foundry's data catalog and the Ontology, making it the primary development environment for custom functions and transforms.

### VS Code Integration

VS Code workspaces in Foundry provide a full development environment with:
- Continue (open-source AI coding assistant, pre-configured)
- Palantir-specific SDK knowledge built into the AI assistant
- Direct connection to Foundry datasets and Ontology
- Full language support (Python, TypeScript, SQL, Java)

### Palantir MCP (Model Context Protocol)

Palantir implements the MCP standard to allow external agents and tools to connect to Foundry:
- External AI IDEs can query Ontology data
- External agents can build and interact with Foundry applications
- Enables integration with Claude Code, Cursor, Copilot, and other external tools

### Build with AIP

**build.palantir.com** is the developer hub for AIP, providing:
- Tutorials and starter projects
- Sample applications demonstrating AIP capabilities
- Documentation for all developer tools
- Community forums and support resources

### Workshop

**Workshop** is Palantir's no-code application builder (predates AIP), which has been enhanced with AIP capabilities:
- **AIP Agent widgets**: Embed AIP Agents directly in Workshop applications
- Users can interact with agents, view agent responses, and approve proposed actions from within Workshop UIs
- Enables citizen developers to build AIP-powered operational dashboards

### Pipeline Builder (AIP-Enhanced)

Pipeline Builder is Foundry's visual ETL/data pipeline tool, enhanced with AIP:
- **AI-assisted pipeline generation**: Describe what you want in natural language
- **Regex Helper**: Generate regex patterns via natural language
- **Explain**: AI explains what each pipeline step does

---

## Summary: Why AIP Matters

Palantir's AIP represents a distinct architectural bet: that enterprise AI must be grounded in **operational data** (not general internet knowledge), must be able to take **real-world actions** (not just generate text), and must maintain **enterprise-grade security and governance** (not bolted on as an afterthought).

The Ontology is the central innovation — a structured, semantic, decision-centric model of the enterprise that LLMs can query and act upon, dramatically reducing hallucinations and enabling consequential AI automation.

The Bootcamp go-to-market strategy has proven highly effective at demonstrating value quickly and compressing enterprise sales cycles from months to days.

AIP's competitive position is strongest in:
1. **Regulated industries** requiring strict governance and audit (defense, healthcare, finance)
2. **Operational workflows** where AI must take actions (not just analyze)
3. **Complex multi-source data environments** where the Ontology's integration layer provides unique value
4. **Defense / classified deployments** where Apollo's air-gapped delivery and Gotham's heritage are unmatched

The primary competitive risks are: Microsoft's ubiquity and bundling power; Databricks' and Snowflake's maturing AI capabilities; and the perception that AIP's complexity and cost may exceed the marginal value over simpler alternatives for smaller enterprises.

---

## Sources

- [Palantir AIP Platform Overview](https://www.palantir.com/platforms/aip/)
- [AIP Official Documentation](https://www.palantir.com/docs/foundry/aip/overview)
- [AIP Architecture Overview](https://www.palantir.com/docs/foundry/architecture-center/aip-architecture)
- [AIP Logic Overview](https://www.palantir.com/docs/foundry/logic/overview)
- [AIP Agent Studio Overview](https://www.palantir.com/docs/foundry/agent-studio/overview)
- [AIP Features](https://www.palantir.com/docs/foundry/aip/aip-features)
- [Supported LLMs](https://www.palantir.com/docs/foundry/platform-overview/supported-llms)
- [AIP Bootcamp](https://www.palantir.com/platforms/aip/bootcamp/)
- [Foundry Platform Summary for LLMs](https://www.palantir.com/docs/foundry/getting-started/foundry-platform-summary-llm)
- [Platform Architecture](https://www.palantir.com/docs/foundry/platform-overview/architecture)
- [Palantir Ontology](https://www.palantir.com/platforms/ontology/)
- [Our New Platform (Launch Letter)](https://www.palantir.com/newsroom/letters/our-new-platform/)
- [Reducing Hallucinations with the Ontology](https://blog.palantir.com/reducing-hallucinations-with-the-ontology-in-palantir-aip-288552477383)
- [Building with AIP: Data Tools for RAG/OAG](https://blog.palantir.com/building-with-palantir-aip-data-tools-for-rag-oag-b3b509c8b0f3)
- [Inside AIPCon 8 Demos](https://blog.palantir.com/inside-the-aipcon-8-demos-redefining-the-future-of-enterprise-ai-a0a740fe44ce)
- [TITAN Program Page](https://www.palantir.com/offerings/defense/titan/)
- [Army TITAN Contract Award ($178M)](https://investors.palantir.com/news-details/2024/Army-Selects-Palantir-to-Deliver-TITAN-Next-Generation-Deep-Sensing-Capability-in-Prototype-Maturation-Phase/)
- [Palantir delivers first TITAN systems to Army (CNBC, March 2025)](https://www.cnbc.com/2025/03/07/palantir-delivers-first-two-ai-enabled-systems-to-us-army.html)
- [Palantir + Anduril Alliance (DefenseScoop)](https://defensescoop.com/2024/12/06/palantir-anduril-consortium-ai-new-alliance-merge-capabilities/)
- [Palantir 2024 10-K (SEC)](https://www.sec.gov/Archives/edgar/data/1321655/000132165525000022/pltr-20241231.htm)
- [Palantir 2024 Annual Report PDF](https://investors.palantir.com/files/2024%20FY%20PLTR%2010-K.pdf)
- [Palantir vs Databricks Analysis (SPR)](https://spr.com/databricks-and-palantir-picking-the-right-path-to-enterprise-ai/)
- [AIP Bootcamp Strategy - Financial Content](https://markets.financialcontent.com/stocks/article/marketminute-2026-3-6-palantir-shares-surge-as-aip-bootcamp-strategy-cementing-dominance-in-enterprise-ai)
- [Palantir AI Strategy - Klover.ai](https://www.klover.ai/palantir-ai-strategy-path-to-ai-dominance-from-defense-to-enterprise/)
- [Palantir Foundry AIP - Unit8](https://unit8.com/resources/palantir-foundry-aip/)
- [VS Code AI Development Tools](https://www.palantir.com/docs/foundry/vs-code/ai-development-tools)
- [AIP for Developers](https://www.palantir.com/aip/developers/)
- [AIP Now](https://aip.palantir.com/)
- [Build with AIP](https://build.palantir.com/)
- [AIPCon 4 Customer Demos](https://www.palantir.com/aipcon4/demos/)
- [Palantir Competitors Analysis (SPR)](https://permutable.ai/palantir-competitors/)
- [Snowflake isn't Palantir's Biggest Challenge (Yahoo Finance)](https://finance.yahoo.com/news/snowflake-isnt-palantirs-biggest-challenge-153700288.html)
- [Oracle OCI: Run Foundry on OCI](https://docs.oracle.com/en/solutions/palantir-foundry-ai-platform-on-oci/index.html)
- [AIPCon 8: 70+ Enterprise Giants](https://www.stocktitan.net/news/PLTR/a-new-set-of-palantir-customers-takes-the-spotlight-at-aip-con-eohq6ju1tevz.html)
