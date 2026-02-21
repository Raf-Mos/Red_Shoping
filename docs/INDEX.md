# 📚 Documentation Red Shopping

Bienvenue dans la documentation complète du projet Red Shopping !

## 🎯 Par où commencer ?

### 👨‍💻 Je veux juste tester l'application rapidement
→ **[Quick Start Docker Compose](../README.md#environnement-local)** (5 minutes)
```powershell
docker-compose up -d
```

### ☸️ Je veux apprendre Kubernetes avec Minikube
→ **[Quick Start Minikube](QUICK-START-MINIKUBE.md)** (10-15 minutes)
```powershell
.\scripts\start-minikube.ps1
.\scripts\deploy-minikube.ps1
```

### 🏢 Je dois déployer en production
→ **Guide de déploiement AWS** (à venir)
→ Voir [infrastructure/](../infrastructure/) pour Terraform

---

## 📖 Documentation complète

### Guides de déploiement

| Document | Description | Temps lecture | Pour qui ? |
|----------|-------------|---------------|------------|
| **[QUICK-START-MINIKUBE.md](QUICK-START-MINIKUBE.md)** | Démarrage rapide Kubernetes | 5 min | Débutants Kubernetes |
| **[MINIKUBE-DEPLOYMENT.md](MINIKUBE-DEPLOYMENT.md)** | Guide complet Minikube | 15 min | Tous |
| **[DOCKER-VS-KUBERNETES.md](DOCKER-VS-KUBERNETES.md)** | Comparaison détaillée | 10 min | Indécis |
| **[KUBERNETES-MIGRATION.md](KUBERNETES-MIGRATION.md)** | Explication de la migration | 15 min | DevOps |
| **[CHEATSHEET.md](CHEATSHEET.md)** | Aide-mémoire commandes | Référence | Tous |

### Documentation technique

| Document | Description | Pour qui ? |
|----------|-------------|------------|
| **[admin-guide.md](admin-guide.md)** | Guide administrateur | Admin app |
| **[API.md](../microservices/api-gateway/API.md)** | Documentation API | Développeurs |
| **[SUMMARY-KUBERNETES-ADAPTATION.md](SUMMARY-KUBERNETES-ADAPTATION.md)** | Résumé des changements K8s | DevOps/Review |

---

## 🚀 Guides par cas d'usage

### Je veux développer une nouvelle fonctionnalité

1. **Démarrer l'environnement de dev**
   ```powershell
   docker-compose up -d
   ```

2. **Modifier le code** dans `microservices/<service>/`

3. **Redémarrer le service**
   ```powershell
   docker-compose restart <service-name>
   ```

4. **Voir les logs**
   ```powershell
   docker-compose logs -f <service-name>
   ```

📖 Voir : [CHEATSHEET.md - Workflow de développement](CHEATSHEET.md#-workflow-de-développement)

---

### Je veux tester Kubernetes localement

1. **[Installer les prérequis](QUICK-START-MINIKUBE.md#-prérequis)**
   - Docker Desktop
   - Minikube
   - kubectl

2. **[Démarrer Minikube](QUICK-START-MINIKUBE.md#étape-1--démarrer-minikube-2-3-minutes)**
   ```powershell
   .\scripts\start-minikube.ps1
   ```

3. **[Déployer l'application](QUICK-START-MINIKUBE.md#étape-3--déployer-sur-kubernetes-2-3-minutes)**
   ```powershell
   .\scripts\deploy-minikube.ps1
   ```

📖 Voir : [QUICK-START-MINIKUBE.md](QUICK-START-MINIKUBE.md)

---

### Je veux comprendre l'architecture Kubernetes

1. **Lire la vue d'ensemble**
   - [KUBERNETES-MIGRATION.md - Architecture](KUBERNETES-MIGRATION.md#-architecture-kubernetes)

2. **Comprendre les différences avec Docker Compose**
   - [DOCKER-VS-KUBERNETES.md - Différences clés](DOCKER-VS-KUBERNETES.md#-vue-densemble)

3. **Explorer les manifests**
   - [kubernetes/README.md](../kubernetes/README.md)

📖 Voir : [KUBERNETES-MIGRATION.md](KUBERNETES-MIGRATION.md)

---

### Je veux déployer en production (AWS)

1. **Comprendre l'architecture cible**
   - [README.md - Architecture](../README.md#️-architecture)

2. **Préparer l'infrastructure**
   - Terraform dans `infrastructure/`
   - AWS EKS, RDS, ElastiCache

3. **Adapter les manifests**
   - Changer `imagePullPolicy`
   - Configurer le registry (ECR)
   - Adapter le `storageClass`

📖 Voir : [KUBERNETES-MIGRATION.md - Modifications pour le cloud](KUBERNETES-MIGRATION.md#-modifications-nécessaires-pour-le-cloud)

---

### Je veux gérer l'application en tant qu'admin

1. **Créer un compte admin**
   ```powershell
   docker exec -it red-shopping-user-service node src/scripts/create-admin.js
   ```

2. **Se connecter**
   - Email : `admin@redshoping.com`
   - Password : `admin123`

3. **Gérer les produits et commandes**
   - Dashboard : `/admin`
   - Produits : `/admin/products`
   - Commandes : `/admin/orders`

📖 Voir : [admin-guide.md](admin-guide.md)

---

## 🔍 Recherche rapide

### Commandes fréquentes

| Besoin | Docker Compose | Kubernetes |
|--------|----------------|------------|
| **Démarrer tout** | `docker-compose up -d` | `.\scripts\deploy-minikube.ps1` |
| **Voir les logs** | `docker-compose logs -f <service>` | `kubectl logs -f deployment/<service> -n red-shopping` |
| **Redémarrer un service** | `docker-compose restart <service>` | `kubectl rollout restart deployment/<service> -n red-shopping` |
| **Arrêter tout** | `docker-compose down` | `.\scripts\cleanup-minikube.ps1` |
| **Voir l'état** | `docker-compose ps` | `kubectl get pods -n red-shopping` |

📖 Voir : [CHEATSHEET.md](CHEATSHEET.md)

---

## 🆘 Troubleshooting

### L'application ne démarre pas

**Docker Compose** :
```powershell
# Voir les logs
docker-compose logs

# Reconstruire
docker-compose build --no-cache
docker-compose up -d
```

**Kubernetes** :
```powershell
# Voir l'état des pods
kubectl get pods -n red-shopping

# Voir les logs d'un pod qui ne démarre pas
kubectl logs <pod-name> -n red-shopping
kubectl describe pod <pod-name> -n red-shopping
```

📖 Voir : 
- [QUICK-START-MINIKUBE.md - Résolution de problèmes](QUICK-START-MINIKUBE.md#-résolution-de-problèmes)
- [MINIKUBE-DEPLOYMENT.md - Troubleshooting](MINIKUBE-DEPLOYMENT.md#-troubleshooting)

---

### Problèmes de connexion entre services

**Vérifier la connectivité** :
```powershell
# Docker Compose
docker-compose exec api-gateway curl http://product-service:8001/health

# Kubernetes
kubectl exec -it deployment/api-gateway -n red-shopping -- curl http://product-service:8001/health
```

📖 Voir : [CHEATSHEET.md - Debugging](CHEATSHEET.md#debugging)

---

### Images Docker non trouvées (Kubernetes)

**Cause** : Docker n'utilise pas le daemon Minikube

**Solution** :
```powershell
& minikube -p minikube docker-env --shell powershell | Invoke-Expression
docker-compose build
```

📖 Voir : [QUICK-START-MINIKUBE.md - ImagePullBackOff](QUICK-START-MINIKUBE.md#problème--imagepullbackoff-sur-les-pods)

---

## 📊 Comparaisons

### Docker Compose vs Kubernetes

| Critère | Docker Compose | Kubernetes |
|---------|---------------|------------|
| **Complexité** | ⭐ Simple | ⭐⭐⭐ Avancé |
| **Ressources** | 2-3 GB RAM | 4+ GB RAM |
| **Production** | ❌ Non | ✅ Oui |
| **Apprentissage** | 1-2 heures | 1-2 jours |

📖 Voir : [DOCKER-VS-KUBERNETES.md](DOCKER-VS-KUBERNETES.md)

---

## 🎓 Parcours d'apprentissage

### Niveau 1 : Débutant
1. ✅ Démarrer avec Docker Compose
2. ✅ Comprendre l'architecture microservices
3. ✅ Modifier du code et tester

**Documentation** : 
- [README.md](../README.md)
- [CHEATSHEET.md - Docker Compose](CHEATSHEET.md#-docker-compose)

---

### Niveau 2 : Intermédiaire
1. ✅ Installer Minikube
2. ✅ Déployer sur Kubernetes
3. ✅ Comprendre les concepts K8s (pods, services, deployments)

**Documentation** :
- [QUICK-START-MINIKUBE.md](QUICK-START-MINIKUBE.md)
- [DOCKER-VS-KUBERNETES.md](DOCKER-VS-KUBERNETES.md)

---

### Niveau 3 : Avancé
1. ✅ Comprendre la migration Docker → K8s
2. ✅ Modifier les manifests Kubernetes
3. ✅ Scaler les services
4. ✅ Configurer le monitoring

**Documentation** :
- [KUBERNETES-MIGRATION.md](KUBERNETES-MIGRATION.md)
- [MINIKUBE-DEPLOYMENT.md](MINIKUBE-DEPLOYMENT.md)
- [kubernetes/README.md](../kubernetes/README.md)

---

### Niveau 4 : Expert
1. ✅ Préparer le déploiement production
2. ✅ Infrastructure as Code (Terraform)
3. ✅ CI/CD avec GitLab
4. ✅ Monitoring Prometheus + Grafana

**Documentation** :
- [infrastructure/](../infrastructure/)
- AWS EKS documentation (à venir)

---

## 📁 Structure du projet

```
Red_Shoping/
├── docs/                           # 📚 Toute la documentation
│   ├── QUICK-START-MINIKUBE.md    # 🚀 Démarrage rapide K8s
│   ├── MINIKUBE-DEPLOYMENT.md     # 📖 Guide complet Minikube
│   ├── DOCKER-VS-KUBERNETES.md    # ⚖️ Comparaison
│   ├── KUBERNETES-MIGRATION.md    # 🔄 Migration expliquée
│   ├── CHEATSHEET.md              # 📝 Aide-mémoire
│   ├── admin-guide.md             # 👨‍💼 Guide admin
│   └── SUMMARY-*.md               # 📋 Résumés
│
├── kubernetes/                     # ☸️ Manifests Kubernetes
│   ├── README.md                  # Guide manifests
│   ├── namespaces/                # Namespace
│   ├── secrets/                   # Credentials
│   ├── configmaps/                # Configuration
│   ├── deployments/               # Deployments + Services
│   └── ingress/                   # Ingress
│
├── scripts/                        # 🔨 Scripts automation
│   ├── start-minikube.ps1         # Démarrer Minikube
│   ├── deploy-minikube.ps1        # Déployer l'app
│   ├── cleanup-minikube.ps1       # Nettoyer
│   └── update-service.ps1         # Maj un service
│
├── microservices/                  # 🔧 Code application
│   ├── frontend-ui/               # React
│   ├── api-gateway/               # Node.js
│   ├── product-service/           # Flask
│   ├── user-service/              # Node.js
│   ├── order-service/             # Flask
│   └── notification-service/      # Flask
│
├── infrastructure/                 # 🏗️ Terraform AWS
├── monitoring/                     # 📊 Prometheus/Grafana
├── tests/                          # 🧪 Tests
├── docker-compose.yml              # 🐳 Orchestration locale
└── README.md                       # 📄 README principal
```

---

## 🔗 Liens externes utiles

### Kubernetes
- [Documentation officielle Kubernetes](https://kubernetes.io/docs/)
- [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
- [Kubernetes Patterns](https://k8spatterns.io/)

### Minikube
- [Minikube Documentation](https://minikube.sigs.k8s.io/docs/)
- [Minikube Handbook](https://minikube.sigs.k8s.io/docs/handbook/)

### Docker
- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Reference](https://docs.docker.com/compose/compose-file/)

### Cloud Providers
- [AWS EKS](https://aws.amazon.com/eks/)
- [Azure AKS](https://azure.microsoft.com/en-us/services/kubernetes-service/)
- [Google GKE](https://cloud.google.com/kubernetes-engine)

---

## 💡 Conseils généraux

1. ✅ **Commencez simple** : Docker Compose d'abord
2. ✅ **Progressez graduellement** : Minikube ensuite
3. ✅ **Lisez les logs** : Ils contiennent les réponses
4. ✅ **Utilisez les scripts** : Ils simplifient la vie
5. ✅ **Consultez la doc** : Elle est là pour vous aider

---

## 📞 Besoin d'aide ?

1. **Vérifiez la documentation pertinente** (voir ci-dessus)
2. **Consultez le troubleshooting** dans chaque guide
3. **Regardez les logs** de vos services
4. **Utilisez le cheatsheet** pour les commandes

---

**Bon développement ! 🚀**

*Dernière mise à jour : $(Get-Date -Format "dd/MM/yyyy")*
