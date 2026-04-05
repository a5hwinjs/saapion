from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from database import supabase
from recommendation import generate_weekly_plan

app = FastAPI(title="Saapion API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
def read_root():
    return {"message": "Welcome to Saapion API"}

@app.get("/health")
def health_check():
    db_status = "connected" if supabase else "disconnected (check .env credentials)"
    return {"status": "ok", "database": db_status}

@app.get("/api/get-plan/{user_id}")
def api_get_plan(user_id: str):
    from recommendation import get_active_plan
    plan = get_active_plan(user_id)
    return plan

@app.post("/api/generate-plan/{user_id}")
def api_generate_plan(user_id: str):
    plan = generate_weekly_plan(user_id)
    return plan
