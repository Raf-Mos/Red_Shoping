# Script pour démarrer Minikube avec la configuration recommandée

Write-Host "================================" -ForegroundColor Cyan
Write-Host "Démarrage de Minikube" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Démarrage de Minikube avec 4 CPUs et 4GB de RAM..." -ForegroundColor Yellow
minikube start --cpus=4 --memory=4096 --driver=docker

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✅ Minikube démarré avec succès !" -ForegroundColor Green
    Write-Host ""
    
    Write-Host "Configuration de Docker pour utiliser le daemon Minikube..." -ForegroundColor Yellow
    & minikube -p minikube docker-env --shell powershell | Invoke-Expression
    
    Write-Host ""
    Write-Host "✅ Configuration terminée !" -ForegroundColor Green
    Write-Host ""
    Write-Host "Informations Minikube:" -ForegroundColor Cyan
    minikube status
    Write-Host ""
    Write-Host "Pour déployer l'application:" -ForegroundColor Yellow
    Write-Host "  .\scripts\deploy-minikube.ps1" -ForegroundColor White
    Write-Host ""
    Write-Host "Pour ouvrir le dashboard Kubernetes:" -ForegroundColor Yellow
    Write-Host "  minikube dashboard" -ForegroundColor White
    Write-Host ""
} else {
    Write-Host ""
    Write-Host "❌ Échec du démarrage de Minikube" -ForegroundColor Red
    Write-Host ""
    Write-Host "Vérifiez que:" -ForegroundColor Yellow
    Write-Host "  - Docker est en cours d'exécution" -ForegroundColor White
    Write-Host "  - Minikube est correctement installé" -ForegroundColor White
    Write-Host "  - Vous avez au moins 4GB de RAM disponibles" -ForegroundColor White
    Write-Host ""
}
