# 🚀 Quick Start Guide

Step-by-step guide to run Red Shopping locally.

---

## Prerequisites

### Required Software

- **Docker** & **Docker Compose** (recommended)
- **Node.js** 20+ (for local development)
- **Python** 3.11+ (for local development)
- **PostgreSQL** 15+ (if not using Docker)
- **MongoDB** 7+ (if not using Docker)
- **Redis** 7+ (if not using Docker)
- **RabbitMQ** 3+ (if not using Docker)

---

## Option 1: Docker Compose (Recommended) 🐳

### Step 1: Clone and Setup

```bash
cd c:\Simplon\Red_Shoping
cp .env.example .env
```

### Step 2: Start All Services

```bash
docker-compose up -d
```

This will start:
- All databases (PostgreSQL x2, MongoDB, Redis, RabbitMQ)
- All microservices (6 services)
- Frontend

### Step 3: Check Status

```bash
docker-compose ps
```

All services should show "Up" status.

### Step 4: Access Application

- **Frontend**: http://localhost:3000
- **API Gateway**: http://localhost:8000
- **RabbitMQ Management**: http://localhost:15672 (guest/guest)

### Step 5: View Logs

```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f api-gateway
docker-compose logs -f product-service
```

### Step 6: Stop Services

```bash
docker-compose down
```

---

## Option 2: Local Development (Manual) 💻

### Step 1: Start Databases

**Terminal 1 - PostgreSQL (Products)**
```bash
docker run --name postgres-products -e POSTGRES_DB=products_db -e POSTGRES_PASSWORD=postgres -p 5432:5432 -d postgres:15-alpine
```

**Terminal 2 - PostgreSQL (Orders)**
```bash
docker run --name postgres-orders -e POSTGRES_DB=orders_db -e POSTGRES_PASSWORD=postgres -p 5433:5432 -d postgres:15-alpine
```

**Terminal 3 - MongoDB**
```bash
docker run --name mongodb -e MONGO_INITDB_DATABASE=users_db -p 27017:27017 -d mongo:7
```

**Terminal 4 - Redis**
```bash
docker run --name redis -p 6379:6379 -d redis:7-alpine
```

**Terminal 5 - RabbitMQ**
```bash
docker run --name rabbitmq -p 5672:5672 -p 15672:15672 -d rabbitmq:3-management-alpine
```

---

### Step 2: Start Backend Services

**Terminal 6 - Product Service**
```bash
cd microservices/product-service
python -m venv venv
venv\Scripts\activate
pip install -r requirements.txt
python src/app.py
```
✅ Running on http://localhost:8001

**Terminal 7 - User Service**
```bash
cd microservices/user-service/src
npm install
npm run dev
```
✅ Running on http://localhost:8002

**Terminal 8 - Order Service**
```bash
cd microservices/order-service
python -m venv venv
venv\Scripts\activate
pip install -r requirements.txt
python src/app.py
```
✅ Running on http://localhost:8003

**Terminal 9 - Notification Service**
```bash
cd microservices/notification-service
python -m venv venv
venv\Scripts\activate
pip install -r requirements.txt
python src/consumer.py
```
✅ Consumer listening

**Terminal 10 - API Gateway**
```bash
cd microservices/api-gateway
npm install
npm run dev
```
✅ Running on http://localhost:8000

---

### Step 3: Start Frontend

**Terminal 11 - Frontend**
```bash
cd microservices/frontend-ui
npm install
npm run dev
```
✅ Running on http://localhost:3000

---

## Quick Test Flow 🧪

### 1. Open Browser
Navigate to http://localhost:3000

### 2. Register Account
- Click "Sign Up"
- Fill form:
  - Name: Test User
  - Email: test@example.com
  - Password: test123
- Click "Create Account"

### 3. Browse Products
- Click "Products" in navbar
- You'll see 8 sample products
- Search: "laptop"
- Add products to cart

### 4. Create Order
- Click cart icon
- Review items
- Click "Proceed to Checkout"
- Order created!

### 5. Check Notifications
Look at **Notification Service** terminal:
```
📨 Received event: order_created
📧 EMAIL NOTIFICATION
==================================================
To: test@example.com
Subject: Order Confirmation - Order #1
...
✅ Sent order confirmation for order #1
```

### 6. View Orders
- Click "My Orders"
- See your order history

---

## Health Checks 🏥

Check if services are running:

```bash
# API Gateway
curl http://localhost:8000/health

# Product Service
curl http://localhost:8001/health

# User Service
curl http://localhost:8002/health

# Order Service
curl http://localhost:8003/health

# Notification Service
curl http://localhost:8004/health
```

All should return: `{"status":"healthy",...}`

---

## Troubleshooting 🔧

### Port Already in Use

**Windows:**
```powershell
# Find process using port
netstat -ano | findstr :8000

# Kill process
taskkill /PID <PID> /F
```

### Database Connection Issues

**Check PostgreSQL:**
```bash
docker exec -it postgres-products psql -U postgres -d products_db -c "SELECT 1;"
```

**Check MongoDB:**
```bash
docker exec -it mongodb mongosh --eval "db.runCommand({ ping: 1 })"
```

**Check Redis:**
```bash
docker exec -it redis redis-cli ping
```

### RabbitMQ Not Receiving Messages

1. Check RabbitMQ Management UI: http://localhost:15672
2. Login: guest/guest
3. Go to "Queues" tab
4. Verify "notifications" queue exists

### Frontend Not Connecting to API

Check `.env` in frontend:
```env
VITE_API_URL=http://localhost:8000
```

Rebuild:
```bash
npm run dev
```

---

## Reset Data 🔄

### Docker Compose
```bash
docker-compose down -v  # Removes volumes (all data)
docker-compose up -d    # Fresh start
```

### Manual
```bash
# Drop all databases
docker exec postgres-products psql -U postgres -c "DROP DATABASE products_db; CREATE DATABASE products_db;"
docker exec postgres-orders psql -U postgres -c "DROP DATABASE orders_db; CREATE DATABASE orders_db;"
docker exec mongodb mongosh --eval "db.dropDatabase()"
docker exec redis redis-cli FLUSHALL
```

---

## Production Deployment 🚀

For production deployment, see:
- [Kubernetes Guide](kubernetes/README.md)
- [Terraform Guide](infrastructure/terraform/README.md)
- [CI/CD Pipeline](docs/ci-cd.md)

---

## Useful Commands 📝

### Docker
```bash
# View all containers
docker ps -a

# View logs
docker logs -f <container-name>

# Restart service
docker restart <container-name>

# Remove all containers
docker rm -f $(docker ps -aq)
```

### Database
```bash
# PostgreSQL shell
docker exec -it postgres-products psql -U postgres -d products_db

# MongoDB shell
docker exec -it mongodb mongosh users_db

# Redis CLI
docker exec -it redis redis-cli
```

---

## Next Steps 📚

1. Read [API Documentation](api.md)
2. Explore [Architecture](architecture.md)
3. Run [Tests](../tests/README.md)
4. Deploy to [Kubernetes](../kubernetes/README.md)
