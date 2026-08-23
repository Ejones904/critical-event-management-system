-- ============================================================
-- Critical Event Management System
-- Database Schema
-- ============================================================

-- ============================================================
-- EVENTS
-- Stores business-critical events received by the platform.
-- ============================================================

CREATE TABLE events (
    event_id BIGSERIAL PRIMARY KEY,

    event_type VARCHAR(50) NOT NULL
        CHECK (event_type IN (
            'SAFETY_INCIDENT',
            'SYSTEM_OUTAGE',
            'SECURITY_INCIDENT',
            'FACILITY_EMERGENCY',
            'COMPLIANCE_EVENT',
            'CUSTOMER_IMPACT'
        )),

    source_event_type VARCHAR(100),

    severity VARCHAR(20) NOT NULL
        CHECK (severity IN ('LOW', 'MEDIUM', 'HIGH', 'CRITICAL')),

    location VARCHAR(100) NOT NULL,

    description TEXT NOT NULL,

    status VARCHAR(20) NOT NULL DEFAULT 'OPEN'
        CHECK (status IN ('OPEN', 'PROCESSING', 'RESOLVED', 'CLOSED')),

    source_system VARCHAR(100) NOT NULL
        CHECK (source_system IN (
            'SIMULATED_API',
            'ELD_PLATFORM',
            'TRANSPORTATION_MANAGEMENT_SYSTEM',
            'YARD_MANAGEMENT_SYSTEM',
            'SECURITY_MONITORING',
            'FACILITY_MONITORING'
        )),

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    resolved_at TIMESTAMPTZ
);
-- ============================================================
-- STAKEHOLDERS
-- Stores leadership and operational contacts who may receive
-- critical event notifications.
-- ============================================================

CREATE TABLE stakeholders (
    stakeholder_id BIGSERIAL PRIMARY KEY,

    name VARCHAR(100) NOT NULL,

    role VARCHAR(100) NOT NULL,

    email VARCHAR(150) UNIQUE NOT NULL,

    phone VARCHAR(20),

    email_enabled BOOLEAN NOT NULL DEFAULT TRUE,

    sms_enabled BOOLEAN NOT NULL DEFAULT FALSE,

    active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);
-- ============================================================
-- ESCALATION RULES
-- Maps event type and severity combinations to stakeholder roles.
-- ============================================================

CREATE TABLE escalation_rules (
    rule_id BIGSERIAL PRIMARY KEY,

    event_type VARCHAR(50) NOT NULL
    CHECK (event_type IN (
        'SAFETY_INCIDENT',
        'SYSTEM_OUTAGE',
        'SECURITY_INCIDENT',
        'FACILITY_EMERGENCY',
        'COMPLIANCE_EVENT',
        'CUSTOMER_IMPACT'
    )),

    severity VARCHAR(20) NOT NULL
        CHECK (severity IN ('LOW', 'MEDIUM', 'HIGH', 'CRITICAL')),

    stakeholder_role VARCHAR(100) NOT NULL,

    email_required BOOLEAN NOT NULL DEFAULT TRUE,

    sms_required BOOLEAN NOT NULL DEFAULT FALSE,

    active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    UNIQUE (event_type, severity, stakeholder_role)
);
-- ============================================================
-- NOTIFICATIONS
-- Records each notification attempt for an event and stakeholder.
-- Provides an auditable history of escalation activity.
-- ============================================================

CREATE TABLE notifications (
    notification_id BIGSERIAL PRIMARY KEY,

    event_id BIGINT NOT NULL,

    stakeholder_id BIGINT NOT NULL,

    channel VARCHAR(20) NOT NULL
        CHECK (channel IN ('EMAIL', 'SMS')),

    status VARCHAR(20) NOT NULL DEFAULT 'PENDING'
        CHECK (status IN ('PENDING', 'SENT', 'FAILED')),

    provider_message_id VARCHAR(255),

    error_message TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    sent_at TIMESTAMPTZ,

    CONSTRAINT fk_notification_event
        FOREIGN KEY (event_id)
        REFERENCES events(event_id),

    CONSTRAINT fk_notification_stakeholder
        FOREIGN KEY (stakeholder_id)
        REFERENCES stakeholders(stakeholder_id)
);
