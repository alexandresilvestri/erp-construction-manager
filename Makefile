# =============================================================================
# Construction Manager - Makefile
# =============================================================================
# This file contains shortcuts for common development tasks
# Usage: make <target>
# Example: make dev
# =============================================================================

# .PHONY tells make these aren't actual files, just command names
.PHONY: help dev up down restart logs ps clean install test lint format

# Default target - runs when you just type 'make'
.DEFAULT_GOAL := help

help:
	@echo "📦 Setup & Installation:"
	@echo "  make install           Install all dependencies"
	@echo "  make install-backend   Install backend dependencies"
	@echo "  make install-frontend  Install frontend dependencies"
	@echo ""
	@echo "🚀 Development:"
	@echo "  make dev              Start all services"
	@echo "  make up               Start all services (alias)"
	@echo "  make down             Stop all services"
	@echo "  make restart          Restart all services"
	@echo "  make build            Rebuild all containers"
	@echo ""
	@echo "📊 Monitoring:"
	@echo "  make logs             View logs from all services"
	@echo "  make logs-backend     View backend logs"
	@echo "  make logs-frontend    View frontend logs"
	@echo "  make logs-db          View database logs"
	@echo "  make ps               Show running containers"
	@echo ""
	@echo "🧪 Testing:"
	@echo "  make test             Run all tests"
	@echo "  make test-backend     Run backend tests"
	@echo "  make test-watch       Run tests in watch mode"
	@echo "  make test-coverage    Run tests with coverage"
	@echo ""
	@echo "🎨 Code Quality:"
	@echo "  make lint             Run ESLint on all code"
	@echo "  make lint-fix         Run ESLint and auto-fix issues"
	@echo "  make format           Format code with Prettier"
	@echo "  make format-check     Check code formatting"
	@echo "  make pre-commit       Run all checks before commit"
	@echo ""
	@echo "🗄️  Database:"
	@echo "  make db-shell         Open PostgreSQL shell"
	@echo "  make db-reset         Reset database (⚠️  deletes all data!)"
	@echo ""
	@echo "🧹 Cleanup:"
	@echo "  make clean            Stop and remove containers"
	@echo "  make clean-all        Clean everything including images"
	@echo ""

# Start all services in detached mode
dev: up

up:
	@echo "🚀 Starting all services..."
	docker compose up -d
	@echo "✅ Services started!"
	@echo ""
	@echo "📍 Access your application:"
	@echo "   Frontend:  http://localhost:5173"
	@echo "   Backend:   http://localhost:3000"
	@echo "   Database:  localhost:5432"
	@echo ""
	@echo "💡 Use 'make logs' to view logs"

# Stop all services
down:
	@echo "🛑 Stopping all services..."
	docker compose down
	@echo "✅ Services stopped!"

# Restart all services
restart:
	@echo "🔄 Restarting all services..."
	docker compose restart
	@echo "✅ Services restarted!"

# Rebuild and start all containers
build:
	@echo "🔨 Building all containers..."
	docker compose up -d --build
	@echo "✅ Containers built and started!"

# 📊 MONITORING COMMANDS

logs:
	docker compose logs -f

logs-backend:
	docker compose logs -f backend

logs-frontend:
	docker compose logs -f frontend

logs-db:
	docker compose logs -f postgres

ps:
	docker compose ps

# 📦 INSTALLATION COMMANDS

install: install-backend install-frontend
	@echo ""
	@echo "✅ All dependencies installed!"

install-backend:
	@echo "📦 Installing backend dependencies..."
	docker compose exec backend npm install
	@echo "✅ Backend dependencies installed!"

install-frontend:
	@echo "📦 Installing frontend dependencies..."
	docker compose exec frontend npm install
	@echo "✅ Frontend dependencies installed!"

# 🧪 TESTING COMMANDS

test: test-backend
	@echo "✅ All tests completed!"

test-backend:
	@echo "🧪 Running backend tests..."
	docker compose exec backend npm test

test-watch:
	@echo "🧪 Running tests in watch mode..."
	@echo "Press Ctrl+C to stop"
	docker compose exec backend npm run test:watch

test-coverage:
	@echo "🧪 Running tests with coverage..."
	docker compose exec backend npm run test:coverage
	@echo ""
	@echo "📊 Coverage report generated in backend/coverage/"

# 🗄️  DATABASE COMMANDS

db-shell:
	@echo "🐘 Opening PostgreSQL shell..."
	@echo "Type '\q' to exit"
	docker compose exec postgres psql -U postgres -d construction-manager

# Reset database (WARNING: deletes all data!)
db-reset:
	@echo "⚠️  WARNING: This will delete ALL data in the database!"
	@echo -n "Are you sure? Type 'yes' to continue: " && read answer && [ "$$answer" = "yes" ]
	@echo "🗑️  Resetting database..."
	docker compose down -v
	docker compose up -d postgres
	@sleep 5
	docker compose up -d
	@echo "✅ Database reset complete!"

# 🧹 CLEANUP COMMANDS

clean:
	@echo "🧹 Cleaning up containers and volumes..."
	docker compose down -v
	@echo "✅ Cleanup complete!"

clean-all: clean
	@echo "🧹 Removing Docker images..."
	docker compose down -v --rmi all
	@echo "✅ Full cleanup complete!"

# =============================================================================
# 🛠️  UTILITY COMMANDS
# =============================================================================

shell-backend:
	@echo "🐚 Opening backend shell..."
	docker compose exec backend sh

shell-frontend:
	@echo "🐚 Opening frontend shell..."
	docker compose exec frontend sh

# 🎨 CODE QUALITY COMMANDS

lint:
	@echo "🔍 Running ESLint on all code..."
	@echo "Backend:"
	@docker compose exec backend npm run lint
	@echo ""
	@echo "Frontend:"
	@docker compose exec frontend npm run lint
	@echo "✅ Linting complete!"

lint-fix:
	@echo "🔧 Running ESLint with auto-fix..."
	@echo "Backend:"
	@docker compose exec backend npm run lint:fix
	@echo ""
	@echo "Frontend:"
	@docker compose exec frontend npm run lint:fix
	@echo "✅ Auto-fix complete!"

format:
	@echo "🎨 Formatting code with Prettier..."
	@echo "Backend:"
	@docker compose exec backend npm run format
	@echo ""
	@echo "Frontend:"
	@docker compose exec frontend npm run format
	@echo "✅ Formatting complete!"

format-check:
	@echo "🔍 Checking code formatting..."
	@echo "Backend:"
	@docker compose exec backend npm run format:check
	@echo ""
	@echo "Frontend:"
	@docker compose exec frontend npm run format:check
	@echo "✅ Format check complete!"

pre-commit: format-check lint
	@echo ""
	@echo "✅ All pre-commit checks passed!"
	@echo "👍 Ready to commit!"

lint-backend:
	@echo "🔍 Linting backend code..."
	docker compose exec backend npm run lint

health:
	@echo "🏥 Checking service health..."
	@echo -n "Backend:  "
	@curl -s http://localhost:3000/health > /dev/null && echo "✅ Running" || echo "❌ Not responding"
	@echo -n "Frontend: "
	@curl -s http://localhost:5173 > /dev/null && echo "✅ Running" || echo "❌ Not responding"
	@echo -n "Database: "
	@docker compose exec postgres pg_isready -U postgres > /dev/null 2>&1 && echo "✅ Running" || echo "❌ Not responding"
