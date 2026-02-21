# Red Shopping - Déploiement Minikube

Ce guide explique comment déployer l'application Red Shopping sur Minikube (Kubernetes local).

## 📋 Prérequis

- **Minikube** installé ([Guide d'installation](https://minikube.sigs.k8s.io/docs/start/))
- **kubectl** installé ([Guide d'installation](https://kubernetes.io/docs/tasks/tools/))
- **Docker** en cours d'exécution (pour construire les images)
- Au moins **4 GB de RAM** disponibles pour Minikube

## 🚀 Démarrage Rapide

### 1. Démarrer Minikube

```powershell
# Démarrer Minikube avec les ressources nécessaires
minikube start --cpus=4 --memory=4096

# Vérifier le statut
minikube status
```

### 2. Configurer Docker pour utiliser le daemon Minikube

```powershell
# Sur PowerShell
& minikube -p minikube docker-env --shell powershell | Invoke-Expression
```

Cette commande configure votre shell pour utiliser le daemon Docker de Minikube, permettant à Kubernetes d'utiliser vos images locales.

### 3. Construire les images Docker

```powershell
# Construire toutes les images (dans le dossier racine du projet)
docker-compose build
```

Les images seront construites directement dans le daemon Docker de Minikube.

### 4. Déployer sur Kubernetes

```powershell
# Utiliser le script de déploiement automatique
.\scripts\deploy-minikube.ps1
```

Ou déployer manuellement :

```powershell
# Créer le namespace
kubectl apply -f kubernetes/namespaces/namespace.yaml

# Déployer les secrets et configmaps
kubectl apply -f kubernetes/secrets/secrets.yaml
kubectl apply -f kubernetes/configmaps/configmap.yaml

# Déployer les bases de données
kubectl apply -f kubernetes/deployments/postgres-products.yaml
kubectl apply -f kubernetes/deployments/postgres-orders.yaml
kubectl apply -f kubernetes/deployments/mongodb.yaml
kubectl apply -f kubernetes/deployments/redis.yaml
kubectl apply -f kubernetes/deployments/rabbitmq.yaml

# Attendre que les bases de données soient prêtes (environ 30-60 secondes)
kubectl wait --for=condition=ready pod -l app=postgres-products -n red-shopping --timeout=120s
kubectl wait --for=condition=ready pod -l app=postgres-orders -n red-shopping --timeout=120s
kubectl wait --for=condition=ready pod -l app=mongodb -n red-shopping --timeout=120s

# Déployer les microservices
kubectl apply -f kubernetes/deployments/product-service.yaml
kubectl apply -f kubernetes/deployments/user-service.yaml
kubectl apply -f kubernetes/deployments/order-service.yaml
kubectl apply -f kubernetes/deployments/notification-service.yaml

# Déployer l'API Gateway et le Frontend
kubectl apply -f kubernetes/deployments/api-gateway.yaml
kubectl apply -f kubernetes/deployments/frontend-ui.yaml
```

### 5. Accéder à l'application

```powershell
# Obtenir l'URL du frontend
minikube service frontend-ui -n red-shopping --url

# Obtenir l'URL de l'API Gateway
minikube service api-gateway -n red-shopping --url
```

Ou ouvrir directement dans le navigateur :

```powershell
# Ouvrir le frontend
minikube service frontend-ui -n red-shopping

# Ouvrir l'API Gateway
minikube service api-gateway -n red-shopping
```

## 🔍 Commandes Utiles

### Vérifier l'état des déploiements

```powershell
# Voir tous les pods
kubectl get pods -n red-shopping

# Voir tous les services
kubectl get services -n red-shopping

# Voir les déploiements
kubectl get deployments -n red-shopping

# Voir les volumes persistants
kubectl get pvc -n red-shopping
```

### Voir les logs

```powershell
# Logs d'un pod spécifique
kubectl logs -f deployment/api-gateway -n red-shopping
kubectl logs -f deployment/frontend-ui -n red-shopping
kubectl logs -f deployment/product-service -n red-shopping

# Logs de tous les pods d'un service
kubectl logs -l app=api-gateway -n red-shopping
```

### Déboguer un pod

```powershell
# Obtenir les détails d'un pod
kubectl describe pod <nom-du-pod> -n red-shopping

# Accéder à un pod en shell
kubectl exec -it deployment/user-service -n red-shopping -- sh

# Redémarrer un déploiement
kubectl rollout restart deployment/api-gateway -n red-shopping
```

### Créer l'utilisateur admin

```powershell
# Se connecter au pod user-service
kubectl exec -it deployment/user-service -n red-shopping -- node src/scripts/create-admin.js
```

Credentials par défaut :
- Email : `admin@redshoping.com`
- Mot de passe : `admin123`

## 🔧 Configuration

### Modifier les variables d'environnement

Éditez les fichiers de configuration :

- **Secrets** : `kubernetes/secrets/secrets.yaml`
- **ConfigMaps** : `kubernetes/configmaps/configmap.yaml`

Puis appliquez les changements :

```powershell
kubectl apply -f kubernetes/secrets/secrets.yaml
kubectl apply -f kubernetes/configmaps/configmap.yaml

# Redémarrer les pods pour prendre en compte les changements
kubectl rollout restart deployment -n red-shopping
```

### Changer les ressources allouées

Éditez les fichiers de déploiement dans `kubernetes/deployments/` et ajoutez des limites de ressources :

```yaml
resources:
  requests:
    memory: "256Mi"
    cpu: "250m"
  limits:
    memory: "512Mi"
    cpu: "500m"
```

## 🗑️ Nettoyage

### Supprimer tous les déploiements

```powershell
# Supprimer le namespace (supprime tout)
kubectl delete namespace red-shopping
```

Ou utilisez le script de nettoyage :

```powershell
.\scripts\cleanup-minikube.ps1
```

### Arrêter Minikube

```powershell
minikube stop
```

### Supprimer complètement Minikube

```powershell
minikube delete
```

## 📊 Monitoring

### Dashboard Kubernetes

```powershell
# Ouvrir le dashboard Kubernetes
minikube dashboard
```

### Métriques

```powershell
# Activer les métriques
minikube addons enable metrics-server

# Voir l'utilisation des ressources
kubectl top pods -n red-shopping
kubectl top nodes
```

## 🐛 Troubleshooting

### Les pods ne démarrent pas

```powershell
# Vérifier les événements
kubectl get events -n red-shopping --sort-by='.lastTimestamp'

# Vérifier les logs d'un pod qui ne démarre pas
kubectl logs <nom-du-pod> -n red-shopping
```

### Images non trouvées (ImagePullBackOff)

Vérifiez que vous avez bien configuré Docker pour utiliser le daemon Minikube :

```powershell
& minikube -p minikube docker-env --shell powershell | Invoke-Expression
docker images | Select-String "red-shopping"
```

Si les images n'apparaissent pas, reconstruisez-les :

```powershell
docker-compose build
```

### Problèmes de connexion entre services

```powershell
# Tester la connectivité depuis un pod
kubectl exec -it deployment/api-gateway -n red-shopping -- sh
# Puis dans le pod :
# ping product-service
# curl http://product-service:8001/health
```

### Base de données non initialisée

```powershell
# Supprimer et recréer les PVC
kubectl delete pvc --all -n red-shopping
kubectl apply -f kubernetes/deployments/postgres-products.yaml
kubectl apply -f kubernetes/deployments/postgres-orders.yaml
kubectl apply -f kubernetes/deployments/mongodb.yaml
```

## 🔄 Mise à jour de l'application

Pour mettre à jour une image après modification du code :

```powershell
# 1. Reconfigurer Docker pour Minikube
& minikube -p minikube docker-env --shell powershell | Invoke-Expression

# 2. Reconstruire l'image spécifique
docker-compose build <service-name>

# 3. Redémarrer le déploiement
kubectl rollout restart deployment/<service-name> -n red-shopping

# Exemple pour l'API Gateway :
docker-compose build api-gateway
kubectl rollout restart deployment/api-gateway -n red-shopping
```

## 📝 Architecture Kubernetes

```
┌─────────────────────────────────────────────────────────┐
│                    Namespace: red-shopping               │
├─────────────────────────────────────────────────────────┤
│                                                           │
│  ┌─────────────┐         ┌──────────────┐               │
│  │ Frontend UI │◄────────┤ API Gateway  │               │
│  │ (NodePort)  │         │  (NodePort)  │               │
│  └─────────────┘         └──────┬───────┘               │
│                                  │                       │
│          ┌──────────────────────┼────────────┐          │
│          │                      │            │          │
│     ┌────▼────┐          ┌─────▼─────┐  ┌──▼────┐      │
│     │ Product │          │   User    │  │ Order │      │
│     │ Service │          │  Service  │  │Service│      │
│     └────┬────┘          └─────┬─────┘  └───┬───┘      │
│          │                     │            │          │
│     ┌────▼────┐          ┌─────▼─────┐  ┌──▼────┐      │
│     │Postgres │          │  MongoDB  │  │Postgres│      │
│     │Products │          │           │  │ Orders │      │
│     └─────────┘          └─────┬─────┘  └───┬───┘      │
│                                │            │          │
│          ┌────────────────────┼────────────┘          │
│          │                    │                       │
│     ┌────▼────┐          ┌────▼─────┐                 │
│     │  Redis  │          │ RabbitMQ │                 │
│     └─────────┘          └──────────┘                 │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

## 🔗 Ressources

- [Documentation Minikube](https://minikube.sigs.k8s.io/docs/)
- [Documentation Kubernetes](https://kubernetes.io/docs/home/)
- [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
