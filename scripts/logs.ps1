#!/usr/bin/env pwsh
# View logs for all or specific service (Windows PowerShell)

param(
    [string]$Service = ""
)

if (-not (Test-Path "docker-compose.yml")) {
    Write-Host "❌ Error: docker-compose.yml not found" -ForegroundColor Red
    exit 1
}

if ($Service) {
    Write-Host "📋 Viewing logs for: $Service" -ForegroundColor Cyan
    Write-Host "Press Ctrl+C to exit" -ForegroundColor Gray
    Write-Host ""
    docker-compose logs -f $Service
} else {
    Write-Host "📋 Viewing logs for all services" -ForegroundColor Cyan
    Write-Host "Press Ctrl+C to exit" -ForegroundColor Gray
    Write-Host ""
    docker-compose logs -f
}
