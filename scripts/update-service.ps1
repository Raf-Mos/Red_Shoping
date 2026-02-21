# Script pour mettre à jour un service après modification du code

param(
    [Parameter(Mandatory=$true)]
    [string]$ServiceName
)

Write-Host "================================" -ForegroundColor Cyan
Write-Host "Mise à jour du service: $ServiceName" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

# Liste des services valides
$validServices = @(
    "product-service",
    "user-service",
    "order-service",
    "notification-service",
    "api-gateway",
    "frontend-ui"
)

if ($ServiceName -notin $validServices) {
    Write-Host "❌ Service invalide: $ServiceName" -ForegroundColor Red
    Write-Host ""
    Write-Host "Services valides:" -ForegroundColor Yellow
    $validServices | ForEach-Object { Write-Host "  - $_" -ForegroundColor White }
    Write-Host ""
    exit 1
}

# Configurer Docker pour utiliser le daemon Minikube
Write-Host "Configuration de Docker pour Minikube..." -ForegroundColor Yellow
& minikube -p minikube docker-env --shell powershell | Invoke-Expression
Write-Host ""

# Reconstruire l'image
Write-Host "Reconstruction de l'image $ServiceName..." -ForegroundColor Yellow
docker-compose build $ServiceName

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Échec de la construction de l'image" -ForegroundColor Red
    exit 1
}
Write-Host "✅ Image reconstruite" -ForegroundColor Green
Write-Host ""

# Redémarrer le déploiement
Write-Host "Redémarrage du déploiement..." -ForegroundColor Yellow
kubectl rollout restart deployment/$ServiceName -n red-shopping

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Échec du redémarrage du déploiement" -ForegroundColor Red
    exit 1
}
Write-Host "✅ Déploiement redémarré" -ForegroundColor Green
Write-Host ""

# Attendre que le rollout soit terminé
Write-Host "Attente de la mise à jour..." -ForegroundColor Yellow
kubectl rollout status deployment/$ServiceName -n red-shopping
Write-Host ""

Write-Host "✅ Mise à jour terminée !" -ForegroundColor Green
Write-Host ""
Write-Host "Pour voir les logs:" -ForegroundColor Yellow
Write-Host "  kubectl logs -f deployment/$ServiceName -n red-shopping" -ForegroundColor White
Write-Host ""
