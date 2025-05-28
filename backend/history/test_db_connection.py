#!/usr/bin/env python3

import sys
from pathlib import Path

# Add the app directory to the path
sys.path.append(str(Path(__file__).parent / "app"))

print("=== Testing Database Connection ===")

try:
    from database import engine, DATABASE_URL, Base
    print(f"DATABASE_URL: {DATABASE_URL}")
    
    # Test the connection
    from sqlalchemy import text
    with engine.connect() as connection:
        result = connection.execute(text("SELECT version();"))
        version = result.fetchone()
        print(f"Successfully connected to PostgreSQL!")
        print(f"PostgreSQL version: {version[0]}")
        
    # Test if our tables exist
    from sqlalchemy import inspect
    inspector = inspect(engine)
    tables = inspector.get_table_names()
    print(f"Existing tables: {tables}")
    
    # Import models to register them with Base
    import models  # This will register the Friend model
    print(f"Creating tables...")
    Base.metadata.create_all(bind=engine)
    
    # Check tables again
    inspector = inspect(engine)
    tables = inspector.get_table_names()
    print(f"Tables after creation: {tables}")
    
except Exception as e:
    print(f"Database connection failed: {e}")
    import traceback
    traceback.print_exc()
