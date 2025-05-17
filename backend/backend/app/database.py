import os
from dotenv import load_dotenv

load_dotenv()  # Load variables from .env file
DATABASE_URL = os.getenv("DATABASE_URL", "sqlite:///./friends.db")  # Fallback to SQLite if not found
