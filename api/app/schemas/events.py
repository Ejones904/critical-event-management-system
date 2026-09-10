from enum import Enum

from pydantic import BaseModel, Field


class Severity(str, Enum):
    LOW = "LOW"
    MEDIUM = "MEDIUM"
    HIGH = "HIGH"
    CRITICAL = "CRITICAL"


class SourceSystem(str, Enum):
    ELD_PLATFORM = "ELD_PLATFORM"
    TRANSPORTATION_MANAGEMENT_SYSTEM = "TRANSPORTATION_MANAGEMENT_SYSTEM"
    YARD_MANAGEMENT_SYSTEM = "YARD_MANAGEMENT_SYSTEM"
    SECURITY_MONITORING = "SECURITY_MONITORING"
    FACILITY_MONITORING = "FACILITY_MONITORING"


class EventCreate(BaseModel):
    source_event_id: str = Field(min_length=1, max_length=100)
    source_system: SourceSystem
    source_event_type: str = Field(min_length=1, max_length=100)
    severity: Severity
    location: str = Field(min_length=1, max_length=100)
    description: str = Field(min_length=1)
