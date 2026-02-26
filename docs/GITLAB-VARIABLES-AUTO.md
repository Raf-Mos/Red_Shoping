# 🚀 GitLab Variables - Méthode Automatique

## ✅ Ajouter TOUTES les variables en une seule commande !

Au lieu d'ajouter les variables une par une dans l'interface GitLab, utilisez l'API pour tout automatiser.

---

## 📋 Prérequis

### 1. Créer un Personal Access Token

1. Allez sur GitLab: **Settings** > **Access Tokens**
2. Ou directement: https://gitlab.com/-/user_settings/personal_access_tokens
3. Créez un token avec le scope **`api`**
4. Copiez le token (vous ne pourrez plus le voir après)

### 2. Installer les dépendances (si nécessaire)

**Windows PowerShell:** Rien à installer, le script utilise Invoke-RestMethod natif

**Linux/macOS/Git Bash:**
```bash
# Installer curl et jq si pas déjà installés
sudo apt-get install curl jq openssl  # Ubuntu/Debian
brew install curl jq openssl          # macOS
```

---

## 🎯 Utilisation

### Sur Windows (PowerShell)

```powershell
# Depuis le dossier Red_Shoping
.\scripts\add-gitlab-variables.ps1
```

**Le script va vous demander:**
1. GitLab URL (default: https://gitlab.com)
2. Project Path (ex: `username/red-shopping`)
3. Personal Access Token
4. Si vous voulez ajouter un kubeconfig (y/n)

### Sur Linux/macOS (Bash)

```bash
# Rendre le script exécutable
chmod +x scripts/add-gitlab-variables.sh

# Exécuter
./scripts/add-gitlab-variables.sh
```

---

## 📦 Variables Ajoutées Automatiquement

Le script ajoute **20+ variables** :

| Variable | Description | Protected | Masked |
|----------|-------------|-----------|--------|
| `CI_REGISTRY` | Registry Docker | Non | Non |
| `K8S_NAMESPACE` | Namespace Kubernetes | Non | Non |
| `JWT_SECRET` | Secret JWT (généré) | Oui | Oui |
| `POSTGRES_PASSWORD` | Password PostgreSQL (généré) | Oui | Oui |
| `RABBITMQ_PASSWORD` | Password RabbitMQ (généré) | Oui | Oui |
| `REDIS_PASSWORD` | Password Redis (généré) | Oui | Oui |
| `MONGO_URI` | URI MongoDB | Non | Non |
| `KUBE_CONFIG_STAGING` | Kubeconfig staging (optionnel) | Oui | Non |
| `KUBE_CONFIG_PROD` | Kubeconfig prod (optionnel) | Oui | Non |
| ... | +10 autres variables | | |

---

## 🔐 Sécurité

### Secrets Générés Automatiquement

Le script génère des secrets aléatoires sécurisés:
- **JWT_SECRET**: 64 caractères alphanumériques
- **Passwords**: 32 caractères alphanumériques

### Backup Local

Les secrets sont sauvegardés dans `gitlab-secrets-backup.txt`:

```
⚠️  IMPORTANT:
- Ce fichier est automatiquement exclu de Git (.gitignore)
- Gardez-le dans un endroit sûr (gestionnaire de mots de passe)
- Ne le partagez JAMAIS
```

---

## 🛠️ Dépannage

### Erreur: "401 Unauthorized"

**Problème:** Token invalide ou expiré

**Solution:**
1. Vérifiez que le token a le scope `api`
2. Créez un nouveau token si nécessaire
3. Vérifiez le Project Path (format: `username/project`)

### Erreur: "400 Bad Request - Variable already exists"

**Problème:** La variable existe déjà

**Solution:** Le script skip automatiquement les variables existantes (normal)

### Erreur: "404 Not Found"

**Problème:** Project Path incorrect

**Solution:** Vérifiez le format: `username/red-shopping` (pas d'espace, pas de `/` au début/fin)

### Variables ne s'affichent pas

**Solution:**
1. Allez sur: `https://gitlab.com/username/red-shopping/-/settings/ci_cd`
2. Expand **Variables**
3. Vérifiez qu'elles sont bien là

---

## 📝 Exemple d'Utilisation

```powershell
PS C:\Simplon\Red_Shoping> .\scripts\add-gitlab-variables.ps1

========================================
GitLab Variables - Bulk Upload
========================================

Step 1: GitLab Configuration
----------------------------------------
GitLab URL (default: https://gitlab.com): [Enter]
Project Path (e.g., username/red-shopping): johndoe/red-shopping
Personal Access Token (with api scope): glpat-xxxxxxxxxxxxxxxxxxxx

Step 2: Generating Secrets
----------------------------------------
Secrets generated ✓

Step 3: Kubeconfig (Optional)
----------------------------------------
Add kubeconfig? (y/n): y
Path to kubeconfig (default: ~/.kube/config): [Enter]
Kubeconfig encoded ✓

Step 4: Adding Variables to GitLab
========================================

  ✅ Added: CI_REGISTRY
  ✅ Added: K8S_NAMESPACE
  ✅ Added: JWT_SECRET
  ✅ Added: POSTGRES_PASSWORD
  ✅ Added: RABBITMQ_PASSWORD
  ✅ Added: REDIS_PASSWORD
  ✅ Added: MONGO_URI
  ✅ Added: KUBE_CONFIG_STAGING
  ✅ Added: KUBE_CONFIG_PROD
  ... (20+ variables)

========================================
Summary
========================================
✅ Added: 22
❌ Failed: 0

Step 5: Saving Secrets Locally
----------------------------------------
Secrets saved to: gitlab-secrets-backup.txt

========================================
✅ Variables Added Successfully!
========================================

Next steps:
  1. Verify in GitLab: Settings > CI/CD > Variables
  2. Enable GitLab Runners
  3. Push code to trigger pipeline
```

---

## 🔗 Méthode Alternative: GitLab UI (Manuelle)

Si vous préférez ajouter manuellement:

1. Allez sur: `Settings > CI/CD > Variables`
2. Cliquez **Add Variable** pour chaque variable
3. Utilisez `.\scripts\setup-gitlab-ci.ps1` pour générer les secrets

---

## 📚 Ressources

- [GitLab API Documentation](https://docs.gitlab.com/ee/api/project_level_variables.html)
- [Personal Access Tokens](https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html)
- [GitLab CI/CD Variables](https://docs.gitlab.com/ee/ci/variables/)

---

## 🆘 Besoin d'aide?

1. Vérifiez que le token a le scope `api`
2. Vérifiez le Project Path (format: `username/project`)
3. Lisez les messages d'erreur du script
4. Consultez `docs/GITLAB-CI-CD.md` pour plus d'infos

---

**Créé le:** 26 Février 2026  
**Dernière mise à jour:** 26 Février 2026
