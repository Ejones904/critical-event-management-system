-- ============================================================
-- Critical Event Management System
-- Application Database Permissions
-- ============================================================

-- Create a dedicated application role.
-- Password is assigned separately and is NOT stored in Git.
CREATE ROLE critical_event_app
    WITH LOGIN;

-- Allow the application role to connect to the database.
GRANT CONNECT ON DATABASE critical_events
    TO critical_event_app;

-- Allow access to objects within the public schema.
GRANT USAGE ON SCHEMA public
    TO critical_event_app;

-- Application table permissions.
GRANT SELECT, INSERT, UPDATE
    ON events
    TO critical_event_app;

GRANT SELECT
    ON stakeholders
    TO critical_event_app;

GRANT SELECT
    ON escalation_rules
    TO critical_event_app;

GRANT SELECT, INSERT, UPDATE
    ON notifications
    TO critical_event_app;

-- Allow PostgreSQL-generated IDs to function when the
-- application inserts events and notifications.
GRANT USAGE, SELECT
    ON SEQUENCE events_event_id_seq
    TO critical_event_app;

GRANT USAGE, SELECT
    ON SEQUENCE notifications_notification_id_seq
    TO critical_event_app;
