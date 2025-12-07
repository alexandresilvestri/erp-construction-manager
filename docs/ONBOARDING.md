# 🚀 Onboarding - Environment Setup

> **For New Developers:** This guide will help you set up the environment in minutes!

## ⚡ Quick Setup (Recommended)

### Option 1: Automated Script (Linux/Mac)

```bash
# 1. Clone the repository
git clone <repository-url>
cd <project-name>

# 2. Run the setup script
./setup.sh

# 3. Done! 🎉
```

## 📋 Prerequisites

You need to have installed:

- ✅ [Docker Desktop](https://www.docker.com/products/docker-desktop/) (version 20.10+)
- ✅ [Docker Compose](https://docs.docker.com/compose/install/) (version 2.0+)
- ✅ [Git](https://git-scm.com/)

**Optional (but recommended):**
- 🔧 [Make](https://www.gnu.org/software/make/) - to use simplified commands
- 🎨 [VS Code](https://code.visualstudio.com/) - recommended editor

## 🎯 Important URLs

After setup, access:

| Service | URL | Description |
|---------|-----|-----------|
| **Frontend** | http://localhost:5173 | Application interface |
| **Backend** | http://localhost:3000 | REST API |
| **PostgreSQL** | localhost:5432 | Database |

## 🔧 Essential Commands

### With Make (Simplified)

```bash
# View all available commands
make help

# Start environment
make dev

# View logs
make logs

# Stop environment
make down

# Create migration
make migrate-make name=create_users

# Execute migrations
make migrate-latest
```

### With Docker Compose (Direct)

```bash
# Start
docker-compose up -d

# View logs
docker-compose logs -f

# Stop
docker-compose down

# Restart
docker-compose restart

# View status
docker-compose ps
```

## 📁 Project Structure

```
project/
├── backend/           # Node.js + TypeScript API
├── frontend/          # React + Vite + Tailwind
├── .env              # Your settings (DO NOT commit!)
├── .env.example      # Configuration template
└── docker-compose.yml # Container orchestration
```

## ⚙️ Custom Settings

### Port Conflicts?

If any port is already in use, edit the `.env` file:

```env
# Change to available ports
BACKEND_PORT=3001
FRONTEND_PORT=5174
DB_PORT=5433
```

Then restart:
```bash
docker-compose down
docker-compose up -d
```

### Database Credentials

**In development (default - OK to use):**
```env
DB_USER=postgres
DB_PASSWORD=postgres
```

**In production (ALWAYS change):**
```env
DB_USER=app_user
DB_PASSWORD=S3nh@Mu1t0F0rt3!
```

## 🐛 Troubleshooting

### Problem: "Port already in use"

```bash
# Check what's using the port
lsof -i :3000  # Linux/Mac
netstat -ano | findstr :3000  # Windows

# Change the port in .env or kill the process
```

### Problem: "Cannot connect to database"

```bash
# Check if PostgreSQL is running
docker-compose ps

# View database logs
docker-compose logs postgres

# Restart database
docker-compose restart postgres
```

### Problem: Containers don't start

```bash
# Clean everything and restart
docker-compose down -v
docker-compose up -d --build
```

### Problem: Modules not found

```bash
# Reinstall dependencies
make install-backend
make install-frontend

# or
docker-compose exec backend npm install
docker-compose exec frontend npm install
```

### How do I add a new dependency?

```bash
# Backend
docker-compose exec backend npm install package-name

# Frontend
docker-compose exec frontend npm install package-name
```