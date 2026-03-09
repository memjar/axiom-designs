# Palantir Foundry Ontology — Deep Technical Dive

**Research Date:** March 2026
**Scope:** Comprehensive technical analysis of Palantir Foundry's Ontology layer
**Sources:** Official Palantir docs, engineering blogs, developer community, third-party analysis

---

## Table of Contents

1. [What Is the Ontology?](#1-what-is-the-ontology)
2. [Architecture Internals](#2-architecture-internals)
3. [Object Storage: V1 (Phonograph) vs V2](#3-object-storage-v1-phonograph-vs-v2)
4. [Object Types — Schema & Lifecycle](#4-object-types--schema--lifecycle)
5. [Link Types — Relationship Modeling](#5-link-types--relationship-modeling)
6. [Action Types — Full System](#6-action-types--full-system)
7. [Interface Types — Abstraction & Polymorphism](#7-interface-types--abstraction--polymorphism)
8. [Ontology Sync — Backing Datasets & Pipelines](#8-ontology-sync--backing-datasets--pipelines)
9. [Ontology Search & Querying](#9-ontology-search--querying)
10. [Time Series on the Ontology](#10-time-series-on-the-ontology)
11. [Ontology Media — Attachments & References](#11-ontology-media--attachments--references)
12. [Derived Properties — Computed & Virtual Fields](#12-derived-properties--computed--virtual-fields)
13. [Rules Engine — Business Logic & Constraints](#13-rules-engine--business-logic--constraints)
14. [Multi-Ontology — Spaces, Shared Ontologies, Isolation](#14-multi-ontology--spaces-shared-ontologies-isolation)
15. [Ontology Versioning & Schema Evolution](#15-ontology-versioning--schema-evolution)
16. [Ontology Branching (Feature Branch Testing)](#16-ontology-branching-feature-branch-testing)
17. [Security — Row, Column, Cell-Level Access Control](#17-security--row-column-cell-level-access-control)
18. [Scale — How Many Objects Can It Handle?](#18-scale--how-many-objects-can-it-handle)
19. [Ontology vs Knowledge Graph (Neo4j, TigerGraph)](#19-ontology-vs-knowledge-graph-neo4j-tigergraph)
20. [AIP Integration — AI Agents & Action Grounding](#20-aip-integration--ai-agents--action-grounding)
21. [Ontology SDK (OSDK)](#21-ontology-sdk-osdk)
22. [What Palantir Engineers Say About How It Actually Works](#22-what-palantir-engineers-say-about-how-it-actually-works)
23. [Performance Limits Reference Table](#23-performance-limits-reference-table)
24. [Key Source URLs](#24-key-source-urls)

---

## 1. What Is the Ontology?

The Palantir Ontology is the **operational semantic layer** of Foundry. It sits on top of all integrated digital assets (datasets, virtual tables, models) and maps them to real-world entities — from physical assets like factories and equipment, to abstract concepts like customer orders or financial transactions.

Palantir describes it as a **"digital twin"** of an organization, but that understates it. More accurately it is:

- A **semantic layer** (what entities exist, how they relate)
- A **kinetic layer** (how entities change via governed actions)
- A **dynamic layer** (polymorphism, interfaces, AI-ready abstraction)

The Ontology is the core reason Foundry applications don't break when underlying data models change, why AI agents can be grounded in real business concepts, and why governance/security is enforced automatically across every app.

### The Prime Directive

> "The Ontology is designed to represent the decisions in an enterprise, not simply the data."

Traditional databases capture data. The Ontology captures **business context + permitted change**.

### Historical Timeline

| Period | Development |
|--------|------------|
| Pre-2021 | Palantir used code-heavy "data lineage" models |
| 2021-2022 | Ontology introduced as a first-class product in Foundry |
| 2023 | Object Storage V2 + streaming indexing introduced |
| 2024 | Interfaces, derived properties, branching, improved OSDK |
| 2025 | AIP agents fully grounded on Ontology; NVIDIA integration; Ontology-oriented software development published |

---

## 2. Architecture Internals

The Foundry Ontology backend is a **microservices architecture** with six key services:

```
ONTOLOGY BACKEND
=================

[Ontology Metadata Service (OMS)]
  - Schema definitions for ALL ontology entities
  - Object type metadata, link type metadata, action type metadata
  - Tracks incompatible usage during OSv1->OSv2 migration

[Object Set Service (OSS)] — ALL READS FLOW HERE
  - Single read gateway for all Foundry apps + OSDK
  - Search / filter / aggregate / search-around
  - Fans out sub-queries per object type for complex queries

[Object Data Funnel] — ALL WRITES FLOW HERE
  - Orchestrates writes from: datasets, restricted views, streams, Actions
  - Computes changelogs for incremental indexing (auto background)
  - Batch: Parallelized Apache Spark
  - Streaming: Apache Flink (exactly-once, 1s checkpoint default)
  - Full reindex trigger: >80% rows changed in single transaction

[Object Databases] — STORAGE LAYER
  - OSv1 (Phonograph): Legacy — deprecation June 30, 2026
  - OSv2: Current — decoupled indexing + querying

[Actions Service]
  - Permission enforcement on all writes
  - Edit application + historical audit log

[Functions on Objects]
  - TypeScript / Python code executed at query time
  - Powers derived columns, computed properties
```

### Service Interaction Flow

```
READ PATH:
  App / OSDK → OSS → Object Database → Result

WRITE PATH (Datasource Update):
  Dataset transaction → Funnel detects → Changelog computed
  → Spark/Flink job → Object Database indexed

WRITE PATH (User Action):
  User submits Action → Actions Service validates
  → Funnel writes edits → Object Database updated
  → Writeback dataset updated
```

---

## 3. Object Storage: V1 (Phonograph) vs V2

### Object Storage V1 — Phonograph (Legacy)

Phonograph is Foundry's original object database built on **Elasticsearch-style querying** with **Lucene-based distributed indices**.

**Internal architecture:**
- Distributed set of indices in a horizontally scalable cluster
- Large data structures traversed by the Ontology query engine
- Text-type columns indexed by default Elasticsearch tokenizer (tokenizes on breaking non-word characters)
- Search syntax modeled on Elasticsearch search syntax

**Pruning mechanism:**
When a query executes, the engine traverses indices to skip irrelevant data ("pruning"). Result: search through billions of records by evaluating up to **1000x fewer records**.

**Palantir's own Lucene evolution:**
Palantir built internal telemetry infrastructure using Elasticsearch, then evolved to **pre-computed Lucene indices stored in cold storage (S3)** and loaded into search nodes on demand. This explains the Phonograph architecture — and why V2 needed to decouple indexing from querying.

**Limitations of Phonograph:**
- Large API surface area exposed low-level DB functionality
- Tightly coupled indexing and querying
- Less deterministic behavior (dictated by underlying document store)
- No column-level property permissions
- Limited incremental indexing (only APPEND and UPDATE)
- Scheduled for full deprecation: **June 30, 2026**

### Object Storage V2 (Current)

Built from first principles for next-generation Ontology-driven use cases.

**Key architectural changes:**
- Fully decoupled indexing and querying → independent horizontal scaling
- Indexing overseen by Object Data Funnel (not storage layer itself)
- Stricter validation → more deterministic behavior
- Incremental indexing enabled by default

**New capabilities:**
- Tens of billions of objects per object type
- Up to 10,000 objects per single Action (vs OSv1)
- Up to 2,000 properties per object type
- Column-level permissions via multi-datasource object types
- Spark-based query execution layer for aggregations
- Streaming datasource support (Flink-backed)
- On-demand Spark for search-arounds >100,000 objects
- Schema migration framework for breaking changes
- Object security policies (near-instant updates, no rebuild)

**OSv2 Indexing throughput limit:** 2 MB/s per object type (contact Palantir for higher)

**"Most recent transaction wins":** If a dataset has multiple rows with the same primary key, data from the most recent transaction wins in the Ontology.

---

## 4. Object Types — Schema & Lifecycle

### Analogy Mapping

| Ontology Concept | Dataset Equivalent |
|-----------------|-------------------|
| Object Type | Dataset/Table schema |
| Object (instance) | Row |
| Object Set | Filtered set of rows |
| Property | Column |
| Property Value | Field value |
| Link Type | Join between datasets |
| Link (instance) | Joined row |

### Schema Structure

- **Primary Key** — unique identifier (required)
- **Properties** — schema definitions of characteristics
- **API Name** — IMMUTABLE once status is "active" (used in OSDK)
- **Display Name** — human-readable name
- **Status** — active / experimental / deprecated / example
- **Backing Datasource(s)** — datasets, restricted views, or streams

### All Property Base Types

| Type | Description |
|------|-------------|
| String | Text values |
| Boolean | True/false |
| Integer / Long / Double | Numeric types |
| Date / Timestamp | Temporal values |
| Geopoint | Geographic coordinates |
| GeoShape | Geographic areas/polygons |
| Struct | Multi-field nested property (from struct-type dataset column) |
| Array | Collections of above types |
| Attachment | File stored on object via Actions |
| Media Reference | Pointer to a file in a media set |
| Vector | Embedding vector for semantic/nearest-neighbor search |
| Time Series | References a time series (keyed by seriesId) |

### Struct Properties

Structs allow multi-field properties created from struct-type dataset columns.

**Current limitation:** Struct properties cannot be used in queries with derived properties. TypeScript OSDK workaround: use `$select` to exclude structs.

### Metadata Statuses (Lifecycle)

| Status | Restrictions |
|--------|-------------|
| `experimental` | Can be deleted, API name can change |
| `active` | CANNOT be deleted; API name CANNOT be changed |
| `deprecated` | Must move to deprecated before deletion |
| `example` | Demo only |

**Critical:** Plan API names before promoting to `active`. They are permanent.

### Multi-Datasource Object Types (MDOs)

- **Row-wise MDO:** Multiple datasets contribute rows to the same object type
- **Column-wise MDO:** Different datasources provide different property subsets — used for column-level access control

---

## 5. Link Types — Relationship Modeling

### Definition

A **link type** defines a relationship between two object types. A **link** is a single instance of that relationship between two objects.

### Cardinality

| Cardinality | Backing Mechanism | Notes |
|-------------|------------------|-------|
| One-to-One | Foreign key on object type | "Object type foreign keys" config |
| Many-to-One | Foreign key on object type | "Object type foreign keys" config |
| One-to-Many | Pipeline Builder — datasource on object type | Supported |
| Many-to-Many | Join table — datasource on LINK TYPE itself | Requires join table |

**Important:** One-to-one cardinality is NOT supported in Pipeline Builder. Only via foreign key configuration.

**Many-to-many detail:** The join table contains pairs of primary keys. Ontology maps which columns in the join table reference which object type's primary keys.

### Directionality & Display Names

Each link type has TWO sides, each with their own display name:
- Forward: e.g., "Employee"
- Reverse: e.g., "Employer"
- Plural (for "many" sides): e.g., "Scheduled Flights"

### Special Link Type Variants

**Self-referential links:** Links between two objects of the SAME type (e.g., Direct Report <-> Manager within Employee).

**Object-Backed Link Types:** The link itself is an object type. Allows links to carry additional metadata properties.
- Example: `FlightManifest` object type with `Pilot` and `FirstMate` properties representing an Aircraft-to-Flight link

**Interface Link Types:** Abstract link types defined at the interface level. ONE or MANY cardinality.

### Cross-Ontology Limitation

Links between object types across DIFFERENT ontologies are NOT supported. Each ontology is a closed relationship graph.

### Search Around

Primary query use of link types. Takes an input object set, traverses a link type, returns related objects. Equivalent to a JOIN in the Ontology query layer.

- Default limit: 100,000 objects
- OSv2: on-demand Spark cluster for >100,000 object search-arounds

### Streaming Limitation

Many-to-many links and user edits CANNOT be enabled for objects backed by streaming datasets.

---

## 6. Action Types — Full System

### Core Design Principle

In Foundry, users **cannot issue direct database writes**. ALL data changes flow through Action Types, which enforce validation, permissions, audit trails, and side effects. This is enforced at the platform level — there is no bypass.

### Action Type Full Structure

```
Action Type
├── Parameters (inputs from users or systems)
├── Ontology Rules (data edits — compiled into single edit per object)
│   ├── Create object
│   ├── Modify object(s)
│   ├── Delete object(s)
│   ├── Add/Remove links
│   ├── Create object(s) of interface
│   ├── Modify object(s) of interface
│   ├── Delete object(s) of interface
│   └── Function rule (code-backed — replaces ALL other rules)
├── Side Effect Rules
│   ├── Notification rule (post-execution, pre-edit state)
│   └── Webhook rule (writeback or side effect mode)
├── Submission Criteria (conditional execution constraints)
├── Permissions (who can execute)
└── Audit Trail (automatic — every execution logged)
```

### Rule Compilation Model

Multiple rules compile into a **single edit per object**. Rule ordering matters — later rules override earlier ones for the same property. The following combinations are NOT supported:
- Delete before add
- Modify before create
- Create an object twice in same form submission

**Function Rule:** When a TypeScript or Python function backs the action, it REPLACES all other rules. Functions can express any edit logic.

### Webhooks — Detailed Technical Behavior

**Writeback Webhook (pre-execution):**
- Executes BEFORE any Ontology rules
- If webhook FAILS → NO Ontology changes are made
- Output parameters from webhook available in subsequent rules
- Use case: Write to SAP/ERP first; update Foundry only if external system succeeds
- Ensures digital twin never drifts from real system state

**Side Effect Webhook (post-execution):**
- Executes AFTER all Ontology rules
- Foundry changes already applied when this runs
- Webhook failure does NOT roll back Ontology changes
- Use case: Send Slack notifications, trigger downstream processes

**Branch safety:** Function-backed actions that make external calls FAIL ENTIRELY when executed on a branch — prevents accidental external writes during testing.

**Default:** Webhook side effects are NOT enabled by default.

### Action Compute Model

- Base overhead: **18 compute-seconds** per action
- Scale: **1 additional compute-second** per object edited beyond the first

### Action Limits

| Limit | Default | Override |
|-------|---------|---------|
| Objects per action | 10,000 | Contact Palantir Support |
| Spark overflow trigger | >10,000 objects | Automatic |

### Notification Rules

- Execute AFTER all edits are applied
- Notification content generated from BEFORE-edit state
- Delivery options: in-platform push, email, or both (user configurable)

### Writeback Datasets

Actions write to both the Object Database AND a **writeback dataset** — a Foundry dataset that persists all user edits and can feed downstream pipelines.

### Value Types (Validation Constraints)

Semantic wrappers around base property types with:
- Metadata and constraints
- Type safety and expressiveness
- Reusable across the entire platform
- Enforce domain-specific data validation

---

## 7. Interface Types — Abstraction & Polymorphism

### Definition

An **interface** is an abstract Ontology type defining a common shape that concrete object types can implement. Interfaces cannot be instantiated — they must be implemented by object types.

Visual distinction: Interfaces have **dashed line borders** around their icons in the platform.

### Concrete vs Abstract Comparison

| Aspect | Object Type | Interface |
|--------|-------------|-----------|
| Backing dataset | Yes | No |
| Can be instantiated | Yes | No (must use implementing type) |
| Schema defined by | Local/shared properties | Interface properties |
| Can be queried directly | Yes | Via implementing types only |

### Inheritance Model

- Interfaces can extend MULTIPLE other interfaces (multiple inheritance)
- Multi-layer inheritance chains supported
- Object types can implement MULTIPLE interfaces simultaneously
- Child interfaces inherit all parent interface properties

### Practical Example

```
Interface: Facility
  Properties: [Facility Name, Location]
  
Implemented by:
  Airport         → adds: [Terminal Count, IATA Code]
  Manufacturing   → adds: [Production Capacity, ISO Cert]
  MaintenanceHangar → adds: [Aircraft Capacity, Hangar Type]

Workflow A uses "Facility" interface:
  → Automatically works with Airport, Manufacturing, Hangar
  → When new "WarehouseHub" implements Facility:
     → Workflow A works with WarehouseHub IMMEDIATELY
     → No refactoring needed
```

### Interface Link Types

Define abstract relationships with ONE or MANY cardinality:
- ONE: each implementing object links to one target
- MANY: each implementing object links to any number of targets

### Platform Support (as of 2025)

| Platform | Support Level |
|----------|--------------|
| Ontology Manager | Full (define, edit, implement) |
| Marketplace | Full (packaging/installation) |
| TypeScript v2 Functions | Full |
| OSDK (TypeScript) | Supported |
| OSDK (Java, Python) | In development |
| Actions | Cannot reference interface link types directly |
| Object Set Service | Search and sorting — aggregation in development |
| Workshop | NOT YET supported |
| TypeScript v1 / Python | NOT YET supported |

---

## 8. Ontology Sync — Backing Datasets & Pipelines

### Full Data Flow

```
External System
      |
      v
Data Connection Sync --> Foundry Dataset (Bronze)
                               |
                        Transform Pipelines
                               |
                        Backing Dataset (Gold)
                               |
                        Funnel Service
                    /          |           \
          Batch Index    Incremental    Streaming Index
           (Spark)      (changelog)   (Flink, ~1s latency)
                    \          |           /
                        Object Database
                               |
                       Object Set Service
                               |
             Apps / Workshop / OSDK / AIP Agents
```

### Dataset Transaction Types & Ontology Behavior

| Transaction | Description | Ontology Impact |
|------------|-------------|----------------|
| SNAPSHOT | Replaces entire dataset view | Full reindex |
| APPEND | Adds new files to current view | Incremental index |
| UPDATE | Adds new files, may overwrite | Incremental index |
| DELETE | Removes file references | Removes from index |

### Funnel Batch Pipeline Internals

1. Funnel detects datasource update (new transaction)
2. Changelog job computes data diff vs. previous version
3. Creates intermediate changelog datasets (APPEND transactions with diffs)
4. Parallelized Spark job indexes changes into OSv2
5. "Most recent transaction wins" for same primary key conflicts

**Full reindex trigger:** >80% of rows changed in a single transaction → Funnel switches from incremental to full reindex (cheaper than computing a changelog for nearly all rows).

### Streaming Indexing (Apache Flink)

- Generally available since 2024
- Indexes data in **seconds** (vs minutes for batch)
- "Exactly once" semantics via Flink checkpointing
- Default checkpoint frequency: **every 1 second** — this is the dominant latency
- Historical streaming data backfilled via Spark

**Streaming limitations:**
- Does NOT support many-to-many link types
- Does NOT support user edits

### Change Data Capture (CDC)

Foundry natively supports CDC feeds:
- Any streaming data can be "keyed" with changelog metadata
- Workshop supports **auto-refresh** for CDC data
- Push-based ingestion via stream proxy supports manually pushed changelog records

### Live Pipeline Updates

Funnel live pipelines auto-trigger whenever backing datasources receive new data. No manual scheduling for most configurations.

---

## 9. Ontology Search & Querying

### Query Types

**1. Filters**
- Dynamic object sets: filter representation auto-updated as data changes
- Array properties: `.contains()` filter
- Compose with `.and()` and `.or()`
- ONLY works on properties with **Searchable render hint** enabled

**2. Full-Text Search**
- Individual words searched independently by default
- Phrase search: quotes → `"exact phrase"`
- Boolean operators: AND, OR, NOT
- Elasticsearch-style syntax internally

**3. Property-Based Search (API)**
```json
{
  "type": "contains",
  "field": "propertyApiName",
  "value": "search term"
}
```
Operators: exact match (high precision), contains all terms, contains any terms (higher recall). Queries can be nested/composed.

**4. Aggregations**
- `sum`, `avg`, `count`, `min`, `max` on filtered object sets
- `.segmentBy()` → 3D aggregation (group by)
- `.cardinality()` → approximate count of distinct values
- ONLY on Searchable-hinted properties

**5. Search Arounds (JOIN equivalent)**
- Takes input object set + traverses link type → returns related objects
- Default limit: 100,000 objects
- OSv2: on-demand Spark for >100,000 objects

**6. Vector / Semantic Search**
- k-nearest-neighbor on Vector-typed properties
- Returns k objects with embeddings nearest to a provided embedding
- Embeddings generated in Pipeline Builder or at query time via model
- Can inject LLM for query augmentation (expand, enrich, remove stop words)

### Performance Optimization

- Filter BEFORE aggregating (reduces compute significantly)
- Limit searches to specific object types (reduces OSS sub-queries)
- Enable Searchable render hint only on properties actually searched
- Avoid full object set aggregations on billion-object types

---

## 10. Time Series on the Ontology

### Time Series Property (TSP) vs Standard Property

| Aspect | Standard Property | Time Series Property |
|--------|------------------|---------------------|
| Values stored | Single current value | History of timestamped values |
| Updates | Overwrites previous | Appends to history |
| Access | Direct | Via seriesId lookup in time series sync |

### How TSP Resolution Works

1. Object has TSP with a `seriesId` value
2. Foundry looks up `seriesId` in configured time series sync data source
3. Returns all time-value pairs for that seriesId
4. Resolved on-demand at query time

### Temporal Data Modeling: Three Patterns

| Entity Type | Behavior | Use When |
|-------------|----------|---------|
| Object | Properties overwrite — no history retained | Current state matters, history doesn't |
| Event | Occurs at point in time, properties fixed after | Historical records, audit events |
| Time Series | Timestamped value history | Sensor data, metrics, trends |

**Common approach:** Use BOTH simultaneously — TSPs for time series tools, event objects for workflow tools.

### Derived Series (Computed Time Series)

Calculated on-the-fly without storage:
- **Time Shift:** Shift series forward/backward by duration
- **Derivative:** Rate of change (with optional unit conversion)
- **Integral:** Cumulative area under curve (with optional unit conversion)
- **Rolling:** Aggregate over temporal window preceding each point

Once in Ontology, derived series behave identically to standard TSPs.

---

## 11. Ontology Media — Attachments & References

### Two Distinct Mechanisms

**Attachments (per-object file storage)**
- Files uploaded temporarily and linked to objects via Actions
- Property type: `Attachment`
- Garbage collection: unlinked attachments deleted **1 hour after upload**
- Previously disconnected attachments purged **biweekly**
- Max size in TypeScript v1: **20 MB** (memory limit)
- Supported types: application/json, application/pdf, image/jpeg, etc.

**Media References (media set pointers)**
- Points to a specific item in a **media set** (separate file storage)
- Property type: `Media Reference`
- Media source (the media set) configured in Capabilities tab
- Backing dataset must include a media reference column
- Enables faster previews in Workshop/Object Explorer
- Supports geospatial image tiling in Map

### Working with Media via Functions

TypeScript v1: `MediaItem` type with built-in operations — no external libraries needed.

Key workflow:
- Upload → receive `media_item_rid`
- Need actual `media_reference` (not just RID) for Ontology objects
- Use `images.list_media_items_by_path_with_media_reference(ctx)` to get references
- Python pipelines: add `transforms-media` dependency

---

## 12. Derived Properties — Computed & Virtual Fields

### What They Are

Runtime-calculated fields derived from other property values or linked object data. Computed on demand — not stored.

**Security:** Derived properties inherit security of ALL objects in the calculation chain. No information exposure beyond user's existing access.

### Capabilities

- Aggregate values from linked objects (e.g., total revenue per customer)
- Select attributes from linked objects
- Available for filtering, sorting, aggregation within queries
- Used via `withProperties` in TypeScript OSDK

### Limitations (Beta as of 2025)

| Limitation | Detail |
|-----------|--------|
| No OSv1 | Cannot use with OSv1-indexed object types |
| No text search | Cannot use in full-text or keyword filters |
| No struct types | Cannot include struct properties (use `$select` to exclude) |
| OSDK version | Requires `@osdk/client` 2.2.0-beta.x or later |

### Functions on Objects (FOO) — Alternative

Workshop function-backed columns:
- Function receives object data → returns display values per object
- Async execution supported for parallel computation
- Used for Workshop derived table columns

---

## 13. Rules Engine — Business Logic & Constraints

### Three Layers of Business Rules

**Layer 1: Action Type Rules**
- ALL writes flow through action type rules
- Types: Create, Modify, Delete objects/links; Function rules
- Multiple rules compile into single edit per object per execution

**Layer 2: Foundry Rules (formerly "Taurus")**
- Low-code point-and-click interface
- Apply to: datasets, objects, time series
- Use cases: alert generation, data categorization
- Range from simple filters to complex aggregations/joins

**Layer 3: Dynamic Scheduling Validation**
- TypeScript function-backed rules for scheduling constraints
- Re-evaluated on EVERY schedule modification
- Real-time constraint visibility during planning operations

### Value Types (Schema-Level Constraints)

Semantic wrappers around base types:
- Metadata, constraints, type safety
- Reusable across the platform
- Domain-specific data validation enforcement
- Example: `Temperature_Celsius` (Double) with min/max bounds

### Submission Criteria

- Conditions preventing action submission when not met
- Configured in Security & Submission Criteria tab
- Can reference both parameter values and object property values

### Closed World Assumption (CWA)

Palantir's Ontology operates on CWA — if a fact is not explicitly known, it is treated as false/unknown. This is the correct model for enterprise operational systems (vs. Open World Assumption used in semantic web ontologies). Unknown states trigger action responses, not silent assumption.

---

## 14. Multi-Ontology — Spaces, Shared Ontologies, Isolation

### Core Mapping

**Each ontology maps 1:1 with a space:**
- Create a space → ontology with same name created automatically
- Private space → private ontology
- Shared space → shared ontology

A single Foundry instance CAN have multiple ontologies, partitioned by organizational boundaries (spaces).

### Private Ontology

- Single organization access only
- Default for most deployments

### Shared Ontology

- Mapped to a dedicated shared space
- Multiple organizations collaborate on shared workflows
- Enables cross-org data sharing with governance
- Access controlled by organization membership of shared space

### Cross-Ontology Limitation

**Links between object types across different ontologies are NOT supported.** Each ontology is a self-contained graph.

### Practical Architecture

Large enterprise example:
- Main production ontology (private, single org)
- Shared ontology per major cross-team collaboration
- One per business unit with distinct governance requirements

---

## 15. Ontology Versioning & Schema Evolution

### Schema Change Process (OSv2)

1. User specifies change in Ontology Manager + saves
2. New **schema version** created in OMS backend
3. Replacement pipeline orchestrated by Funnel
4. New version queryable once pipeline complete and declared "fully hydrated"

### Breaking Changes (Examples)

- Changing property data type
- Changing backing datasource
- Changing primary key

### Schema Migration Framework (OSv2)

- Palantir detects breaking changes automatically in Ontology Manager
- Guides users to select predefined migration option for existing user edits
- **Limit:** Maximum 500 schema migrations per batch
- If more needed: execute in batches

### API Name Immutability

Once object type status = `active`, **API name is permanently locked**. This protects OSDK applications from breaking. Plan API names BEFORE going active.

### Metadata vs Data Versioning

- Object type schemas: versioned in OMS, history maintained
- Object data values: no native time-travel (unlike Foundry datasets with full transaction history)
- User edits via Actions: full audit log maintained; writeback datasets track history

---

## 16. Ontology Branching (Feature Branch Testing)

### Overview

Git-style branching applied to the entire Foundry platform including the Ontology.

Main branch = production state
Feature branch = isolated copy for safe development

### What Can Be Branched

| Resource | Branchable |
|----------|-----------|
| Ontology (object/action/link types) | YES |
| Pipeline Builder | YES |
| Workshop apps | YES |
| Code Repositories (datasets) | YES |
| Ontology SDK | NO |
| TypeScript v2 / Python functions | NO (can reference specific version) |
| Quiver, other non-Workshop apps | NO |

### Branch Workflow

1. Create branch from Main
2. Modify ontology resources
3. Index object types on branch for testing
4. Test actions in Workshop (edits scoped to branch — NOT merged to Main)
5. Review via Proposal (like a pull request)
6. Merge to Main once approved

### Rebase Process

When Main changes while on a feature branch:
- Blue indicator prompts review
- Manual rebase required once ontology changes introduced to branch
- Incorporates latest Main changes into branch

### Cost & Retention

- Compute + storage costs per branch
- Large object types on branches = significant additional costs
- Branches are SHORT-LIVED by design
- Inactive branches auto-marked → auto-closed
- Closed branches CANNOT be reopened
- Resources deleted/de-indexed if not deployed to Main

### Action Testing Safety

Actions tested on branches do NOT write to Main. Purely a testing mechanism. No production state changes.

### Legacy (Sunset)

Ontology proposals (old system) sunset on enrollments with Foundry Branching enabled. Use Foundry Branching instead.

---

## 17. Security — Row, Column, Cell-Level Access Control

### Security Model Layers

1. **Mandatory controls** — propagate via data provenance/lineage
2. **Discretionary permissions** — roles with operations (view, edit) per resource
3. **Granular policies** — row/column controls based on user attributes

### Object Security Policies (Row-Level)

- Control which object instances (rows) a user can see
- Configured directly on the object type in Ontology Manager
- Independent of backing datasource permissions
- **Near-instantaneous policy updates** (no rebuild required — key advantage over Restricted Views)
- Compatible with streaming data and Foundry branching

### Property Security Policies (Column-Level)

- Control which properties (columns) a user can see
- User must pass BOTH object policy AND property policy to see a property
- Same mechanism as object security policies

### Combined = Cell-Level Security

Row + column policies together → cell-level security. Granularity down to individual object instances AND individual properties.

### Restricted Views (Datasource-Level Alternative)

- Filter dataset access to rows the user can see
- Policy change requires **pipeline rebuild** before taking effect (key disadvantage)
- Cannot be used as transform inputs

### Granular Policy Mechanics

Dynamic templates evaluated at read time:

User attributes evaluated:
- User ID and Username
- Group IDs and Group Names (direct + inherited memberships)
- Marking IDs (all markings user has permission to view)
- Custom attributes from identity provider

Example: Policy returns objects where `region` = user's `region` attribute → automatic per-user filtering, no static lists.

### Column-Wise MDOs for Column-Level Control

Multi-datasource object types (column-wise):
- Different datasources provide different property subsets
- Users without datasource access simply don't see those columns
- Natural column-level control without explicit property policies

### AI Security

All AIP agents operating through the Ontology inherit the **requesting user's security context**. AI cannot access objects/properties the user cannot see. No privilege escalation for AI systems.

---

## 18. Scale — How Many Objects Can It Handle?

### Hard Numbers

| Metric | Value |
|--------|-------|
| Objects per object type (OSv2) | Tens of billions |
| Properties per object type (OSv2) | 2,000 maximum |
| Search Around default limit | 100,000 objects |
| Objects editable per Action (default) | 10,000 |
| Indexing throughput per object type | 2 MB/s |
| Search pruning efficiency | Up to 1000x fewer records evaluated |
| Streaming indexing latency | ~1 second (Flink checkpoint frequency) |
| Action base compute overhead | 18 compute-seconds |
| Action per-object compute | 1 compute-second per object beyond first |

### Anti-Patterns That Kill Scale

DO NOT:
- Store raw/bronze data in the Ontology (use curated gold data only)
- Use it as OLTP transaction-heavy database
- Add thousands of properties to a single object type
- Run unfiltered aggregations over full billion-object sets

DO:
- Filter before aggregating
- Limit searches to specific object types
- Only enable Searchable render hint on actually-searched properties
- Use streaming for low-latency use cases
- Use incremental pipelines to minimize reindex costs

---

## 19. Ontology vs Knowledge Graph (Neo4j, TigerGraph)

### Comparison Table

| Dimension | Palantir Ontology | Neo4j / TigerGraph |
|-----------|------------------|-------------------|
| Primary role | Enterprise operational platform | Native graph database |
| Data model | Objects, Links, Properties, Actions | Nodes, Relationships, Properties |
| Query language | OSDK, TypeScript, Python, REST | Cypher (Neo4j), GSQL (TigerGraph) |
| Write/action support | Strong — full kinetic layer | Limited — primarily read-heavy |
| Graph algorithms | Limited | Strong (community detection, shortest path, PageRank) |
| AI integration | Deep — AIP, agent grounding | Growing — GraphRAG |
| External orchestration | Strong — webhooks, ERP integration | Primarily a database |
| World assumption | Closed World (operational) | Open World (semantic) |
| Schema model | Schema-first, governed | Schema-optional |
| Governance | First-class (permissions, audits, markings) | External (application-managed) |
| All writes governed | Yes — through Action Types | No — direct CRUD allowed |

### Why Closed World Assumption Matters

**Neo4j/semantic web:** Open World Assumption — "a fact not known is not necessarily false." Good for knowledge representation.

**Palantir Ontology:** Closed World Assumption — "a fact not known is false or unknown and actionable." Required for operational enterprise systems where gaps must trigger responses.

### Where Neo4j Wins

- Pure graph traversal (shortest path, community detection, PageRank)
- Highly connected data with many hops
- Schema-optional environments
- Complex graph pattern matching via Cypher

### Where Palantir Ontology Wins

- Enterprise governance, security, auditability
- Data → Decision → Action → Real-world impact pipeline
- AI agent grounding with safety guardrails
- Unified view over diverse datasources (not just graph data)
- Governed data modification with external system integration
- Digital twin of an entire organization

### From the Developer Community

The Palantir developer community has specifically requested "true knowledge graph capabilities" (OWL-based reasoning, full RDF compliance) as gaps. The Ontology is NOT a semantic web ontology — it prioritizes operational utility over philosophical semantic correctness.

### Open Source Alternatives

None fully replicate the Foundry Ontology:
- **Apache Atlas** — metadata layer, less operational
- **dbt Semantic Layer** — analytics-focused
- **Databricks Unity Catalog** — data governance focus
- **OpenMetadata** — metadata management
- No open source alternative has the kinetic layer + action types + AI integration combination

---

## 20. AIP Integration — AI Agents & Action Grounding

### How AI Uses the Ontology

```
User natural language
        |
        v
    LLM (AIP Logic)
        |
        v
Ontology Query (via OSS)
[Objects, Properties, Links with business meaning]
        |
        v
LLM Reasoning over business-semantic data
        |
        v
Staged Action (human review) OR Auto-Action (if authorized)
        |
        v
Real-world change (Ontology edit + webhook to external system)
```

### AIP Agent Studio

Agents powered by:
- LLMs
- The Ontology (objects, links, action types as callable tools)
- Documents (unstructured data layer)
- Custom tools (TypeScript/Python functions)

Capabilities:
- Query objects, traverse links
- Surface action types as tool calls
- Execute actions (if authorized) or stage for human review
- Automate complex multi-step workflows autonomously

### Safety Guardrails Architecture

**Default:** AI can ONLY stage actions. Humans review and approve before execution.

**Selective automation:** Organizations surgically authorize specific trusted AI processes to close the action loop without human review.

**Security enforcement:**
- AI inherits requesting user's security context
- AI cannot access anything user cannot access
- No privilege escalation for AI
- Same permission model as human users

**Audit trail:** Every AI action staged or executed — full decision lineage captured.

### Decision Lineage & Learning Loop

```
AI decision made
        |
Decision logged with full context
        |
Human feedback (approve/reject staged actions)
        |
Aggregate decisions across thousands of users
        |
Fine-tuning data or LLM prompting principles
        |
Improved AI performance
```

### AIP Logic

- Automates: connecting unstructured data to Ontology, resolving conflicts, optimizing assets, reacting to disruptions
- Can automatically apply Ontology edits OR stage for human review
- Built on same platform security model
- User and function permissions fully enforced

### NVIDIA Integration (Late 2025)

- NVIDIA accelerated computing available in Foundry/AIP
- CUDA-X data science libraries accessible
- Open-source NVIDIA Nemotron models available via the Ontology
- GPU-accelerated AI grounded in enterprise Ontology

---

## 21. Ontology SDK (OSDK)

### Overview

The OSDK is the external API surface of the Ontology — allows any application to access Foundry's Ontology from any development environment.

### Language Support

| Language | Package Manager |
|----------|----------------|
| TypeScript | NPM |
| Python | Pip / Conda |
| Java | Maven |
| Any language | OpenAPI spec |

### Code Generation

Developer Console generates:
- Type-safe bindings from Ontology metadata
- Field names use API Name from Ontology (dot notation)
- Type metadata accessible programmatically
- Documentation for all selected object types, action types, functions

### Key TypeScript Packages

| Package | Purpose |
|---------|---------|
| `@osdk/client` | Core OSDK client (2.2.0-beta.x+ for derived properties) |
| `@foundry/functions-api` | Function decorators (`@Function`, `@Edits`, `FunctionsMap`) |
| `@foundry/ontology-api` | Object types, links, `Objects.search()` |
| `@osdk/functions` | TypeScript v2 (`Edits`, `createEditBatch`) |

### Security Model

OSDK token scoped to:
1. Ontological entities the application should access
2. Requesting user's own permissions

No application can access beyond what the user is permitted.

### Creating an OSDK Application

1. Developer Console → Resources → "Yes, generate Ontology SDK"
2. Select Ontology (IMMUTABLE after creation — cannot change)
3. Select object types and action types to expose
4. Package generated with bindings and documentation

### OSDK Branching Limitation

The OSDK is NOT branchable (as of 2025). OSDK applications always interact with the Main branch Ontology.

---

## 22. What Palantir Engineers Say About How It Actually Works

### From Official Engineering Posts

**"Ontology-Oriented Software Development" (Nov 2025, Palantir Blog):**

> "The Ontology centralizes knowledge and encapsulates it within a shared system, connecting fragmented data, logic, and action components. This allows a translation of component-specific models into a shared conceptual model to happen once, rather than every time a new application is built."

**Key insight:** Solves the "every app reinvents the data model" problem. CRM has its own Customer, ERP has its own Customer, BI has its own Customer. The Ontology defines Customer ONCE.

**"Connecting AI to Decisions with the Palantir Ontology":**

> "The prime directive of every organization is to execute the best possible decisions, often in real-time. Traditional data architectures do not capture the reasoning that goes into decision-making or the action that results."

**Key insight:** The Ontology is the decision record, not just the data record. Every action taken (human or AI) is captured in context.

**On the three-layer architecture:**

> "The semantic layer defines WHAT. The kinetic layer defines HOW CHANGE HAPPENS. The dynamic layer (interfaces) defines WHAT CAN BE DIFFERENT WHILE STILL BEING THE SAME."

**From Palantir's Lucene/Elasticsearch post:**

Internal Palantir telemetry initially used Elasticsearch, then evolved to pre-computed Lucene indices stored in cold storage (S3) loaded into search nodes on demand. This is the DNA of Phonograph — and explains why OSv2's decoupled architecture was necessary to achieve the next scale tier.

### From Developer Community Analysis

**On the semantic vs. knowledge graph distinction:**

The Foundry Ontology is NOT a W3C knowledge graph. No OWL. No RDF. No SPARQL. It is a **business object model with governed actions** — closer to Domain-Driven Design aggregates than to a semantic web ontology.

**On "digital twin" accuracy:**

Palantir's use of "digital twin" is broader than industrial IoT meaning. It's not just sensor data mirroring physical assets — it's a semantic representation of the entire business: abstract concepts, processes, decisions, and relationships.

**On why it's hard to replicate:**

The moat is the combination of all five working together:
1. Universal semantic layer (all data maps here)
2. Governed kinetic layer (all writes go through here)
3. Automatic security enforcement (not optional or configurable)
4. AI grounding (agents bounded by same policies as humans)
5. Full lineage (every data point traceable to source)

Each is achievable individually. All five integrated is the competitive advantage.

**On the OSDK as defragmentation:**

> "The OSDK makes it possible to defragment the enterprise by integrating isolated components."

Each OSDK application is a view into a shared semantic layer. When the semantic layer changes, consuming applications update — no per-app data model maintenance.

**On real-time advantage:**

> "Palantir's pipelines are designed to work with real-time data. Most competitor programs are designed for bulk updates at scheduled intervals."

---

## 23. Performance Limits Reference Table

| Resource | Limit | Notes |
|----------|-------|-------|
| Objects per object type | Tens of billions | OSv2 |
| Properties per object type | 2,000 | OSv2 hard limit |
| Objects per single Action | 10,000 (default) | Higher via Palantir Support |
| Search Around default | 100,000 objects | On-demand Spark for more |
| Schema migrations per batch | 500 | Batch in multiple runs if more |
| Indexing throughput per object type | 2 MB/s | Higher via Support request |
| Full reindex trigger threshold | >80% rows changed | Switches from incremental to full |
| Streaming indexing latency | ~1 second | Dominated by Flink checkpoint |
| Attachment auto-deletion (unlinked) | 1 hour after upload | |
| Attachment purge (disconnected) | Biweekly | Previously linked, now disconnected |
| Attachment max size (TypeScript v1) | 20 MB | Memory limit |
| Search pruning efficiency | Up to 1000x | Fewer records evaluated per query |
| Action base compute cost | 18 compute-seconds | Minimum overhead per action |
| Action per-object compute cost | 1 compute-second | Beyond first object |

---

## 24. Key Source URLs

### Official Palantir Documentation
- [Ontology Architecture](https://www.palantir.com/docs/foundry/object-backend/overview)
- [Ontology Overview](https://www.palantir.com/docs/foundry/ontology/overview)
- [Core Concepts](https://www.palantir.com/docs/foundry/ontology/core-concepts)
- [Object Types Overview](https://www.palantir.com/docs/foundry/object-link-types/object-types-overview)
- [Link Types Overview](https://www.palantir.com/docs/foundry/object-link-types/link-types-overview)
- [Base Types Reference](https://www.palantir.com/docs/foundry/object-link-types/base-types)
- [Action Types Overview](https://www.palantir.com/docs/foundry/action-types/overview)
- [Action Types Rules](https://www.palantir.com/docs/foundry/action-types/rules)
- [Action Types Webhooks](https://www.palantir.com/docs/foundry/action-types/webhooks)
- [Action Types Side Effects](https://www.palantir.com/docs/foundry/action-types/side-effects-overview)
- [Interface Overview](https://www.palantir.com/docs/foundry/interfaces/interface-overview)
- [Derived Properties](https://www.palantir.com/docs/foundry/ontology/derived-properties)
- [Time Series Overview](https://www.palantir.com/docs/foundry/time-series/time-series-overview)
- [Time Series Properties Use Case](https://www.palantir.com/docs/foundry/time-series/time-series-properties-use-case-ontology)
- [Time Series Syncs](https://www.palantir.com/docs/foundry/time-series/time-series-syncs)
- [Derived Series](https://www.palantir.com/docs/foundry/time-series/derived-series-overview)
- [Media in Ontology](https://www.palantir.com/docs/foundry/media-sets-advanced-formats/media-in-ontology)
- [Attachment API](https://www.palantir.com/docs/foundry/api/ontology-resources/attachments/attachment-basics)
- [Object Storage V1 Phonograph](https://www.palantir.com/docs/foundry/object-databases/object-storage-v1)
- [OSv1 to OSv2 Migration](https://www.palantir.com/docs/foundry/object-backend/osv1-osv2-migration)
- [Breaking Changes OSv1 to OSv2](https://www.palantir.com/docs/foundry/object-backend/object-storage-v2-breaking-changes)
- [Indexing Overview](https://www.palantir.com/docs/foundry/object-indexing/overview)
- [Funnel Batch Pipelines](https://www.palantir.com/docs/foundry/object-indexing/funnel-batch-pipelines)
- [Indexing Compute Usage](https://www.palantir.com/docs/foundry/ontologies/compute-usage)
- [Ontologies Overview (Multi-Ontology)](https://www.palantir.com/docs/foundry/ontologies/ontologies-overview)
- [Shared Ontologies](https://www.palantir.com/docs/foundry/ontologies/shared-ontologies)
- [Schema Migrations](https://www.palantir.com/docs/foundry/object-edits/schema-migrations)
- [Foundry Branching Overview](https://www.palantir.com/docs/foundry/foundry-branching/overview)
- [Foundry Branching Core Concepts](https://www.palantir.com/docs/foundry/foundry-branching/core-concepts)
- [Test Changes in Ontology](https://www.palantir.com/docs/foundry/ontologies/test-changes-in-ontology)
- [Object Security Policies](https://www.palantir.com/docs/foundry/object-permissioning/object-security-policies)
- [Granular Policies](https://www.palantir.com/docs/foundry/platform-security-management/manage-granular-policies)
- [Restricted Views](https://www.palantir.com/docs/foundry/security/restricted-views)
- [Ontology SDK Overview](https://www.palantir.com/docs/foundry/ontology-sdk/overview)
- [Object Explorer Search Syntax](https://www.palantir.com/docs/foundry/object-explorer/search-syntax)
- [Ontology Query Compute Usage](https://www.palantir.com/docs/foundry/ontologies/query-compute-usage)
- [Foundry Rules Overview](https://www.palantir.com/docs/foundry/foundry-rules/overview)
- [AIP Overview](https://www.palantir.com/docs/foundry/aip/overview)
- [AIP Agent Studio](https://www.palantir.com/docs/foundry/agent-studio/overview)
- [Functions Overview](https://www.palantir.com/docs/foundry/functions/overview)
- [Derived Properties in Vertex](https://www.palantir.com/docs/foundry/vertex/derive-property-functions)

### Engineering Blogs & Analysis
- [Ontology-Oriented Software Development (Palantir Blog)](https://blog.palantir.com/ontology-oriented-software-development-68d7353fdb12)
- [Connecting AI to Decisions with the Palantir Ontology](https://blog.palantir.com/connecting-ai-to-decisions-with-the-palantir-ontology-c73f7b0a1a72)
- [How Palantir Foundry's Ontology Deploys Data Science to the Front Line](https://blog.palantir.com/how-palantir-foundrys-ontology-deploys-data-science-to-the-front-line-7a9679bdfd01)
- [AI Infrastructure & Ontology (Palantir + NVIDIA)](https://blog.palantir.com/ai-infrastructure-and-ontology-78b86f173ea6)
- [Indexing and Querying Telemetry Logs with Lucene (Palantir)](https://medium.com/palantir/indexing-and-querying-telemetry-logs-with-lucene-234c5ce3e5f3)
- [Shifting the Enterprise Ontology Paradigm: From Semantic Web to Palantir](https://blog.pebblous.ai/project/CURK/ontology/enterprise-ontology-paradigm/en/)
- [Understanding Palantir's Ontology: Semantic, Kinetic, and Dynamic Layers](https://pythonebasta.medium.com/understanding-palantirs-ontology-semantic-kinetic-and-dynamic-layers-explained-c1c25b39ea3c)
- [Palantir Developer Community: True Knowledge Graph Capabilities Discussion](https://community.palantir.com/t/true-knowledge-graph-capabilities/1045)
- [Demystifying Palantir: Features and Open Source Alternatives](https://dashjoin.medium.com/demystifying-palantir-features-and-open-source-alternatives-ed3ed39432f9)
- [How to Build a Search Feature for Foundry's Ontology](https://medium.com/ontologize/how-to-build-a-search-feature-for-foundrys-ontology-c4c50cf3db06)
- [Palantir Foundry Ontology (Jimmy Wang)](https://medium.com/@jimmywanggenai/palantir-foundry-ontology-3a83714bc9a7)
- [Practical Ontologies & How to Build Them (FourthAge)](https://fourthage.substack.com/p/practical-ontologies-and-how-to-build-355)

---

*Research compiled March 2026. Palantir continuously updates Foundry — verify limits and feature availability against official docs for production use.*
