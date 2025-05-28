# FastAPI Backend Development Scripts

This directory contains utility scripts to manage your FastAPI backend development environment.

## 🚀 Quick Start

To start everything from scratch:

```bash
./startup.sh
```

This script will:
- ✅ Check if Docker is running
- ✅ Activate virtual environment
- ✅ Install Python dependencies
- ✅ Load environment variables
- ✅ Start PostgreSQL container
- ✅ Create database if it doesn't exist
- ✅ Test database connection
- ✅ Create/update database tables
- ✅ Run tests to verify everything works
- ✅ Start FastAPI server on http://localhost:8000

## 🛑 Shutdown

To stop all services cleanly:

```bash
./shutdown.sh
```

## 🗄️ Database Management

To reset/manage the database:

```bash
./reset_db.sh
```

Options available:
1. **Clear all data** - Remove all records but keep table structure
2. **Drop and recreate tables** - Reset table structure and data
3. **Delete entire database** - Complete database reset
4. **Delete Docker volume** - Nuclear option, fresh start
5. **Cancel** - Exit without changes

## 📋 Manual Commands

If you prefer to run commands manually:

### Start PostgreSQL only:
```bash
docker-compose up -d postgres
```

### Start FastAPI server only:
```bash
source venv/bin/activate
python -m uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

### Run tests:
```bash
source venv/bin/activate
python -m pytest tests/ -v
```

### Check database:
```bash
docker exec -it ios_app_postgres psql -U admin -d friends_db
```

## 🌐 API Endpoints

Once running, you can access:
- **API Root**: http://localhost:8000/
- **Interactive Docs**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc
- **Friends API**: http://localhost:8000/friends/

## 🔧 Configuration

### Environment Variables (.env)
```
DATABASE_URL=postgresql://admin:admin@localhost:5432/friends_db
```

### PostgreSQL Connection
- **Host**: localhost
- **Port**: 5432
- **User**: admin
- **Password**: admin
- **Database**: friends_db

## 📝 Notes

- Data persists between container restarts due to Docker volumes
- The virtual environment must exist before running scripts
- PostgreSQL data is stored in Docker volume `backend_postgres_data`
- All scripts include error handling and colored output for clarity
