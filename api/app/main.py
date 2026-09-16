from fastapi import FastAPI

from api.app.routes.events import router as events_router

app = FastAPI(title="Critical Event Management System")

app.include_router(events_router)


@app.get("/health")
def health_check():
    return {"status": "healthy"}
