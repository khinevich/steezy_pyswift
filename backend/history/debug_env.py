#!/usr/bin/env python3

import os
import sys
from pathlib import Path

# Add the app directory to the path so we can import from it
sys.path.append(str(Path(__file__).parent / "app"))

print("=== Environment Variable Debug ===")
print(f"Current working directory: {os.getcwd()}")
print(f"Script location: {Path(__file__).parent}")

# Check system environment first
print(f"System DATABASE_URL: {os.environ.get('DATABASE_URL', 'NOT_SET')}")

# Now test dotenv loading
from dotenv import load_dotenv

# Try loading from current directory
print(f"\n=== Loading .env from current directory ===")
load_dotenv()
print(f"After load_dotenv(): {os.getenv('DATABASE_URL', 'NOT_SET')}")

# Try loading from explicit path
print(f"\n=== Loading .env from explicit path ===")
env_path = Path(__file__).parent / ".env"
print(f"Looking for .env at: {env_path}")
print(f".env exists: {env_path.exists()}")

if env_path.exists():
    load_dotenv(env_path)
    print(f"After explicit load_dotenv(): {os.getenv('DATABASE_URL', 'NOT_SET')}")
    
    # Read the file content directly
    print(f"\n=== .env file contents ===")
    with open(env_path, 'r') as f:
        print(f.read())

# Now import the database module to see what it gets
print(f"\n=== Testing database.py import ===")
try:
    from database import DATABASE_URL
    print(f"DATABASE_URL from database.py: {DATABASE_URL}")
except ImportError as e:
    print(f"Failed to import database.py: {e}")
