-- Migration 003
-- Preserve the source-provided severity while allowing
-- INFORMATIONAL as a normalized CEMS event severity.

-- Preserve the original severity received from the source system.
ALTER TABLE events
ADD COLUMN source_severity VARCHAR(50);

-- Replace the existing severity constraint so normalized
-- INFORMATIONAL events can be stored.
ALTER TABLE events
DROP CONSTRAINT events_severity_check;

ALTER TABLE events
ADD CONSTRAINT events_severity_check
CHECK (
    severity IN (
        'INFORMATIONAL',
        'LOW',
        'MEDIUM',
        'HIGH',
        'CRITICAL'
    )
);
