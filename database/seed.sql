-- ============================================================
-- Critical Event Management System
-- Seed Data
-- ============================================================

-- ============================================================
-- STAKEHOLDERS
-- Synthetic contacts used for local development and testing.
-- ============================================================

INSERT INTO stakeholders (
    name,
    role,
    email,
    phone,
    email_enabled,
    sms_enabled,
    active
)
VALUES
(
    'Jordan Mitchell',
    'VP Operations',
    'vp.operations@example.com',
    '+15555550101',
    TRUE,
    TRUE,
    TRUE
),
(
    'Taylor Brooks',
    'Legal Counsel',
    'legal.counsel@example.com',
    '+15555550102',
    TRUE,
    FALSE,
    TRUE
),
(
    'Morgan Reed',
    'Executive Leadership',
    'executive.leadership@example.com',
    '+15555550103',
    TRUE,
    TRUE,
    TRUE
),
(
    'Casey Parker',
    'Operations Leadership',
    'operations.leadership@example.com',
    '+15555550104',
    TRUE,
    FALSE,
    TRUE
);

-- ============================================================
-- ESCALATION RULES
-- Defines which stakeholder roles receive notifications for
-- standardized event/severity combinations.
-- ============================================================

INSERT INTO escalation_rules (
    event_type,
    severity,
    stakeholder_role,
    email_required,
    sms_required,
    active
)
VALUES
(
    'SAFETY_INCIDENT',
    'CRITICAL',
    'VP Operations',
    TRUE,
    TRUE,
    TRUE
),
(
    'SAFETY_INCIDENT',
    'CRITICAL',
    'Legal Counsel',
    TRUE,
    FALSE,
    TRUE
),
(
    'SAFETY_INCIDENT',
    'CRITICAL',
    'Executive Leadership',
    TRUE,
    TRUE,
    TRUE
),
(
    'SECURITY_INCIDENT',
    'CRITICAL',
    'Executive Leadership',
    TRUE,
    TRUE,
    TRUE
),
(
    'SECURITY_INCIDENT',
    'CRITICAL',
    'Legal Counsel',
    TRUE,
    FALSE,
    TRUE
),
(
    'SYSTEM_OUTAGE',
    'HIGH',
    'Operations Leadership',
    TRUE,
    FALSE,
    TRUE
),
(
    'FACILITY_EMERGENCY',
    'CRITICAL',
    'VP Operations',
    TRUE,
    TRUE,
    TRUE
);
