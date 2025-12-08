
## Automated Script (Linux)

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

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (version 20.10+)
- [Docker Compose](https://docs.docker.com/compose/install/) (version 2.0+)
- [Git](https://git-scm.com/)

**Optional (but recommended):**
- [Make](https://www.gnu.org/software/make/) - to use simplified commands
- [VS Code](https://code.visualstudio.com/) - recommended editor

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
