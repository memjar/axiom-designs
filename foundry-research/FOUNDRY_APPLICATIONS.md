# Palantir Foundry Application Suite — Comprehensive Technical Reference

> Research compiled: March 2026
> Sources: Palantir official documentation, Palantir developer community, Medium/Ontologize publications

---

## Table of Contents

1. [Platform Overview](#platform-overview)
2. [Contour — Tabular Analytics & Visualization](#1-contour)
3. [Quiver — Time Series & Object Analysis](#2-quiver)
4. [Slate — Custom Low-Code Application Builder](#3-slate)
5. [Workshop — No-Code Application Builder](#4-workshop)
6. [Pipeline Builder — Visual Data Pipeline Creation](#5-pipeline-builder)
7. [Code Workbook — Interactive Coding Environment](#6-code-workbook)
8. [Code Repositories — Git-Based Code Management](#7-code-repositories)
9. [Notepad — Collaborative Documentation & Reporting](#8-notepad)
10. [Reports — Automated Report Generation (Sunset)](#9-reports-sunset)
11. [Fusion — Spreadsheet Interface](#10-fusion)
12. [Marketplace — Data & Application Marketplace](#11-marketplace)
13. [Carbon — Workspace & Asset Management](#12-carbon)
14. [Foundry Maps — Geospatial Visualization](#13-foundry-maps)
15. [Vertex — Graph Visualization & Network Analysis](#14-vertex)
16. [Phonograph — Object Storage & Media Management (Legacy)](#15-phonograph)
17. [Compass — Project & Resource Management](#16-compass)
18. [Object Explorer — Object Set Browsing & Exploration](#17-object-explorer)
19. [Actions — Ontology Writeback & Business Logic](#18-actions)
20. [Code Workspaces — Exploratory IDE (Jupyter/RStudio/VS Code)](#19-code-workspaces)
21. [Recent Platform Additions (2025-2026)](#recent-platform-additions-2025-2026)
22. [Cross-Application Integration Summary](#cross-application-integration)

---

## Platform Overview

Palantir Foundry is an enterprise data operations platform organized around a central **Ontology** — a digital twin of an organization's real-world entities, assets, processes, and relationships. Every application in the Foundry suite interacts with this shared Ontology layer, ensuring that data, models, and decisions are consistent across the platform.

### Core Architecture Layers

```
Source Systems
      │
      ▼
Connectors / Ingestion
      │
      ▼
Datasets (raw → clean via transforms)
      │
      ▼
Ontology  ←──────────────────────────────────────────────┐
(Objects, Links, Actions, Functions, Time Series)        │
      │                                                   │
      ├──── Analytics Tools (Contour, Quiver, Vertex)     │
      ├──── Application Builders (Workshop, Slate)        │
      ├──── Developer Tools (Code Repositories, OSDK)     │
      ├──── Pipeline Tools (Pipeline Builder, Code WB)    │
      └──── Write-back / Actions ──────────────────────────┘
```

### Ontology Primitives

| Primitive | Description |
|-----------|-------------|
| **Object Types** | Representations of real-world entities (e.g., customer, aircraft, order) |
| **Properties** | Attributes of objects (e.g., name, location, status) |
| **Links** | Typed relationships between object types |
| **Actions** | Operations that create, modify, or delete objects/links |
| **Functions** | Typed TypeScript/Python logic that transforms or queries ontology data |
| **Time Series** | High-frequency sensor or signal data attached to objects |

---

## 1. Contour

**Category:** Analytics / Business Intelligence
**Type:** No-code / Point-and-click
**Status:** Active (primary BI tool)

### Purpose

Contour is Foundry's primary point-and-click analytical tool for exploring and transforming tabular data at scale. It is designed for rapid top-down data exploration, deriving new datasets through visual transformations, and creating interactive dashboards — without requiring any coding knowledge.

### Architecture: Paths & Boards

Analyses in Contour are organized into **Paths** — a sequential chain of steps starting from an input dataset and flowing downward:

```
Input Dataset
      │
   [Board 1: Filter]
      │
   [Board 2: Group By]
      │
   [Board 3: Chart — Bar]
      │
   [Board 4: Table]
      │
 [Dashboard Output]
```

Each step in a Path is a **Board**, of which there are two types:
- **Display Boards** — Show data without transforming it (Table, Chart, Map, Pivot Table)
- **Transform Boards** — Modify data flowing through the path (Filter, Join, Group By, Derive Column, Formula)

### Key Features

| Feature | Description |
|---------|-------------|
| **Point-and-click analysis** | No code required for most operations |
| **Expression language** | DSL for advanced computed columns and transformations |
| **Parameterization** | Parameterized analyses allow switching between data slices |
| **Dashboards** | Interactive dashboards with chart-to-chart filtering |
| **PDF Export** | Fullscreen presentation view and PDF exports |
| **Dataset Output** | Save analysis results as new Foundry datasets |
| **Visualization Timezone** | Per-analysis timezone control for datetime display (added Feb 2024) |
| **Restricted Views** | Access and analyze row-level security restricted datasets |

### Ontology Integration

Contour can work both with raw datasets and Ontology-backed data. It is best suited for:
- Data that has **not** been mapped into the Ontology
- Very large-scale operations (100,000+ objects or 50,000+ rows)
- One-time exploratory analysis where ontology mapping isn't needed

When data is in the Ontology, **Quiver** is generally preferred. Contour fills the gap for raw datasets and large-scale tabular exploration.

### Target Users

- Data analysts performing ad-hoc investigations
- Business users exploring datasets without coding
- Report creators building dashboards for stakeholders

### Connections to Other Apps

- Contour boards can be embedded in **Notepad** documents
- Contour dashboards can be embedded in **Workshop** modules via iframe
- Analysis results can be saved as datasets for use by **Pipeline Builder**, **Code Repositories**, and other tools
- Contour was the only tool that could interact with restricted views until recently (now also accessible from Jupyter Workspaces)

---

## 2. Quiver

**Category:** Analytics / Time Series & Object Analysis
**Type:** No-code / Point-and-click
**Status:** Active

### Purpose

Quiver is Foundry's primary analytics tool for exploring **Ontology-mapped object and time series data**. It is optimized for temporal analysis of high-frequency sensor data, operational signals, and event-based workflows. Quiver sits at the intersection of the Ontology and analytics — it natively understands object relationships and time series properties without requiring manual joins.

### Architecture: Card-Based Analysis

Quiver analyses are built from **cards** — modular units that take typed inputs and produce typed outputs. Cards can be chained to create complex analysis workflows:

```
[Object Set Card]
       │
[Time Series Plot Card]
       │
[Filter Card]
       │
[Event Statistics Card]
       │
[Forecast Card]
       │
[Dashboard Output]
```

Every card has strongly-typed inputs and outputs (e.g., object set → time series → categorical chart → number), making it easy to build correct analytical pipelines.

### Key Features

| Feature | Description |
|---------|-------------|
| **Time Series Library** | Sensor/signal processing functions optimized for high-frequency data |
| **Proprietary TS Database** | Backend optimized for time series operations |
| **Batch Analysis** | Analyze hundreds of time series simultaneously |
| **Grouped Plots** | Visualize multiple time series together for comparison |
| **Linear Aggregation** | Combine multiple series into a single aggregated result |
| **Event Analysis** | Define events (start/end timestamps) and analyze time series behavior around them |
| **Event Statistics** | Aggregate time series over event intervals for per-event metrics |
| **Forecasting** | Visual, interactive time series forecasting using the Time Series Forecast card |
| **Formula Language** | Proprietary formula DSL for custom calculations |
| **AIP Generate** | AI-powered card generation via natural language prompts |
| **AIP Configure** | AI-assisted time series analysis within chart context |
| **Write-Back** | Write analytical conclusions back to the Ontology via Actions |
| **Dashboard Templates** | Build interactive dashboards for sharing; embed in Workshop |

### Analysis Types

- **Object analysis** — Filter, aggregate, and explore ontology object sets
- **Time series analysis** — Plot, transform, and forecast signal data
- **Event-based analysis** — Analyze behavior relative to operational events (downtime, maintenance windows, batches)
- **Batch analysis** — Multi-time-series comparison at scale

### Ontology Integration

Quiver is the most Ontology-native analytics tool in Foundry. It:
- Reads time series properties directly from Ontology objects
- Navigates object-to-object links without manual joins
- Can trigger Actions to write decisions back to the Ontology
- Is the preferred tool when data is mapped in the Ontology and time series analysis is required

### Target Users

- Industrial engineers monitoring equipment sensors
- Operations analysts tracking supply chain events
- Data scientists performing exploratory signal analysis
- Business analysts requiring time-based dashboards

### Connections to Other Apps

- Quiver cards and dashboards can be embedded in **Notepad**
- Quiver dashboards can be embedded in **Workshop** modules
- Time series properties come from the **Ontology** (Object Types)
- AIP integration uses Palantir-hosted LLMs for analysis suggestions

---

## 3. Slate

**Category:** Application Building
**Type:** Low-code / Custom HTML+CSS+JS
**Status:** Active

### Purpose

Slate is Foundry's most powerful and flexible application builder. It provides a drag-and-drop canvas combined with the ability to write arbitrary HTML, CSS, and JavaScript, enabling the construction of fully custom, highly branded single-page web applications. Slate bridges the gap between Workshop's no-code simplicity and fully custom external development.

### Architecture: Single-Page Web Application

Slate applications are essentially single-page web applications (SPAs) hosted on Foundry's infrastructure:

```
Slate Application
├── Pages (isolated scope, load separately)
│   ├── Variables (local state)
│   ├── Queries (data fetching from Foundry / Ontology)
│   ├── Functions (client-side logic)
│   └── Events (user interaction handlers)
├── Widgets (drag-and-drop UI components)
│   ├── Built-in widgets (tables, charts, maps, inputs)
│   └── Custom widgets (arbitrary HTML/CSS/JS)
├── Ontology API (objects, links, actions, functions)
└── PostgreSQL Backend (Foundry datasets synced to Postgres)
```

### Key Features

| Feature | Description |
|---------|-------------|
| **Drag-and-Drop UI** | Position widgets freely on the canvas |
| **Full HTML/CSS/JS** | Complete control over styling and behavior |
| **Page-Based Architecture** | Split complex apps into isolated pages for performance |
| **Ontology Integration** | Call Foundry Objects, Links, Actions, and Functions via API |
| **Public-Facing Apps** | Build apps accessible without a Foundry account |
| **External Data Sources** | Query external databases and APIs alongside Foundry data |
| **PostgreSQL Backend** | Dataset data synced to Postgres for SQL-style querying |
| **Writeback via Phonograph** | Capture user edits back to source datasets |
| **OSDK Support** | Use the Ontology SDK directly in JavaScript widgets |

### Slate vs Workshop

| Dimension | Slate | Workshop |
|-----------|-------|----------|
| Code requirement | HTML/CSS/JS possible | No code required |
| Flexibility | Maximum | Moderate |
| Target user | Developer | Business builder |
| Maintenance cost | Higher | Lower |
| Ontology integration | Via API calls | Native, first-class |
| Public-facing apps | Yes | Limited |
| Best for | Complex, branded apps | Operational workflows |

### Target Users

- Frontend developers building custom enterprise apps
- Teams requiring unique branding/UI beyond widget libraries
- Teams building public-facing data submission portals
- Advanced builders needing full control over interactions

### Connections to Other Apps

- Can embed **Quiver**, **Contour**, and **Map** visualizations
- Reads and writes to the **Ontology** via Functions and Actions
- Queries **Foundry datasets** via PostgreSQL backend
- Can use the **OSDK** for typed Ontology access

---

## 4. Workshop

**Category:** Application Building
**Type:** No-code / Low-code
**Status:** Active (primary no-code app builder)

### Purpose

Workshop is Foundry's primary no-code application builder. It is tightly integrated with the Ontology layer and enables business users and less technical builders to create rich, interactive operational applications using drag-and-drop widgets. Workshop applications are "Ontology-aware" by design — they understand objects, links, and actions natively.

### Architecture: Widget-Based Canvas

```
Workshop Module
├── Layout (Sections, Columns, Rows)
├── Widgets
│   ├── Object Table (Ontology object set display)
│   ├── Object List (card-style object browser)
│   ├── Chart XY (aggregation-backed chart)
│   ├── Map (geospatial visualization)
│   ├── Inline Action (create/modify/delete objects)
│   ├── Metric Card (single KPI display)
│   ├── Form (multi-field input for actions)
│   ├── Tabs (navigation)
│   ├── Button (trigger events/actions)
│   ├── Text/Image (static content)
│   ├── Iframe (embed external apps)
│   └── Custom Widget (OSDK-backed custom component)
├── Variables (reactive state, drive filtering/selection)
├── Events (user interaction → variable updates → widget refresh)
└── Overlays (conditional panels, modals)
```

### Key Features

| Feature | Description |
|---------|-------------|
| **Ontology-Native Widgets** | Object Table, Object List natively understand Ontology types |
| **Reactive Variables** | Widgets react to variable changes without code |
| **Events System** | User interactions trigger defined workflows |
| **Inline Actions** | Execute Ontology Actions (create, edit, delete) directly in the app |
| **Custom Widgets** | Build fully custom widgets backed by the OSDK |
| **Iframe Embedding** | Embed external applications; bidirectional variable sync |
| **Mobile-Ready** | Layouts can be configured for desktop and mobile |
| **Design Hub** | Marketplace product with 6 high-quality example applications |
| **Overlays** | Contextual panels and modals triggered by user events |
| **Functions Integration** | Embed TypeScript Functions for complex widget logic |

### Example Applications (from Design Hub)

- **Common Operating Picture** — Geographical metrics on a map
- **Rental Booking App** — Visual exploratory app with filtering
- **Operations Dashboard** — KPIs, alerts, and actions for ops teams
- **Investigation Workflow** — Step-by-step entity investigation

### Ontology Integration

Workshop is the most Ontology-native application builder in Foundry:
- Object widgets automatically read properties and links
- Actions are executed directly through the widget system
- No SQL or joins required — the Ontology handles relationships
- Aggregations are handled by Foundry's compute layer, not client-side

### Target Users

- Business analysts building operational dashboards
- Operations teams creating workflow tools
- Product owners building internal applications
- Any user wanting rich interactive apps without coding

### Connections to Other Apps

- Can embed **Quiver**, **Contour**, **Vertex**, and **Map** visualizations
- Executes **Ontology Actions** and calls **Functions**
- **Notepad** documents can be generated from Workshop templates
- **Marketplace** provides pre-built Workshop templates
- Custom widgets use the **OSDK** for Ontology access

---

## 5. Pipeline Builder

**Category:** Data Engineering / Integration
**Type:** No-code / Visual pipeline builder
**Status:** Active (primary data integration tool)

### Purpose

Pipeline Builder is Foundry's primary application for data integration and transformation. It enables users to build production-grade data pipelines that transform raw source data into clean outputs ready for analysis and Ontology consumption — without writing code. It replaces the need for custom ETL scripts for many use cases.

### Architecture: DAG-Based Pipeline

```
[Input Datasets / Media Sets / Manual Data / Syncs]
            │
    [Transform Node 1: Filter]
            │
    [Transform Node 2: Join]
            │
    [Transform Node 3: Derive Column]
            │
    [LLM Node: Extract entities from text]
            │
    [Transform Node 4: Aggregate]
            │
[Outputs: Datasets / Virtual Tables / Ontology Objects / Link Types / Time Series]
```

Pipelines are represented as a directed acyclic graph (DAG) with two rendering modes:
- **Collapsed Board** — Traditional visual node graph
- **Pseudocode** — Cleaner text-based view resembling code (no specific language syntax)

### Key Features

| Feature | Description |
|---------|-------------|
| **Visual Transform Library** | Hundreds of pre-built transforms (filter, join, aggregate, derive, union, etc.) |
| **Type-Safe Functions** | Strongly typed transforms catch errors at edit time, not build time |
| **LLM Node** | Execute LLMs on data at scale; no coding required |
| **Vision Capabilities** | Vision-capable LLMs can analyze images in pipelines |
| **Prompt Templates** | Pre-engineered prompt templates for common LLM tasks |
| **Unstructured Data Support** | Process media sets (PDFs, images, audio, video) |
| **Ontology Outputs** | Directly create/update Object Types, Link Types, and Time Series |
| **Data Expectations** | Primary key and row count checks; fail build if not met |
| **Scheduling** | Time-based, cadence-based, or parent-triggered scheduling |
| **Streaming & Batch** | Managed serverless support for batch, micro-batch, and streaming |
| **Compute Optimization** | Only materializes data needed for specified outputs |
| **Join Key Suggestions** | Automatic column casting and join key suggestions |
| **Strict Output Checks** | Prevent builds that would break downstream dependencies |
| **Build Path Pruning** | Automatically prunes unconnected transform paths |

### Target Users

- Data engineers building production ETL/ELT pipelines
- Data analysts creating self-service transformation workflows
- Non-technical users performing simple data reshaping
- AI/ML engineers building LLM-powered data pipelines

### Connections to Other Apps

- Outputs feed directly into the **Ontology** (objects, links, time series)
- Outputs consumed by **Contour**, **Quiver**, **Workshop**, and other analytics tools
- Can ingest from **Foundry datasets**, **virtual tables**, **media sets**, and external syncs
- LLM nodes use Foundry-hosted models (AIP) for AI transforms
- Results can be promoted to **Code Repositories** for production management

---

## 6. Code Workbook

**Category:** Developer Tools / Interactive Coding
**Type:** Interactive notebook / REPL
**Status:** Legacy (documented as "Code Workbook [Legacy]"; successor is Code Workspaces / Jupyter)

### Purpose

Code Workbook provides an interactive notebook-style coding environment within Foundry for rapid iteration on transformation logic and ad-hoc data exploration. It supports multiple languages and includes a REPL for interactive execution. Code Workbook is positioned between Pipeline Builder (no-code) and Code Repositories (production code) — it is the exploration and prototyping layer.

### Architecture: Transform Graph with Interactive Execution

```
[Input Datasets]
       │
[Python Transform: clean_data()]  ←── REPL / Interactive execution
       │
[PySpark Transform: aggregate()]
       │
[R Transform: visualize()]
       │
[Output Dataset]
```

Each transform is a function; the inputs are referenced by alias, and Code Workbook wires them together automatically. The environment is backed by Apache Spark.

### Supported Languages

| Language | Notes |
|----------|-------|
| **Python 3.9 / 3.10** | PySpark + Pandas; best practice is native PySpark |
| **R** | Statistical analysis and visualization |
| **SQL** | Query Foundry datasets directly |

### Key Features

| Feature | Description |
|---------|-------------|
| **Interactive REPL** | Per-language console for rapid ad-hoc analysis |
| **Spark-Backed Execution** | Full PySpark performance on large datasets |
| **Conda Environment** | Any Conda Forge package available; custom environments per workbook |
| **Visualization Support** | Matplotlib, Plotly, Seaborn for inline charts |
| **Interactive vs Batch Builds** | Interactive for iteration; batch for production output |
| **Templates** | Reusable transform logic templates |
| **Export to Code Repositories** | Promote production-ready workbooks to Git repos |
| **Point-and-Click Spark Config** | Configure Spark environment via UI, no YAML required |
| **Multi-User Collaboration** | Multiple users can share logic on a single analysis |

### Key Limitation

Code Workbook is marked as **Legacy**. Palantir has moved toward **Code Workspaces** (Jupyter-based, backed by Code Repositories infrastructure) for new interactive development workflows.

### Target Users

- Data scientists exploring datasets and building models
- Data engineers prototyping pipeline logic before production
- Analysts comfortable with Python/R/SQL who need Spark scale
- Researchers performing one-off analyses

### Connections to Other Apps

- Output datasets feed into **Contour**, **Quiver**, and **Pipeline Builder**
- Visualizations can be embedded in **Notepad**
- Production-ready code can be exported to **Code Repositories**
- Backed by the same Spark infrastructure as Code Repositories transforms

---

## 7. Code Repositories

**Category:** Developer Tools / Code Management
**Type:** Web-based IDE + Git
**Status:** Active (primary production code tool)

### Purpose

Code Repositories provides a full web-based integrated development environment (IDE) for writing, reviewing, and managing production-grade code within Foundry. It is the Git-backed system for all production data pipelines, Functions, and application logic. Code Repositories combines standard Git version control with Foundry-specific features like dataset branching and data/code version control simultaneously.

### Architecture: Git + Dataset Branching

```
Code Repository
├── Git Repository
│   ├── Branches (feature, main, release)
│   ├── Commits / Tags
│   ├── Pull Requests (code review)
│   └── Merge / Conflict Resolution
├── Dataset Branches (data version control)
│   ├── Feature branch: code + data isolated
│   ├── Main branch: production code + data
│   └── Proposals (PRs for data + code together)
└── Build System
    ├── Incremental builds
    ├── Scheduled builds
    └── CI/CD integration
```

Foundry's branching system applies Git principles to data: a **branch** contains both code and the resulting datasets, so you can safely experiment with pipeline changes without affecting production data.

### Key Features

| Feature | Description |
|---------|-------------|
| **Full Git Support** | Branch, commit, tag, merge, pull request via web UI |
| **Pull Requests** | Line-by-line code review with configurable merge permissions |
| **Dataset Branching** | Simultaneous code + data version control |
| **Proposals** | Data-aware PRs that include changed datasets, not just code |
| **IntelliSense** | Code completion and inline documentation |
| **Linting & Error Checking** | Real-time code quality feedback |
| **Problems Helper** | Jump directly to problematic code |
| **Preview Helper** | Run on a sample of data before committing |
| **File Changes Helper** | Diff view for uncommitted changes |
| **VS Code Integration** | Palantir VS Code extension for local development |
| **Code Workspaces** | Jupyter-backed workspaces backed by Code Repositories |
| **Multi-Language** | Python (PySpark), TypeScript (Functions), SQL |

### Code Workspaces (Modern Successor to Code Workbook)

Code Workspaces are Jupyter-powered interactive environments backed by Code Repositories infrastructure. They combine the interactivity of Code Workbook with the full Git version control of Code Repositories. Workspaces can:
- Access restricted views in Foundry
- Interact with Ontology data via Python
- Commit code directly to a Code Repository branch

### Target Users

- Data engineers building production pipelines
- Software engineers writing Ontology Functions (TypeScript)
- ML engineers building models deployed to AIP
- Platform administrators managing code quality and review processes

### Connections to Other Apps

- Produced transforms feed **Pipeline Builder**-style outputs (datasets, Ontology types)
- TypeScript Functions written here power **Workshop**, **Quiver**, and **Vertex** logic
- **Code Workspaces** are backed by Code Repositories infrastructure
- Code can be packaged and published via **Marketplace**
- Integrated with Foundry's build/schedule system for production workloads

---

## 8. Notepad

**Category:** Documentation / Reporting
**Type:** Rich text editor / Report builder
**Status:** Active (primary reporting tool, replaces legacy Reports)

### Purpose

Notepad is Foundry's collaborative rich-text editor and primary reporting tool. It allows users to create living documents that embed live-updating content from across the Foundry platform — charts, tables, analyses, and object data — alongside narrative text. Notepad is designed for both one-time reports and periodic recurring report generation.

### Architecture: Document with Embedded Foundry Content

```
Notepad Document
├── Rich Text (Markdown-style prose)
├── Embedded Artifacts
│   ├── Contour boards (tabular charts/tables)
│   ├── Quiver cards (time series charts)
│   ├── Code Workbook visualizations
│   ├── Object Explorer views
│   └── Fusion spreadsheet data
├── Document Templates
│   ├── Parameterized inputs
│   └── One-click report generation
└── Export
    ├── PDF (granular page break control)
    └── In-platform sharing
```

### Key Features

| Feature | Description |
|---------|-------------|
| **Cross-Product Embedding** | Embed content from Contour, Quiver, Code Workbook, Object Explorer |
| **Live-Updating Content** | Embedded charts update automatically as underlying data changes |
| **Static (Point-in-Time) Documents** | Lock a report to a specific data snapshot |
| **Document Templatization** | Create blueprints; generate the latest report in one click |
| **Ontology Lineage** | Trace data sources for any embedded artifact |
| **Annotation** | Annotate documents with comments |
| **PDF Export** | Granular control over export layout, page breaks, and embed appearance |
| **In-Platform Sharing** | Share with Foundry users directly |
| **Workshop Integration** | Generate Notepad documents from Workshop via templates |

### Notepad vs Other Reporting Tools

| Use Case | Recommended Tool |
|----------|-----------------|
| Cross-product narrative report with live data | **Notepad** |
| Interactive Contour-based dashboard | **Contour Dashboard** |
| Interactive Quiver/time series dashboard | **Quiver Dashboard** |
| Static export for external sharing | **Notepad PDF Export** |
| Dynamic filtered operational dashboard | **Workshop** |

### Target Users

- Analysts writing data-driven reports for leadership
- Operations teams generating recurring status reports
- Data teams documenting findings alongside visualizations
- Any user who needs to combine narrative and live data

### Connections to Other Apps

- Embeds content from **Contour**, **Quiver**, **Fusion**, **Code Workbook**
- Can be triggered from **Workshop** for automated document generation
- Ontology lineage links back to **Pipeline Builder** and source datasets

---

## 9. Reports (Sunset)

**Category:** Analytics / Reporting
**Type:** Legacy dashboard/report tool
**Status:** SUNSETTED — Read-only as of August 2023; deprecation pending

### Purpose (Historical)

Foundry Reports was the original dashboard and reporting application in Foundry. It supported both live dashboarding and static reporting use cases, combining content from analyses into shareable reports. It served the same purpose that **Notepad** and **Contour/Quiver Dashboards** now serve.

### Current Status

- **New report creation disabled** for most customers as of August 2023
- **Existing reports** are read-only; they can be viewed but not edited
- **Recipes** (related automated report scheduling) is also sunsetted; replaced by **Automations**
- **Migration recommended** to Contour Dashboards, Quiver Dashboards, or Notepad

### Migration Guide

| Legacy Reports Use Case | Recommended Replacement |
|------------------------|------------------------|
| Contour-based dashboards | Contour Dashboards |
| Quiver/time series dashboards | Quiver Dashboards |
| Cross-product narrative reporting | Notepad |
| Scheduled report delivery | Automations |

### Why Sunsetted

Contour Dashboards, Quiver Dashboards, and Notepad collectively offer richer feature sets, better interactivity (chart-to-chart filtering, parameters, fullscreen mode), and deeper Ontology integration than the legacy Reports application provided.

---

## 10. Fusion

**Category:** Analytics / Data Entry
**Type:** Spreadsheet interface
**Status:** Active

### Purpose

Fusion is Foundry's spreadsheet application. It provides a familiar spreadsheet interface (similar to Excel or Google Sheets) that can query Foundry datasets, sync data back to Foundry datasets, and be used for collaborative data entry, manual data correction, and lightweight analysis. Fusion bridges the gap between spreadsheet-native workflows and Foundry's data infrastructure.

### Key Features

| Feature | Description |
|---------|-------------|
| **Spreadsheet UX** | Familiar cell-reference model; keyboard shortcuts |
| **Find & Use Data** | Built-in panel to pull Foundry dataset/object data into cells |
| **Formula Language** | Combination of Contour expression language DSL + spreadsheet functions |
| **Real-Time Collaboration** | Multiple users editing simultaneously; cursor presence |
| **Auto-Update** | Cells automatically update when Foundry datasets change |
| **Edit History** | Snapshot history with compare and restore capability |
| **Table Regions** | Enforce tabular structure; column-name references; sorting |
| **Sync to Dataset** | Sync entire sheet or table region to a Foundry dataset |
| **CSV Export** | Export synced data as CSV |
| **Conditional Formatting** | `color` and `tooltip` functions for cell-level logic |
| **Dropdowns** | `dropdown()` and `multidropdown()` functions for constrained input |
| **Locked Cells** | Prevent accidental edits to shared cells |
| **Templates** | Convert any Fusion sheet into a reusable template |
| **Data Types** | String, Number, Date, Timestamp, Boolean, Array, Null |

### Use Cases

- Manual data entry and correction workflows
- Lightweight analysis on Foundry data without learning Contour
- Data validation and reconciliation against source datasets
- Collaborative planning spreadsheets backed by live data
- Bridge for users who need spreadsheet familiarity but data platform governance

### Ontology Integration

Fusion connects to Foundry datasets and can sync data into datasets (which can then be mapped to Ontology objects). It is primarily a dataset-level tool rather than an Ontology-level tool, but its output datasets can be consumed by Ontology Manager and Pipeline Builder.

### Target Users

- Business users comfortable with spreadsheets
- Operations teams doing manual data corrections
- Finance and planning teams requiring live data in familiar formats
- Data engineers performing quick data edits

### Connections to Other Apps

- Synced datasets feed into **Contour**, **Pipeline Builder**, and **Ontology**
- **Notepad** can embed Fusion content
- Part of the **Contour expression language** (shared formula syntax)

---

## 11. Marketplace

**Category:** Platform / Distribution
**Type:** Internal app and data product store
**Status:** Active

### Purpose

Foundry Marketplace is an internal distribution system that enables teams to package, publish, and install complex **data products** — including applications, functions, models, Ontology entities, and pipelines — as reusable, versioned products. It is the mechanism for sharing reusable Foundry solutions across an organization or across Palantir customers.

### Architecture: Product-Based Distribution

```
Publisher (Developer)
├── Package Product
│   ├── Applications (Workshop modules, Slate apps)
│   ├── Functions (TypeScript/Python)
│   ├── Models (AIP-hosted)
│   ├── Ontology components (object types, link types, action types)
│   ├── Pipelines
│   └── Datasets
├── Define Inputs (required data mappings)
├── Configure Release Channels
└── Publish to Marketplace

                    ↓

Consumer (Installer)
├── Browse Marketplace Storefront
├── Select Product → Install
├── Map Inputs to their own datasets/objects
├── Configure Ontology prefix (to avoid naming conflicts)
├── Select maintenance windows (production mode)
└── Installed → Product runs in their environment
```

### Key Features

| Feature | Description |
|---------|-------------|
| **Guided Installation** | Step-by-step wizard for input mapping and configuration |
| **Input Mapping** | Map required inputs to consumer's own datasets/ontology entities |
| **Ontology Prefix** | Prefix all object types, link types, action types to avoid conflicts |
| **Content Summary** | Preview all resources that will be installed before confirming |
| **Stub Resources** | Create placeholder resources to unblock installation |
| **Production Mode** | Release channels + automatic upgrades with maintenance windows |
| **OSDK Support** | Functions using OSDKs can be packaged; inputs are remappable |
| **Model Deployment** | Models can be packaged as product outputs via DevOps |
| **Workshop Design Hub** | Pre-built Workshop example apps available as Marketplace products |
| **Functions Packaging** | TypeScript/Python functions included as packaged outputs |

### Marketplace vs External Marketplaces

Foundry Marketplace is an **internal enterprise marketplace**, not a public app store. It enables:
- Reuse of solutions across business units
- Consistent deployment of approved data products
- Version control and upgrade management for complex multi-component products

### Target Users

- Platform teams packaging reusable solutions for the enterprise
- Business units installing pre-built analytics products
- Palantir partners distributing industry-specific data products
- ML teams deploying models via managed pipelines

### Connections to Other Apps

- Packages can include **Workshop** modules, **Slate** apps, **Functions**, **Models**
- **Workshop Design Hub** is a specific Marketplace product
- Models deployed via **AIP Model Catalog** can be included in Marketplace products
- Installed products write to the consumer's **Ontology**

---

## 12. Carbon

**Category:** Platform UX / Workspace Management
**Type:** Configurable operational workspace framework
**Status:** Active

### Purpose

Carbon is Foundry's workspace configuration application. It enables administrators to create **tailored, focused experiences** for specific user groups by packaging together a curated set of Foundry applications and resources into a unified workspace. Carbon is designed to reduce platform complexity for non-technical operational users, presenting only the tools and data relevant to their specific role.

### Architecture: Workspace + Module System

```
Carbon Workspace (e.g., "Customer Support Analysts")
├── Custom Landing Page
│   ├── Ontology-aware search bar
│   ├── Configurable link sections
│   ├── Object type shortcuts
│   └── Featured resources
├── Modules (parameterized Foundry apps)
│   ├── Module 1: Workshop app (claim management)
│   ├── Module 2: Contour dashboard (trends)
│   ├── Module 3: Object Explorer (investigation)
│   └── Module 4: Map (geographic claims view)
├── Navigation (cross-module workflow routing)
├── Permissions & Access Control
│   ├── Set as default workspace for user groups
│   ├── Restrict navigation outside workspace
│   └── Control module discovery
└── Tabs (context-persistent across modules)
```

### Key Features

| Feature | Description |
|---------|-------------|
| **Custom Landing Page** | Branded homepage with Ontology search, links, and resource shortcuts |
| **Module System** | Each module is a parameterized version of a Foundry app |
| **Cross-Module Navigation** | Configure routes between modules for unified workflows |
| **Access Control** | Restrict users to only what they need for their role |
| **Default Workspace Assignment** | Set specific workspaces as the default experience for user groups |
| **Navigation Restriction** | Optionally prevent users from navigating outside the Carbon workspace |
| **Tab Persistence** | Tabs remain open as users navigate between modules |
| **Example Workspaces** | Pre-built workspace templates available as starting points |

### Use Cases

- **Customer support teams** — Manage and action warranty claims through a unified interface
- **Field operations** — Mobile-friendly workspace for workers in the field
- **Executive dashboards** — High-level KPI workspace with limited write access
- **Compliance workflows** — Restricted workspace for sensitive data review
- **Onboarding** — Simplified workspace for new users unfamiliar with Foundry

### Target Users

- Platform administrators configuring role-based experiences
- Operational teams needing a focused, guided interface
- Non-technical users who need Foundry's power without the complexity

### Connections to Other Apps

- Modules can be any Foundry app: **Workshop**, **Contour**, **Map**, **Quiver**, **Vertex**
- Landing page uses the **Ontology** for its search capabilities
- Permissions integrate with Foundry's core **security model**
- Accessible via the **Applications Portal**

---

## 13. Foundry Maps

**Category:** Analytics / Geospatial
**Type:** No-code geospatial visualization
**Status:** Active

### Purpose

The Foundry Map application provides powerful geospatial and temporal visualization capabilities. It integrates data from across Foundry into a cohesive map experience, enabling users to visualize object locations, movement paths, geographic boundaries, and satellite imagery — all connected to the Ontology.

### Architecture: Layer-Based Map System

```
Foundry Map
├── Base Layer (map background: street, satellite, dark, light)
├── Object Layers (Ontology object data)
│   ├── Icons/circles (geopoint property)
│   ├── Lines/polygons (geoshape property)
│   ├── Track lines (movement over time)
│   ├── Breadcrumbs (historical path)
│   └── Heatmaps (density visualization)
├── Overlay Layers (supplementary data)
│   ├── Vector layers (GeoJSON / MVT URL)
│   ├── Raster layers (tile imagery)
│   └── Boundary/choropleth layers (regions)
├── Timeline (temporal filtering)
├── Drawing Tools (polygon, circle, bounding box)
└── Map Layer Editor (create/edit custom layer configs)
```

**Projection:** Web Mercator (EPSG:3857); coordinates in WGS 84 (EPSG:4326)

### Key Features

| Feature | Description |
|---------|-------------|
| **Object Layers** | Visualize Ontology objects by geopoint or geoshape properties |
| **Track Lines** | Animate movement of objects over time |
| **Breadcrumbs** | Show historical path of objects |
| **Heatmaps** | Density visualization for high-volume point data |
| **Choropleth Layers** | Color regions by dataset values (countries, provinces, postal codes) |
| **Vector Layers** | GeoJSON or MVT tile data sources |
| **Raster Layers** | Satellite/aerial tile imagery |
| **Gradient Coloring** | Color by numeric properties with custom gradient mapping |
| **String Coloring** | Manual or automatic color assignment by string property values |
| **Labels & Tooltips** | Configurable per-object labels and hover tooltips |
| **Drawing Tools** | Draw shapes for spatial queries and Actions |
| **Geospatial Actions** | Execute Ontology Actions from drawn shapes |
| **Bounding Box Queries** | Spatial search within a drawn region |
| **Timeline Filtering** | Filter displayed objects by time range |
| **Map Layer Editor** | Standalone app for creating/editing/previewing custom layers |
| **Workshop Integration** | Embed as Map widget in Workshop applications |
| **Contour Map Board** | Map visualization available within Contour analyses |

### Ontology Integration

Maps is deeply integrated with the Ontology:
- Object types with geopoint or geoshape properties are natively visualized
- Filtering by map area can feed into Ontology queries
- Actions can be triggered from drawn map regions
- Movement tracks are read from time series properties on objects

### Target Users

- Operations teams tracking asset locations
- Defense/intelligence analysts mapping entity networks
- Logistics teams monitoring fleet movement
- Urban planners visualizing regional data
- Any team requiring spatial context for Ontology objects

### Connections to Other Apps

- Map Widget embeds in **Workshop** modules
- Contour has a **Map Board** for tabular-data geographic views
- **Vertex** supports media layers that function like maps for image overlays
- **Pipeline Builder** can output geospatial datasets used by Maps

---

## 14. Vertex

**Category:** Analytics / Graph Visualization
**Type:** No-code graph exploration
**Status:** Active

### Purpose

Vertex is Foundry's graph visualization and network analysis application. It enables users to visualize the complex relationships between Ontology objects as an interactive node-edge graph, traverse networks using Search Around queries, style graphs by object properties, and run simulations of operational scenarios. Vertex transforms the abstract Ontology into a visual, explorable network.

### Architecture: Graph + Ontology Traversal

```
Vertex Graph
├── Nodes (Ontology Objects)
│   ├── Styled by property (color, size, icon)
│   ├── Labeled by property values
│   └── Grouped by object type layer
├── Edges (Ontology Links or Function-generated relationships)
│   ├── Direct edges (typed link between two objects)
│   ├── Intermediate edges (via common related object)
│   └── Styled by property (color, width, line style)
├── Graph Templates (saved, reusable views)
├── Search Around (expand graph by traversing links)
├── Timeline (filter nodes/edges by time)
├── Media Layers (object overlays on images/maps)
└── Functions Integration (programmatically generate graphs)
```

### Key Features

| Feature | Description |
|---------|-------------|
| **Node Styling** | Color, size, icon based on object properties or time series values |
| **Edge Styling** | Color, width, line style (straight, curved, orthogonal) by properties |
| **Search Around** | Right-click any node to traverse links and add related objects |
| **Multi-Step Traversal** | Build complex filtered multi-hop graph queries |
| **Layer Configuration** | Style all objects of a type independently as a layer |
| **Graph Templates** | Save and share curated graphs for reuse |
| **Function-Generated Graphs** | TypeScript functions produce graph structures programmatically |
| **Direct Edges** | Link-based edges with type display name |
| **Intermediate Edges** | Edges via intermediate objects (e.g., shared events) |
| **Timeline Filtering** | Filter graph by time to show historical states |
| **Simulation / What-If** | Explore simulated future system states |
| **Media Layers** | Overlay objects on images or maps for spatial context |
| **Workshop Integration** | Embed Vertex graphs in Workshop modules |
| **Event Configuration** | Explore related events from graph nodes |

### Ontology Integration

Vertex is one of the most Ontology-intensive applications in Foundry:
- Every node is a typed Ontology object
- Every edge is a typed Ontology link (or Function-generated relationship)
- Search Around queries traverse the Ontology link graph
- Actions can be triggered from within graph context
- Time series properties can drive node/edge styling dynamically

### Use Cases

- **Supply chain networks** — Map suppliers, parts, and logistics relationships
- **Financial fraud detection** — Graph of accounts, transactions, and entities
- **Organizational networks** — Org charts and influence maps
- **Infrastructure dependency maps** — Systems, services, and dependencies
- **Military/defense** — Entity-relationship networks in intelligence workflows

### Target Users

- Intelligence analysts investigating entity networks
- Operations teams mapping system dependencies
- Supply chain managers visualizing supplier relationships
- Data scientists exploring graph-structured data
- Platform architects visualizing Ontology structure

### Connections to Other Apps

- Reads all data from the **Ontology** (objects, links)
- TypeScript **Functions** in **Code Repositories** generate graph structures
- Graphs can be embedded in **Workshop** modules
- Time series data from the **Ontology** drives dynamic styling
- **Quiver** provides complementary time-based analysis of the same objects

---

## 15. Phonograph

**Category:** Data Storage / Object Backend
**Type:** Internal infrastructure component / Legacy
**Status:** Legacy (Object Storage V1 — being replaced by Object Storage V2)

### Purpose

Phonograph (formally: Object Storage V1) is Foundry's legacy Ontology backend storage engine. It is not a user-facing application in the traditional sense but an infrastructure component that powers Ontology queries, writeback operations, and edit tracking for applications built on Foundry. Understanding Phonograph is important for legacy system maintenance and for comprehending how Ontology data flows through the platform.

### How Phonograph Works

```
Foundry Dataset (backing datasource)
         │
   [Registered in Ontology Manager]
         │
   [Indexed into Phonograph]
         │
   Phonograph Object Store
   ├── Indexed object data (searchable, aggregatable)
   ├── Edit tracking (user-generated changes)
   ├── Writeback cache (Slate user input)
   └── Query serving (for Workshop, Quiver, Vertex, etc.)
```

### Key Capabilities

| Capability | Description |
|------------|-------------|
| **Incremental Indexing** | Indexes new data on APPEND or UPDATE transactions only |
| **Query Serving** | Responds to object search and aggregation queries from applications |
| **Edit Tracking** | Tracks application of user-generated edits (from Slate writeback) |
| **Writeback Cache** | Captures user input changes in Slate before writing to source datasets |
| **Datasource Registration** | Backing datasets are registered and indexed for Ontology access |

### Migration Status

Phonograph writeback is in the **legacy phase** — no additional development is expected. Palantir recommends migrating to **Object Storage V2** for:
- New writeback workflows
- Improved performance and architecture
- Better support for modern Ontology features

### Media Sets & Unstructured Data (Related)

While Phonograph handles structured object storage, Foundry also manages **unstructured data** through:

- **Media Sets** — Collections of files (PDFs, images, audio, video) with a common schema
- **Media References** — Pointers to media items usable in datasets without duplication
- **AIP Document Intelligence** — AI-powered extraction from document media sets
- **Media Preview Widget** — Workshop widget for displaying image/video/document media

AIP Document Intelligence supports:
- OCR and embedded text extraction from PDFs
- LLM-based entity extraction
- One-click deployment as a Python pipeline transform
- Visual bounding box result review

### Target Users (Legacy)

- Platform engineers maintaining legacy Foundry deployments
- Developers understanding Ontology data flow for debugging
- Architects planning migration to Object Storage V2

---

## 16. Compass

**Category:** Platform / Resource Management
**Type:** Filesystem and project management
**Status:** Active (foundational platform tool)

### Purpose

Compass is Foundry's filesystem — the organizational backbone that powers resource management, project creation, access control, and navigation across the entire platform. Every Foundry resource (dataset, analysis, application, code repository, etc.) lives in Compass. It is analogous to a combination of a file system and a project management tool, providing the organizational layer beneath all other Foundry applications.

### Architecture: Three-Tier Organization

```
Compass Filesystem
├── Spaces (top-level organizational containers)
│   └── Portfolios (group of related projects)
│       └── Projects (collaborative work unit = security boundary)
│           ├── Files (datasets, analyses, apps, repos)
│           ├── Pinned Items (important resources at top)
│           ├── Autosaved (unsaved workspace items)
│           ├── References (external inputs flowing in)
│           ├── Trash (recoverable deleted items)
│           └── Sensitive Data Scanner (PII detection)
└── Personal Space
    ├── Your Files (personal workspace, not shared)
    └── Shared with You (resources others have shared)
```

### Key Features

| Feature | Description |
|---------|-------------|
| **Projects** | Collaborative, security-bounded work units |
| **Portfolios** | Group related projects for organizational visibility |
| **Pinned Resources** | Pin important files to the top of project Files view |
| **Access Management** | Manage user/group roles with Owner, Editor, Viewer permissions |
| **Markings** | Apply data classification markings to restrict access by sensitivity |
| **Access Graph** | Visualize the security setup of a project |
| **Project References** | Manage data flow across project boundaries |
| **File References** | Track external datasets used by Code Repositories, Pipeline Builder, etc. |
| **Sensitive Data Scanner** | Detect PII in project datasets |
| **Resource Management** | View compute and storage usage per project |
| **AIP Rate Limit Tracking** | Monitor AIP API usage and rate limit hits per project |
| **Trash & Recovery** | Recover deleted resources |
| **Tag & Filter System** | Filter resources by type, status, portfolio, organization, tags |
| **Request Access** | Users can request access to restricted projects |

### Project References

Projects serve as both conceptual and **security boundaries**. When data flows between projects, Compass tracks this through **Project References**:
- **File references** — External files used in Code Repositories, Code Workbook, Pipeline Builder, Fusion, or Contour
- **External references** — Non-file dependencies (e.g., packages)

This ensures data governance is maintained across organizational boundaries.

### Sensitive Data Scanner

A built-in PII detection capability within Compass that:
- Scans project datasets for personally identifiable information
- Surfaces detections in a dedicated project view
- Helps compliance teams maintain data hygiene

### Target Users

- All Foundry users (universal — everyone uses Compass to navigate)
- Platform administrators managing access and security
- Project owners organizing team work
- Compliance officers reviewing data access and PII

### Connections to Other Apps

- All Foundry apps store their resources (analyses, repos, datasets) in Compass
- **Code Repositories** use Compass for file and access management
- **Pipeline Builder** project references are managed via Compass
- **Resource Management** app links from Compass for usage analytics
- **AIP** usage monitoring is accessible from Compass project views

---

## 17. Object Explorer

**Category:** Object Set Browsing & Exploration
**Status:** Active

### What It Does

Object Explorer provides a low-configuration, user-friendly interface for browsing, comparing, and acting on sets of Ontology objects. It is designed for less technical users who need to explore data without building analyses or full applications. It serves as the natural starting point for object exploration before transitioning to more powerful tools.

### Key Features

| Feature | Description |
|---------|-------------|
| **Preset Visualizations** | Charts, maps, tables, and other visualizations requiring minimal setup |
| **Object Set Comparison** | Compare and contrast different subsets of objects side by side |
| **Drill-Down Filtering** | Use visualizations to progressively filter into specific subsets |
| **Bulk Actions** | Execute Ontology Actions (writeback, status changes, etc.) on entire object sets |
| **Cross-App Handoff** | "Analyze in Quiver" button opens the current object set in Quiver for deeper analysis |
| **Export** | Export object sets for use in external tools |
| **Object Views** | Pre-configured detail views for individual objects, embeddable in other apps |

### Ecosystem Role

Object Explorer is the **entry point for object-centric exploration**. The typical user journey is:

```
Object Explorer (browse/filter) --> Quiver (deep analysis) --> Workshop (operational action)
```

It requires minimal configuration, making it ideal for end users who need quick access to filtered, visual views of Ontology data without waiting for an application to be built.

### Connections to Other Apps

- Seamless transition to **Quiver** for deeper analytical workflows
- Object sets can be opened in **Workshop** or other compatible apps
- Object Views are embeddable in **Notepad** documents
- Bulk **Actions** can be triggered directly from Object Explorer

---

## 18. Actions

**Category:** Ontology Writeback & Business Logic Execution
**Status:** Active (core Ontology primitive)

### What It Does

Actions define the "verbs" of the enterprise — the structured, permissioned, auditable operations that users perform to create, edit, delete, and link objects in the Ontology. They are what make Foundry applications operational rather than read-only.

### Key Concepts

**Action Types** are configurable templates that define what an action does and who can do it. They consist of:

1. **Parameters** — Inputs the user provides (object references, text, numbers, dates, etc.)
2. **Rules** — Logic that transforms parameters into Ontology edits or side effects
3. **Conditions** — Validation logic and permission gates

### Rule Types

| Rule Type | Description |
|-----------|-------------|
| **Create Object** | Create a new object of a predefined type with specified properties |
| **Modify Object(s)** | Update properties of existing objects referenced by parameters |
| **Delete Object(s)** | Remove objects from the Ontology |
| **Create/Delete Link** | Add or remove relationships between objects |
| **Function Rule** | Delegate to a TypeScript/Python function for complex logic; when present, handles everything |
| **Interface-Based Rules** | Create/modify/delete objects by interface rather than specific type |
| **Notification Rule** | Send a notification about the action to specified recipients |
| **Webhook Rule** | Make an HTTP request to an external system, passing action parameters through |

### Key Features

| Feature | Description |
|---------|-------------|
| **Granular Permissions** | Different users can have different action permissions (e.g., analysts create, managers close) |
| **Audit Trail** | Every action creates a historical log entry for compliance and decision analysis |
| **Multi-Rule Compilation** | Multiple rules compile into a single edit per object; rule order determines conflict resolution |
| **Branching Support** | Run Actions on Foundry branches to test workflows without affecting production |
| **Writeback Datasets** | Object edits are captured in writeback datasets (Object Storage V2 recommended) |
| **Validation Logic** | Custom conditions gate whether an action can be executed |
| **Compute Cost** | Minimum 18 compute-seconds overhead per action, plus 1 per additional object edited |

### Ecosystem Role

Actions are the **write layer** of the entire Ontology. They are triggered from:

- **Workshop** buttons, forms, and inline table edits
- **Slate** custom interfaces
- **Object Explorer** bulk operations
- **Ontology SDK (OSDK)** for programmatic access
- **AIP Agents** for AI-driven workflows

Without Actions, every Foundry application would be a read-only dashboard. Actions are what close the loop — enabling users to approve, reject, assign, escalate, update, and trigger integrations.

---

## 19. Code Workspaces

**Category:** Exploratory IDE (Jupyter / RStudio / VS Code)
**Status:** Active (successor to Code Workbook)

### What It Does

Code Workspaces provides familiar IDE environments — JupyterLab, RStudio Workbench, and VS Code — embedded within Foundry's security and governance layer. It is designed for exploratory analysis and prototyping with cell-by-cell iteration and instant feedback.

### Key Features

| Feature | Description |
|---------|-------------|
| **Three IDE Options** | JupyterLab, RStudio Workbench, and VS Code |
| **Cell-by-Cell Execution** | Instant feedback on code, ideal for data exploration and ML prototyping |
| **Foundry Data Access** | Full access to Foundry datasets and Ontology objects within the IDE |
| **Branching** | Create and work on Foundry branches from within the workspace |
| **Build Scheduling** | Schedule workspace outputs as recurring pipeline builds |
| **Resource Management** | Configurable compute resources per workspace |
| **Shareable Outputs** | Export to reports, publish to dashboards, or promote to production pipelines |
| **Data Security** | All data access governed by Foundry's permission model |

### Code Workspaces vs. Code Repositories vs. Code Workbook

| Dimension | Code Workspaces | Code Repositories | Code Workbook (Legacy) |
|-----------|----------------|-------------------|----------------------|
| **Purpose** | Exploratory analysis | Production pipelines | Interactive coding (legacy) |
| **IDE** | Jupyter, RStudio, VS Code | Foundry web IDE | Foundry web notebook |
| **Compute** | Single-node (no Spark) | Distributed Spark | Distributed Spark |
| **Git** | Backed by Code Repos | Full Git workflows | Limited versioning |
| **Best For** | Prototyping, ML, ad-hoc | Governed production code | Being replaced by Workspaces |

### Ecosystem Role

Code Workspaces is the **data science sandbox**. Analysts and data scientists use it for ad-hoc analysis, model prototyping, and exploratory work in familiar notebook environments. When code matures, it is promoted to Code Repositories for production governance. It replaces the legacy Code Workbook application.

### Limitations

- Does not support distributed Spark — best for data that fits within single-node compute limits
- Not designed for production deployment (promote to Code Repositories for that)

---

## Recent Platform Additions (2025-2026)

| Feature | Date | Description |
|---------|------|-------------|
| **Pipeline Builder Warm Pool** | Oct 2025 | Auto-scaling VM pool eliminates job startup latency |
| **Spreadsheet Media Sets** | Oct 2025 | Spreadsheet preview in Workshop; Pipeline Builder can extract spreadsheet data |
| **AIP Document Intelligence** | Feb 2026 | Low-code document extraction workflows (GA) |
| **Model Studio** | Feb 2026 | No-code ML model training and deployment (GA) |
| **Compute Modules** | Feb 2026 | Custom functions/APIs callable from Workshop, Slate, OSDK |
| **Foundry Branching** | 2025 | Unified branching across Code Repos, Pipeline Builder, Ontology Manager, Workshop |

---

## Cross-Application Integration Summary

### How Apps Flow Together

```
Raw Data Sources
      │
      ▼
Pipeline Builder ─────────────────────────────────────────────┐
      │                                                        │
      ▼                                                        ▼
Datasets ──── Code Workbook/Repos ──── Ontology (Objects, Links, Time Series)
      │                                         │
      ├── Fusion (manual edits/entry)           ├── Contour (tabular analytics)
      │                                         ├── Quiver (time series + objects)
      └── Contour (direct dataset analysis)     ├── Vertex (graph relationships)
                                                ├── Maps (geospatial)
                                                ├── Workshop (no-code apps)
                                                ├── Slate (custom apps)
                                                └── Carbon (role workspaces)
                                                         │
                                                         ▼
                                                    Notepad (reporting)
                                                    Marketplace (distribution)
                                                    Compass (organization)
```

### Application Selection Guide

| Need | Best Tool |
|------|-----------|
| Explore large tabular datasets without code | **Contour** |
| Analyze time series / sensor data | **Quiver** |
| Build an operational app without coding | **Workshop** |
| Build a fully branded custom web app | **Slate** |
| Build ETL pipelines without code | **Pipeline Builder** |
| Write production Python/TypeScript transforms | **Code Repositories** |
| Prototype and explore data interactively | **Code Workspaces / Code Workbook** |
| Write narrative reports with live data | **Notepad** |
| Work with data in a spreadsheet | **Fusion** |
| Visualize geospatial data | **Maps** |
| Explore entity/network relationships | **Vertex** |
| Create a focused role-specific experience | **Carbon** |
| Organize and secure platform resources | **Compass** |
| Distribute reusable data products | **Marketplace** |
| Track movement/location over time | **Maps (track lines)** |
| Process unstructured documents with AI | **AIP Document Intelligence** |
| Browse and filter Ontology objects quickly | **Object Explorer** |
| Let users modify Ontology data from apps | **Actions** (via Workshop/Slate) |
| Run exploratory analysis in Jupyter/RStudio | **Code Workspaces** |

---

## Sources

- [Palantir Foundry Official Documentation](https://www.palantir.com/docs/foundry)
- [Contour Overview](https://www.palantir.com/docs/foundry/contour/overview)
- [Quiver Overview](https://www.palantir.com/docs/foundry/quiver/overview)
- [Slate Overview](https://www.palantir.com/docs/foundry/slate/overview)
- [Workshop Overview](https://www.palantir.com/docs/foundry/workshop/overview)
- [Pipeline Builder Overview](https://www.palantir.com/docs/foundry/pipeline-builder/overview)
- [Code Workbook Overview](https://www.palantir.com/docs/foundry/code-workbook/overview)
- [Code Repositories Overview](https://www.palantir.com/docs/foundry/code-repositories/overview)
- [Notepad Overview](https://www.palantir.com/docs/foundry/notepad/overview)
- [Reports (Sunset) Overview](https://www.palantir.com/docs/foundry/reports/overview)
- [Fusion Overview](https://www.palantir.com/docs/foundry/fusion/overview)
- [Marketplace Overview](https://www.palantir.com/docs/foundry/marketplace/overview)
- [Carbon Overview](https://www.palantir.com/docs/foundry/carbon/overview)
- [Map Overview](https://www.palantir.com/docs/foundry/map/overview)
- [Vertex Overview](https://www.palantir.com/docs/foundry/vertex/overview)
- [Object Storage V1 (Phonograph)](https://www.palantir.com/docs/foundry/object-databases/object-storage-v1)
- [Compass Overview](https://www.palantir.com/docs/foundry/compass/overview)
- [App Building Overview](https://www.palantir.com/docs/foundry/app-building/overview)
- [Foundry Platform Summary for LLMs](https://www.palantir.com/docs/foundry/getting-started/foundry-platform-summary-llm)
- [Intro to Contour - Medium/Ontologize](https://medium.com/ontologize/palantir-foundry-101-intro-to-contour-for-data-analysis-fb486ea1d959)
- [Mastering Workshop - Medium/D-ONE.AI](https://medium.com/d-one/mastering-palantir-foundry-workshop-building-insightful-dashboards-a5697adeb17d)
- [Object Explorer Overview](https://www.palantir.com/docs/foundry/object-explorer/overview)
- [Action Types Overview](https://www.palantir.com/docs/foundry/action-types/overview)
- [Action Types Rules](https://www.palantir.com/docs/foundry/action-types/rules)
- [Code Workspaces Overview](https://www.palantir.com/docs/foundry/code-workspaces/overview)
- [Code Products Comparison](https://www.palantir.com/docs/foundry/code-workbook/code-products-comparison)
- [Foundry DevOps Overview](https://www.palantir.com/docs/foundry/foundry-devops/overview)
- [February 2026 Announcements](https://www.palantir.com/docs/foundry/announcements)
- [October 2025 Announcements](https://www.palantir.com/docs/foundry/announcements/2025-10)
