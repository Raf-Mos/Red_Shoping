# 🚀 GitLab CI/CD Pipeline - Red Shopping

Guide de configuration et utilisation du pipeline CI/CD pour Red Shopping.

---

## 📋 Table des Matières

- [Vue d'ensemble](#vue-densemble)
- [Configuration GitLab](#configuration-gitlab)
- [Variables d'environnement](#variables-denvironnement)
- [Stages du Pipeline](#stages-du-pipeline)
- [Déploiement](#déploiement)
- [Troubleshooting](#troubleshooting)

---

## 🎯 Vue d'ensemble

Le pipeline CI/CD automatise :

- ✅ **Build** - Construction des images Docker pour tous les microservices
- ✅ **Test** - Exécution des tests unitaires et d'intégration
- ✅ **Deploy** - Déploiement sur Kubernetes (staging/production)
- ✅ **Rollback** - Retour à la version précédente si nécessaire

### Architecture du Pipeline

```
┌─────────────────────────────────────────────────────────┐
│                       STAGES                            │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  BUILD                TEST              DEPLOY          │
│  ┌─────────┐         ┌─────────┐      ┌──────────┐     │
│  │ Frontend│────────▶│ Frontend│      │ Staging  │     │
│  │ API GW  │         │ API GW  │      │          │     │
│  │ Product │         │ Product │────▶ │ Docker   │     │
│  │ User    │         │ User    │      │ Compose  │     │
│  │ Order   │         │ Order   │      │          │     │
│  │ Notif   │         │ Notif   │      │Production│     │
│  └─────────┘         └─────────┘      └──────────┘     │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## ⚙️ Configuration GitLab

### 1. Activer GitLab Container Registry

Dans votre projet GitLab :
1. Allez dans **Settings** > **General** > **Visibility, project features, permissions**
2. Activez **Container Registry**

### 2. Configurer GitLab Runner

**Option A: Utiliser les Shared Runners de GitLab**
- Activez les shared runners dans **Settings** > **CI/CD** > **Runners**

**Option B: Installer un runner dédié**

```bash
# Sur Linux/macOS
sudo gitlab-runner register

# Sur Windows (PowerShell Admin)
gitlab-runner register
```

**Configuration du runner:**
- URL: https://gitlab.com/
- Token: Trouvé dans **Settings** > **CI/CD** > **Runners**
- Executor: `docker`
- Default image: `docker:24-dind`

---

## 🔐 Variables d'environnement

Configurez ces variables dans **Settings** > **CI/CD** > **Variables** :

### Variables Obligatoires

| Variable | Description | Type | Exemple |
|----------|-------------|------|---------|
| `CI_REGISTRY` | URL du registry Docker | Variable | `registry.gitlab.com` |
| `CI_REGISTRY_USER` | Username GitLab | Variable | `gitlab-ci-token` |
| `CI_REGISTRY_PASSWORD` | Token d'accès | Masked | `${CI_JOB_TOKEN}` |

### Variables Kubernetes

| Variable | Description | Type | Protection |
|----------|-------------|------|-----------|
| `KUBE_CONFIG_STAGING` | Kubeconfig staging (base64) | File | Protected |
| `KUBE_CONFIG_PROD` | Kubeconfig production (base64) | File | Protected |
| `K8S_NAMESPACE` | Namespace Kubernetes | Variable | `red-shopping` |

### Variables Secrets

| Variable | Description | Type | Protection |
|----------|-------------|------|-----------|
| `JWT_SECRET` | Secret JWT | Masked | Protected |
| `POSTGRES_PASSWORD` | Mot de passe PostgreSQL | Masked | Protected |
| `RABBITMQ_PASSWORD` | Mot de passe RabbitMQ | Masked | Protected |

### Générer KUBE_CONFIG (base64)

**Staging:**
```bash
# Encodez votre fichier kubeconfig
cat ~/.kube/config-staging | base64 -w 0

# Ou sur Windows
[Convert]::ToBase64String([System.IO.File]::ReadAllBytes("$HOME\.kube\config-staging"))
```

**Production:**
```bash
cat ~/.kube/config-prod | base64 -w 0
```

---

## 📦 Stages du Pipeline

### Stage 1: BUILD

Construction des images Docker pour chaque microservice modifié.

**Triggered by:**
- Push sur `main` ou `develop`
- Changements dans `microservices/*/` 
- Changements dans `.gitlab-ci.yml`

**Output:**
- Images Docker taguées avec:
  - `$CI_COMMIT_SHORT_SHA` (ex: `abc1234`)
  - `latest`

**Registry:**
```
registry.gitlab.com/username/red-shopping/frontend-ui:latest
registry.gitlab.com/username/red-shopping/api-gateway:abc1234
```

### Stage 2: TEST

Exécution des tests pour chaque service modifié.

**Tests inclus:**
- Linting (ESLint, Pylint)
- Tests unitaires (Jest, Pytest)
- Tests d'intégration avec bases de données

**Services utilisés:**
- PostgreSQL 15
- MongoDB 7
- RabbitMQ 3
- Redis 7

### Stage 3: DEPLOY

Déploiement sur les environnements cibles.

**Environnements disponibles:**

1. **Docker Compose** (`develop` branche)
   - Déploiement sur serveur de développement
   - Utilise `docker-compose.yml`
   - Manual trigger

2. **Staging** (`develop` branche)
   - Déploiement sur cluster Kubernetes staging
   - Mise à jour automatique des deployments
   - Manual trigger

3. **Production** (`main` branche)
   - Déploiement sur cluster Kubernetes production
   - Mise à jour automatique des deployments
   - Manual trigger
   - Nécessite approbation

---

## 🚀 Déploiement

### Workflow Standard

```mermaid
graph LR
    A[Push Code] --> B[Build Images]
    B --> C[Run Tests]
    C --> D{Tests OK?}
    D -->|Yes| E[Manual Deploy]
    D -->|No| F[Fix & Retry]
    E --> G[Staging]
    G --> H{Validate}
    H -->|OK| I[Production]
    H -->|Issues| J[Rollback]
```

### Déploiement Staging

1. Mergez votre branche dans `develop`
2. Le pipeline build et test s'exécute automatiquement
3. Si les tests passent, allez dans **CI/CD** > **Pipelines**
4. Cliquez sur **▶ Play** à côté de `deploy:staging`
5. Vérifiez le déploiement :

```bash
kubectl get pods -n red-shopping
kubectl logs -f deployment/api-gateway -n red-shopping
```

### Déploiement Production

1. Mergez `develop` dans `main`
2. Le pipeline build et test s'exécute
3. Allez dans **CI/CD** > **Pipelines**
4. Cliquez sur **▶ Play** à côté de `deploy:production`
5. Confirmez le déploiement

### Rollback Production

En cas de problème en production:

1. Allez dans **CI/CD** > **Pipelines**
2. Trouvez le dernier pipeline
3. Cliquez sur **▶ Play** à côté de `rollback:production`

Ou manuellement:
```bash
kubectl rollout undo deployment/api-gateway -n red-shopping
```

---

## 🔍 Monitoring du Pipeline

### Vérifier l'état des jobs

```bash
# Via GitLab UI
CI/CD > Pipelines > Sélectionnez le pipeline

# Via CLI
gitlab-runner list
```

### Logs des jobs

**Dans GitLab UI:**
1. Allez dans **CI/CD** > **Pipelines**
2. Cliquez sur le pipeline
3. Cliquez sur le job pour voir les logs

### Vérifier le déploiement Kubernetes

```bash
# Pods status
kubectl get pods -n red-shopping

# Deployment status
kubectl rollout status deployment/api-gateway -n red-shopping

# Logs d'un service
kubectl logs -f deployment/frontend-ui -n red-shopping

# Events
kubectl get events -n red-shopping --sort-by='.lastTimestamp'
```

---

## 🐛 Troubleshooting

### Build échoue

**Problème:** `docker: command not found`
```yaml
# Solution: Vérifier que Docker-in-Docker est activé
services:
  - docker:24-dind
```

**Problème:** `Cannot connect to Docker daemon`
```yaml
# Solution: Vérifier DOCKER_HOST
variables:
  DOCKER_HOST: tcp://docker:2375
```

### Tests échouent

**Problème:** `Cannot connect to database`
```yaml
# Solution: Vérifier que le service est démarré
services:
  - postgres:15-alpine
variables:
  DATABASE_URL: postgresql://postgres:postgres@postgres:5432/test_db
```

### Déploiement échoue

**Problème:** `Unable to connect to the server`
```bash
# Solution: Vérifier KUBE_CONFIG
echo $KUBE_CONFIG_PROD | base64 -d
```

**Problème:** `ImagePullBackOff`
```bash
# Solution: Vérifier que l'image existe dans le registry
kubectl describe pod <pod-name> -n red-shopping
```

### Variables manquantes

**Problème:** Variable non définie
```bash
# Solution: Ajouter dans GitLab
Settings > CI/CD > Variables > Add Variable
```

---

## 📊 Optimisations

### Cache

Le pipeline utilise le cache pour accélérer les builds:

```yaml
cache:
  paths:
    - microservices/frontend-ui/node_modules/
    - .cache/pip
```

### Only/Changes

Les jobs ne s'exécutent que si les fichiers concernés changent:

```yaml
only:
  changes:
    - microservices/frontend-ui/**/*
```

### Parallel Builds

Les microservices sont buildés en parallèle pour gagner du temps.

---

## 📝 Bonnes Pratiques

1. **Toujours tester localement avant de push**
   ```bash
   docker-compose up -d --build
   ```

2. **Utiliser des branches features**
   ```bash
   git checkout -b feature/nouvelle-fonctionnalite
   ```

3. **Pull Request avec review**
   - Ne mergez jamais directement dans `main`
   - Demandez une review de code

4. **Tagging des versions**
   ```bash
   git tag -a v1.0.0 -m "Release 1.0.0"
   git push origin v1.0.0
   ```

5. **Monitoring continu**
   - Vérifiez les logs après chaque déploiement
   - Configurez des alertes Prometheus/Grafana

---

## 🔗 Ressources

- [GitLab CI/CD Documentation](https://docs.gitlab.com/ee/ci/)
- [Docker Documentation](https://docs.docker.com/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Red Shopping API Documentation](./api.md)

---

## 📞 Support

En cas de problème avec le pipeline:

1. Vérifiez les logs du job
2. Consultez la section Troubleshooting
3. Contactez l'équipe DevOps
4. Créez une issue GitLab avec les logs

---

**Créé le:** 26 Février 2026  
**Dernière mise à jour:** 26 Février 2026  
**Version Pipeline:** 1.0.0
