# Projet Fil Rouge - Déploiement DevOps d'une Application Microservices

## Vue d'ensemble

Vous allez concevoir, déployer, automatiser, orchestrer et monitorer une **application microservices de votre choix** en utilisant l'ensemble des compétences DevOps acquises durant votre formation.

**Liberté de choix du domaine métier** : E-commerce, gestion hospitalière, IoT, réseau social, plateforme de streaming, gestion d'événements, système bancaire, etc.

**Focus de l'évaluation** : Compétences DevOps (Infrastructure, CI/CD, Kubernetes, Monitoring, SRE) - **PAS** la complexité fonctionnelle de l'application.

**Durée** : 2 semaines (80 heures)  
**Type** : Projet intégrateur de fin d'études  
**Modalité** : Individuel

---

## Choix du domaine métier

### Liberté totale du sujet

Vous êtes **libre de choisir n'importe quel domaine métier** pour votre application. L'évaluation portera exclusivement sur vos compétences DevOps, pas sur la complexité fonctionnelle.

### Exemples de domaines possibles

| Domaine           | Exemples d'applications                                 |
| ----------------- | ------------------------------------------------------- |
| **E-commerce**    | Boutique en ligne, marketplace, système de réservation  |
| **Santé**         | Gestion de patients, prise de RDV, dossier médical      |
| **Finance**       | Gestion de comptes, transactions, budget personnel      |
| **Éducation**     | Plateforme de cours, gestion d'étudiants, quiz en ligne |
| **Réseau social** | Microblogging, partage de photos, messagerie            |
| **Media**         | Plateforme de streaming, bibliothèque, playlist         |
| **Logistique**    | Gestion de livraisons, tracking, inventaire             |
| **RH**            | Gestion de candidatures, évaluations, planning          |
| **Sport**         | Gestion de compétitions, scores, statistiques           |

### Contraintes minimales

Quel que soit votre choix, votre application doit respecter :

- **Architecture microservices** : Minimum 3 services, maximum 8 services
- **API REST** : Communication entre services via HTTP/JSON
- **Base(s) de données** : Au moins 1 base de données (SQL et/ou NoSQL)
- **Frontend** : Interface utilisateur (web ou mobile)
- **Communication asynchrone** : Au moins 1 service avec messaging (RabbitMQ, Kafka, SQS)

### Validation du sujet

** Validation obligatoire** : Votre sujet doit être validé par le formateur **avant le Jour 2** pour s'assurer qu'il respecte les contraintes techniques.

**Livrable de validation** :

- Document de 2 pages max décrivant :
  - Le domaine métier choisi
  - Les 3-8 microservices prévus
  - Les technologies envisagées
  - Le diagramme d'architecture préliminaire

---

## Objectifs du projet

### Objectifs pédagogiques

- Démontrer la maîtrise complète de la chaîne DevOps (Dev → Build → Test → Deploy → Monitor)
- Intégrer l'ensemble des technologies apprises (Linux, Docker, Kubernetes, AWS, Observabilité)
- Produire une documentation technique professionnelle
- Constituer un projet portfolio pour votre recherche d'emploi

### Objectifs techniques

- Déployer une application microservices complète sur AWS avec Kubernetes (EKS)
- Implémenter une pipeline CI/CD complète avec GitLab CI
- Mettre en place une stack d'observabilité (Prometheus, Grafana, ELK)
- Automatiser l'infrastructure avec Terraform et Ansible
- Implémenter des pratiques SRE (SLI, SLO, SLA, Error Budgets)

---

## Architecture de l'application

### Vue d'ensemble de l'architecture type

```
                         ┌─────────────────────┐
                         │   USERS / CLIENTS   │
                         └──────────┬──────────┘
                                    │
                         ┌──────────▼──────────┐
                         │  AWS Route 53 (DNS) │
                         └──────────┬──────────┘
                                    │
                         ┌──────────▼──────────────┐
                         │ AWS ALB (Load Balancer) │
                         └──────────┬──────────────┘
                                    │
                ┌───────────────────┼───────────────────┐
                │                   │                   │
        ┌───────▼────────┐  ┌──────▼──────┐   ┌───────▼──────┐
        │  Frontend UI   │  │ API Gateway │   │ Admin Panel  │
        │  (React/Vue)   │  │(Node.js/Py) │   │   (React)    │
        └────────────────┘  └──────┬──────┘   └──────────────┘
                                   │
            ┌──────────────────────┼──────────────────────┐
            │                      │                      │
    ┌───────▼────────┐    ┌───────▼────────┐    ┌───────▼────────┐
    │ Product Service│    │  User Service  │    │ Order Service  │
    │ (Python/Flask) │    │   (Node.js)    │    │     (Java)     │
    └────────┬───────┘    └────────┬───────┘    └────────┬───────┘
             │                     │                      │
             │            ┌────────▼────────┐            │
             │            │ Payment Service │            │
             │            │   (Go/Python)   │            │
             │            └────────┬────────┘            │
             │                     │                      │
             └─────────────────────┼──────────────────────┘
                                   │
                       ┌───────────▼────────────┐
                       │ Message Queue (RabbitMQ)│
                       └───────────┬─────────────┘
                                   │
                       ┌───────────▼───────────┐
                       │ Notification Service  │
                       │     (Email/SMS)       │
                       └───────────────────────┘

    ┌──────────────┐  ┌──────────────┐  ┌──────────────┐
    │ PostgreSQL   │  │   MongoDB    │  │    Redis     │
    │ (Products)   │  │   (Users)    │  │   (Cache)    │
    └──────────────┘  └──────────────┘  └──────────────┘
```

### Exigences minimales pour vos microservices

Quelle que soit votre application, vous devez implémenter **entre 3 et 8 microservices** respectant ces critères :

#### Critères techniques obligatoires

| Exigence             | Description                             | Minimum                    |
| -------------------- | --------------------------------------- | -------------------------- |
| **Polyglossie**      | Utiliser au moins 2 langages différents | 2+ langages                |
| **Bases de données** | Variété de technologies de stockage     | 2+ types (SQL/NoSQL/Cache) |
| **Communication**    | Mix de patterns de communication        | REST + Messaging           |
| **Frontend**         | Interface utilisateur web               | 1 frontend                 |
| **API Gateway**      | Point d'entrée unique                   | 1 gateway                  |
| **Services métier**  | Logique business distribuée             | 2-5 services               |

#### Template de microservices recommandés

**Adaptez cette structure à votre domaine** :

1. **Frontend Web** - Interface utilisateur
2. **API Gateway** - Point d'entrée, routing, authentification
3. **Service Entité A** - CRUD sur une entité principale (ex: produits, patients, transactions)
4. **Service Entité B** - CRUD sur une deuxième entité (ex: utilisateurs, rendez-vous, comptes)
5. **Service Processus** - Orchestration d'un processus métier (ex: commandes, diagnostics, transferts)
6. **Service Communication** - Notifications, emails, SMS (optionnel)
7. **Service Analytics** - Statistiques, reporting (optionnel)
8. **Admin Panel** - Interface d'administration (optionnel)

---

## Stack technologique

### Choix des technologies

Vous avez la **liberté de choisir** vos technologies applicatives, avec ces contraintes :

#### Langages autorisés

**Backend** : Python, Node.js, Java, Go, PHP, Ruby, C# (.NET)  
**Frontend** : React, Vue.js, Angular, Svelte (ou même HTML/CSS/JS vanilla)

#### Bases de données recommandées

**Relationnelles** : PostgreSQL (recommandé), MySQL, MariaDB  
**NoSQL** : MongoDB, Cassandra, DynamoDB  
**Cache** : Redis, Memcached  
**Message Queue** : RabbitMQ, Kafka, AWS SQS

#### Technologies DevOps (OBLIGATOIRES - non négociables)

| Catégorie            | Technologie                 | Obligation  |
| -------------------- | --------------------------- | ----------- |
| **Containerisation** | Docker                      | Obligatoire |
| **Orchestration**    | Kubernetes (EKS)            | Obligatoire |
| **Infrastructure**   | Terraform                   | Obligatoire |
| **CI/CD**            | GitLab CI ou GitHub Actions | Obligatoire |
| **Monitoring**       | Prometheus + Grafana        | Obligatoire |
| **Logs**             | ELK Stack (ou Loki)         | Obligatoire |
| **Cloud**            | AWS                         | Obligatoire |
| **Registry**         | AWS ECR                     | Obligatoire |

### Simplification recommandée

** Conseil** : Plus votre application métier est simple, plus vous pouvez vous concentrer sur l'excellence DevOps.

**Options de simplification** :

1. **Utiliser des apps existantes** : Forker des projets open-source simples
2. **API REST minimales** : CRUD basique suffit (GET, POST, PUT, DELETE)
3. **UI basique** : Bootstrap/TailwindCSS sans trop de JavaScript
4. **Mock de services** : Simuler certains services (paiement, email)

**L'évaluation porte à 100% sur le DevOps, pas sur les fonctionnalités !**

---

## Livrables attendus

### 1. Code Source et Configuration

#### Repository Git structuré

```
mon-projet-devops/
 README.md
 .gitignore
 .gitlab-ci.yml                    # Pipeline CI/CD complète

 microservices/                     # Code des microservices
    frontend-ui/
       Dockerfile
       package.json
       src/
    api-gateway/
       Dockerfile
       src/
    product-service/
       Dockerfile
       requirements.txt
       src/
    user-service/
       Dockerfile
       src/
    order-service/
       Dockerfile
       pom.xml
       src/
    payment-service/
       Dockerfile
       src/
    notification-service/
       Dockerfile
       src/
    admin-panel/
        Dockerfile
        src/

 infrastructure/                    # Infrastructure as Code
    terraform/
       main.tf
       variables.tf
       outputs.tf
       vpc.tf                    # VPC configuration
       eks.tf                    # EKS cluster
       rds.tf                    # RDS PostgreSQL
       elasticache.tf            # Redis
       mq.tf                     # Amazon MQ (RabbitMQ)
       monitoring.tf             # CloudWatch, ALB
    ansible/
        playbooks/
           setup-monitoring.yml
           configure-nodes.yml
           deploy-app.yml
        inventory/
            hosts.yml

 kubernetes/                        # Manifests Kubernetes
    namespaces/
       production.yaml
       staging.yaml
       monitoring.yaml
    configmaps/
       app-config.yaml
    secrets/
       app-secrets.yaml.example
    deployments/
       frontend-deployment.yaml
       api-gateway-deployment.yaml
       product-service-deployment.yaml
       user-service-deployment.yaml
       order-service-deployment.yaml
       payment-service-deployment.yaml
       notification-service-deployment.yaml
       admin-panel-deployment.yaml
    services/
       frontend-service.yaml
       api-gateway-service.yaml
       [autres services].yaml
    ingress/
       ingress.yaml
       ingress-nginx-controller.yaml
    autoscaling/
       hpa.yaml                  # Horizontal Pod Autoscaler
    databases/
       postgres-statefulset.yaml
       mongodb-statefulset.yaml
       redis-deployment.yaml
    monitoring/
        prometheus/
           prometheus-deployment.yaml
           prometheus-config.yaml
           service-monitors.yaml
        grafana/
           grafana-deployment.yaml
           dashboards/
        elk/
            elasticsearch-statefulset.yaml
            logstash-deployment.yaml
            kibana-deployment.yaml

 monitoring/                        # Configuration observabilité
    prometheus/
       prometheus.yml
       alerts.yml
       rules/
    grafana/
       dashboards/
           application-dashboard.json
           infrastructure-dashboard.json
           business-metrics-dashboard.json
    elk/
       logstash.conf
       index-templates/
    sre/
        slo-definitions.yaml
        error-budgets.yaml
        alerting-policies.yaml

 scripts/                           # Scripts automation
    setup/
       install-dependencies.sh
       configure-kubectl.sh
    deploy/
       deploy-production.sh
       deploy-staging.sh
    monitoring/
       setup-prometheus.sh
       setup-elk.sh
    utilities/
        database-backup.py
        health-check.py
        load-test.sh

 tests/                             # Tests automatisés
    unit/
    integration/
    e2e/
    load/
        locustfile.py             # Tests de charge

 docs/                              # Documentation
     architecture.md
     deployment-guide.md
     monitoring-guide.md
     troubleshooting.md
     sre-runbook.md
     api-documentation.md
```

### 2. Infrastructure AWS (Terraform)

**Ressources à provisionner** :

- **VPC** avec subnets publics/privés sur 2 AZs minimum
- **EKS Cluster** avec node groups (t3.medium minimum)
- **RDS PostgreSQL** (Multi-AZ pour la production)
- **ElastiCache Redis**
- **Amazon MQ** (RabbitMQ) ou alternative
- **ALB** (Application Load Balancer)
- **Route 53** pour le DNS
- **S3** pour les assets statiques
- **ECR** pour les images Docker
- **CloudWatch** pour les logs et métriques
- **IAM Roles** avec principe du moindre privilège

### 3. Pipeline CI/CD (GitLab CI)

**Stages obligatoires** :

```yaml
stages:
  - validate # Linting, format checking
  - build # Build des images Docker
  - test # Tests unitaires, integration
  - security # Security scanning (Trivy, SonarQube)
  - push # Push vers ECR
  - deploy-staging # Déploiement automatique staging
  - test-e2e # Tests end-to-end sur staging
  - deploy-prod # Déploiement manuel production
  - monitor # Validation post-déploiement
```

**Fonctionnalités requises** :

- Build automatique des images Docker pour chaque microservice
- Tests automatisés (unit tests, integration tests)
- Scan de sécurité des images (Trivy)
- Déploiement automatique sur staging
- Déploiement manuel (avec approbation) sur production
- Rollback automatique en cas d'échec
- Notifications (Slack, email) sur les statuts

### 4. Kubernetes sur EKS

**Ressources Kubernetes requises** :

- **Namespaces** : `production`, `staging`, `monitoring`
- **Deployments** pour tous les microservices
- **Services** (ClusterIP, LoadBalancer)
- **Ingress** avec certificats SSL (Let's Encrypt)
- **ConfigMaps** pour la configuration
- **Secrets** pour les credentials
- **HPA** (Horizontal Pod Autoscaler) sur au moins 3 services
- **StatefulSets** pour les bases de données
- **PersistentVolumes** pour les données
- **NetworkPolicies** pour la sécurité
- **ResourceQuotas** et **LimitRanges**

### 5. Monitoring et Observabilité

#### Stack Prometheus + Grafana

**Dashboards Grafana obligatoires** :

1. **Infrastructure Dashboard**

   - CPU, RAM, Disk usage des nodes
   - Network traffic
   - Pods running/pending/failed

2. **Application Dashboard**

   - Request rate par service
   - Response time (p50, p95, p99)
   - Error rate
   - Active users

3. **Business Metrics Dashboard**
   - Commandes créées/jour
   - Revenue tracking
   - Taux de conversion
   - Produits les plus consultés

**Alertes Prometheus requises** :

- CPU > 80% pendant 5 minutes
- Memory > 90% pendant 5 minutes
- Pods CrashLooping
- Response time > 2s pendant 5 minutes
- Error rate > 5%
- Service down/unavailable

#### Stack ELK (Elasticsearch, Logstash, Kibana)

**Logs centralisés** :

- Tous les logs applicatifs agrégés dans Elasticsearch
- Parsing et enrichissement avec Logstash
- Dashboards Kibana pour analyse
- Retention policy de 30 jours minimum

**Visualisations Kibana** :

- Logs par service
- Error tracking
- Request tracing
- Performance analysis

#### Distributed Tracing (Jaeger ou Zipkin)

- Tracing des requêtes à travers les microservices
- Identification des bottlenecks
- Service dependency mapping

### 6. Pratiques SRE

#### SLI (Service Level Indicators)

Définir et mesurer :

- **Availability** : % de uptime du service
- **Latency** : temps de réponse des requêtes
- **Error Rate** : % de requêtes en erreur
- **Throughput** : requêtes par seconde

#### SLO (Service Level Objectives)

Exemple d'objectifs :

- **Availability** : 99.9% sur 30 jours (43 minutes de downtime max)
- **Latency** : 95% des requêtes < 500ms
- **Error Rate** : < 0.1% des requêtes
- **Throughput** : Support de 1000 requêtes/sec

#### Error Budgets

- Calcul automatisé des error budgets
- Dashboard de consommation du budget
- Blocage des déploiements si budget épuisé

#### Incident Management

- **Runbook** : Procédures de résolution d'incidents
- **Post-Mortem Template** : Analyse après incident
- **On-Call Rotation** : Simulation d'astreintes

### 7. Sécurité

**Mesures obligatoires** :

- Secrets chiffrés (AWS Secrets Manager ou Sealed Secrets)
- HTTPS/TLS sur toutes les communications
- Network Policies Kubernetes
- Security Groups AWS restrictifs
- IAM Roles avec moindre privilège
- Container image scanning (Trivy)
- Pod Security Policies
- Audit logs activés

### 8. Documentation

**Documents obligatoires** :

1. **README.md principal**

   - Vue d'ensemble du projet
   - Architecture
   - Quick start guide

2. **Architecture Diagram**

   - Diagramme d'architecture complet
   - Flow de données
   - Infrastructure AWS

3. **Deployment Guide**

   - Prérequis
   - Instructions détaillées de déploiement
   - Variables d'environnement
   - Troubleshooting

4. **API Documentation**

   - Endpoints de chaque service
   - Swagger/OpenAPI specs
   - Exemples de requêtes

5. **Monitoring Guide**

   - Accès aux dashboards
   - Interprétation des métriques
   - Procédures d'alerte

6. **SRE Runbook**

   - Procédures d'incident
   - Playbooks de résolution
   - Contacts d'escalade

7. **Post-Mortem Template**
   - Template d'analyse d'incidents
   - Exemple de post-mortem rempli

---

## Référentiel de validation des compétences

### Contexte de validation

Le projet sera évalué selon le **référentiel de compétences DevOps - Niveau 3**, avec validation de 7 compétences principales. Chaque compétence doit être démontrée de manière autonome et complète.

### Compétences à valider (Niveau 3)

#### **C1 - Définir un environnement de développement commun**

**Objectif** : Automatiser l'installation d'un environnement de développement partagé

**Critères de validation** :

- Fichier `docker-compose.yml` fonctionnel pour environnement local
- Documentation d'installation automatisée (scripts bash/python)
- Choix et justification des outils de virtualisation (Docker, VMs)
- Application des principes Infrastructure as Code
- Variables d'environnement externalisées (`.env`, ConfigMaps)
- Reproductibilité : un développeur peut setup l'env en < 10 min

**Livrables attendus** :

- `docker-compose.yml` avec tous les services
- Scripts `setup-dev.sh` ou `setup-dev.py`
- Documentation `docs/environment-setup.md`
- Fichier `.env.example`

**Indicateurs de réussite** :

- **Acquis** : Environnement reproductible, documenté, automatisé
- **En cours d'acquisition** : Fonctionne mais nécessite interventions manuelles
- **Non acquis** : Environnement non reproductible ou manuel

---

#### **C2 - Concevoir la procédure d'intégration continue**

**Objectif** : Automatiser builds et tests lors du commit de code

**Critères de validation** :

- Pipeline CI avec fichier `.gitlab-ci.yml` ou `github-actions.yml`
- Build automatique de toutes les images Docker
- Exécution automatique des tests (unit, integration)
- Déclenchement au push/merge sur branches principales
- Rapport de tests et métriques de qualité
- Échec du pipeline si tests échouent

**Livrables attendus** :

- `.gitlab-ci.yml` avec stages : validate, build, test
- Tests automatisés dans `tests/`
- Badges de statut du build
- Documentation `docs/ci-pipeline.md`

**Indicateurs de réussite** :

- **Acquis** : Pipeline complète, tests auto, builds reproductibles
- **En cours d'acquisition** : Pipeline partielle, quelques tests manuels
- **Non acquis** : Pas de CI ou builds manuels

---

#### **C3 - Concevoir les éléments de configuration de l'infrastructure**

**Objectif** : Automatiser provisionnement et gestion de l'infrastructure

**Critères de validation** :

- Code Terraform pour provisionner l'infrastructure AWS complète
- Modules réutilisables (VPC, EKS, RDS, etc.)
- Variables paramétrables (`variables.tf`)
- State Terraform géré (remote backend S3)
- Documentation des ressources créées (`outputs.tf`)
- Infrastructure créée avec `terraform apply` en une commande

**Livrables attendus** :

- Dossier `infrastructure/terraform/`
- Fichiers : `main.tf`, `variables.tf`, `outputs.tf`
- Modules dans `modules/`
- Documentation `docs/infrastructure.md`

**Indicateurs de réussite** :

- **Acquis** : Infrastructure 100% IaC, modulaire, documentée
- **En cours d'acquisition** : IaC partiel, quelques ressources manuelles
- **Non acquis** : Infrastructure créée manuellement

---

#### **C4 - Élaborer des tests automatiques de l'infrastructure**

**Objectif** : Garantir la qualité de l'infrastructure via tests automatisés

**Critères de validation** :

- Tests de validation Terraform (`terraform validate`, `terraform plan`)
- Tests de sécurité (Checkov, tfsec, Trivy)
- Tests d'intégration de l'infrastructure (kitchen-terraform, terratest)
- Exécution automatique dans la CI
- Blocage du déploiement si tests échouent
- Rapports de tests accessibles

**Livrables attendus** :

- Stage `infra-test` dans `.gitlab-ci.yml`
- Scripts de tests dans `tests/infrastructure/`
- Configuration Checkov/tfsec
- Rapports de sécurité

**Indicateurs de réussite** :

- **Acquis** : Tests auto, multiples types, intégrés CI
- **En cours d'acquisition** : Tests basiques, pas tous automatisés
- **Non acquis** : Pas de tests d'infrastructure

---

#### **C5 - Créer une procédure de déploiement continu**

**Objectif** : Automatiser le déploiement de l'application en production

**Critères de validation** :

- Pipeline CD avec stages : build → test → deploy staging → deploy prod
- Déploiement automatique vers environnement staging
- Déploiement manuel (avec approbation) vers production
- Utilisation de manifests Kubernetes ou Helm charts
- Rollback automatique en cas d'échec
- Versioning des déploiements (tags Git, versions images)

**Livrables attendus** :

- Stages CD dans `.gitlab-ci.yml`
- Manifests Kubernetes dans `kubernetes/`
- Scripts de déploiement `scripts/deploy/`
- Documentation `docs/deployment.md`

**Indicateurs de réussite** :

- **Acquis** : CD complète, multi-env, rollback auto
- **En cours d'acquisition** : Déploiement semi-automatique
- **Non acquis** : Déploiements manuels

---

#### **C6 - Automatiser le monitorage des éléments d'infrastructure et applications**

**Objectif** : Favoriser l'amélioration continue via métriques et alertes

**Critères de validation** :

- Stack Prometheus + Grafana déployée et configurée
- Métriques collectées : infrastructure, applications, business
- Au moins 3 dashboards Grafana distincts
- Alertes configurées (CPU, RAM, erreurs, latence)
- Stack ELK pour logs centralisés
- Définition de SLI/SLO avec Error Budgets

**Livrables attendus** :

- Configuration dans `monitoring/prometheus/`
- Dashboards Grafana exportés (JSON)
- Configuration alertes `monitoring/alerts/`
- Stack ELK configurée
- Documentation SLI/SLO dans `docs/sre.md`

**Indicateurs de réussite** :

- **Acquis** : Monitoring complet, alertes actives, SLI/SLO définis
- **En cours d'acquisition** : Monitoring partiel, alertes basiques
- **Non acquis** : Pas de monitoring ou manuel

---

#### **C7 - Concevoir un système de veille technologique**

**Objectif** : Améliorer les décisions techniques via veille structurée

**Critères de validation** :

- Documentation des choix technologiques justifiés
- Analyse comparative des alternatives (Docker vs Podman, EKS vs ECS)
- Veille sur sécurité (CVE, vulnérabilités)
- Documentation des best practices appliquées
- Sources de veille référencées et classifiées
- Rapport de veille dans le projet

**Livrables attendus** :

- Document `docs/technical-decisions.md` (ADR - Architecture Decision Records)
- Analyse comparative dans `docs/technology-comparison.md`
- Scan CVE dans pipeline CI
- Références et sources de veille
- Justification des choix dans README

**Indicateurs de réussite** :

- **Acquis** : Choix justifiés, veille documentée, ADR complets
- **En cours d'acquisition** : Justifications partielles
- **Non acquis** : Choix non justifiés

---

### Grille de validation finale

| Compétence                     | Code | Statut                     | Observations |
| ------------------------------ | ---- | -------------------------- | ------------ |
| Environnement de développement | C1   | Acquis En cours Non acquis |              |
| Intégration Continue           | C2   | Acquis En cours Non acquis |              |
| Configuration Infrastructure   | C3   | Acquis En cours Non acquis |              |
| Tests Infrastructure           | C4   | Acquis En cours Non acquis |              |
| Déploiement Continu            | C5   | Acquis En cours Non acquis |              |
| Monitorage & Observabilité     | C6   | Acquis En cours Non acquis |              |
| Veille Technologique           | C7   | Acquis En cours Non acquis |              |

**Validation Niveau 3** : Toutes les compétences doivent être **Acquis** pour valider le niveau 3.

**Critères globaux** :

- Autonomie complète dans la réalisation
- Capacité à justifier les choix techniques
- Résolution autonome des problèmes rencontrés
- Documentation professionnelle et exhaustive
- Respect des bonnes pratiques DevOps/SRE

---

## Planning recommandé (2 semaines)

### Semaine 1 : Infrastructure et Déploiement de base

#### Jour 1 : Choix du sujet et Setup (8h)

- **Matin** :
- Brainstorming du sujet métier
- Définition des 3-8 microservices
- Architecture préliminaire
- **Validation du sujet avec le formateur**
- **Après-midi** :
- Setup repository Git, structure projet
- Début Terraform - VPC, subnets, security groups

#### Jour 2 : Infrastructure AWS (8h)

- **Matin** : Terraform - EKS cluster, RDS, ElastiCache
- **Jour 2 Matin** : Terraform - EKS cluster, RDS, ElastiCache
- **Jour 2 Après-midi** : Terraform - ALB, Route 53, IAM

#### Jour 3-4 : Containerisation et Kubernetes (16h)

- **Jour 3 Matin** : Dockerfiles pour tous les microservices
- **Jour 3 Après-midi** : Docker Compose pour dev local, tests
- **Jour 4 Matin** : Kubernetes manifests (Deployments, Services)
- **Jour 4 Après-midi** : ConfigMaps, Secrets, Ingress

#### Jour 5 : Premier déploiement (8h)

- **Matin** : Push images vers ECR
- **Après-midi** : Déploiement sur EKS, validation

### Semaine 2 : CI/CD, Monitoring et SRE

#### Jour 6-7 : CI/CD Pipeline (16h)

- **Jour 6 Matin** : GitLab CI - stages build, test
- **Jour 6 Après-midi** : GitLab CI - security scanning, push ECR
- **Jour 7 Matin** : GitLab CI - deploy staging, e2e tests
- **Jour 7 Après-midi** : GitLab CI - deploy production, rollback

#### Jour 8-9 : Monitoring et Observabilité (16h)

- **Jour 8 Matin** : Installation Prometheus + Grafana
- **Jour 8 Après-midi** : Dashboards Grafana (3 dashboards), alerting
- **Jour 9 Matin** : ELK Stack - Elasticsearch, Logstash, Kibana
- **Jour 9 Après-midi** : Distributed Tracing (Jaeger/Zipkin)

#### Jour 10 : SRE et Documentation (8h)

- **Matin** : SLI/SLO, Error Budgets, Runbook
- **Après-midi** : Documentation complète, README, guides

---

## Critères de réussite

### Fonctionnels

- Application accessible via URL publique HTTPS
- Tous les microservices fonctionnels et communicants
- CRUD complet sur les produits
- Authentification utilisateur fonctionnelle
- Création de commandes end-to-end
- Notifications envoyées (simulées)

### Techniques

- Infrastructure provisionnable en 1 commande Terraform
- Application déployable en 1 commande Kubernetes
- Pipeline CI/CD automatique fonctionnelle
- Monitoring accessible et dashboards informatifs
- Logs centralisés et searchables
- Alertes configurées et testées
- Documentation complète et à jour

### Professionnels

- Code propre et bien structuré
- Commits Git atomiques et messages clairs
- README professionnel (portfolio-ready)
- Documentation technique exhaustive
- Respect des bonnes pratiques DevOps/SRE

---

## Ressources et conseils

### Ressources techniques

#### Application de base (si besoin)

Si vous préférez ne pas coder les microservices from scratch :

- **Option 1** : Utiliser des applications open-source existantes
  - [Sock Shop Microservices Demo](https://github.com/microservices-demo/microservices-demo)
  - [Google Microservices Demo](https://github.com/GoogleCloudPlatform/microservices-demo)
- **Option 2** : Applications minimales (focus sur DevOps)
  - Créer des services REST basiques avec CRUD simple
  - L'important est l'infrastructure DevOps, pas la complexité métier

#### Stack recommandée

**Pour rapidité de développement** :

- Frontend : React + Nginx
- API Gateway : Node.js Express
- Services : Python Flask (rapide à développer)
- Bases : PostgreSQL (RDS), MongoDB (Atlas ou self-hosted), Redis (ElastiCache)

### Conseils pratiques

#### Organisation du travail

1. **Commencez par l'infrastructure** (Terraform)
2. **Containerisez les services** (Docker)
3. **Déployez sur Kubernetes** (manifests basiques)
4. **Ajoutez le CI/CD** (GitLab CI)
5. **Implémentez le monitoring** (Prometheus, Grafana, ELK)
6. **Finalisez la documentation**

#### Pièges à éviter

- Ne pas commencer par le code applicatif (c'est un projet DevOps !)
- Vouloir une application trop complexe (simplicité = meilleure démo)
- Négliger la documentation (50% du projet)
- Oublier les tests de charge (indispensable pour SLO)
- Ignorer les coûts AWS (utilisez t3.micro, surveillez la facture)

#### Optimisation des coûts AWS

- Utilisez **t3.micro** / **t3.small** pour les nodes EKS
- Activez **Auto Scaling** pour réduire les coûts hors heures
- Utilisez **RDS Free Tier** si éligible
- **Détruisez les ressources** après démo : `terraform destroy`
- Budget AWS : maximum **50-100€** pour 2 semaines

#### Tests et validation

**Tests de charge avec Locust** :

```python
# tests/load/locustfile.py
from locust import HttpUser, task, between

class AppUser(HttpUser):
    wait_time = between(1, 3)

    @task(3)
    def view_products(self):
        self.client.get("/api/products")

    @task(2)
    def view_product_detail(self):
        self.client.get("/api/products/1")

    @task(1)
    def create_order(self):
        self.client.post("/api/orders", json={
            "user_id": 1,
            "product_id": 1,
            "quantity": 1
        })
```

Lancer : `locust -f tests/load/locustfile.py --host=https://mon-app.example.com`

---

## Présentation finale (30 minutes)

### Format de soutenance

**Durée** : 30 minutes (20 min présentation + 10 min questions)

**Structure recommandée** :

1. **Introduction** (2 min)

   - Présentation du projet
   - Choix techniques

2. **Architecture** (5 min)

   - Diagramme architecture
   - Stack technologique
   - Justification des choix

3. **Démo Live** (10 min)

   - Application fonctionnelle
   - Pipeline CI/CD en action
   - Dashboards monitoring
   - Simulation d'incident et résolution

4. **DevOps Practices** (3 min)

   - Infrastructure as Code (Terraform)
   - Kubernetes manifests
   - GitOps workflow

5. **SRE et Observabilité** (5 min)

   - SLI/SLO/SLA
   - Monitoring et alerting
   - Runbook et incident management

6. **Retour d'expérience** (3 min)

   - Difficultés rencontrées
   - Solutions apportées
   - Apprentissages clés

7. **Questions/Réponses** (10 min)

### Checklist pré-soutenance

- Application accessible et fonctionnelle
- Dashboards Grafana préparés et affichables
- Logs Kibana configurés et démo-ready
- Pipeline CI/CD testée et fonctionnelle
- Slides de présentation (PDF)
- Demo script préparé (plan B si problème réseau)
- Repository Git propre et documenté

---

## Annexes

### Annexe A : Exemples d'API Endpoints

#### Product Service

```
GET    /api/products          # Liste tous les produits
GET    /api/products/:id      # Détail d'un produit
POST   /api/products          # Créer un produit (admin)
PUT    /api/products/:id      # Modifier un produit (admin)
DELETE /api/products/:id      # Supprimer un produit (admin)
```

#### User Service

```
POST   /api/users/register    # Créer un compte
POST   /api/users/login       # Login (retourne JWT)
GET    /api/users/profile     # Profil utilisateur (authentifié)
PUT    /api/users/profile     # Modifier profil
```

#### Order Service

```
POST   /api/orders            # Créer une commande
GET    /api/orders            # Liste commandes utilisateur
GET    /api/orders/:id        # Détail d'une commande
PUT    /api/orders/:id/status # Changer statut (admin)
```

### Annexe B : Variables d'environnement

**Exemple de ConfigMap Kubernetes** :

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  DATABASE_HOST: "postgres-service"
  DATABASE_PORT: "5432"
  REDIS_HOST: "redis-service"
  REDIS_PORT: "6379"
  RABBITMQ_HOST: "rabbitmq-service"
  RABBITMQ_PORT: "5672"
  API_GATEWAY_URL: "http://api-gateway-service:8080"
  LOG_LEVEL: "info"
  ENVIRONMENT: "production"
```

### Annexe C : SLO Examples

```yaml
# monitoring/sre/slo-definitions.yaml

service_level_objectives:
  - name: "API Gateway Availability"
    sli: "availability"
    target: 99.9 # 99.9% uptime
    window: 30d # Sur 30 jours

  - name: "API Gateway Latency"
    sli: "latency_p95"
    target: 500 # 95% des requêtes < 500ms
    window: 7d

  - name: "Order Service Error Rate"
    sli: "error_rate"
    target: 0.1 # < 0.1% d'erreurs
    window: 30d

  - name: "Payment Service Success Rate"
    sli: "success_rate"
    target: 99.5 # > 99.5% de succès
    window: 30d
```

### Annexe D : Checklist de sécurité

**Sécurité Infrastructure** :

- [ ] VPC avec subnets publics/privés séparés
- [ ] Security Groups avec règles minimales (principe du moindre privilège)
- [ ] Network ACLs configurées
- [ ] Pas d'accès direct aux bases de données depuis Internet
- [ ] Bastion host ou AWS Systems Manager Session Manager pour l'accès

**Sécurité Kubernetes** :

- [ ] Secrets chiffrés (Sealed Secrets ou AWS Secrets Manager)
- [ ] Network Policies définies
- [ ] Pod Security Policies activées
- [ ] RBAC configuré avec rôles spécifiques
- [ ] Service Accounts dédiés par service
- [ ] Resource Limits définis (prévention DoS)

**Sécurité Applicative** :

- [ ] Authentification JWT sur API Gateway
- [ ] HTTPS/TLS partout (Let's Encrypt)
- [ ] Validation des inputs (prévention injection)
- [ ] Rate limiting sur API Gateway
- [ ] CORS configuré correctement
- [ ] Pas de credentials dans le code (use env vars)

**Sécurité CI/CD** :

- [ ] Scan des images Docker (Trivy)
- [ ] SAST (Static Analysis) avec SonarQube
- [ ] Dépendances scannées (Dependabot, Snyk)
- [ ] Secrets GitLab chiffrés
- [ ] Accès pipeline limité (protected branches)

---

## Bonus (points supplémentaires)

**Fonctionnalités bonus** (non obligatoires mais valorisées) :

- **Chaos Engineering** : Injection de pannes avec Chaos Mesh (5 points)
- **Blue/Green ou Canary Deployment** : Stratégie avancée (5 points)
- **Service Mesh** : Istio ou Linkerd (5 points)
- **GitOps** : ArgoCD ou FluxCD (5 points)
- **Multi-Region** : Déploiement sur 2 régions AWS (5 points)
- **Disaster Recovery** : Plan et tests de DR (5 points)
- **Cost Optimization** : Dashboard de coûts AWS et optimisations (3 points)
- **A/B Testing** : Infrastructure pour A/B tests (3 points)

---

## Support et questions

**Modalités d'accompagnement** :

- **Daily Stand-up** : Point quotidien de 15 minutes (progrès, blocages)
- **Technical Reviews** : Revues techniques hebdomadaires (architecture, code)
- **Office Hours** : Disponibilité formateur pour questions ponctuelles
- **Slack/Discord** : Canal dédié pour entraide et questions rapides

**Contact formateur** : Hassan ESSADIK  
**Email** : hassan.essadik@simplon.co  
**Slack** : @hassan

---

**Bon courage et que le DevOps soit avec vous ! **

_Formateur : Hassan ESSADIK | Sprint 6 - Projet Fil Rouge DevOps_  
_Simplon Maghreb - Formation DevOps 2025_
