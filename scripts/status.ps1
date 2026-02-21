#!/usr/bin/env pwsh
# Check status of all services (Windows PowerShell)

Write-Host "🔍 Checking Red Shopping services status..." -ForegroundColor Cyan
Write-Host ""

if (-not (Test-Path "docker-compose.yml")) {
    Write-Host "❌ Error: docker-compose.yml not found" -ForegroundColor Red
    exit 1
}

# Docker Compose Status
Write-Host "📦 Docker Containers:" -ForegroundColor White
docker-compose ps

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray

# Health Checks
Write-Host ""
Write-Host "🏥 Health Checks:" -ForegroundColor White
Write-Host ""

$services = @{
    "API Gateway" = "http://localhost:8000/health"
    "Product Service" = "http://localhost:8001/health"
    "User Service" = "http://localhost:8002/health"
    "Order Service" = "http://localhost:8003/health"
    "Notification Service" = "http://localhost:8004/health"
    "Frontend" = "http://localhost:3000"
}

foreach ($service in $services.GetEnumerator()) {
    try {
        $response = Invoke-WebRequest -Uri $service.Value -TimeoutSec 3 -UseBasicParsing
        if ($response.StatusCode -eq 200) {
            Write-Host "   ✅ $($service.Key) - Healthy" -ForegroundColor Green
        }
    } catch {
        Write-Host "   ❌ $($service.Key) - Not responding" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray

# Database Status
Write-Host ""
Write-Host "💾 Database Status:" -ForegroundColor White
Write-Host ""

# PostgreSQL
try {
    docker exec postgres-products psql -U postgres -d products_db -c "SELECT 1;" 2>$null | Out-Null
    Write-Host "   ✅ PostgreSQL (Products) - Connected" -ForegroundColor Green
} catch {
    Write-Host "   ❌ PostgreSQL (Products) - Not connected" -ForegroundColor Red
}

try {
    docker exec postgres-orders psql -U postgres -d orders_db -c "SELECT 1;" 2>$null | Out-Null
    Write-Host "   ✅ PostgreSQL (Orders) - Connected" -ForegroundColor Green
} catch {
    Write-Host "   ❌ PostgreSQL (Orders) - Not connected" -ForegroundColor Red
}

# MongoDB
try {
    docker exec mongodb mongosh --quiet --eval "db.runCommand({ ping: 1 })" 2>$null | Out-Null
    Write-Host "   ✅ MongoDB - Connected" -ForegroundColor Green
} catch {
    Write-Host "   ❌ MongoDB - Not connected" -ForegroundColor Red
}

# Redis
try {
    docker exec redis redis-cli ping 2>$null | Out-Null
    Write-Host "   ✅ Redis - Connected" -ForegroundColor Green
} catch {
    Write-Host "   ❌ Redis - Not connected" -ForegroundColor Red
}

# RabbitMQ
try {
    $response = Invoke-WebRequest -Uri "http://localhost:15672" -TimeoutSec 3 -UseBasicParsing
    Write-Host "   ✅ RabbitMQ - Running" -ForegroundColor Green
} catch {
    Write-Host "   ❌ RabbitMQ - Not running" -ForegroundColor Red
}

Write-Host ""
