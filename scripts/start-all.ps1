#!/usr/bin/env pwsh
# Start all Red Shopping services locally (Windows PowerShell)

Write-Host "🚀 Starting Red Shopping Microservices..." -ForegroundColor Green
Write-Host ""

$ErrorActionPreference = "Stop"

# Check if running in project root
if (-not (Test-Path "docker-compose.yml")) {
    Write-Host "❌ Error: docker-compose.yml not found" -ForegroundColor Red
    Write-Host "Please run this script from the project root directory" -ForegroundColor Yellow
    exit 1
}

# Function to check if port is in use
function Test-Port {
    param([int]$Port)
    $connection = Test-NetConnection -ComputerName localhost -Port $Port -WarningAction SilentlyContinue -InformationLevel Quiet
    return $connection
}

# Check required ports
Write-Host "🔍 Checking required ports..." -ForegroundColor Cyan
$ports = @(3000, 5432, 5433, 6379, 8000, 8001, 8002, 8003, 8004, 15672, 27017)
$portsInUse = @()

foreach ($port in $ports) {
    if (Test-Port $port) {
        $portsInUse += $port
    }
}

if ($portsInUse.Count -gt 0) {
    Write-Host "⚠️  Warning: The following ports are already in use:" -ForegroundColor Yellow
    $portsInUse | ForEach-Object { Write-Host "   - $_" -ForegroundColor Yellow }
    Write-Host ""
    $response = Read-Host "Continue anyway? (y/n)"
    if ($response -ne "y") {
        Write-Host "❌ Aborted" -ForegroundColor Red
        exit 1
    }
}

# Create .env if it doesn't exist
if (-not (Test-Path ".env")) {
    Write-Host "📝 Creating .env file from .env.example..." -ForegroundColor Cyan
    Copy-Item ".env.example" ".env"
    Write-Host "✅ .env file created" -ForegroundColor Green
    Write-Host ""
}

# Start Docker Compose
Write-Host "🐳 Starting Docker Compose..." -ForegroundColor Cyan
Write-Host ""

docker-compose up -d

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "❌ Failed to start services" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "⏳ Waiting for services to be ready..." -ForegroundColor Cyan
Start-Sleep -Seconds 10

# Check service health
Write-Host ""
Write-Host "🏥 Checking service health..." -ForegroundColor Cyan

$services = @{
    "API Gateway" = "http://localhost:8000/health"
    "Product Service" = "http://localhost:8001/health"
    "User Service" = "http://localhost:8002/health"
    "Order Service" = "http://localhost:8003/health"
    "Notification Service" = "http://localhost:8004/health"
}

$allHealthy = $true

foreach ($service in $services.GetEnumerator()) {
    try {
        $response = Invoke-WebRequest -Uri $service.Value -TimeoutSec 5 -UseBasicParsing
        if ($response.StatusCode -eq 200) {
            Write-Host "   ✅ $($service.Key) is healthy" -ForegroundColor Green
        }
    } catch {
        Write-Host "   ⚠️  $($service.Key) not responding yet" -ForegroundColor Yellow
        $allHealthy = $false
    }
}

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "✨ Red Shopping is running!" -ForegroundColor Green
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""
Write-Host "🌐 Access URLs:" -ForegroundColor White
Write-Host "   Frontend:        http://localhost:3000" -ForegroundColor Cyan
Write-Host "   API Gateway:     http://localhost:8000" -ForegroundColor Cyan
Write-Host "   RabbitMQ UI:     http://localhost:15672 (guest/guest)" -ForegroundColor Cyan
Write-Host ""
Write-Host "📊 Service Ports:" -ForegroundColor White
Write-Host "   Product Service:      8001" -ForegroundColor Gray
Write-Host "   User Service:         8002" -ForegroundColor Gray
Write-Host "   Order Service:        8003" -ForegroundColor Gray
Write-Host "   Notification Service: 8004" -ForegroundColor Gray
Write-Host ""
Write-Host "📚 Documentation:" -ForegroundColor White
Write-Host "   API Docs:  docs/api.md" -ForegroundColor Gray
Write-Host "   Quick Start: docs/quick-start.md" -ForegroundColor Gray
Write-Host ""
Write-Host "📝 Useful Commands:" -ForegroundColor White
Write-Host "   View logs:     docker-compose logs -f" -ForegroundColor Gray
Write-Host "   Stop services: docker-compose down" -ForegroundColor Gray
Write-Host "   Restart:       docker-compose restart" -ForegroundColor Gray
Write-Host ""

if (-not $allHealthy) {
    Write-Host "⚠️  Some services may still be starting up." -ForegroundColor Yellow
    Write-Host "   Check status with: docker-compose ps" -ForegroundColor Yellow
    Write-Host ""
}

Write-Host "🎉 Happy coding!" -ForegroundColor Green
