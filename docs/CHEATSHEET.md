# Red Shopping - Commandes Utiles

Aide-mémoire des commandes fréquemment utilisées pour gérer l'application.

## 🐳 Docker Compose

### Démarrage et arrêt

```powershell
# Démarrer tous les services
docker-compose up -d

# Arrêter tous les services
docker-compose down

# Arrêter et supprimer les volumes
docker-compose down -v

# Redémarrer un service spécifique
docker-compose restart api-gateway
```

### Construction et logs

```powershell
# Construire toutes les images
docker-compose build

# Construire un service spécifique
docker-compose build product-service

# Forcer la reconstruction
docker-compose build --no-cache

# Voir les logs
docker-compose logs -f

# Logs d'un service spécifique
docker-compose logs -f api-gateway

# Dernières 100 lignes
docker-compose logs --tail=100 api-gateway
```

### Debugging

```powershell
# Lister les conteneurs
docker-compose ps

# Accéder à un conteneur
docker-compose exec api-gateway sh

# Voir l'utilisation des ressources
docker stats
```

## ☸️ Kubernetes/Minikube

### Gestion du cluster

```powershell
# Démarrer Minikube
.\scripts\start-minikube.ps1
# OU manuellement :
minikube start --cpus=4 --memory=4096

# Arrêter Minikube
minikube stop

# Supprimer Minikube
minikube delete

# Statut
minikube status

# Dashboard
minikube dashboard
```

### Déploiement

```powershell
# Déploiement complet (recommandé)
.\scripts\deploy-minikube.ps1

# Nettoyer tout
.\scripts\cleanup-minikube.ps1

# Mettre à jour un service
.\scripts\update-service.ps1 -ServiceName api-gateway
```

### Gestion des pods

```powershell
# Lister tous les pods
kubectl get pods -n red-shopping

# Avec plus de détails
kubectl get pods -n red-shopping -o wide

# Décrire un pod
kubectl describe pod <pod-name> -n red-shopping

# Accéder à un pod
kubectl exec -it deployment/api-gateway -n red-shopping -- sh

# Supprimer un pod (sera recréé automatiquement)
kubectl delete pod <pod-name> -n red-shopping
```

### Logs

```powershell
# Logs d'un deployment
kubectl logs -f deployment/api-gateway -n red-shopping

# Logs de tous les pods d'un label
kubectl logs -l app=api-gateway -n red-shopping

# Dernières 100 lignes
kubectl logs --tail=100 deployment/api-gateway -n red-shopping

# Logs d'un pod spécifique
kubectl logs <pod-name> -n red-shopping

# Logs depuis la dernière heure
kubectl logs --since=1h deployment/api-gateway -n red-shopping
```

### Services et networking

```powershell
# Lister les services
kubectl get svc -n red-shopping

# Obtenir l'URL d'un service (Minikube)
minikube service frontend-ui -n red-shopping --url

# Ouvrir un service dans le navigateur
minikube service frontend-ui -n red-shopping

# Port-forward pour accéder localement
kubectl port-forward deployment/api-gateway 8000:8000 -n red-shopping
```

### Déploiements et mises à jour

```powershell
# Lister les deployments
kubectl get deployments -n red-shopping

# Scaler un deployment
kubectl scale deployment api-gateway --replicas=3 -n red-shopping

# Redémarrer un deployment
kubectl rollout restart deployment/api-gateway -n red-shopping

# Voir le statut d'un rollout
kubectl rollout status deployment/api-gateway -n red-shopping

# Historique des rollouts
kubectl rollout history deployment/api-gateway -n red-shopping

# Rollback
kubectl rollout undo deployment/api-gateway -n red-shopping
```

### ConfigMaps et Secrets

```powershell
# Voir les configmaps
kubectl get configmap -n red-shopping

# Voir le contenu d'une configmap
kubectl describe configmap service-config -n red-shopping

# Voir les secrets (encodés)
kubectl get secrets -n red-shopping

# Décoder un secret
kubectl get secret database-secrets -n red-shopping -o jsonpath='{.data.jwt-secret}' | base64 --decode
```

### Persistent Volumes

```powershell
# Voir les PVC
kubectl get pvc -n red-shopping

# Détails d'un PVC
kubectl describe pvc postgres-products-pvc -n red-shopping

# Voir les PV
kubectl get pv
```

### Monitoring et debug

```powershell
# Événements récents
kubectl get events -n red-shopping --sort-by='.lastTimestamp'

# Événements avec watch
kubectl get events -n red-shopping -w

# Utilisation des ressources (nécessite metrics-server)
kubectl top pods -n red-shopping
kubectl top nodes

# Informations sur le cluster
kubectl cluster-info
kubectl get nodes
```

### Commandes de dépannage

```powershell
# Vérifier si un service répond
kubectl exec -it deployment/api-gateway -n red-shopping -- curl http://product-service:8001/health

# Tester la connectivité DNS
kubectl exec -it deployment/api-gateway -n red-shopping -- nslookup product-service

# Voir la configuration d'un deployment
kubectl get deployment api-gateway -n red-shopping -o yaml

# Éditer un deployment en direct
kubectl edit deployment api-gateway -n red-shopping
```

## 🔧 Docker (général)

### Images

```powershell
# Lister les images
docker images

# Filtrer par nom
docker images | Select-String "red-shopping"

# Supprimer une image
docker rmi <image-id>

# Supprimer toutes les images non utilisées
docker image prune -a

# Construire une image manuellement
docker build -t red-shopping-api-gateway:latest ./microservices/api-gateway
```

### Conteneurs

```powershell
# Lister tous les conteneurs
docker ps -a

# Arrêter un conteneur
docker stop <container-id>

# Supprimer un conteneur
docker rm <container-id>

# Supprimer tous les conteneurs arrêtés
docker container prune
```

### Volumes

```powershell
# Lister les volumes
docker volume ls

# Supprimer un volume
docker volume rm <volume-name>

# Supprimer tous les volumes non utilisés
docker volume prune
```

### Réseau

```powershell
# Lister les réseaux
docker network ls

# Inspecter un réseau
docker network inspect <network-name>
```

## 🗄️ Base de données

### PostgreSQL (Products)

```powershell
# Docker Compose
docker-compose exec postgres-products psql -U postgres -d products_db

# Kubernetes
kubectl exec -it deployment/postgres-products -n red-shopping -- psql -U postgres -d products_db

# Commandes SQL utiles :
# \l                  Liste des databases
# \c products_db      Se connecter à une DB
# \dt                 Liste des tables
# SELECT * FROM products;
```

### PostgreSQL (Orders)

```powershell
# Docker Compose
docker-compose exec postgres-orders psql -U postgres -d orders_db

# Kubernetes
kubectl exec -it deployment/postgres-orders -n red-shopping -- psql -U postgres -d orders_db
```

### MongoDB (Users)

```powershell
# Docker Compose
docker-compose exec mongodb mongosh users_db

# Kubernetes
kubectl exec -it deployment/mongodb -n red-shopping -- mongosh users_db

# Commandes MongoDB utiles :
# show dbs            Liste des databases
# use users_db        Utiliser une DB
# show collections    Liste des collections
# db.users.find()     Voir tous les users
```

### Redis

```powershell
# Docker Compose
docker-compose exec redis redis-cli

# Kubernetes
kubectl exec -it deployment/redis -n red-shopping -- redis-cli

# Commandes Redis :
# KEYS *              Toutes les clés
# GET <key>           Voir une valeur
# FLUSHALL            Vider tout (attention!)
```

## 👨‍💼 Administration

### Créer l'utilisateur admin

```powershell
# Docker Compose
docker exec -it red-shopping-user-service node src/scripts/create-admin.js

# Kubernetes
kubectl exec -it deployment/user-service -n red-shopping -- node src/scripts/create-admin.js
```

Credentials :
- Email : `admin@redshoping.com`
- Password : `admin123`

## 🔄 Workflow de développement

### Modifier du code et tester

#### Avec Docker Compose

```powershell
# 1. Modifier le code dans microservices/<service>/

# 2. Reconstruire et redémarrer
docker-compose up -d --build <service-name>

# 3. Voir les logs
docker-compose logs -f <service-name>
```

#### Avec Minikube

```powershell
# 1. Configurer Docker pour Minikube
& minikube -p minikube docker-env --shell powershell | Invoke-Expression

# 2. Modifier le code dans microservices/<service>/

# 3. Mettre à jour
.\scripts\update-service.ps1 -ServiceName <service-name>

# 4. Voir les logs
kubectl logs -f deployment/<service-name> -n red-shopping
```

## 🧹 Nettoyage complet

```powershell
# Docker Compose
docker-compose down -v
docker system prune -a

# Kubernetes
kubectl delete namespace red-shopping
minikube delete

# Tout supprimer (Docker)
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)
docker rmi $(docker images -q)
docker volume prune -f
docker network prune -f
```

## 📚 Ressources

- [Documentation Docker](https://docs.docker.com/)
- [Docker Compose CLI](https://docs.docker.com/compose/reference/)
- [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
- [Minikube Commands](https://minikube.sigs.k8s.io/docs/commands/)
