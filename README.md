# Critical Event Management System

**A cloud-based system for turning operational alerts into coordinated incident responses.**

Fleet and facility teams receive alerts from multiple systems: ELD platforms, transportation and yard management systems, and security or facility monitoring tools. When those alerts arrive separately, responders have to determine what happened, whether events are related, who needs to act, and where the response was documented.

The Critical Event Management System (CEMS) brings that process into one workflow. It is designed to accept events through an API, maintain a consistent record in PostgreSQL, process incidents, notify stakeholders, and preserve an auditable response timeline.

> **Development status:** The database foundation and initial API structure are in place. Queue processing, notifications, AWS deployment, and AI-assisted operations have not yet been completed.

## What the system does

CEMS is designed to:

- Receive events from fleet, yard, transportation, security, and facility systems.
- Validate and normalize events into a consistent format.
- Store accepted events in PostgreSQL.
- Identify related events and apply defined routing and escalation rules.
- Notify the appropriate stakeholders and record their responses.
- Give operators a single timeline for investigating an incident.

The database and API foundations are in place. Incident processing and notification are the next implementation phases.

## System architecture

```text
Operational systems
       |
       v
FastAPI ingestion and validation
       |
       v
PostgreSQL system of record
       |
       v
Amazon SQS + dead-letter queue
       |
       v
Incident worker
       |
       v
Routing and escalation rules
       |
       v
Amazon SNS -> stakeholders
       |
       v
Responses and updates -> incident timeline
```

PostgreSQL is the system of record. SQS will separate incoming API requests from incident processing, allowing a worker to handle correlation, routing, escalation, and notification independently. A dead-letter queue will retain messages that cannot be processed successfully for investigation.

A later phase will add a limited AI operations layer for retrieving incident context, recording investigation notes, checking system health, and performing a controlled worker restart. Routing and escalation decisions will remain rule based.

## Implemented components

| Component | Current capability |
| --- | --- |
| PostgreSQL | Tables for events, stakeholders, notifications, and escalation rules |
| Data validation | Constraints and foreign keys, including checks that reject invalid values and relationships |
| Local environment | PostgreSQL running with Docker Compose |
| FastAPI | Application structure, event routes, request schemas, and normalization logic |
| Repository workflow | `main`, `develop`, feature and bugfix branches, GitHub Issues, and pull requests |
| Repository security | `.gitignore` cleanup to prevent local and sensitive files from being committed |

The database defines events from `ELD_PLATFORM`, `TRANSPORTATION_MANAGEMENT_SYSTEM`, `YARD_MANAGEMENT_SYSTEM`, `SECURITY_MONITORING`, and `FACILITY_MONITORING`. These are supported source values in the data model. Live integrations with those platforms have not yet been built.

## Implementation roadmap

1. Connect the API to PostgreSQL and verify event persistence.
2. Add an SQS queue, dead-letter queue, and incident worker.
3. Implement event correlation, stakeholder routing, and escalation rules.
4. Send notifications through SNS and record responses in the incident timeline.
5. Deploy the system on AWS with Terraform and add CloudWatch monitoring.
6. Test failures, retries, recovery, and the complete event-to-notification workflow.
7. Add audited, limited AI operations tools.

## Technology

**In the current implementation:** Python, FastAPI, PostgreSQL, Docker Compose, SQL, Git, GitHub Issues, and pull requests.

**Planned for deployment:** Amazon SQS, Amazon SNS, Amazon EC2, AWS IAM, Amazon CloudWatch, Terraform, and Jenkins.

## Architectural decisions

- **PostgreSQL is the system of record.** Events and response activity need a consistent place to be queried and audited.
- **Incident processing is separate from ingestion.** A queue and worker will handle downstream work without making an API caller wait for notification and escalation.
- **Routing follows explicit rules.** Operators should be able to see why a stakeholder was notified or an incident was escalated.
- **Processing failures remain visible.** Retries, a dead-letter queue, logs, and health checks are part of the target workflow.
- **AI has limited authority.** The planned AI layer will assist investigation and a small set of audited operational actions.

## Development approach and AI use

I defined the operational requirements and made the architectural decisions for CEMS, including its system boundaries, data flow, technology choices, and limits on automation. ChatGPT generated code during development. I reviewed the code and checked the behavior of implemented components.

The system documentation distinguishes working components from planned capabilities. Generated code is not presented as a completed feature until it has been integrated and verified.

## Operational background

My experience supporting fleet technology systems exposed me to hardware connectivity issues, missing operational data, and exceptions that could affect both daily operations and compliance. CEMS applies that experience to a system-level problem: receiving signals from different sources, coordinating the right response, and keeping a reliable record of what happened.