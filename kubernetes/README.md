# Kubernetes Configuration pour Red Shopping

Ce dossier contient tous les manifests Kubernetes nécessaires pour déployer Red Shopping sur Minikube ou n'importe quel cluster Kubernetes.

## 📁 Structure

```
kubernetes/
├── namespaces/          # Définition du namespace
├── secrets/             # Credentials et clés sensibles
├── configmaps/          # Configuration des services
├── deployments/         # Deployments et Services pour chaque composant
└── ingress/            # Ingress pour exposition (optionnel)
```

## 🚀 Déploiement rapide

### Avec les scripts PowerShell (recommandé)

```powershell
# Tout en un
.\scripts\deploy-minikube.ps1
```

### Manuel

```powershell
# 1. Namespace
kubectl apply -f namespaces/

# 2. Configuration
kubectl apply -f secrets/
kubectl apply -f configmaps/

# 3. Infrastructure
kubectl apply -f deployments/postgres-products.yaml
kubectl apply -f deployments/postgres-orders.yaml
kubectl apply -f deployments/mongodb.yaml
kubectl apply -f deployments/redis.yaml
kubectl apply -f deployments/rabbitmq.yaml

# Attendre que les DBs soient prêtes
kubectl wait --for=condition=ready pod -l app=postgres-products -n red-shopping --timeout=120s
kubectl wait --for=condition=ready pod -l app=postgres-orders -n red-shopping --timeout=120s
kubectl wait --for=condition=ready pod -l app=mongodb -n red-shopping --timeout=120s

# 4. Services applicatifs
kubectl apply -f deployments/product-service.yaml
kubectl apply -f deployments/user-service.yaml
kubectl apply -f deployments/order-service.yaml
kubectl apply -f deployments/notification-service.yaml

# 5. Gateway et Frontend
kubectl apply -f deployments/api-gateway.yaml
kubectl apply -f deployments/frontend-ui.yaml

# 6. Ingress (optionnel)
kubectl apply -f ingress/
```

## 🔧 Configuration

### Modifier les secrets

Éditez `secrets/secrets.yaml` :

```yaml
stringData:
  postgres-password: VotreMotDePasse
  jwt-secret: VotreCleSecrete
```

Appliquez les changements :

```powershell
kubectl apply -f secrets/secrets.yaml
kubectl rollout restart deployment -n red-shopping
```

### Modifier les variables d'environnement

Éditez `configmaps/configmap.yaml` et appliquez :

```powershell
kubectl apply -f configmaps/configmap.yaml
kubectl rollout restart deployment -n red-shopping
```

## 📊 Ordre de déploiement

**Important** : Respectez cet ordre pour éviter les erreurs de dépendances :

1. ✅ Namespace
2. ✅ Secrets & ConfigMaps
3. ✅ Bases de données (postgres, mongodb, redis, rabbitmq)
4. ✅ Services métier (product, user, order, notification)
5. ✅ Gateway & Frontend
6. ✅ Ingress (si utilisé)

## 🔍 Vérification

```powershell
# Vérifier tous les pods
kubectl get pods -n red-shopping

# Vérifier les services
kubectl get svc -n red-shopping

# Vérifier les PVC
kubectl get pvc -n red-shopping

# Événements récents
kubectl get events -n red-shopping --sort-by='.lastTimestamp'
```

## 🌐 Accès aux services

### NodePort (Minikube)

```powershell
# Frontend
minikube service frontend-ui -n red-shopping

# API Gateway
minikube service api-gateway -n red-shopping
```

### Ingress (si activé)

```powershell
# Activer l'addon
minikube addons enable ingress

# Obtenir l'IP Minikube
minikube ip

# Ajouter à hosts
echo "$(minikube ip) red-shopping.local" | Out-File -Append C:\Windows\System32\drivers\etc\hosts

# Accès : http://red-shopping.local
```

## 🔄 Mise à jour d'un service

```powershell
# Méthode 1 : Script automatique
.\scripts\update-service.ps1 -ServiceName api-gateway

# Méthode 2 : Manuel
kubectl rollout restart deployment/api-gateway -n red-shopping
kubectl rollout status deployment/api-gateway -n red-shopping
```

## 🗑️ Suppression

```powershell
# Supprimer tout le namespace
kubectl delete namespace red-shopping

# OU utiliser le script
.\scripts\cleanup-minikube.ps1
```

## 📝 Notes importantes

### Images Docker

Les deployments utilisent `imagePullPolicy: Never` pour Minikube (images locales).

Pour un cluster réel :
1. Changez `imagePullPolicy: IfNotPresent` ou `Always`
2. Poussez les images vers un registry (Docker Hub, AWS ECR, etc.)
3. Mettez à jour les noms d'images avec le registry :
   ```yaml
   image: <registry>/red-shopping-api-gateway:v1.0.0
   ```

### Persistent Storage

Les PVC utilisent le `storageClass` par défaut de Minikube.

Pour AWS EKS, utilisez :
```yaml
storageClassName: gp3  # ou ebs-sc
```

### Scalabilité

Pour scaler un déploiement :

```powershell
# Augmenter le nombre de replicas
kubectl scale deployment api-gateway --replicas=3 -n red-shopping

# Retour à 1 replica
kubectl scale deployment api-gateway --replicas=1 -n red-shopping
```

### Health Checks

À ajouter dans les deployments :

```yaml
livenessProbe:
  httpGet:
    path: /health
    port: 8000
  initialDelaySeconds: 30
  periodSeconds: 10

readinessProbe:
  httpGet:
    path: /ready
    port: 8000
  initialDelaySeconds: 10
  periodSeconds: 5
```

## 🔐 Sécurité

### Best Practices

1. **Secrets** : Ne jamais commit les secrets dans Git
2. **RBAC** : Créer des ServiceAccounts avec permissions limitées
3. **Network Policies** : Isoler les communications entre pods
4. **Pod Security** : Utiliser SecurityContext

### Exemple Network Policy

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: api-gateway-policy
  namespace: red-shopping
spec:
  podSelector:
    matchLabels:
      app: api-gateway
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: frontend-ui
  egress:
  - to:
    - podSelector:
        matchLabels:
          app: product-service
    - podSelector:
        matchLabels:
          app: user-service
    - podSelector:
        matchLabels:
          app: order-service
```

## 📚 Documentation

- [Guide de déploiement Minikube](../docs/MINIKUBE-DEPLOYMENT.md)
- [Migration Docker → Kubernetes](../docs/KUBERNETES-MIGRATION.md)
- [Comparaison Docker vs Kubernetes](../docs/DOCKER-VS-KUBERNETES.md)

## 🆘 Troubleshooting

### Pods en CrashLoopBackOff

```powershell
# Voir les logs
kubectl logs <pod-name> -n red-shopping

# Voir les événements
kubectl describe pod <pod-name> -n red-shopping
```

### ImagePullBackOff

```powershell
# Vérifier que Docker utilise le daemon Minikube
& minikube -p minikube docker-env --shell powershell | Invoke-Expression

# Lister les images
docker images | Select-String "red-shopping"

# Reconstruire si nécessaire
docker-compose build
```

### Service inaccessible

```powershell
# Vérifier le service
kubectl get svc -n red-shopping

# Tester depuis un pod
kubectl exec -it deployment/api-gateway -n red-shopping -- sh
# Puis dans le pod :
# curl http://product-service:8001/health
```
