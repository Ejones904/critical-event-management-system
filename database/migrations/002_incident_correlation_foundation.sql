-- CEMS v1 incident correlation foundation
-- Establishes incident_id as the shared correlation key
-- across events, notifications, messages, and AI activity.

CREATE TABLE IF NOT EXISTS incidents (
    incident_id BIGSERIAL PRIMARY KEY,

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

    status VARCHAR(20) NOT NULL DEFAULT 'OPEN'
        CHECK (status IN ('OPEN', 'PROCESSING', 'RESOLVED', 'CLOSED')),

    opened_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    closed_at TIMESTAMPTZ
);


-- ============================================================
-- EVENTS
-- Preserve source-event detail while associating it
-- with the CEMS-managed incident.
-- ============================================================

ALTER TABLE events
ADD COLUMN IF NOT EXISTS incident_id BIGINT;

ALTER TABLE events
ADD COLUMN IF NOT EXISTS source_event_time TIMESTAMPTZ;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'events_incident_id_fkey'
    ) THEN
        ALTER TABLE events
        ADD CONSTRAINT events_incident_id_fkey
        FOREIGN KEY (incident_id)
        REFERENCES incidents(incident_id);
    END IF;
END
$$;


-- ============================================================
-- NOTIFICATIONS
-- Preserve both incident-level and event-level traceability.
-- ============================================================

ALTER TABLE notifications
ADD COLUMN IF NOT EXISTS incident_id BIGINT;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'notifications_incident_id_fkey'
    ) THEN
        ALTER TABLE notifications
        ADD CONSTRAINT notifications_incident_id_fkey
        FOREIGN KEY (incident_id)
        REFERENCES incidents(incident_id);
    END IF;
END
$$;


-- ============================================================
-- INCIDENT MESSAGES
-- All inbound, outbound, and system communication
-- can be correlated to the same managed incident.
-- ============================================================

ALTER TABLE incident_messages
ADD COLUMN IF NOT EXISTS incident_id BIGINT;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'incident_messages_incident_id_fkey'
    ) THEN
        ALTER TABLE incident_messages
        ADD CONSTRAINT incident_messages_incident_id_fkey
        FOREIGN KEY (incident_id)
        REFERENCES incidents(incident_id);
    END IF;
END
$$;


-- ============================================================
-- AGENT ACTIVITY
-- AI investigations, tool calls, actions, recommendations,
-- and escalations are tied to the incident lifecycle.
-- ============================================================

ALTER TABLE agent_activity
ADD COLUMN IF NOT EXISTS incident_id BIGINT;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'agent_activity_incident_id_fkey'
    ) THEN
        ALTER TABLE agent_activity
        ADD CONSTRAINT agent_activity_incident_id_fkey
        FOREIGN KEY (incident_id)
        REFERENCES incidents(incident_id);
    END IF;
END
$$;


-- ============================================================
-- INDEXES
-- Support incident lookup, timeline queries,
-- and future correlation logic.
-- ============================================================

CREATE INDEX IF NOT EXISTS idx_events_incident_id
ON events(incident_id);

CREATE INDEX IF NOT EXISTS idx_events_source_event_time
ON events(source_event_time);

CREATE INDEX IF NOT EXISTS idx_notifications_incident_id
ON notifications(incident_id);

CREATE INDEX IF NOT EXISTS idx_incident_messages_incident_id
ON incident_messages(incident_id);

CREATE INDEX IF NOT EXISTS idx_agent_activity_incident_id
ON agent_activity(incident_id);

CREATE INDEX IF NOT EXISTS idx_incidents_status_event_type
ON incidents(status, event_type);


-- ============================================================
-- LEAST-PRIVILEGE APPLICATION ACCESS
-- ============================================================

GRANT SELECT, INSERT, UPDATE
ON incidents
TO critical_event_app;

GRANT USAGE, SELECT
ON SEQUENCE incidents_incident_id_seq
TO critical_event_app;
