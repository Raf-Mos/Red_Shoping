# Scripts Directory

Utility scripts for managing Red Shopping services.

## Available Scripts

### 🚀 start-all.ps1
Start all services using Docker Compose.

```powershell
.\scripts\start-all.ps1
```

**What it does:**
- Checks if required ports are available
- Creates `.env` file if missing
- Starts all Docker containers
- Performs health checks
- Shows access URLs

### 🛑 stop-all.ps1
Stop all running services.

```powershell
.\scripts\stop-all.ps1
```

### 📋 logs.ps1
View service logs.

```powershell
# View all logs
.\scripts\logs.ps1

# View specific service logs
.\scripts\logs.ps1 -Service api-gateway
.\scripts\logs.ps1 -Service product-service
.\scripts\logs.ps1 -Service frontend-ui
```

**Available services:**
- `api-gateway`
- `frontend-ui`
- `product-service`
- `user-service`
- `order-service`
- `notification-service`
- `postgres-products`
- `postgres-orders`
- `mongodb`
- `redis`
- `rabbitmq`

### 🔍 status.ps1
Check status of all services.

```powershell
.\scripts\status.ps1
```

**Shows:**
- Docker container status
- Service health checks
- Database connectivity
- RabbitMQ status

### 🔄 reset.ps1
Reset all data and restart services.

```powershell
.\scripts\reset.ps1
```

**⚠️ WARNING:** This will delete ALL data!

**What it does:**
- Stops all services
- Deletes all Docker volumes
- Removes all databases
- Restarts services with fresh data

---

## Quick Commands

### Development Workflow

```powershell
# Start everything
.\scripts\start-all.ps1

# Check if everything is running
.\scripts\status.ps1

# View logs for debugging
.\scripts\logs.ps1 -Service order-service

# Reset data for testing
.\scripts\reset.ps1

# Stop when done
.\scripts\stop-all.ps1
```

### Troubleshooting

```powershell
# Check which services are unhealthy
.\scripts\status.ps1

# View specific service logs
.\scripts\logs.ps1 -Service <service-name>

# Restart everything
.\scripts\stop-all.ps1
.\scripts\start-all.ps1
```

---

## Manual Commands

If you prefer manual control:

### Start Services
```powershell
docker-compose up -d
```

### Stop Services
```powershell
docker-compose down
```

### View Logs
```powershell
docker-compose logs -f
docker-compose logs -f api-gateway
```

### Restart Single Service
```powershell
docker-compose restart api-gateway
```

### Rebuild Service
```powershell
docker-compose up -d --build api-gateway
```

### Remove Everything (including volumes)
```powershell
docker-compose down -v
```

---

## Environment Variables

All scripts use the `.env` file in the project root. If it doesn't exist, `start-all.ps1` will create it from `.env.example`.

---

## Execution Policy

If you get an error about script execution policy:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

Then try running the script again.

---

## Troubleshooting

### Port Already in Use

Run this to find what's using a port:
```powershell
netstat -ano | findstr :8000
```

Kill the process:
```powershell
taskkill /PID <PID> /F
```

### Docker Not Running

Make sure Docker Desktop is running:
```powershell
docker version
```

### Services Not Starting

Check Docker Compose logs:
```powershell
docker-compose logs
```

---

## Additional Setup Scripts

### Install Dependencies (Manual Setup)

**Frontend:**
```powershell
cd microservices/frontend-ui
npm install
```

**API Gateway:**
```powershell
cd microservices/api-gateway
npm install
```

**User Service:**
```powershell
cd microservices/user-service/src
npm install
```

**Python Services:**
```powershell
# Product Service
cd microservices/product-service
python -m venv venv
venv\Scripts\activate
pip install -r requirements.txt

# Order Service
cd microservices/order-service
python -m venv venv
venv\Scripts\activate
pip install -r requirements.txt

# Notification Service
cd microservices/notification-service
python -m venv venv
venv\Scripts\activate
pip install -r requirements.txt
```
