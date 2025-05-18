#Entry point for the FastAPI application

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from . import models
from .database import engine
from .routers import friends

# Create tables
# Table Creation: Automatically creates database tables
models.Base.metadata.create_all(bind=engine)

# FastAPI App: Creates the main application
app = FastAPI(title="Friends API")

# Add CORS middleware
# CORS Middleware: Allows requests from your iOS app
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, limit this to your app's domain
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
# Router Registration: Includes the friends router
app.include_router(friends.router)


# Root Endpoint: Adds a simple welcome message
# This is the main entry point for the API
@app.get("/")
def read_root():
    return {"message": "Welcome to the Friends API"}

# This ties all components together into a working API.