# Guide de Migration vers Kubernetes

Ce guide explique comment l'architecture Docker Compose a été adaptée pour Kubernetes/Minikube.

## 📁 Structure des fichiers créés

### Manifests Kubernetes (`kubernetes/`)

```
kubernetes/
├── namespaces/
│   └── namespace.yaml              # Namespace 'red-shopping' pour isoler les ressources
├── secrets/
│   └── secrets.yaml                # Credentials (DB passwords, JWT secret, RabbitMQ)
├── configmaps/
│   └── configmap.yaml              # Configuration des services (URLs, env vars)
├── deployments/
│   ├── postgres-products.yaml      # PostgreSQL pour les produits + PVC
│   ├── postgres-orders.yaml        # PostgreSQL pour les commandes + PVC
│   ├── mongodb.yaml                # MongoDB pour les utilisateurs + PVC
│   ├── redis.yaml                  # Redis pour le cache
│   ├── rabbitmq.yaml               # RabbitMQ pour les messages
│   ├── product-service.yaml        # Service produits (Flask)
│   ├── user-service.yaml           # Service utilisateurs (Node.js)
│   ├── order-service.yaml          # Service commandes (Flask)
│   ├── notification-service.yaml   # Service notifications (Flask)
│   ├── api-gateway.yaml           # API Gateway (Node.js) - NodePort 30800
│   └── frontend-ui.yaml           # Frontend React - NodePort 30300
└── ingress/
    └── ingress.yaml                # Ingress pour exposer l'app (optionnel)
```

### Scripts PowerShell (`scripts/`)

```
scripts/
├── start-minikube.ps1              # Démarre Minikube avec config optimale
├── deploy-minikube.ps1             # Déploiement complet automatisé
├── cleanup-minikube.ps1            # Suppression de tous les déploiements
└── update-service.ps1              # Met à jour un service spécifique
```

### Documentation (`docs/`)

```
docs/
├── MINIKUBE-DEPLOYMENT.md          # Guide complet de déploiement Minikube
└── DOCKER-VS-KUBERNETES.md         # Comparaison des deux approches
```

## 🔄 Correspondance Docker Compose → Kubernetes

### Services Base de données

| Docker Compose | Kubernetes | Notes |
|---------------|------------|-------|
| `postgres-products` | `postgres-products.yaml` | Ajout d'un PVC 1Gi |
| `postgres-orders` | `postgres-orders.yaml` | Ajout d'un PVC 1Gi |
| `mongodb` | `mongodb.yaml` | Ajout d'un PVC 1Gi |
| `redis` | `redis.yaml` | Pas de persistance |
| `rabbitmq` | `rabbitmq.yaml` | ClusterIP interne |

### Services Application

| Docker Compose | Kubernetes | Type Service |
|---------------|------------|--------------|
| `product-service` | `product-service.yaml` | ClusterIP |
| `user-service` | `user-service.yaml` | ClusterIP |
| `order-service` | `order-service.yaml` | ClusterIP |
| `notification-service` | `notification-service.yaml` | ClusterIP |
| `api-gateway` | `api-gateway.yaml` | **NodePort 30800** |
| `frontend-ui` | `frontend-ui.yaml` | **NodePort 30300** |

## 🔑 Différences clés

### 1. Gestion des secrets

**Docker Compose:**
```yaml
environment:
  - JWT_SECRET=your-super-secret-jwt-key
```

**Kubernetes:**
```yaml
env:
- name: JWT_SECRET
  valueFrom:
    secretKeyRef:
      name: database-secrets
      key: jwt-secret
```

### 2. Networking

**Docker Compose:**
- 3 réseaux : `frontend-network`, `backend-network`, `database-network`
- Segmentation avec `internal: true`

**Kubernetes:**
- 1 namespace : `red-shopping`
- Service discovery automatique via DNS
- Network policies (à ajouter pour sécurité avancée)

### 3. Volumes

**Docker Compose:**
```yaml
volumes:
  postgres-products-data:
```

**Kubernetes:**
```yaml
kind: PersistentVolumeClaim
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
```

### 4. Exposition des services

**Docker Compose:**
```yaml
ports:
  - "3000:3000"
  - "8000:8000"
```

**Kubernetes:**
```yaml
spec:
  type: NodePort
  ports:
  - port: 3000
    targetPort: 3000
    nodePort: 30300
```

Accès via : `minikube service frontend-ui -n red-shopping`

## 🚀 Workflow de déploiement

### 1. Préparation (une fois)

```powershell
# Installer Minikube
choco install minikube

# Installer kubectl
choco install kubernetes-cli
```

### 2. Démarrage (à chaque session)

```powershell
# Démarrer Minikube
.\scripts\start-minikube.ps1

# Configurer Docker pour Minikube
& minikube -p minikube docker-env --shell powershell | Invoke-Expression

# Construire les images
docker-compose build
```

### 3. Déploiement

```powershell
# Déploiement automatique
.\scripts\deploy-minikube.ps1

# OU manuel étape par étape
kubectl apply -f kubernetes/namespaces/namespace.yaml
kubectl apply -f kubernetes/secrets/secrets.yaml
kubectl apply -f kubernetes/configmaps/configmap.yaml
kubectl apply -f kubernetes/deployments/
```

### 4. Accès

```powershell
# Obtenir les URLs
minikube service frontend-ui -n red-shopping --url
minikube service api-gateway -n red-shopping --url

# Ouvrir dans le navigateur
minikube service frontend-ui -n red-shopping
```

### 5. Développement (mise à jour d'un service)

```powershell
# Modifier le code dans microservices/<service-name>/

# Mettre à jour le service
.\scripts\update-service.ps1 -ServiceName <service-name>

# Exemples:
.\scripts\update-service.ps1 -ServiceName api-gateway
.\scripts\update-service.ps1 -ServiceName frontend-ui
```

### 6. Nettoyage

```powershell
# Supprimer tous les déploiements
.\scripts\cleanup-minikube.ps1

# Arrêter Minikube
minikube stop

# Supprimer complètement (si besoin)
minikube delete
```

## 📊 Avantages de cette migration

### ✅ Pour le développement

1. **Environnement identique à la production**
   - Même configuration que AWS EKS
   - Test des manifests avant déploiement

2. **Apprentissage Kubernetes**
   - Pratique avec kubectl
   - Compréhension des concepts K8s

3. **Tests réalistes**
   - Service discovery
   - Health checks
   - Rolling updates

### ✅ Pour la production

1. **Deployment simplifié AWS EKS**
   - Mêmes manifests YAML
   - Changement uniquement : `imagePullPolicy`, `storageClass`, `Ingress`

2. **Scalabilité**
   - Ajout de replicas : `kubectl scale deployment api-gateway --replicas=3`
   - Horizontal Pod Autoscaler (HPA)

3. **Haute disponibilité**
   - Self-healing automatique
   - Rolling updates sans downtime

## 🔧 Personnalisation

### Ajouter des replicas

Éditez les deployments :

```yaml
spec:
  replicas: 3  # Au lieu de 1
```

### Ajouter des limites de ressources

```yaml
resources:
  requests:
    memory: "256Mi"
    cpu: "250m"
  limits:
    memory: "512Mi"
    cpu: "500m"
```

### Activer l'Ingress (optionnel)

```powershell
# Activer l'addon ingress
minikube addons enable ingress

# Déployer l'ingress
kubectl apply -f kubernetes/ingress/ingress.yaml

# Ajouter à hosts (en admin)
echo "$(minikube ip) red-shopping.local" | Out-File -Append C:\Windows\System32\drivers\etc\hosts

# Accéder via http://red-shopping.local
```

## 📈 Monitoring

### Dashboard Kubernetes

```powershell
minikube dashboard
```

### Metrics

```powershell
# Activer metrics-server
minikube addons enable metrics-server

# Voir l'utilisation
kubectl top pods -n red-shopping
kubectl top nodes
```

### Logs

```powershell
# Logs d'un deployment
kubectl logs -f deployment/api-gateway -n red-shopping

# Logs de tous les pods d'un service
kubectl logs -l app=api-gateway -n red-shopping --tail=100
```

## 🎯 Prochaines étapes

1. **Network Policies** : Ajouter des règles de sécurité réseau
2. **Resource Quotas** : Limiter l'utilisation des ressources par namespace
3. **HPA** : Auto-scaling basé sur CPU/mémoire
4. **Helm Charts** : Packager l'application pour faciliter le déploiement
5. **GitOps** : CI/CD avec ArgoCD ou Flux

## 🔗 Ressources

- [Documentation Kubernetes](https://kubernetes.io/docs/)
- [Minikube Handbook](https://minikube.sigs.k8s.io/docs/handbook/)
- [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
- [Kubernetes Patterns](https://www.redhat.com/en/resources/oreilly-kubernetes-patterns-cloud-native-apps)
