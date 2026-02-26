#!/bin/bash
# Script to add GitLab variables via API (Linux/macOS/Git Bash)
# Usage: ./scripts/add-gitlab-variables.sh

echo "========================================"
echo "GitLab Variables - Bulk Upload"
echo "========================================"
echo ""

# Configuration
echo "Step 1: GitLab Configuration"
echo "----------------------------------------"
read -p "GitLab URL (default: https://gitlab.com): " GITLAB_URL
GITLAB_URL=${GITLAB_URL:-https://gitlab.com}

read -p "Project Path (e.g., username/red-shopping): " PROJECT_PATH
read -sp "Personal Access Token (with api scope): " ACCESS_TOKEN
echo ""

# URL encode project path
PROJECT_PATH_ENCODED=$(echo -n "$PROJECT_PATH" | jq -sRr @uri)
API_URL="$GITLAB_URL/api/v4/projects/$PROJECT_PATH_ENCODED/variables"

echo ""
echo "Step 2: Generating Secrets"
echo "----------------------------------------"

# Generate secrets
JWT_SECRET=$(openssl rand -base64 48 | tr -d '\n')
POSTGRES_PASSWORD=$(openssl rand -base64 24 | tr -d '\n')
RABBITMQ_PASSWORD=$(openssl rand -base64 24 | tr -d '\n')
REDIS_PASSWORD=$(openssl rand -base64 24 | tr -d '\n')

echo "✓ Secrets generated"
echo ""

# Function to add variable
add_variable() {
    local KEY=$1
    local VALUE=$2
    local PROTECTED=${3:-false}
    local MASKED=${4:-false}
    local VAR_TYPE=${5:-env_var}
    
    RESPONSE=$(curl -s -w "\n%{http_code}" --request POST \
        --header "PRIVATE-TOKEN: $ACCESS_TOKEN" \
        --header "Content-Type: application/json" \
        --data "{
            \"key\": \"$KEY\",
            \"value\": \"$VALUE\",
            \"protected\": $PROTECTED,
            \"masked\": $MASKED,
            \"variable_type\": \"$VAR_TYPE\"
        }" \
        "$API_URL")
    
    HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
    
    if [ "$HTTP_CODE" -eq 201 ]; then
        echo "  ✅ Added: $KEY"
        return 0
    elif [ "$HTTP_CODE" -eq 400 ]; then
        echo "  ⚠️  Already exists: $KEY (skipping)"
        return 1
    else
        echo "  ❌ Failed: $KEY (HTTP $HTTP_CODE)"
        return 1
    fi
}

echo "Step 3: Adding Variables to GitLab"
echo "========================================"
echo ""

# Add variables
add_variable "CI_REGISTRY" "registry.gitlab.com" false false
add_variable "K8S_NAMESPACE" "red-shopping" false false

add_variable "JWT_SECRET" "$JWT_SECRET" true true
add_variable "JWT_EXPIRATION" "24h" false false

add_variable "POSTGRES_USER" "postgres" true false
add_variable "POSTGRES_PASSWORD" "$POSTGRES_PASSWORD" true true
add_variable "PRODUCT_DB_NAME" "products_db" false false
add_variable "ORDER_DB_NAME" "orders_db" false false

add_variable "MONGO_URI" "mongodb://mongodb:27017/users_db" false false
add_variable "MONGO_DB_NAME" "users_db" false false

add_variable "RABBITMQ_HOST" "rabbitmq" false false
add_variable "RABBITMQ_PORT" "5672" false false
add_variable "RABBITMQ_USER" "guest" false false
add_variable "RABBITMQ_PASSWORD" "$RABBITMQ_PASSWORD" true true
add_variable "RABBITMQ_QUEUE" "notifications" false false

add_variable "REDIS_HOST" "redis" false false
add_variable "REDIS_PORT" "6379" false false
add_variable "REDIS_PASSWORD" "$REDIS_PASSWORD" true true

add_variable "NODE_ENV" "development" false false
add_variable "FLASK_ENV" "development" false false
add_variable "LOG_LEVEL" "info" false false

# Kubeconfig (optional)
echo ""
read -p "Add kubeconfig? (y/n): " ADD_KUBE
if [ "$ADD_KUBE" = "y" ]; then
    read -p "Path to kubeconfig (default: ~/.kube/config): " KUBE_PATH
    KUBE_PATH=${KUBE_PATH:-~/.kube/config}
    
    if [ -f "$KUBE_PATH" ]; then
        KUBE_CONFIG_BASE64=$(cat "$KUBE_PATH" | base64 -w 0)
        add_variable "KUBE_CONFIG_STAGING" "$KUBE_CONFIG_BASE64" true false "file"
        add_variable "KUBE_CONFIG_PROD" "$KUBE_CONFIG_BASE64" true false "file"
    else
        echo "  ⚠️  Kubeconfig not found, skipping..."
    fi
fi

echo ""
echo "========================================"
echo "Step 4: Saving Secrets Locally"
echo "========================================"

cat > gitlab-secrets-backup.txt <<EOF
========================================
GitLab Secrets - Backup
Generated: $(date)
========================================

JWT_SECRET=$JWT_SECRET
POSTGRES_PASSWORD=$POSTGRES_PASSWORD
RABBITMQ_PASSWORD=$RABBITMQ_PASSWORD
REDIS_PASSWORD=$REDIS_PASSWORD

⚠️  KEEP THIS FILE SECURE!
⚠️  DO NOT COMMIT TO GIT!

========================================
EOF

echo "✓ Secrets saved to: gitlab-secrets-backup.txt"
echo ""

echo "========================================"
echo "✅ Variables Added Successfully!"
echo "========================================"
echo ""
echo "Next steps:"
echo "  1. Verify in GitLab: Settings > CI/CD > Variables"
echo "  2. Enable GitLab Runners"
echo "  3. Push code to trigger pipeline"
echo ""
echo "View variables: $GITLAB_URL/$PROJECT_PATH/-/settings/ci_cd"
echo ""
