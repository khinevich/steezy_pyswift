#Script to start the server

# Uses uvicorn to run the FastAPI application
import uvicorn

# Enables hot reloading for development
# Sets host and port

if __name__ == "__main__":
    uvicorn.run("app.main:app", host="0.0.0.0", port=8000, reload=True)