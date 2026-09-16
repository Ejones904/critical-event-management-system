from api.app.schemas.events import EventCreate


EVENT_TYPE_MAP = {
    "HARD_BRAKE_COLLISION": "SAFETY_INCIDENT",
    "VEHICLE_COLLISION": "SAFETY_INCIDENT",
    "FORCED_DOOR_ENTRY": "SECURITY_INCIDENT",
    "UNAUTHORIZED_ACCESS": "SECURITY_INCIDENT",
    "TEMPERATURE_THRESHOLD_EXCEEDED": "FACILITY_EMERGENCY",
    "APPLICATION_DOWN": "SYSTEM_OUTAGE",
    "REGULATORY_VIOLATION": "COMPLIANCE_EVENT",
    "SERVICE_DISRUPTION": "CUSTOMER_IMPACT",
}


SEVERITY_MAP = {
    "P1": "INFORMATIONAL",
    "SEV1": "INFORMATIONAL",
    "P2": "LOW",
    "SEV2": "LOW",
    "P3": "MEDIUM",
    "SEV3": "MEDIUM",
    "P4": "HIGH",
    "SEV4": "HIGH",
    "INFORMATIONAL": "INFORMATIONAL",
    "LOW": "LOW",
    "MEDIUM": "MEDIUM",
    "HIGH": "HIGH",
    "CRITICAL": "CRITICAL",
    "EMERGENCY": "CRITICAL",
}


def normalize_event_type(event: EventCreate) -> str:
    if event.source_event_type not in EVENT_TYPE_MAP:
        raise ValueError(
            f"Unsupported source event type: {event.source_event_type}"
        )

    return EVENT_TYPE_MAP[event.source_event_type]


def normalize_severity(event: EventCreate) -> str:
    source_severity = event.severity.strip().upper()

    if source_severity not in SEVERITY_MAP:
        raise ValueError(
            f"Unsupported source severity: {event.severity}"
        )

    return SEVERITY_MAP[source_severity]
    return EVENT_TYPE_MAP[event.source_event_type]
