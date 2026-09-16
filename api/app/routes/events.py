from fastapi import APIRouter, HTTPException

from api.app.schemas.events import EventCreate
from api.app.services.normalization import (
    normalize_event_type,
    normalize_severity,
)

router = APIRouter()


@router.post("/events")
def create_event(event: EventCreate):
    try:
        normalized_event_type = normalize_event_type(event)
        normalized_severity = normalize_severity(event)
    except ValueError as exc:
        raise HTTPException(status_code=422, detail=str(exc))
    return {
        "source_event_id": event.source_event_id,
        "source_system": event.source_system,
        "source_event_type": event.source_event_type,
        "normalized_event_type": normalized_event_type,
        "source_event_time": event.source_event_time,
        "source_severity": event.severity,
        "normalized_severity": normalized_severity,
        "location": event.location,
        "description": event.description,
    }
