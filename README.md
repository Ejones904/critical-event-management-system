# Cloud-Native Critical Event Management & Communication System

## Executive Summary

The **Cloud-Native Critical Event Management & Communication System** is an enterprise-style event-driven platform designed to centralize communication and maintain a consistent operating picture during critical operational events.

Critical incidents often generate communication across disconnected channels: operational systems, separate email chains, text messages, phone calls, and manually distributed updates. As an incident develops, stakeholders can receive different information at different times, making it difficult for operations, leadership, legal, and other teams to maintain the same understanding of the event.

This system is designed to replace that fragmented model with a **centralized critical-event communication workflow**.

Events originating from multiple enterprise-style source systems are ingested, validated, normalized into a canonical event model, and processed through a durable asynchronous architecture. The system determines the appropriate stakeholder audience, establishes the communication workflow for the incident, and maintains subsequent updates as part of the same incident context.

A later AI-assisted coordination layer will analyze incident context, correlate updates, identify information gaps, and assist with drafting consistent stakeholder communications while deterministic controls remain responsible for event processing, escalation, delivery, security, and auditability.

The project is being engineered around:

- Event-driven architecture
- Centralized incident communication
- API design
- Asynchronous processing
- Relational data modeling
- Reliability and failure handling
- Least-privilege security
- Infrastructure as Code
- Observability
- Auditability
- AI-assisted incident coordination
- Human-in-the-loop controls

---

## Business / Operational Problem

Critical-event communication can become fragmented quickly.

A single operational incident may generate:

- An automated alert from an operational system
- Separate leadership email chains
- Individual text messages
- Phone calls
- Legal or compliance communication
- Independent operational updates
- Follow-up information distributed through different channels

This can create multiple versions of the same event:

```text
                         Critical Event
                              │
          ┌───────────────────┼───────────────────┐
          ▼                   ▼                   ▼
      Email Chain        Text Messages       Phone Calls
          │                   │                   │
          ▼                   ▼                   ▼
      Leadership          Operations            Legal

                  FRAGMENTED COMMUNICATION
```

The technical problem is therefore larger than sending an alert.

The system must maintain:

- A single authoritative incident record
- Consistent incident context
- Defined stakeholder participation
- Controlled escalation
- Centralized communication
- Subsequent incident updates
- Communication history
- Processing and delivery status
- An auditable incident timeline

The target communication model is:

```text
                  Enterprise Source Systems
                            │
                            ▼
                     Critical Event
                            │
                            ▼
                 Central Incident Record
                            │
                  ┌─────────┴─────────┐
                  │                   │
            Initial Incident      Event Updates
                  │                   │
                  └─────────┬─────────┘
                            ▼
               Central Communication
                       Workflow
                            │
              ┌─────────────┼─────────────┐
              ▼             ▼             ▼
          Operations      Legal       Leadership
              │             │             │
              └─────────────┼─────────────┘
                            ▼
                     Shared Context
                     Shared Updates
                     Shared Timeline
```

The goal is to maintain **one coordinated communication path throughout the lifecycle of a critical event**.

---

# System Functionality

The completed platform is designed to manage both the technical processing of critical events and the communication lifecycle surrounding them.

The system will:

1. Receive events from multiple enterprise-style source systems
2. Validate incoming event payloads
3. Preserve original source-event information
4. Normalize source-specific terminology into a canonical event model
5. Create and maintain a centralized incident record
6. Place events onto a durable message queue for processing
7. Process events asynchronously
8. Detect duplicate or previously processed events
9. Evaluate database-driven escalation policies
10. Determine which stakeholder roles require involvement
11. Establish the communication workflow for the incident
12. Generate the initial incident communication
13. Associate subsequent updates with the existing incident
14. Maintain consistent context across updates
15. Deliver approved communications through supported channels
16. Track communication and delivery status
17. Retry recoverable processing failures
18. Isolate repeatedly failing messages using a dead-letter queue
19. Maintain an auditable incident and communication history
20. Expose operational health and readiness information
21. Support AI-assisted incident analysis and communication coordination
22. Provision AWS infrastructure through Terraform

The intended incident lifecycle is:

```text
Event Detected
      │
      ▼
Validate Event
      │
      ▼
Normalize Event
      │
      ▼
Durable Queue
      │
      ▼
Create / Update Incident
      │
      ▼
Evaluate Escalation Policy
      │
      ▼
Resolve Stakeholders
      │
      ▼
Establish Communication Workflow
      │
      ▼
Initial Communication
      │
      ▼
Receive Additional Information
      │
      ▼
Update Existing Incident
      │
      ▼
AI-Assisted Context / Drafting
      │
      ▼
Human / Policy Controls
      │
      ▼
Same Communication Workflow
      │
      ▼
Incident Resolution
      │
      ▼
Complete Audit History
```

---

# Architecture

## Target AWS Architecture

```text
                  External / Simulated Systems
              ┌─────────────────────────────────┐
              │ ELD Platform                    │
              │ Transportation Management       │
              │ Yard Management                 │
              │ Security Monitoring             │
              │ Facility Monitoring             │
              └────────────────┬────────────────┘
                               │
                               ▼
                    Application Load Balancer
                               │
                               ▼
                      FastAPI Application
                               │
                    Validate + Normalize
                               │
                               ▼
                         Amazon SQS
                     ┌─────────┴─────────┐
                     │                   │
                     ▼                   ▼
               Worker Service      Dead-Letter Queue
                     │
                     ▼
              Central Incident State
                PostgreSQL / RDS
                     │
          ┌──────────┼───────────┐
          │          │           │
          ▼          ▼           ▼
     Escalation   Stakeholder   Communication
       Rules       Resolution      History
          │          │           │
          └──────────┼───────────┘
                     │
                     ▼
             Communication Engine
                     │
              ┌──────┴──────┐
              ▼             ▼
            Email           SMS
                     │
                     ▼
                Audit / S3


            AI-Assisted Coordination Layer
                     │
        ┌────────────┼─────────────┐
        │            │             │
        ▼            ▼             ▼
     Context      Incident       Update
     Analysis     Correlation    Drafting
        │            │             │
        └────────────┼─────────────┘
                     ▼
              Guardrails /
               Human Review
                     │
                     ▼
          Central Communication
                 Workflow
```

The target AWS deployment separates publicly accessible ingress from private application and database resources.

The deterministic processing architecture remains responsible for critical system behavior. AI capabilities operate on top of that foundation rather than replacing it.

---

# Engineering Architecture

The platform separates responsibilities across multiple components.

```text
Source Systems
      ↓
API Layer
      ↓
Validation
      ↓
Normalization
      ↓
Message Queue
      ↓
Worker
      ↓
Incident State
      ↓
Escalation Engine
      ↓
Communication Engine
      ↓
Audit Trail
```

Each component has a specific responsibility and can be tested independently.

This reduces coupling between event ingestion, processing, communication, and infrastructure.

---

# Current Implementation Status

## Completed

### Repository & Development Workflow

The project uses an enterprise-style Git workflow rather than developing directly against the release branch.

Implemented:

- `main` branch for stable project state
- `develop` branch for integration
- Feature branches
- Bugfix branches
- Pull-request-based integration
- GitHub Issues for implementation work
- Environment-variable protection
- Secret exclusion through `.gitignore`
- Incremental implementation and validation

---

## PostgreSQL Data Layer

The relational database foundation has been implemented using PostgreSQL.

Current core tables:

```text
events
stakeholders
escalation_rules
notifications
```

These represent four fundamental responsibilities:

```text
events
    ↓
What happened?

escalation_rules
    ↓
What should happen?

stakeholders
    ↓
Who needs visibility?

notifications
    ↓
What communication occurred?
```

The data model provides the deterministic foundation that later API, worker, communication, and AI components will operate against.

---

## Canonical Event Model

External systems frequently represent similar operational conditions using different terminology.

The platform therefore separates the **source event type** from the **canonical event type**.

Example:

```text
Source System:       ELD_PLATFORM
Source Event Type:   collision_detected
Canonical Event:     SAFETY_INCIDENT
Severity:            CRITICAL
```

Current canonical event categories include:

```text
SAFETY_INCIDENT
SYSTEM_OUTAGE
SECURITY_INCIDENT
FACILITY_EMERGENCY
COMPLIANCE_EVENT
CUSTOMER_IMPACT
```

Current simulated source systems include:

```text
ELD_PLATFORM
TRANSPORTATION_MANAGEMENT_SYSTEM
YARD_MANAGEMENT_SYSTEM
SECURITY_MONITORING
FACILITY_MONITORING
SIMULATED_API
```

This design allows downstream components to operate against a consistent event contract rather than containing source-specific logic throughout the application.

---

## Database-Driven Escalation

Escalation policy is represented as data rather than being hardcoded directly into application workflows.

Example:

```text
SAFETY_INCIDENT + CRITICAL
        │
        ├── VP Operations
        │      ├── Email
        │      └── SMS
        │
        ├── Legal Counsel
        │      └── Email
        │
        └── Executive Leadership
               ├── Email
               └── SMS
```

The database defines the policy.

The application and worker services will execute that policy.

This separates:

```text
Policy
  ↓
PostgreSQL escalation rules

from

Execution
  ↓
Python application services
```

---

## Database Integrity Testing

Database controls have been deliberately tested against both valid and invalid operations.

Validated protections include:

- Severity constraints
- Canonical event-type constraints
- Source-system constraints
- Foreign-key integrity
- Duplicate escalation-rule prevention
- Valid event creation
- Valid notification creation
- Event-to-notification relationships
- Event-to-stakeholder relationships
- Multi-table incident queries

The implementation intentionally validates failure conditions rather than testing only successful operations.

---

# Security Architecture

## Least-Privilege Database Access

A dedicated PostgreSQL application role has been implemented.

The application account can perform the operations required by the application but does not receive database-administration privileges.

Permitted operations include:

- Read events
- Create events
- Update event state
- Read stakeholders
- Read escalation rules
- Read notification records
- Create notification records
- Update notification state

Restricted operations include:

- Modifying escalation policy
- Deleting business records
- Creating database tables
- Dropping database objects
- Altering the schema
- Performing administrative actions

Unauthorized modification of escalation rules has been explicitly tested and rejected.

This provides separation between:

```text
Database Administrator
        │
        └── Schema / Policy Administration

Application Account
        │
        └── Runtime Application Operations
```

---

## Planned Cloud Security Controls

The AWS implementation is designed to include:

- Private RDS networking
- Private application resources
- Restricted security groups
- Controlled ingress through an Application Load Balancer
- IAM roles instead of embedded AWS access keys
- Least-privilege IAM policies
- Environment-based configuration
- Secret exclusion from source control
- Private S3 storage
- Encryption in transit
- Restricted database administration
- Application logging without credential exposure

Security is treated as an architectural requirement rather than a final deployment step.

---

# FastAPI Application Layer

## Current Development Phase

The project is currently entering the FastAPI implementation phase.

The application structure has been established as:

```text
api/
└── app/
    ├── main.py
    ├── routes/
    ├── schemas/
    ├── services/
    ├── database/
    └── core/
```

The application follows a simple separation-of-responsibility model:

> **Routes receive. Schemas validate. Services transform. Database persists and retrieves. Core supports.**

### Routes

Responsible for HTTP interaction.

### Schemas

Responsible for request and response validation.

### Services

Responsible for application and transformation logic.

### Database

Responsible for application interaction with PostgreSQL.

### Core

Responsible for shared configuration, exceptions, logging, and supporting application behavior.

---

# Planned API Functionality

Initial endpoints will include:

```text
POST /events
GET /events
GET /events/{event_id}
GET /health
GET /ready
```

## Event Ingestion

`POST /events` will:

1. Receive an event payload
2. Validate the request
3. Reject malformed input
4. Preserve source information
5. Normalize the event
6. Create the canonical representation
7. Submit the event for asynchronous processing

The API should remain focused on receiving and validating events rather than performing the entire incident workflow synchronously.

---

# Event Normalization

A dedicated normalization service will translate source-specific terminology into the canonical event model.

For example:

```text
ELD_PLATFORM
collision_detected
       │
       ▼
SAFETY_INCIDENT
```

Another system may describe a similar event differently:

```text
collision_detected ─┐
vehicle_accident    ├──► SAFETY_INCIDENT
yard_collision      ┘
```

Downstream processing only needs to understand:

```text
SAFETY_INCIDENT
```

rather than every possible upstream representation.

This reduces coupling between external systems and internal processing.

---

# Asynchronous Processing

Amazon SQS is planned as the durable handoff between the API and worker.

```text
FastAPI
   │
   ▼
Amazon SQS
   │
   ▼
Worker
```

This prevents event ingestion from depending directly on the availability of every downstream component.

If the worker becomes unavailable:

```text
Event Received
      ↓
API Accepts Event
      ↓
SQS Stores Message
      ↓
Worker Unavailable
      ↓
Message Remains Queued
      ↓
Worker Restored
      ↓
Processing Continues
```

Planned reliability controls include:

- Retry handling
- Dead-letter queue
- Duplicate-event detection
- Idempotent processing
- Processing-state tracking
- Structured failure logging

---

# Worker Processing

The worker will execute the primary deterministic incident-processing workflow.

Planned processing sequence:

```text
Receive SQS Message
        ↓
Identify Event
        ↓
Check Idempotency
        ↓
Create / Update Incident State
        ↓
Evaluate Escalation Rules
        ↓
Resolve Stakeholders
        ↓
Create Communication Records
        ↓
Execute Communication
        ↓
Record Delivery Results
        ↓
Update Audit History
```

Separating worker processing from API ingestion allows failure-prone or longer-running operations to occur outside the HTTP request path.

---

# Centralized Communication Workflow

Centralized communication is the primary business capability of the platform.

The system is not intended to create a new independent message every time information changes.

Instead:

```text
Critical Event
      ↓
Central Incident Record
      ↓
Communication Established
      ↓
Initial Incident Information
      ↓
New Operational Information
      ↓
Existing Incident Updated
      ↓
Communication Update
      ↓
Same Incident Context
      ↓
Additional Updates
      ↓
Resolution
```

The objective is for required stakeholders to receive communication from the same coordinated incident workflow rather than independent, disconnected communication paths.

This provides:

- Shared incident context
- Consistent messaging
- Controlled stakeholder participation
- Update continuity
- Communication history
- Incident traceability

---

# Communication & Notification Layer

The communication layer will initially support:

- Email
- SMS

The communication system will track:

- Associated incident/event
- Stakeholder
- Communication channel
- Delivery state
- Provider message identifier
- Failure information
- Creation timestamp
- Delivery timestamp

As the incident evolves, subsequent communications will remain associated with the same incident context.

This allows the system to reconstruct:

```text
Incident Created
      ↓
Initial Communication
      ↓
Update #1
      ↓
Update #2
      ↓
Escalation
      ↓
Resolution Communication
```

rather than storing unrelated notification events.

---

# Reliability Engineering

The platform is being designed around expected failure conditions rather than only the successful path.

Planned validation scenarios include:

- Invalid API payloads
- Unsupported source events
- Duplicate events
- Database connectivity failures
- Worker outages
- SQS retry behavior
- Dead-letter queue behavior
- Notification-provider failures
- Partial delivery failures
- Unauthorized database operations
- Duplicate message delivery
- Application restart scenarios

A key planned reliability demonstration is:

```text
API receives critical event
        ↓
Worker intentionally unavailable
        ↓
Event remains safely queued
        ↓
Worker restored
        ↓
Event processed
        ↓
Communication workflow continues
```

This demonstrates that temporary downstream failure does not automatically result in lost critical-event information.

---

# Observability & Operational Support

Structured logging will be used to make an incident traceable through the system.

Planned logging context includes:

```text
event_id
incident_id
source_system
severity
message_id
processing_status
communication_status
error_type
timestamp
```

The goal is to answer operational questions such as:

- Was the event received?
- Was it normalized successfully?
- Was it placed on the queue?
- Did the worker process it?
- Which escalation rule was selected?
- Which stakeholders were resolved?
- Was communication attempted?
- Did delivery succeed?
- If processing failed, where did it fail?

Health and readiness endpoints will provide additional deployment and operational visibility.

---

# AI-Assisted Incident Coordination

## Planned AI Agent

A later phase will introduce an **AI-assisted incident coordination agent**.

The AI agent is not intended to replace the deterministic critical-event processing system.

The underlying platform will continue to own:

- Event validation
- Event normalization
- Queue processing
- Incident state
- Escalation policy
- Stakeholder resolution
- Communication execution
- Security controls
- Audit history

The AI agent will operate on the trusted incident context created by those components.

Its purpose is to assist with the higher-level coordination problem:

> **What changed, what matters now, who needs to know, and what should the next coordinated update communicate?**

---

## Planned AI Capabilities

The agent is intended to support:

- Incident-context summarization
- Analysis of new incident updates
- Correlation of related operational information
- Identification of missing or conflicting information
- Investigation assistance
- Recommendation of next investigation steps
- Stakeholder-context awareness
- Drafting consistent communication updates
- Escalation recommendations
- Controlled tool use
- Maintenance of decision context across the incident lifecycle

Example:

```text
Initial Critical Event
        ↓
Central Incident State
        ↓
Additional Operational Data
        ↓
AI Incident Agent
        │
        ├── What changed?
        ├── Is information conflicting?
        ├── What information is missing?
        ├── Has severity changed?
        ├── Does escalation need review?
        └── What should stakeholders know?
        │
        ▼
Draft Coordinated Update
        ↓
Guardrails / Human Approval
        ↓
Central Communication Workflow
        ↓
Same Stakeholder Audience / Incident Context
```

---

# AI Guardrails & Human Control

The AI component will operate as an assistive coordination layer rather than an unrestricted autonomous decision-maker.

High-impact actions will remain subject to deterministic policy and/or human approval.

Examples include:

- Changes to incident severity
- Expansion of stakeholder escalation
- Sensitive legal communication
- External communication
- High-impact operational recommendations

The target control model is:

```text
Deterministic Processing
        ↓
Trusted Incident State
        ↓
AI Analysis
        ↓
AI Recommendation / Draft
        ↓
Policy Guardrails
        ↓
Human Approval Where Required
        ↓
Communication Execution
        ↓
Audit Record
```

This allows AI to improve information synthesis and communication consistency without becoming the authoritative source for critical operational decisions.

---

# AWS Infrastructure

The target deployment will use AWS services including:

- Amazon VPC
- Application Load Balancer
- Amazon EC2
- Amazon RDS for PostgreSQL
- Amazon SQS
- SQS Dead-Letter Queue
- Amazon S3
- AWS IAM
- Email / SMS delivery integration

The network design will separate:

```text
Internet
   ↓
Public Load Balancer
   ↓
Private Application Resources
   ↓
Private Database Resources
```

Direct public database exposure is not part of the target architecture.

---

# Infrastructure as Code

AWS infrastructure will be provisioned using **Terraform**.

Planned Terraform resources include:

- VPC
- Public subnets
- Private application subnets
- Database subnets
- Route tables
- Security groups
- Application Load Balancer
- Target groups
- EC2 instances
- IAM roles
- IAM instance profiles
- RDS PostgreSQL
- RDS subnet group
- SQS queue
- Dead-letter queue
- S3 bucket

The deployment lifecycle is intended to be repeatable:

```text
terraform plan
      ↓
terraform apply
      ↓
Deploy Application
      ↓
Validate Infrastructure
      ↓
Run Integration Tests
      ↓
Run Failure Tests
      ↓
Capture Implementation Evidence
      ↓
terraform destroy
```

This provides repeatability while allowing portfolio environments to be removed when they are not actively required.

---

# Key Engineering Decisions

## 1. Centralized Incident Communication

The system is designed around an incident rather than individual alerts.

Subsequent information remains associated with the existing incident and communication workflow.

**Reason:** prevent fragmented critical-event communication and preserve a shared operating picture.

---

## 2. Canonical Event Model

External systems are translated into a common internal event representation.

**Reason:** downstream components should not need to understand every source system's terminology.

---

## 3. Preserve Source Information

The original source event type is retained alongside the normalized event.

**Reason:** normalization should not destroy information required for troubleshooting, auditing, or investigation.

---

## 4. Database-Driven Escalation

Escalation policy is represented in PostgreSQL rather than scattered through application code.

**Reason:** separate business policy from workflow execution.

---

## 5. Asynchronous Processing

The API and worker are separated using SQS.

**Reason:** downstream outages should not automatically cause critical events to be lost.

---

## 6. Dead-Letter Queue

Repeatedly failing messages will be isolated from normal processing.

**Reason:** one problematic event should not indefinitely disrupt the processing pipeline.

---

## 7. Idempotent Processing

The worker will protect against duplicate message processing.

**Reason:** distributed messaging systems may deliver a message more than once.

---

## 8. Least Privilege

Application services receive only the permissions required to perform their responsibilities.

**Reason:** compromise or application defects should not automatically provide administrative access.

---

## 9. Defense in Depth

Validation occurs at multiple layers.

```text
API Validation
      ↓
Application Logic
      ↓
Database Constraints
```

**Reason:** no single validation layer should be the only protection for critical system data.

---

## 10. Infrastructure as Code

AWS resources will be provisioned through Terraform.

**Reason:** infrastructure should be repeatable, reviewable, and reproducible.

---

## 11. AI Above the Deterministic Workflow

The AI agent is separated from authoritative event processing and communication controls.

**Reason:** AI is most valuable for synthesis, investigation, and coordination while deterministic systems remain responsible for critical operational execution.

---

# Technology Stack

## Implemented

- Python
- PostgreSQL
- SQL
- Docker
- Docker Compose
- Git
- GitHub

## In Development

- FastAPI
- Pydantic
- REST APIs
- Automated testing
- Structured application architecture

## Planned Cloud / DevOps

- AWS
- Amazon EC2
- Amazon RDS
- Amazon SQS
- Amazon S3
- AWS IAM
- Application Load Balancer
- Terraform
- Email / SMS integration
- Structured logging

## Planned AI

- AI-assisted incident coordination
- Controlled tool use
- Incident-context retrieval
- Human-in-the-loop approval
- Auditable AI recommendations

---

# Repository Structure

```text
critical-event-management-system/
│
├── api/
│   └── app/
│       ├── main.py
│       ├── routes/
│       ├── schemas/
│       ├── services/
│       ├── database/
│       └── core/
│
├── database/
│   ├── schema.sql
│   ├── seed.sql
│   └── permissions.sql
│
├── worker/
│
├── terraform/
│
├── tests/
│
├── docs/
│   └── screenshots/
│
├── reports/
│
├── scripts/
│
├── docker-compose.yml
├── .env.example
├── .gitignore
└── README.md
```

The repository will continue to evolve as each implementation phase is completed.

---

# Development Roadmap

| Phase | Engineering Focus | Status |
|---|---|---|
| 1 | Repository & Local Development Foundation | ✅ Complete |
| 2 | PostgreSQL Data Model | ✅ Complete |
| 3 | Database Validation & Least-Privilege Security | ✅ Complete |
| 4 | FastAPI Event Ingestion & Normalization | 🚧 In Progress |
| 5 | SQS, DLQ & Worker Processing | ⬜ Planned |
| 6 | Centralized Communication & Escalation | ⬜ Planned |
| 7 | AWS Infrastructure & Terraform | ⬜ Planned |
| 8 | Reliability Testing, Failure Handling & Observability | ⬜ Planned |
| 9 | AI-Assisted Incident Coordination | ⬜ Planned |
| 10 | End-to-End Validation & Portfolio Release | ⬜ Planned |

---

# Current Engineering Focus

The current implementation phase is:

**FastAPI Event Ingestion & Normalization**

The next development work will establish:

```text
POST /events
      ↓
Pydantic Validation
      ↓
Source Event Preservation
      ↓
Normalization
      ↓
Canonical Event Model
      ↓
Queue Publishing Interface
```

This creates the application contract that later SQS, worker, communication, and AI components will consume.

---

# End-State System

At completion, the platform is intended to demonstrate the engineering of an integrated system across:

```text
Enterprise Source Systems
        ↓
REST API
        ↓
Data Validation
        ↓
Event Normalization
        ↓
Asynchronous Messaging
        ↓
Worker Processing
        ↓
Central Incident State
        ↓
PostgreSQL
        ↓
Escalation Policy
        ↓
Stakeholder Resolution
        ↓
Centralized Communication
        ↓
Continuous Incident Updates
        ↓
AI-Assisted Coordination
        ↓
Human / Policy Controls
        ↓
Audit History
        ↓
AWS Infrastructure
        ↓
Terraform
        ↓
Reliability & Failure Testing
        ↓
Operational Observability
```

The individual technologies are not the objective of the project.

They are components of a larger engineering problem:

> **How can critical-event information from multiple operational systems be reliably transformed into one secure, resilient, auditable, and continuously updated communication workflow for the people responsible for managing the incident?**

The project is being implemented incrementally, with each layer validated before additional complexity is introduced.
