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