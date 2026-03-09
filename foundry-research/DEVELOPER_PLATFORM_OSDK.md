# Palantir Developer Platform & OSDK — Comprehensive Technical Reference

> Research compiled: March 2026
> Covers: OSDK, TypeScript/Python/Java SDKs, REST APIs, Functions, Developer Console, Widgets, Ontology Types, Auth, Webhooks, External Apps, Community, DevCon

---

## Table of Contents

1. [OSDK Overview](#1-osdk-overview)
2. [TypeScript SDK](#2-typescript-sdk)
3. [Python SDK](#3-python-sdk)
4. [Java SDK](#4-java-sdk)
5. [REST APIs — Foundry Platform API](#5-rest-apis--foundry-platform-api)
6. [Code Repositories — Foundry's Built-in Git](#6-code-repositories--foundrys-built-in-git)
7. [Functions — Serverless Compute](#7-functions--serverless-compute)
8. [Developer Console](#8-developer-console)
9. [Widgets — Custom UI for Workshop](#9-widgets--custom-ui-for-workshop)
10. [Ontology Type System](#10-ontology-type-system)
11. [Authentication — OAuth2, Service Accounts, App Registration](#11-authentication--oauth2-service-accounts-app-registration)
12. [Webhooks & Events — External Integration Patterns](#12-webhooks--events--external-integration-patterns)
13. [External Applications — React/Angular/Vue on Foundry](#13-external-applications--reactangularvue-on-foundry)
14. [Palantir MCP — Model Context Protocol](#14-palantir-mcp--model-context-protocol)
15. [Developer Community & Learning Curve](#15-developer-community--learning-curve)
16. [Palantir DevCon — Developer Conferences](#16-palantir-devcon--developer-conferences)
17. [Key GitHub Repositories](#17-key-github-repositories)
18. [Source Index](#18-source-index)

---

## 1. OSDK Overview

### What Is the Ontology SDK?

The **Ontology Software Development Kit (OSDK)** is Palantir's primary developer-facing abstraction layer for building applications on top of the Palantir Foundry platform. Rather than requiring developers to interact with low-level REST APIs, the OSDK generates **type-safe, Ontology-specific client libraries** that reflect the actual data model (object types, link types, action types, and functions) defined in a Foundry enrollment.

The OSDK was built around a core insight: enterprise applications should be written in the language of the business — in terms of `Employees`, `FlightSchedules`, and `Airports`, not rows and columns. Palantir calls this paradigm **Ontology-Oriented Software Development**.

### When Was It Launched?

- **OSDK v1.x**: Initial release, TypeScript and Python support
- **OSDK 2.0**: Generally available week of **October 28, 2024** — major rewrite focused on performance and scalability
- **Java OSDK**: Launched **July 2024**
- **OSDK Templates**: Experimental, **February 2025**
- **OSDK in Slate**: Available on all enrollments, **June 2024**

### Core Purpose

1. **Accelerated Development** — Generate a strongly-typed client from your Ontology in minutes; start querying objects and firing actions with minimal boilerplate
2. **Strong Type Safety** — Types and functions generated directly from your Ontology schema; full IDE IntelliSense support
3. **Centralized Maintenance** — The Ontology is managed in Foundry centrally; application code benefits automatically when the Ontology evolves
4. **Secure by Design** — Each OSDK application token is scoped to only the Ontology entities the application needs, intersected with the user's own permissions

### OSDK vs. Platform SDK

| | Platform SDK | OSDK |
|---|---|---|
| **Purpose** | Generic API bindings for all Foundry endpoints | Ontology-specific type-safe wrappers |
| **Use When** | Administrative/platform-level operations | Building apps that read/write Ontology data |
| **Abstraction Level** | Low (HTTP-level) | High (domain-model-level) |
| **Generation** | Static library | Generated per-enrollment, per-application |

### Supported Languages & Package Managers

| Language | Package Manager | Status |
|---|---|---|
| TypeScript | npm (`@osdk/*`) | GA (v2.0 as of Oct 2024) |
| Python | pip / conda | GA |
| Java | Maven | GA (July 2024+) |
| Any language | OpenAPI spec | Manual / code-gen |

---

## 2. TypeScript SDK

### Repositories

- **OSDK TypeScript (monorepo)**: [github.com/palantir/osdk-ts](https://github.com/palantir/osdk-ts)
- **Foundry Platform TypeScript**: [github.com/palantir/foundry-platform-typescript](https://github.com/palantir/foundry-platform-typescript)

### Key npm Packages

| Package | Purpose |
|---|---|
| `@osdk/client` | Core client factory, entry point for all OSDK operations |
| `@osdk/oauth` | OAuth2 token provider (PKCE and client credentials flows) |
| `@osdk/foundry` | Meta-package; all Foundry Platform SDK namespaces |
| `@osdk/foundry.{namespace}` | Individual namespace packages (e.g., `@osdk/foundry.ontologies`) |
| `@osdk/gotham.{namespace}` | Gotham-specific API namespaces |
| `@osdk/react` | React hooks and context provider for OSDK |
| `@osdk/create-app` | CLI scaffolding tool: `npm create @osdk/app@latest` |
| `@osdk/create-widget` | CLI scaffolding for Workshop custom widgets |
| `@osdk/workshop-iframe-custom-widget` | Bidirectional Workshop iframe widget communication |

### Requirements

- **Node.js 18+** required
- Monorepo managed with **pnpm** + **turborepo**
- TypeScript (strict mode recommended)

### OSDK 2.0 vs 1.x — Key Changes

**Performance & Scale**
- v1.x generated full implementations for every Ontology item — package size scaled with total Ontology size (which can be enormous in large enterprises)
- v2.0 **scales linearly with shape/metadata**, not full item count; supports **lazy loading** (only load what you use, when you use it)

**Developer Experience**
- v2.0 **separates the client from generated code** — hotfixes can update library dependencies without full SDK regeneration
- Exponentially better code reuse across projects
- Streamlined code generation for large ontologies

**New Capabilities in 2.0**
- **Ontology Interfaces** — polymorphic object type modeling
- **Real-time subscriptions** — receive live updates when object sets change
- **Media sets** — binary/media data access
- `ontologyRid` parameter required on client creation (can be read from env or generated `$ontologyRid` variable)

**Migration Path**: v1.1 → v1.2 → v2.0. Palantir will maintain v1.x support for at least one year after v2.0 GA.

### Bootstrapping a New TypeScript App

```bash
npm create @osdk/app@latest \
  --foundryUrl https://your-stack.palantirfoundry.com \
  --clientId your-client-id \
  --osdkPackage @your-sdk/package
```

### Client Setup

```typescript
import { createClient } from "@osdk/client";
import { createPublicOauthClient } from "@osdk/oauth";

const auth = createPublicOauthClient(
  clientId,
  foundryUrl,
  redirectUrl,
);

const client = createClient(foundryUrl, ontologyRid, auth);
```

### Real-Time Subscriptions

The subscriptions feature allows an application to receive live updates when objects in a specified object set are changed — including addition, deletion, and property value changes.

```typescript
const unsubscribe = client(Employee).subscribe(
  { filter: ... },
  (change) => { console.log(change); }
);
```

### OSDK Templates (Feb 2025 — Experimental)

Pre-configured TypeScript starting points that enforce UI standards and shared Ontology resources across projects. Accessible via Developer Console under SDK settings.

---

## 3. Python SDK

### Repositories

- **Foundry Platform Python**: [github.com/palantir/foundry-platform-python](https://github.com/palantir/foundry-platform-python)
- **Legacy (deprecated)**: [github.com/palantir/palantir-python-sdk](https://github.com/palantir/palantir-python-sdk)
- **PyPI**: [pypi.org/project/foundry-platform-sdk](https://pypi.org/project/foundry-platform-sdk/)

### Python OSDK

The Python OSDK is generated per-enrollment through Developer Console and installed via pip:

```bash
pip install your-generated-osdk-package
# or
conda install your-generated-osdk-package
```

The generated package provides Pythonic classes for each object type in the Ontology:

```python
from your_osdk_package import Employee, FoundryClient

client = FoundryClient(auth=ConfidentialClientAuth(...), hostname="...")
employees = client.ontologies.objects.Employee.where(...).all()
```

### Foundry Platform Python SDK

The **Platform SDK** (`foundry-platform-sdk`) is distinct from the OSDK:
- Generated from the Foundry API's OpenAPI specification
- Covers platform-level operations: metadata, resource management, administrative endpoints
- Also surfaces Ontology resource schemas (object types, link types, action types)
- Use OSDK for data read/write; use Platform SDK for platform operations

### Authentication in Python

```python
from palantir_oauth_client import get_user_credentials
from foundry import FoundryClient
from foundry.v2.core.auth import ConfidentialClientAuth

# Service account (confidential client)
auth = ConfidentialClientAuth(
    client_id="...",
    client_secret="...",
    hostname="...",
    should_refresh=True,
)
auth.sign_in_as_service_user()

client = FoundryClient(auth=auth, hostname="...")
```

Tokens are short-lived; the SDK auto-retries on 401 after token refresh.

### Python OSDK in Developer Console

The Developer Console generates Ontology-specific documentation for Python alongside TypeScript and cURL. Builders can switch between language targets using the dropdown in the upper right of the Console.

---

## 4. Java SDK

### Launch

Java OSDK support launched in **July 2024**, available through Developer Console alongside TypeScript and Python.

### Maven Setup

```xml
<!-- In build.gradle or pom.xml after setting Maven Group ID in Developer Console -->
<dependency>
  <groupId>com.your-group-id</groupId>
  <artifactId>your-osdk-artifact</artifactId>
  <version>generated-version</version>
</dependency>
```

Developer Console now includes a **Maven tab** in the Application SDK page that lists all generated Java packages.

### Requirements

- **Java 17–21** required

### Capabilities

- Object type queries with type-safe filter/sort/page
- Executing Action types (create, modify, delete objects/links)
- Calling Foundry Functions via generated `Query` interfaces
- Confidential client authentication (service user pattern)

### Upcoming Features (as of research date)

- Interface casting on Java OSDK
- Interface filtering and operations
- Compute Module template for Foundry Workflows

### Tutorial

A Java OSDK Tutorial can be generated directly inside Developer Console for hands-on onboarding.

---

## 5. REST APIs — Foundry Platform API

### Overview

The **Foundry REST API** is the underlying HTTP layer. All SDKs are built on top of it.

- Protocol: **REST / HTTP**
- Authentication: **OAuth 2.0** (Bearer tokens)
- Payload: Primarily **JSON**
- Versioning: API namespaces versioned independently

**Docs**: [palantir.com/docs/foundry/api/general/overview/introduction](https://www.palantir.com/docs/foundry/api/general/overview/introduction)

### Core API Namespaces

| Namespace | Coverage |
|---|---|
| `ontologies` | Object CRUD, Action execution, Function invocation, Link traversal |
| `filesystem` | Dataset management, file operations |
| `admin` | User, group, role management |
| `connectivity` | Source connections, data ingestion |
| `third-party-applications` | OAuth2 app registration and management |
| `models` | ML model registry and serving |

### Ontology REST Operations

**Object CRUD**:
```
GET  /v2/ontologies/{ontologyRid}/objects/{objectType}/{primaryKey}
GET  /v2/ontologies/{ontologyRid}/objects/{objectType}
POST /v2/ontologies/{ontologyRid}/objects/{objectType}/search
POST /v2/ontologies/{ontologyRid}/objectSets/loadObjects
```

**Action Execution**:
```
POST /v2/ontologies/{ontologyRid}/actions/{actionType}/apply
POST /v2/ontologies/{ontologyRid}/actions/{actionType}/applyBatch
POST /v2/ontologies/{ontologyRid}/actions/{actionType}/validate
```

**Function Invocation**:
```
POST /v2/ontologies/{ontologyRid}/queryTypes/{queryApiName}/execute
```

**Link Traversal**:
```
GET /v2/ontologies/{ontologyRid}/objects/{objectType}/{primaryKey}/links/{linkType}
```

### When to Use REST Directly

- Integrating from languages without SDK support
- Server-side non-TypeScript/Python/Java environments
- Administrative automation scripts
- Lightweight read-only integrations

---

## 6. Code Repositories — Foundry's Built-in Git

### Overview

**Code Repositories** is Foundry's web-based IDE and Git system. It provides a full development environment without leaving the platform.

**Docs**: [palantir.com/docs/foundry/code-repositories/overview](https://www.palantir.com/docs/foundry/code-repositories/overview)

### Git Feature Set

- Full branching, committing, tagging
- Pull requests with line-by-line code review
- Configurable branch protection rules
- Merge conflict resolution UI
- Impact analysis views (what downstream pipelines will be affected)

### Integrated Developer Tools

| Tool | Purpose |
|---|---|
| Problems Helper | Real-time lint/error detection |
| Debugger | Step through transform behavior during execution |
| Preview Helper | Run code on sample data without committing |
| Tests Helper | Run and display unit test results |
| File Changes Helper | Diff uncommitted changes, compare historical versions |
| IntelliSense | Autocomplete for Python, TypeScript, and Ontology types |

### Repository Types

| Type | Language | Use Case |
|---|---|---|
| Transform Repository | Python / PySpark | Data pipeline transforms |
| Functions Repository | TypeScript v1/v2, Python | Business logic functions for Workshop/Actions |
| Application Repository | TypeScript (React) | Frontend applications using OSDK |
| Widget Set Repository | TypeScript | Custom Workshop widgets |

### VS Code Workspaces

For developers who prefer local IDEs, **Code Workspaces** allow VS Code to connect to the platform, providing the same experience with familiar local tooling. Supports `ruff`, `mypy`, `pylint`, `black`, and pre-commit hooks via **Foundry DevTools** (community package).

### When to Use Code Repositories

Recommended for:
- Production pipelines with governance requirements
- High-visibility pipelines needing code review gates
- Unit-test-gated deployments
- Functions requiring iterative OSDK-aware development

---

## 7. Functions — Serverless Compute

### Overview

**Foundry Functions** are serverless or deployed compute units written in TypeScript or Python that are natively integrated with the Ontology. They serve as the primary mechanism for encoding business logic.

**Docs**: [palantir.com/docs/foundry/functions/overview](https://www.palantir.com/docs/foundry/functions/overview)

### Supported Languages

| Language | Version | Status |
|---|---|---|
| TypeScript v1 | Node runtime (limited) | GA, deprecated for new projects |
| TypeScript v2 | Full Node.js runtime | GA (recommended) |
| Python | Standard Python | GA; serverless beta Dec 2024 |

### Serverless vs. Deployed

| | Serverless | Deployed |
|---|---|---|
| **Cost model** | Pay-per-execution | Continuous (long-lived container) |
| **Setup** | Minimal — auto-managed infra | Requires deployment config |
| **GPU support** | No | Yes |
| **Multi-version** | Yes (safe upgrades) | No |
| **Recommended** | Default choice | GPU-intensive workloads |

**Python serverless** entered beta in **December 2024** — same high-performance backend as TypeScript.

### TypeScript v2 Features

- **Full Node.js runtime**: access to `fs`, `child_process`, `crypto`, native npm modules
- Up to **8 vCPUs and 5GB memory** per function
- **Multithreading** via `worker_threads`
- **Live Preview**: debug and iterate on functions within an active Workshop session (GA: December 16, 2024)
- Designed around the OSDK — same SDK used in external apps; no separate learning curve
- **Property sub-selection**: only load required properties, reducing data transfer

### Function Types

| Decorator | TypeScript | Python | Description |
|---|---|---|---|
| `@Function` | Yes | Yes | Core function unit |
| `@Query` | Yes | Yes | Read-only function (safe for polling) |
| `@OntologyEditFunction` | Yes | Yes | Write function (for Actions) |

### Memory Configuration

- Default: **1,024 MiB**
- Range: **512 MiB – 5,120 MiB** (configurable per function)

### External API Calls from Functions

Functions can call external REST APIs, but require:
1. A registered **External Source** in Data Connection
2. The source client passed into the function
3. Serverless functions use the client from the source object; third-party clients not directly supported

### Python Functions in Workshop

Python functions written in Code Repositories can be surfaced directly in **Workshop** modules as data sources or action side effects, matching TypeScript's existing Workshop integration.

---

## 8. Developer Console

### Overview

**Developer Console** is the central hub for building OSDK-powered applications. It handles:

- Registering OAuth2 applications
- Selecting which Ontology entities the app can access
- Generating the versioned OSDK package (TypeScript / Python / Java)
- Managing SDK versions and settings
- Viewing auto-generated, Ontology-specific API documentation
- Bootstrapping new Code Repositories (React apps, widget sets)
- Hosting deployed React applications (custom subdomains, auto-provisioned TLS)

**Docs**: [palantir.com/docs/foundry/ontology-sdk/create-a-new-osdk](https://www.palantir.com/docs/foundry/ontology-sdk/create-a-new-osdk)

### Workflow

1. Create a new application in Developer Console
2. Select object types, link types, action types, and functions you need
3. Generate an SDK version (TypeScript / Python / Java)
4. Use the generated package name in your app's dependencies
5. Regenerate when the Ontology changes (v2.0 supports hotfixes without full regen)

### Auto-Generated Documentation

Developer Console generates **inline, Ontology-specific API docs** showing:
- Available object types and their properties
- Filterable properties and operations
- Action parameter shapes with validation rules
- Function signatures
- cURL, TypeScript, and Python examples side by side

### PR Preview (Jan 2025)

Pull Request previews for React applications — full working preview of proposed changes before merge, directly from Developer Console. Eliminates the need for separate dev environments.

### Web Hosting

Developer Console can provision custom subdomains for deployed React apps:
- DNS records and TLS certificates auto-provisioned
- Available on Developer Tier enrollments
- Enables fully self-contained Foundry-powered web applications

---

## 9. Widgets — Custom UI for Workshop

### Workshop Overview

**Workshop** is Foundry's low-code application builder. Module builders place and configure widgets to create operational applications. Custom widgets allow developers to extend Workshop with arbitrary frontend code.

**Docs**: [palantir.com/docs/foundry/custom-widgets/overview](https://www.palantir.com/docs/foundry/custom-widgets/overview)

### Native Widgets

Workshop includes a large library of built-in widgets:
- Tables, charts, maps
- Input forms, dropdowns, date pickers
- Action buttons (trigger Action types)
- Timelines, Gantt charts
- Embedded content (iframes)
- Object search and linking panels

Widget behavior is configured via the **Widget Setup tab**: bind variables, configure events, set display options.

### Custom Widget Development

Custom widgets are TypeScript-based components packaged as **Widget Sets**. They are built using a Code Repository in Developer Console.

**Key concepts**:
- A **Widget Set** is a versioned package containing one or more widgets
- Widgets declare a `main.config.ts` file defining **parameters** (inputs from Workshop) and **events** (outputs back to Workshop)
- Parameters and events are fully type-safe
- **Dev mode** allows previewing widget changes live within actual Workshop modules during development

```typescript
// main.config.ts example structure
export const config = defineConfig({
  parameters: {
    employeeId: { type: "string" },
    showDetails: { type: "boolean", default: false },
  },
  events: {
    onEmployeeSelected: { parameterKey: "employeeId" },
  },
});
```

### Iframe Bidirectional Widgets

The **`@osdk/workshop-iframe-custom-widget`** package enables embedding existing web applications inside Workshop as custom widgets with two-way communication:

- Workshop passes variable values into the iframed app
- The iframed app can set Workshop variable values
- The iframed app can trigger Workshop events

This is the **recommended path for custom widgets** and opens up any existing web app for integration.

```bash
npm install @osdk/workshop-iframe-custom-widget
```

**Performance note**: Iframes consume additional memory; Palantir recommends no more than one iframe widget visible on-screen at a time.

### OSDK in Custom Widgets

Widget sets can use the OSDK to read/write Ontology data directly:

```typescript
import { useOsdkClient } from "@osdk/react";

function MyWidget() {
  const client = useOsdkClient();
  const employees = client(Employee).fetchPage({ pageSize: 20 });
  // ...
}
```

---

## 10. Ontology Type System

### Overview

The Foundry Ontology is the semantic and operational backbone of the platform — a **digital twin** of the organization. It maps raw data to business concepts and enables both reading (queries) and writing (actions).

**Docs**: [palantir.com/docs/foundry/ontology/overview](https://www.palantir.com/docs/foundry/ontology/overview)

### Core Types

#### Object Types

An **Object Type** is the schema of a real-world entity or event.

- Analogous to a dataset schema (like a table definition)
- An **Object** is a single instance (like a row)
- An **Object Set** is a filtered collection (like a query result)

Examples: `Employee`, `Airport`, `WorkOrder`, `FlightSchedule`

Properties can be:
- **Standard**: string, integer, double, boolean, date, timestamp, array types
- **Geo**: GeoPoint, GeoShape for spatial data
- **Shared Properties**: reusable properties across multiple object types for consistency

Object types have a **status**: `active`, `experimental`, `deprecated`, `example`, or `endorsed` (highest trust).

#### Link Types

A **Link Type** defines a relationship between two Object Types.

- Analogous to a JOIN between two datasets
- A **Link** is a single instance of that relationship
- Supports many-to-many, one-to-many, one-to-one cardinalities
- Can link objects of the same type

Examples: `Employee → worksFor → Company`, `Flight → departFrom → Airport`

#### Action Types

An **Action Type** defines a set of changes users can make to the Ontology all at once.

- Combines parameter capture (form input) with rules (what changes to make)
- Rules can: create objects, modify property values, delete objects, create/delete links, execute webhooks, invoke functions
- Two rule sub-types:
  - **Ontology Rules** — modify the Ontology itself
  - **Side Effect Rules** — trigger external behavior (webhooks, notifications)
- Actions enforce **validation** before execution
- Support batch application for bulk operations

#### Functions

A **Function** is a code-based logic unit integrated with the Ontology.

- Takes object sets and properties as inputs
- Returns computed outputs
- Can be called from Action types, Workshop, and external apps via the OSDK
- Written in TypeScript v2 or Python

#### Interfaces

An **Interface** defines a shape (property contract) that multiple object types can implement, enabling **polymorphism**.

Example: A `WorkAsset` interface with `id`, `status`, `owner` properties could be implemented by `Vehicle`, `Equipment`, and `Facility` object types, allowing unified querying across all three.

#### Query Types

Query types are functions registered as callable endpoints, accessible via the OSDK's function invocation pattern. They appear as named, typed operations in generated SDKs.

### Type Status Lifecycle

| Status | Meaning |
|---|---|
| `experimental` | Under development; API may change |
| `active` | Production-ready |
| `endorsed` | Highest trust; core reusable type |
| `deprecated` | Scheduled for removal |
| `example` | Tutorial/demo only |

---

## 11. Authentication — OAuth2, Service Accounts, App Registration

### Overview

Foundry uses **OAuth 2.0** exclusively for API authentication. There are no long-lived static API keys for application use.

**Docs**: [palantir.com/docs/foundry/platform-security-third-party/third-party-apps-overview](https://www.palantir.com/docs/foundry/platform-security-third-party/third-party-apps-overview)

### Registering a Third-Party Application

1. Navigate to **Control Panel → Third-party applications → New application**
2. Follow the 4-step wizard: Details → Client Type → Authorization Grant Types → Summary
3. Receive a **Client ID** and (for confidential clients) a **Client Secret**

### Client Types

| Type | When to Use | Security Model |
|---|---|---|
| **Confidential Client** | Backend servers, services | Can hold secrets securely; supports both auth code and client credentials |
| **Public Client** | Browser-based SPAs | Cannot hold secrets; PKCE required; authorization code + PKCE only |

### Grant Types

#### Authorization Code Grant (User-delegated)
- App acts **on behalf of a logged-in Foundry user**
- User explicitly grants the app permission
- Access is the intersection of the requested scopes and the user's own permissions
- Supports optional resource restriction (limit access to specific Foundry resources)

#### Client Credentials Grant (Service Accounts)
- App acts as a **Foundry service user** (machine-to-machine)
- Auto-creates a service user account (username = client ID)
- Service user starts with no permissions; admin must grant roles
- Used for automated workflows, backend services, pipelines

### Token Lifecycle & Security

- All access tokens are **short-lived**
- Refresh tokens are **rotated on each use** (reuse detection: if same token used twice within 1 minute, all related tokens invalidated)
- Inactive refresh tokens auto-invalidated after **30 days**
- Service accounts auto-retry once on 401 after refreshing the token

### Scopes & Permissions

Applications must declare the minimum set of scopes required. The effective permission is the **intersection** of:
- Scopes requested by the application
- Permissions of the user (auth code grant) or service user (client credentials grant)

### Third-Party App Enablement

After registration, apps must be **enabled for each Organization** before users in that org can use the app. Admins can also pre-authorize apps org-wide (silent authorization, users not notified).

### OAuth2 Client Libraries

- **Python**: [github.com/palantir/palantir-oauth-client](https://github.com/palantir/palantir-oauth-client)
  ```python
  from palantir_oauth_client import get_user_credentials
  credentials = get_user_credentials(["offline_access"], hostname, client_id)
  ```
- **TypeScript**: `@osdk/oauth` package
  ```typescript
  import { createPublicOauthClient } from "@osdk/oauth";
  const auth = createPublicOauthClient(clientId, foundryUrl, redirectUrl);
  ```

---

## 12. Webhooks & Events — External Integration Patterns

### Overview

Foundry webhooks are the primary mechanism for **event-driven integration** with external systems — triggered by user Actions or data events within Foundry.

**Docs**: [palantir.com/docs/foundry/action-types/webhooks](https://www.palantir.com/docs/foundry/action-types/webhooks)

### Webhook Architecture

Each webhook is:
1. Associated with a **Source** in Data Connection (stores credentials and base URL)
2. Configured with a relative path, headers, query parameters, and body
3. Parameterized — inputs from the Action/Function are mapped into the request
4. Capable of capturing response data as output parameters

### Two Webhook Roles in Actions

| Type | Behavior | Use When |
|---|---|---|
| **Writeback Webhook** | Executes BEFORE Ontology changes; if webhook fails, no Foundry changes are made | Transactional guarantee needed; only 1 per Action |
| **Side Effect Webhook** | Executes AFTER Foundry changes; multiple allowed; best-effort | Notifications, multi-system fan-out, non-critical writes |

### Request Configuration

The REST request builder supports:
- Parameterization of path, headers, query params, and body
- Body formats: form input, form-url-encoded, raw JSON, binary attachment
- **Chained requests**: extract values from one response and pass to subsequent requests
- **OAuth flow support**: chained requests can perform client credentials handshake, then actual operation
- Testing from the Data Connection UI

### Rate and Concurrency Limits

Webhooks support configurable:
- Time limits per execution
- Concurrency limits
- Rate limits

### Using Webhooks from Functions (TypeScript)

Functions can call webhooks via the External Functions API using standard `async/await` patterns. Multiple webhook calls can be parallelized.

```typescript
// In a TypeScript Function
export async function notifyExternalSystem(
  webhookSource: ExternalSource,
  employee: SingleLink<Employee>
): Promise<void> {
  await callWebhook(webhookSource, { employeeId: employee.id });
}
```

**Important**: Webhooks called from `@Query` functions must be read-only (no mutations), because query functions may be retried silently.

### Data Connection REST API Connector

Foundry can also **ingest data** from external REST APIs:
- Periodic polling of REST endpoints
- Webhook-based push (Foundry as receiver)
- Chained auth + data fetch patterns

### Foundry as Webhook Receiver

As of May 2023, Foundry supports the **REST API Source with Webhooks** — Foundry can receive webhook payloads from external systems, enabling event-driven data ingestion pipelines.

---

## 13. External Applications — React/Angular/Vue on Foundry

### Overview

The primary external application pattern in Foundry is **OSDK-powered React applications**, though any JavaScript framework (Angular, Vue, Svelte) can be used since the OSDK is framework-agnostic.

**Docs**: [palantir.com/docs/foundry/ontology-sdk-react-applications/overview](https://www.palantir.com/docs/foundry/ontology-sdk-react-applications/overview)

### Architecture

```
[React App]
    ↓ uses
[@osdk/client + @osdk/react]
    ↓ queries/mutates
[Foundry Ontology REST API]
    ↓ backed by
[Foundry Datasets, Models, Pipelines]
```

### `@osdk/react` Package

The `@osdk/react` package provides:
- **`OsdkProvider`** — React context provider that supplies authentication and OSDK client throughout the component tree
- **`useOsdkClient`** — hook to access the OSDK client anywhere in the tree
- **`useOsdkObjects`** — hook for live-updating object queries

```tsx
import { OsdkProvider, useOsdkClient } from "@osdk/react";
import { $ontologyRid } from "your-generated-osdk";
import { createClient } from "@osdk/client";

const client = createClient(foundryUrl, $ontologyRid, auth);

function App() {
  return (
    <OsdkProvider client={client}>
      <MyFeature />
    </OsdkProvider>
  );
}

function MyFeature() {
  const client = useOsdkClient();
  // Query objects, execute actions...
}
```

### Deployment

1. Develop locally using `npm run dev` (with Vite or similar)
2. Create a Code Repository in Developer Console using the React template
3. Run `npm run lint`, `npm run test`, `npm run build` to validate
4. Cut a release via `git tag` + push
5. Developer Console auto-deploys to hosted subdomain (TLS included)

### PR Preview

Available for all OSDK React apps hosted in Developer Console:
- Creates a live preview URL for each pull request
- Shows proposed changes in full production context
- Automatically torn down after PR merge

### Training Track

Palantir offers a dedicated **"Frontend & OSDK Developer"** learning track on [learn.palantir.com](https://learn.palantir.com/page/training-track-frontend-osdk-developer).

---

## 14. Palantir MCP — Model Context Protocol

### Overview

**Palantir MCP** is Palantir's implementation of Anthropic's Model Context Protocol, enabling AI coding assistants (Cursor, Cline, VS Code Copilot, Continue) to:
1. Read context from your Foundry Ontology and projects
2. Take actions on the platform (modify ontology, run transforms, update Developer Console apps)

**Docs**: [palantir.com/docs/foundry/palantir-mcp/overview](https://www.palantir.com/docs/foundry/palantir-mcp/overview)

### Two MCP Variants

| | Palantir MCP | Ontology MCP |
|---|---|---|
| **Audience** | Ontology builders, developers | External AI agents, enterprise AI consumers |
| **Can modify ontology schema** | Yes | No |
| **Can write ontology data** | No | Yes (via Actions) |
| **Use case** | AI-assisted platform development | AI-powered business workflows |

### Palantir MCP — Developer Capabilities

- Search your Ontology (explore object types, properties, links)
- Modify Ontology types (add/edit object types, properties)
- Update Developer Console applications
- Run and fix Python transforms iteratively (run → error → fix → re-run loop)
- Query Foundry documentation and metadata
- Access Compass project structure

### Ontology MCP — Consumer Capabilities

- Exposes object types, action types, and query functions as MCP tools
- External AI systems (Copilot Studio, Gemini Enterprise, custom agents) can execute actions and query data
- Access controlled by application-level OSDK scopes
- Enables enterprise AI agents to safely write to Foundry within defined boundaries

### IDE Installation

Supported IDEs: **Cursor**, **Cline**, **VS Code**, **Continue**

Installation is managed via the Palantir MCP settings in Developer Console.

---

## 15. Developer Community & Learning Curve

### Official Resources

| Resource | URL | Description |
|---|---|---|
| Developer Portal | [palantir.com/developers](https://www.palantir.com/developers/) | Central developer hub |
| Documentation | [palantir.com/docs/foundry](https://www.palantir.com/docs/foundry/) | Full platform docs |
| Community Forum | [community.palantir.com](https://community.palantir.com/) | "Ask the Community" Q&A |
| Palantir Learn | [learn.palantir.com](https://learn.palantir.com/) | Courses, certifications, workflows |
| Build with AIP | [build.palantir.com](https://build.palantir.com/) | In-platform tutorials |
| YouTube Channel | Palantir YouTube | Video tutorials and DevCon recordings |

### Learning Paths

- **Speedrun: Your First End-to-End Workflow** — 60-minute intro to core Foundry apps; highly recommended starting point
- **Frontend & OSDK Developer** — Dedicated learning track for React/OSDK app building
- **AIP Bootcamp** — Go from zero to use case in hours, working alongside Palantir engineers (requires enrollment)
- **Build with AIP Package** — In-platform "To Do" app tutorial customized to your Ontology

### AIP Assist (In-Platform AI Help)

**AIP Assist** is an LLM-powered tool embedded in Foundry that helps navigate documentation, generate code, and explain platform concepts. It can be configured with custom Agent contexts via Agent Studio.

### Community Forum Activity

The [community.palantir.com](https://community.palantir.com/) forum is active with:
- `Ask the Community` category for technical Q&A
- Bug reports and documentation improvement requests
- `foundry-branching` tag for beta feature feedback
- Product feedback directly read by Palantir engineers

### Honest Learning Curve Assessment

Palantir's platform has a **significant learning curve** for new developers. Historical context:

- The **Forward Deployed Engineering (FDE)** model — Palantir's traditional go-to-market — meant customers were hand-held by Palantir engineers; self-service developer experience (DevEx) was secondary
- Product teams historically reframed developer problems as "Foundry-shaped solutions" rather than addressing DevEx gaps
- **2024 marked a meaningful shift**: Palantir invested heavily in developer self-service (DevCon, OSDK 2.0, Python serverless, MCP, free developer stacks, community forum, certification programs)

Key friction points for new developers:
1. The Ontology paradigm requires a mental model shift (from databases to semantic objects)
2. The OSDK generation loop (change Ontology → regenerate SDK → redeploy app) adds friction
3. Documentation quality has improved substantially but still lags behind mature platforms like AWS or Firebase
4. The platform is vast — Foundry covers data ingestion, transformation, ML, ontology, application building, and more; knowing where to start is non-trivial

Palantir has addressed this with the "Speedrun" tutorials, AIP Bootcamp, and the Build with AIP guided paths.

---

## 16. Palantir DevCon — Developer Conferences

### DevCon 1 (November 13–14, 2024)

Palantir's **first Developer Conference**, bringing together ~150 top commercial and government builders.

**Key Announcements**:

| Announcement | Status at Launch | Notes |
|---|---|---|
| AIP for Developers | GA launch | New developer toolkit accelerating prototype → production |
| OSDK 2.0 | GA | Launched at the conference |
| New Platform APIs | GA | Expanded API surface |
| Workflow Builder | GA | Visual workflow construction |
| Agent Studio | Beta | Build AI agents on top of Ontology |
| Platform Branching | Beta | Environment branching for safer development |
| Compute Modules | Beta | Docker container deployment in Foundry |
| Multi-Modal Data Plane | Private launch | Early access to select technical leaders |

**CTO Quote** (Shyam Sankar): *"The launch of AIP for Developers underscores Palantir's commitment to the primacy of winning. By deprecating backend development, AIP enables our customers to focus on delivering value, faster."*

**Customer Highlight**: Lennar reported **building 50x faster on AIP**.

### DevCon 3 (Referenced)

Palantir has a dedicated DevCon3 page ([palantir.com/devcon3](https://www.palantir.com/devcon3/)) indicating at least a third conference. Details on DevCon 2 and 3 were not fully captured in research.

### AIPCon

Separate from DevCon, **AIPCon** ([palantir.com/aipcon](https://www.palantir.com/aipcon/)) is Palantir's conference specifically focused on AIP — showcasing customer deployments, AI use cases, and platform demonstrations. These are typically larger, customer-facing events.

### Agent Studio — Post-DevCon

Following beta launch at DevCon 2024, **AIP Agent Studio** became **generally available in May 2025**.

Agent capabilities:
- Tier 1: Ad-hoc document analysis (AIP Threads)
- Tier 2: Task-specific agent with Ontology/document context
- Tier 3: Agentic Workshop application (read/write app state)
- Tier 4: Fully automated agent for complex autonomous workflows

Agents can be deployed internally (within Foundry) or externally (via OSDK and platform APIs).

### Platform Branching — Post-DevCon

**Foundry Branching** entered beta in **January 2025**, enabling developers to branch the Ontology and platform configuration, test changes in isolation, and merge safely — analogous to git branching but for the entire Foundry environment.

---

## 17. Key GitHub Repositories

| Repository | URL | Description |
|---|---|---|
| osdk-ts | [github.com/palantir/osdk-ts](https://github.com/palantir/osdk-ts) | TypeScript OSDK monorepo (`@osdk/*` packages) |
| foundry-platform-typescript | [github.com/palantir/foundry-platform-typescript](https://github.com/palantir/foundry-platform-typescript) | Foundry Platform TypeScript SDK |
| foundry-platform-python | [github.com/palantir/foundry-platform-python](https://github.com/palantir/foundry-platform-python) | Official Python SDK for Foundry API |
| palantir-python-sdk | [github.com/palantir/palantir-python-sdk](https://github.com/palantir/palantir-python-sdk) | Legacy Python SDK (deprecated) |
| palantir-oauth-client | [github.com/palantir/palantir-oauth-client](https://github.com/palantir/palantir-oauth-client) | OAuth2 Python client library |
| workshop-iframe-custom-widget | [github.com/palantir/workshop-iframe-custom-widget](https://github.com/palantir/workshop-iframe-custom-widget) | Bidirectional Workshop iframe widget SDK |
| Palantir Technologies (org) | [github.com/palantir](https://github.com/palantir) | All public Palantir open-source repos |

### npm Packages (Palantir)

All public packages: [npmjs.com/~palantir](https://www.npmjs.com/~palantir)

Key packages:
- `@osdk/client`
- `@osdk/oauth`
- `@osdk/foundry`
- `@osdk/react`
- `@osdk/create-app`
- `@osdk/create-widget`
- `@osdk/workshop-iframe-custom-widget`

---

## 18. Source Index

- [Ontology SDK Overview — palantir.com](https://www.palantir.com/docs/foundry/ontology-sdk/overview)
- [Dev Toolchain Overview — palantir.com](https://www.palantir.com/docs/foundry/dev-toolchain/overview)
- [SDK Reference — palantir.com](https://www.palantir.com/docs/foundry/api/general/overview/sdks)
- [Foundry API Introduction — palantir.com](https://www.palantir.com/docs/foundry/api/general/overview/introduction)
- [Python OSDK — palantir.com](https://www.palantir.com/docs/foundry/ontology-sdk/python-osdk)
- [Java OSDK — palantir.com](https://www.palantir.com/docs/foundry/ontology-sdk/java-osdk)
- [TypeScript OSDK Migration Guide (1.x → 2.0) — palantir.com](https://www.palantir.com/docs/foundry/ontology-sdk/typescript-osdk-migration)
- [Bootstrap TypeScript App — palantir.com](https://www.palantir.com/docs/foundry/ontology-sdk/how-to-bootstrapping-typescript)
- [Bootstrap Java App — palantir.com](https://www.palantir.com/docs/foundry/ontology-sdk/how-to-bootstrapping-java)
- [Functions Overview — palantir.com](https://www.palantir.com/docs/foundry/functions/overview)
- [Functions Feature Support by Language — palantir.com](https://www.palantir.com/docs/foundry/functions/language-feature-support)
- [Code Repositories Overview — palantir.com](https://www.palantir.com/docs/foundry/code-repositories/overview)
- [Developer Console: Add OSDK to Existing App — palantir.com](https://www.palantir.com/docs/foundry/developer-console/how-to-add-to-existing-typescript)
- [Custom Widgets Overview — palantir.com](https://www.palantir.com/docs/foundry/custom-widgets/overview)
- [Workshop Widgets Core Concepts — palantir.com](https://www.palantir.com/docs/foundry/workshop/concepts-widgets)
- [Workshop Iframe Widget — palantir.com](https://www.palantir.com/docs/foundry/workshop/widgets-iframe)
- [Ontology Overview — palantir.com](https://www.palantir.com/docs/foundry/ontology/overview)
- [Object Types Overview — palantir.com](https://www.palantir.com/docs/foundry/object-link-types/object-types-overview)
- [Link Types Overview — palantir.com](https://www.palantir.com/docs/foundry/object-link-types/link-types-overview)
- [Action Types Overview — palantir.com](https://www.palantir.com/docs/foundry/action-types/overview)
- [Third-Party Apps Overview — palantir.com](https://www.palantir.com/docs/foundry/platform-security-third-party/third-party-apps-overview)
- [Registering Third-Party Applications — palantir.com](https://www.palantir.com/docs/foundry/platform-security-third-party/register-3pa)
- [Writing OAuth2 Clients — palantir.com](https://www.palantir.com/docs/foundry/platform-security-third-party/writing-oauth2-clients)
- [Foundry API Authentication — palantir.com](https://www.palantir.com/docs/foundry/api/general/overview/authentication)
- [Action Webhooks — palantir.com](https://www.palantir.com/docs/foundry/action-types/webhooks)
- [Data Connection Webhooks Overview — palantir.com](https://www.palantir.com/docs/foundry/data-connection/webhooks-overview)
- [OSDK React Applications Overview — palantir.com](https://www.palantir.com/docs/foundry/ontology-sdk-react-applications/overview)
- [Palantir MCP Overview — palantir.com](https://www.palantir.com/docs/foundry/palantir-mcp/overview)
- [Palantir DevCon Press Release — investors.palantir.com](https://investors.palantir.com/news-details/2024/Palantir-Launches-AIP-for-Developers-at-DevCon/)
- [AIP Agent Studio Overview — palantir.com](https://www.palantir.com/docs/foundry/agent-studio/overview)
- [Palantir Developer Community — community.palantir.com](https://community.palantir.com/)
- [Palantir Learn — learn.palantir.com](https://learn.palantir.com/)
- [Palantir Developers — palantir.com/developers](https://www.palantir.com/developers/)
- [GitHub: palantir/osdk-ts](https://github.com/palantir/osdk-ts)
- [GitHub: palantir/foundry-platform-typescript](https://github.com/palantir/foundry-platform-typescript)
- [GitHub: palantir/foundry-platform-python](https://github.com/palantir/foundry-platform-python)
- [GitHub: palantir/palantir-oauth-client](https://github.com/palantir/palantir-oauth-client)
- [GitHub: palantir/workshop-iframe-custom-widget](https://github.com/palantir/workshop-iframe-custom-widget)
- [PyPI: foundry-platform-sdk](https://pypi.org/project/foundry-platform-sdk/)
- [Ontology-Oriented Software Development — Palantir Blog](https://blog.palantir.com/ontology-oriented-software-development-68d7353fdb12)
- [Foundry DevTools (community) — emdgroup.github.io](https://emdgroup.github.io/foundry-dev-tools/)
- [TypeScript OSDK Subscriptions — palantir.com](https://www.palantir.com/docs/foundry/ontology-sdk/typescript-subscriptions)
- [OSDK React Applications Development — palantir.com](https://www.palantir.com/docs/foundry/ontology-sdk-react-applications/development)
- [Frontend & OSDK Developer Training Track — learn.palantir.com](https://learn.palantir.com/page/training-track-frontend-osdk-developer)
