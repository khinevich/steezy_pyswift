# This file is used to set environment variables for the backend application.
# It loads the database URL from a .env file or defaults to SQLite if not found.
# It is used to configure the database connection for the application.

import os
from dotenv import load_dotenv
from sqlalchemy import create_engine
from sqlalchemy.orm import declarative_base
from sqlalchemy.orm import sessionmaker

load_dotenv()  # Load variables from .env file
DATABASE_URL = os.getenv("DATABASE_URL", "sqlite:///./friends.db")  # Fallback to SQLite if not found

# For SQLite, connect_args is needed for multithreading
connect_args = {"check_same_thread": False} if DATABASE_URL.startswith("sqlite") else {}

# Create database engine
engine = create_engine(DATABASE_URL, connect_args=connect_args)

# Create database session factory
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Create base class for ORM models
Base = declarative_base()

# Dependency for FastAPI to manage database sessions
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
