# Script de nettoyage du déploiement Minikube
# Ce script supprime tous les déploiements Red Shopping de Kubernetes

Write-Host "================================" -ForegroundColor Cyan
Write-Host "Red Shopping - Nettoyage Minikube" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "⚠️  Ce script va supprimer tous les déploiements Red Shopping" -ForegroundColor Yellow
Write-Host ""

$confirmation = Read-Host "Êtes-vous sûr de vouloir continuer ? (oui/non)"

if ($confirmation -ne "oui") {
    Write-Host "Opération annulée" -ForegroundColor Yellow
    exit 0
}

Write-Host ""
Write-Host "Suppression du namespace red-shopping..." -ForegroundColor Yellow
kubectl delete namespace red-shopping

Write-Host ""
Write-Host "✅ Nettoyage terminé !" -ForegroundColor Green
Write-Host ""
Write-Host "Pour redéployer l'application:" -ForegroundColor Yellow
Write-Host "  .\scripts\deploy-minikube.ps1" -ForegroundColor White
Write-Host ""
