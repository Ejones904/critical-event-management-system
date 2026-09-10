-- CEMS v1 additive extensions
-- Supports event deduplication, unified incident communication,
-- and AI activity auditing without redesigning existing tables.

ALTER TABLE events
ADD COLUMN IF NOT EXISTS source_event_id VARCHAR(100);

CREATE UNIQUE INDEX IF NOT EXISTS idx_events_source_system_event
ON events (source_system, source_event_id)
WHERE source_event_id IS NOT NULL;


CREATE TABLE IF NOT EXISTS incident_messages (
    message_id BIGSERIAL PRIMARY KEY,

    event_id BIGINT NOT NULL
        REFERENCES events(event_id),

    direction VARCHAR(10) NOT NULL
        CHECK (direction IN ('INBOUND', 'OUTBOUND', 'SYSTEM')),

    channel VARCHAR(20) NOT NULL
        CHECK (channel IN ('EMAIL', 'SMS', 'INTERNAL')),

    sender VARCHAR(150),

    recipient VARCHAR(150),

    message_body TEXT NOT NULL,

    correlation_token VARCHAR(64),

    provider_message_id VARCHAR(255),

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_incident_messages_event_created
ON incident_messages(event_id, created_at);


CREATE TABLE IF NOT EXISTS agent_activity (
    activity_id BIGSERIAL PRIMARY KEY,

    event_id BIGINT
        REFERENCES events(event_id),

    activity_type VARCHAR(30) NOT NULL
        CHECK (
            activity_type IN (
                'INVESTIGATION',
                'TOOL_CALL',
                'ACTION',
                'RECOMMENDATION',
                'ESCALATION'
            )
        ),

    tool_name VARCHAR(100),

    input_summary TEXT,

    result_summary TEXT,

    approved BOOLEAN,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_agent_activity_event_created
ON agent_activity(event_id, created_at);


GRANT SELECT, INSERT, UPDATE
ON incident_messages
TO critical_event_app;

GRANT SELECT, INSERT
ON agent_activity
TO critical_event_app;

GRANT USAGE, SELECT
ON SEQUENCE incident_messages_message_id_seq
TO critical_event_app;

GRANT USAGE, SELECT
ON SEQUENCE agent_activity_activity_id_seq
TO critical_event_app;
