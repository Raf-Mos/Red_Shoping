# Script de déploiement automatique sur Minikube
# Ce script déploie l'application Red Shopping sur Kubernetes (Minikube)

Write-Host "================================" -ForegroundColor Cyan
Write-Host "Red Shopping - Déploiement Minikube" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

# Vérifier que Minikube est démarré
Write-Host "Vérification de Minikube..." -ForegroundColor Yellow
$minikubeStatus = minikube status 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Minikube n'est pas démarré. Démarrage..." -ForegroundColor Red
    minikube start --cpus=4 --memory=4096
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Échec du démarrage de Minikube" -ForegroundColor Red
        exit 1
    }
}
Write-Host "✅ Minikube est actif" -ForegroundColor Green
Write-Host ""

# Configurer Docker pour utiliser le daemon Minikube
Write-Host "Configuration de Docker pour Minikube..." -ForegroundColor Yellow
& minikube -p minikube docker-env --shell powershell | Invoke-Expression
Write-Host "✅ Docker configuré" -ForegroundColor Green
Write-Host ""

# Vérifier si les images existent, sinon les construire
Write-Host "Vérification des images Docker..." -ForegroundColor Yellow
$images = docker images | Select-String "red-shopping"
if ($images.Count -lt 6) {
    Write-Host "⚠️  Images manquantes. Construction des images..." -ForegroundColor Yellow
    docker-compose build
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Échec de la construction des images" -ForegroundColor Red
        exit 1
    }
    Write-Host "✅ Images construites avec succès" -ForegroundColor Green
} else {
    Write-Host "✅ Toutes les images sont présentes" -ForegroundColor Green
}
Write-Host ""

# Créer le namespace
Write-Host "Création du namespace..." -ForegroundColor Yellow
kubectl apply -f kubernetes/namespaces/namespace.yaml
Write-Host ""

# Déployer les secrets et configmaps
Write-Host "Déploiement des configurations..." -ForegroundColor Yellow
kubectl apply -f kubernetes/secrets/secrets.yaml
kubectl apply -f kubernetes/configmaps/configmap.yaml
Write-Host ""

# Déployer les bases de données
Write-Host "Déploiement des bases de données..." -ForegroundColor Yellow
kubectl apply -f kubernetes/deployments/postgres-products.yaml
kubectl apply -f kubernetes/deployments/postgres-orders.yaml
kubectl apply -f kubernetes/deployments/mongodb.yaml
kubectl apply -f kubernetes/deployments/redis.yaml
kubectl apply -f kubernetes/deployments/rabbitmq.yaml
Write-Host ""

# Attendre que les bases de données soient prêtes
Write-Host "Attente du démarrage des bases de données (peut prendre 1-2 minutes)..." -ForegroundColor Yellow
Start-Sleep -Seconds 10

kubectl wait --for=condition=ready pod -l app=postgres-products -n red-shopping --timeout=120s 2>$null
kubectl wait --for=condition=ready pod -l app=postgres-orders -n red-shopping --timeout=120s 2>$null
kubectl wait --for=condition=ready pod -l app=mongodb -n red-shopping --timeout=120s 2>$null
kubectl wait --for=condition=ready pod -l app=redis -n red-shopping --timeout=120s 2>$null
kubectl wait --for=condition=ready pod -l app=rabbitmq -n red-shopping --timeout=120s 2>$null

Write-Host "✅ Bases de données prêtes" -ForegroundColor Green
Write-Host ""

# Déployer les microservices
Write-Host "Déploiement des microservices..." -ForegroundColor Yellow
kubectl apply -f kubernetes/deployments/product-service.yaml
kubectl apply -f kubernetes/deployments/user-service.yaml
kubectl apply -f kubernetes/deployments/order-service.yaml
kubectl apply -f kubernetes/deployments/notification-service.yaml
Write-Host ""

# Attendre que les services soient prêts
Write-Host "Attente du démarrage des microservices..." -ForegroundColor Yellow
Start-Sleep -Seconds 10
Write-Host ""

# Déployer l'API Gateway et le Frontend
Write-Host "Déploiement de l'API Gateway et du Frontend..." -ForegroundColor Yellow
kubectl apply -f kubernetes/deployments/api-gateway.yaml
kubectl apply -f kubernetes/deployments/frontend-ui.yaml
Write-Host ""

# Attendre que tout soit prêt
Write-Host "Attente du démarrage complet de l'application..." -ForegroundColor Yellow
Start-Sleep -Seconds 15
Write-Host ""

# Afficher l'état des déploiements
Write-Host "================================" -ForegroundColor Cyan
Write-Host "État des déploiements" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
kubectl get pods -n red-shopping
Write-Host ""

# Obtenir les URLs d'accès
Write-Host "================================" -ForegroundColor Cyan
Write-Host "URLs d'accès" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan

$frontendUrl = minikube service frontend-ui -n red-shopping --url
$apiGatewayUrl = minikube service api-gateway -n red-shopping --url

Write-Host ""
Write-Host "✅ Déploiement terminé !" -ForegroundColor Green
Write-Host ""
Write-Host "Frontend UI:    $frontendUrl" -ForegroundColor Cyan
Write-Host "API Gateway:    $apiGatewayUrl" -ForegroundColor Cyan
Write-Host ""
Write-Host "Pour ouvrir dans le navigateur:" -ForegroundColor Yellow
Write-Host "  minikube service frontend-ui -n red-shopping" -ForegroundColor White
Write-Host ""
Write-Host "Pour voir les logs:" -ForegroundColor Yellow
Write-Host "  kubectl logs -f deployment/api-gateway -n red-shopping" -ForegroundColor White
Write-Host ""
Write-Host "Pour créer l'utilisateur admin:" -ForegroundColor Yellow
Write-Host "  kubectl exec -it deployment/user-service -n red-shopping -- node src/scripts/create-admin.js" -ForegroundColor White
Write-Host ""
Write-Host "Pour supprimer le déploiement:" -ForegroundColor Yellow
Write-Host "  .\scripts\cleanup-minikube.ps1" -ForegroundColor White
Write-Host ""
