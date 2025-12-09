# Architecture Red Shopping

## Vue d'ensemble

Red Shopping est une application e-commerce moderne utilisant une architecture microservices.

## Diagramme d'architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         Client Browser                          │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
                    ┌─────────────────┐
                    │   Frontend UI   │
                    │   (React:3000)  │
                    └────────┬────────┘
                             │
                             ▼
                    ┌─────────────────┐
                    │  API Gateway    │
                    │  (Node.js:8000) │
                    │  - Auth (JWT)   │
                    │  - Rate Limit   │
                    └────────┬────────┘
                             │
        ┌────────────────────┼────────────────────┐
        │                    │                    │
        ▼                    ▼                    ▼
┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│Product Svc   │    │  User Svc    │    │ Order Svc    │
│(Flask:8001)  │    │(Node.js:8002)│    │(Flask:8003)  │
│              │    │              │    │              │
│- CRUD        │◄───┤- Auth        │───►│- Cart        │
│- Search      │    │- Profile     │    │- Checkout    │
└──────┬───────┘    └──────┬───────┘    └──────┬───────┘
       │                   │                    │
       ▼                   ▼                    │
┌──────────────┐    ┌──────────────┐           │
│ PostgreSQL   │    │   MongoDB    │           │
│ (products)   │    │   (users)    │           │
└──────────────┘    └──────┬───────┘           │
                            │                   │
                            ▼                   │
                    ┌──────────────┐            │
                    │    Redis     │            │
                    │  (sessions)  │            │
                    └──────────────┘            │
                                                │
                                                ▼
                                        ┌──────────────┐
                                        │  RabbitMQ    │
                                        │   (events)   │
                                        └──────┬───────┘
                                               │
                                               ▼
                                        ┌──────────────┐
                                        │Notification  │
                                        │Svc (Flask)   │
                                        │:8004         │
                                        └──────────────┘
```

## Microservices

### 1. Frontend UI (React)
- **Technologie** : React 18, Vite, TailwindCSS
- **Port** : 3000
- **Responsabilités** :
  - Interface utilisateur
  - Gestion du state (Context API)
  - Communication avec API Gateway

### 2. API Gateway (Node.js)
- **Technologie** : Express, JWT
- **Port** : 8000
- **Responsabilités** :
  - Point d'entrée unique
  - Authentification JWT
  - Rate limiting
  - Routing vers microservices
  - Cache Redis

### 3. Product Service (Python)
- **Technologie** : Flask, SQLAlchemy
- **Port** : 8001
- **Base de données** : PostgreSQL
- **Responsabilités** :
  - CRUD produits
  - Recherche et filtres
  - Gestion du stock

### 4. User Service (Node.js)
- **Technologie** : Express, Mongoose
- **Port** : 8002
- **Base de données** : MongoDB
- **Cache** : Redis
- **Responsabilités** :
  - Registration/Login
  - Gestion profils
  - Sessions utilisateurs

### 5. Order Service (Python)
- **Technologie** : Flask, SQLAlchemy
- **Port** : 8003
- **Base de données** : PostgreSQL
- **Responsabilités** :
  - Gestion du panier
  - Création de commandes
  - Historique commandes
  - Publication d'événements (RabbitMQ)

### 6. Notification Service (Python)
- **Technologie** : Flask, Pika (RabbitMQ)
- **Port** : 8004
- **Responsabilités** :
  - Écoute des événements (RabbitMQ)
  - Envoi d'emails (mock)
  - Notifications push

## Communication entre services

### REST API
- Communication synchrone via HTTP/JSON
- API Gateway → Services
- Order Service → Product Service (vérification stock)

### Message Queue (RabbitMQ)
- Communication asynchrone
- Order Service publie des événements
- Notification Service consomme les événements

## Bases de données

### PostgreSQL
- **products_db** : Catalogue produits
- **orders_db** : Commandes et historique

### MongoDB
- **users_db** : Utilisateurs et profils

### Redis
- Sessions utilisateurs
- Cache (produits populaires)
- Rate limiting

## Sécurité

- **JWT** : Authentification stateless
- **Bcrypt** : Hash des mots de passe
- **CORS** : Configuration restrictive
- **Rate Limiting** : Protection DDoS
- **Input Validation** : Sanitization des entrées

## Scalabilité

- Chaque service est indépendamment scalable
- Communication asynchrone pour opérations longues
- Cache Redis pour performances
- Base de données séparées (Database per Service pattern)

## Monitoring

- **Prometheus** : Métriques applicatives
- **Grafana** : Dashboards
- **ELK Stack** : Logs centralisés
- Health checks sur chaque service
