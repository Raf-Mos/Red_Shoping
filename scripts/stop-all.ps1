#!/usr/bin/env pwsh
# Stop all Red Shopping services (Windows PowerShell)

Write-Host "🛑 Stopping Red Shopping services..." -ForegroundColor Yellow
Write-Host ""

if (-not (Test-Path "docker-compose.yml")) {
    Write-Host "❌ Error: docker-compose.yml not found" -ForegroundColor Red
    Write-Host "Please run this script from the project root directory" -ForegroundColor Yellow
    exit 1
}

# Stop Docker Compose
docker-compose down

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✅ All services stopped successfully" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "❌ Error stopping services" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "💡 To remove volumes (all data), run:" -ForegroundColor Cyan
Write-Host "   docker-compose down -v" -ForegroundColor Gray
Write-Host ""
