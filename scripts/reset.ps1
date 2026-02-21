#!/usr/bin/env pwsh
# Reset all data and restart services (Windows PowerShell)

Write-Host "⚠️  WARNING: This will delete ALL data!" -ForegroundColor Red
Write-Host ""
Write-Host "This will:" -ForegroundColor Yellow
Write-Host "   - Stop all services" -ForegroundColor Yellow
Write-Host "   - Delete all databases" -ForegroundColor Yellow
Write-Host "   - Delete all Docker volumes" -ForegroundColor Yellow
Write-Host "   - Restart all services with fresh data" -ForegroundColor Yellow
Write-Host ""

$response = Read-Host "Are you sure you want to continue? (yes/no)"

if ($response -ne "yes") {
    Write-Host "❌ Aborted" -ForegroundColor Red
    exit 0
}

Write-Host ""
Write-Host "🔄 Resetting Red Shopping..." -ForegroundColor Cyan

# Stop services
Write-Host ""
Write-Host "1️⃣ Stopping services..." -ForegroundColor Cyan
docker-compose down -v

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to stop services" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Services stopped" -ForegroundColor Green

# Remove volumes
Write-Host ""
Write-Host "2️⃣ Removing volumes..." -ForegroundColor Cyan
docker volume prune -f | Out-Null
Write-Host "✅ Volumes removed" -ForegroundColor Green

# Restart services
Write-Host ""
Write-Host "3️⃣ Starting services..." -ForegroundColor Cyan
docker-compose up -d

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to start services" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Services started" -ForegroundColor Green

Write-Host ""
Write-Host "⏳ Waiting for services to initialize..." -ForegroundColor Cyan
Start-Sleep -Seconds 15

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
Write-Host "✨ Reset complete! All services are running with fresh data." -ForegroundColor Green
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
Write-Host ""
Write-Host "🌐 Frontend: http://localhost:3000" -ForegroundColor Cyan
Write-Host "📊 Check status: .\scripts\status.ps1" -ForegroundColor Gray
Write-Host ""
