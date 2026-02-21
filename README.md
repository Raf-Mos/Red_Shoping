# Red Shopping - E-commerce Microservices Platform

![Architecture](https://img.shields.io/badge/Architecture-Microservices-blue)
![AWS](https://img.shields.io/badge/Cloud-AWS-orange)
![Kubernetes](https://img.shields.io/badge/Orchestration-Kubernetes-326CE5)
![CI/CD](https://img.shields.io/badge/CI%2FCD-GitLab-FC6D26)

## 📋 Vue d'ensemble

Red Shopping est une plateforme e-commerce moderne déployée sur AWS avec une architecture microservices complète, démontrant l'excellence DevOps/SRE.

## 🏗️ Architecture

### Microservices (6 services)

1. **Frontend UI** (React) - Interface utilisateur
2. **API Gateway** (Node.js/Express) - Point d'entrée, authentification JWT
3. **Product Service** (Python/Flask) - Gestion catalogue produits
4. **User Service** (Node.js/Express) - Authentification, profils utilisateurs
5. **Order Service** (Python/Flask) - Gestion commandes et panier
6. **Notification Service** (Python/Flask) - Notifications asynchrones

### Stack Technologique

**Backend**
- Python 3.11 (Flask)
- Node.js 20 (Express)

**Frontend**
- React 18
- Tailwind CSS

**Bases de données**
- PostgreSQL (Produits)
- MongoDB (Utilisateurs)
- Redis (Cache/Sessions)

**Message Queue**
- RabbitMQ

**DevOps**
- Docker & Docker Compose
- Kubernetes (EKS)
- Terraform
- GitLab CI/CD
- Prometheus + Grafana
- ELK Stack

**Cloud**
- AWS (VPC, EKS, RDS, ElastiCache, ALB, Route 53, ECR)

## 🚀 Quick Start

### Prérequis

- Docker & Docker Compose
- Node.js 20+
- Python 3.11+
- kubectl
- AWS CLI
- Terraform

### Environnement Local

#### Option 1 : Docker Compose (Développement simple)

```bash
# Cloner le repository
git clone <your-repo-url>
cd Red_Shoping

# Copier les variables d'environnement
cp .env.example .env

# Lancer tous les services
docker-compose up -d

# Accéder à l'application
# Frontend: http://localhost:3000
# API Gateway: http://localhost:8000
# Grafana: http://localhost:3001
```

#### Option 2 : Minikube (Kubernetes local)

```powershell
# 1. Démarrer Minikube
.\scripts\start-minikube.ps1

# 2. Déployer l'application
.\scripts\deploy-minikube.ps1

# 3. Accéder à l'application
minikube service frontend-ui -n red-shopping
minikube service api-gateway -n red-shopping
```

📖 **Documentation complète** : [Guide de déploiement Minikube](docs/MINIKUBE-DEPLOYMENT.md)

### Comparaison des options de déploiement

| Critère | Docker Compose | Minikube |
|---------|---------------|----------|
| **Facilité** | ⭐⭐⭐⭐⭐ Très simple | ⭐⭐⭐ Nécessite kubectl |
| **Ressources** | ⭐⭐⭐⭐ 2-3 GB RAM | ⭐⭐ 4+ GB RAM |
| **Production** | ❌ Dev uniquement | ✅ Similaire à la prod |
| **Scalabilité** | ❌ Limitée | ✅ Horizontale |
| **Réseau** | ⭐⭐⭐ Bridge simple | ⭐⭐⭐⭐⭐ Service mesh |
| **Monitoring** | ⭐⭐⭐ Docker logs | ⭐⭐⭐⭐ Metrics-server |

**Recommandation** : 
- 🏠 **Dev local rapide** → Docker Compose
- 🎯 **Test Kubernetes** → Minikube
- ☁️ **Production** → AWS EKS (voir [infrastructure/](infrastructure/))