# Database Configuration for FastAPI Backend
# 
# This file configures the database connection for the Friends API.
# Primary database: PostgreSQL (configured via DATABASE_URL environment variable)
# Backup/Development fallback: SQLite (for offline development or testing only)

import os
from dotenv import load_dotenv
from sqlalchemy import create_engine
from sqlalchemy.orm import declarative_base
from sqlalchemy.orm import sessionmaker

load_dotenv()  # Load variables from .env file

# Primary: PostgreSQL connection (production/development)
# Backup: SQLite fallback (for offline development/testing only)
DATABASE_URL = os.getenv("DATABASE_URL", "sqlite:///./friends_db_backup.db")  # SQLite backup with consistent naming

# SQLite-specific configuration (backup database only)
# Note: SQLite requires check_same_thread=False for FastAPI compatibility
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
