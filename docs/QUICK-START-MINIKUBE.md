# 🎯 Guide de Démarrage Rapide - Red Shopping sur Minikube

Ce guide vous permet de démarrer Red Shopping sur Kubernetes (Minikube) en quelques minutes.

## ⏱️ Temps estimé : 10-15 minutes

## 📋 Prérequis

Installez les outils suivants (si pas déjà fait) :

### 1. Docker Desktop
```powershell
# Télécharger depuis : https://www.docker.com/products/docker-desktop
# OU avec Chocolatey :
choco install docker-desktop
```

### 2. Minikube
```powershell
# Avec Chocolatey :
choco install minikube

# OU télécharger depuis : https://minikube.sigs.k8s.io/docs/start/
```

### 3. kubectl
```powershell
# Avec Chocolatey :
choco install kubernetes-cli

# OU télécharger depuis : https://kubernetes.io/docs/tasks/tools/
```

### 4. Vérification
```powershell
docker --version
minikube version
kubectl version --client
```

## 🚀 Démarrage en 4 étapes

### Étape 1 : Démarrer Minikube (2-3 minutes)

```powershell
# Dans le dossier du projet
cd C:\Simplon\Red_Shoping

# Démarrer Minikube
.\scripts\start-minikube.ps1
```

Sortie attendue :
```
✅ Minikube démarré avec succès !
✅ Configuration terminée !
```

### Étape 2 : Construire les images Docker (3-5 minutes)

```powershell
# Configurer Docker pour utiliser le daemon Minikube
& minikube -p minikube docker-env --shell powershell | Invoke-Expression

# Construire toutes les images
docker-compose build
```

Sortie attendue :
```
Successfully built [image-id]
Successfully tagged red-shopping-api-gateway:latest
Successfully tagged red-shopping-frontend-ui:latest
...
```

### Étape 3 : Déployer sur Kubernetes (2-3 minutes)

```powershell
# Déploiement automatique
.\scripts\deploy-minikube.ps1
```

Sortie attendue :
```
✅ Minikube est actif
✅ Docker configuré
✅ Toutes les images sont présentes
✅ Bases de données prêtes
✅ Déploiement terminé !

Frontend UI:    http://192.168.49.2:30300
API Gateway:    http://192.168.49.2:30800
```

### Étape 4 : Accéder à l'application

```powershell
# Ouvrir le frontend dans le navigateur
minikube service frontend-ui -n red-shopping
```

🎉 **Félicitations !** L'application est maintenant accessible !

## 🔐 Créer un compte admin

Pour accéder au dashboard admin :

```powershell
kubectl exec -it deployment/user-service -n red-shopping -- node src/scripts/create-admin.js
```

Ensuite, connectez-vous avec :
- **Email** : `admin@redshoping.com`
- **Mot de passe** : `admin123`

## ✅ Vérifier que tout fonctionne

```powershell
# Voir tous les pods (tous doivent être "Running")
kubectl get pods -n red-shopping
```

Sortie attendue :
```
NAME                                     READY   STATUS    RESTARTS   AGE
api-gateway-xxx                          1/1     Running   0          2m
frontend-ui-xxx                          1/1     Running   0          2m
mongodb-xxx                              1/1     Running   0          3m
order-service-xxx                        1/1     Running   0          2m
postgres-orders-xxx                      1/1     Running   0          3m
postgres-products-xxx                    1/1     Running   0          3m
product-service-xxx                      1/1     Running   0          2m
rabbitmq-xxx                             1/1     Running   0          3m
redis-xxx                                1/1     Running   0          3m
user-service-xxx                         1/1     Running   0          2m
```

## 🔧 Commandes utiles

### Voir les logs d'un service
```powershell
kubectl logs -f deployment/api-gateway -n red-shopping
kubectl logs -f deployment/frontend-ui -n red-shopping
```

### Redémarrer un service
```powershell
kubectl rollout restart deployment/api-gateway -n red-shopping
```

### Obtenir les URLs d'accès
```powershell
# Frontend
minikube service frontend-ui -n red-shopping --url

# API Gateway
minikube service api-gateway -n red-shopping --url
```

### Dashboard Kubernetes
```powershell
minikube dashboard
```

## 🛑 Arrêter l'application

### Arrêter Minikube (conserve les données)
```powershell
minikube stop
```

### Supprimer le déploiement (conserve Minikube)
```powershell
.\scripts\cleanup-minikube.ps1
```

### Tout supprimer
```powershell
.\scripts\cleanup-minikube.ps1
minikube delete
```

## 🔄 Redémarrer après un arrêt

```powershell
# 1. Redémarrer Minikube
minikube start

# 2. Reconfigurer Docker
& minikube -p minikube docker-env --shell powershell | Invoke-Expression

# 3. Redéployer (les images sont déjà construites)
.\scripts\deploy-minikube.ps1
```

## 🐛 Résolution de problèmes

### Problème : "Minikube n'est pas démarré"

**Solution :**
```powershell
minikube start --cpus=4 --memory=4096
```

### Problème : "ImagePullBackOff" sur les pods

**Cause** : Les images Docker ne sont pas dans le daemon Minikube

**Solution :**
```powershell
# Reconfigurer Docker
& minikube -p minikube docker-env --shell powershell | Invoke-Expression

# Vérifier que les images sont présentes
docker images | Select-String "red-shopping"

# Si aucune image n'apparaît, reconstruire
docker-compose build
```

### Problème : Pods en "CrashLoopBackOff"

**Solution :**
```powershell
# Voir les logs pour identifier le problème
kubectl logs <pod-name> -n red-shopping

# Redémarrer le déploiement
kubectl rollout restart deployment/<service-name> -n red-shopping
```

### Problème : "Connection refused" entre services

**Cause** : Les bases de données ne sont pas encore prêtes

**Solution :**
```powershell
# Attendre 1-2 minutes que les DBs démarrent
kubectl get pods -n red-shopping -w

# Tous les pods doivent être "Running" avec "1/1" READY
```

### Problème : Pas assez de ressources

**Solution :**
```powershell
# Arrêter d'autres applications
# Ou allouer plus de mémoire à Minikube
minikube delete
minikube start --cpus=4 --memory=8192  # 8GB au lieu de 4GB
```

## 📖 Documentation complète

Pour aller plus loin :

- **[Guide complet Minikube](MINIKUBE-DEPLOYMENT.md)** - Documentation détaillée
- **[Migration Kubernetes](KUBERNETES-MIGRATION.md)** - Explications sur l'architecture
- **[Docker vs Kubernetes](DOCKER-VS-KUBERNETES.md)** - Comparaison des approches
- **[Cheatsheet](CHEATSHEET.md)** - Toutes les commandes utiles

## 💡 Conseils

1. ✅ Utilisez toujours les scripts PowerShell fournis (plus simple)
2. ✅ Vérifiez que Docker Desktop est démarré avant Minikube
3. ✅ Attendez que les bases de données soient prêtes avant les services
4. ✅ Utilisez `kubectl get pods -n red-shopping` pour vérifier l'état
5. ✅ Les logs sont votre meilleur ami pour le debugging

## 🎓 Prochaines étapes

Une fois l'application déployée, vous pouvez :

1. **Tester l'application**
   - Créer un compte utilisateur
   - Naviguer dans le catalogue produits
   - Ajouter au panier et passer commande
   - Se connecter en admin et gérer les produits

2. **Modifier du code**
   ```powershell
   # Modifier le code dans microservices/<service>/
   .\scripts\update-service.ps1 -ServiceName <service-name>
   ```

3. **Explorer Kubernetes**
   ```powershell
   kubectl get all -n red-shopping
   kubectl describe pod <pod-name> -n red-shopping
   minikube dashboard
   ```

4. **Scaler un service**
   ```powershell
   kubectl scale deployment api-gateway --replicas=3 -n red-shopping
   ```

## ❓ Besoin d'aide ?

- Consultez les [logs](#voir-les-logs-dun-service)
- Vérifiez la [résolution de problèmes](#-résolution-de-problèmes)
- Lisez la [documentation complète](MINIKUBE-DEPLOYMENT.md)

---

**Bon développement ! 🚀**
