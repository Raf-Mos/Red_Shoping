# Script to automatically add GitLab CI/CD variables via API
# Usage: .\scripts\add-gitlab-variables.ps1

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "GitLab Variables - Bulk Upload" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Configuration
Write-Host "Step 1: GitLab Configuration" -ForegroundColor Yellow
Write-Host "----------------------------------------"
$GitLabUrl = Read-Host "GitLab URL (default: https://gitlab.com)"
if ([string]::IsNullOrWhiteSpace($GitLabUrl)) {
    $GitLabUrl = "https://gitlab.com"
}

$ProjectPath = Read-Host "Project Path (e.g., username/red-shopping)"
$AccessToken = Read-Host "Personal Access Token (with api scope)" -AsSecureString
$AccessTokenPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($AccessToken))

Write-Host ""
Write-Host "Step 2: Encoding Project Path" -ForegroundColor Yellow
Write-Host "----------------------------------------"
# URL encode project path
$ProjectPathEncoded = [System.Web.HttpUtility]::UrlEncode($ProjectPath)
$ApiUrl = "$GitLabUrl/api/v4/projects/$ProjectPathEncoded/variables"

Write-Host "API URL: $ApiUrl" -ForegroundColor Gray
Write-Host ""

# Function to add variable
function Add-GitLabVariable {
    param(
        [string]$Key,
        [string]$Value,
        [bool]$Protected = $false,
        [bool]$Masked = $false,
        [string]$VariableType = "env_var"  # env_var or file
    )
    
    $body = @{
        key = $Key
        value = $Value
        protected = $Protected
        masked = $Masked
        variable_type = $VariableType
    } | ConvertTo-Json

    $headers = @{
        "PRIVATE-TOKEN" = $AccessTokenPlain
        "Content-Type" = "application/json"
    }

    try {
        $response = Invoke-RestMethod -Uri $ApiUrl -Method Post -Headers $headers -Body $body
        Write-Host "  ✅ Added: $Key" -ForegroundColor Green
        return $true
    } catch {
        if ($_.Exception.Response.StatusCode -eq 400) {
            Write-Host "  ⚠️  Already exists: $Key (skipping)" -ForegroundColor Yellow
        } else {
            Write-Host "  ❌ Failed: $Key - $($_.Exception.Message)" -ForegroundColor Red
        }
        return $false
    }
}

Write-Host "Step 3: Generating Secrets" -ForegroundColor Yellow
Write-Host "----------------------------------------"

# Generate secrets
$jwtSecret = -join ((65..90) + (97..122) + (48..57) | Get-Random -Count 64 | ForEach-Object {[char]$_})
$postgresPassword = -join ((65..90) + (97..122) + (48..57) | Get-Random -Count 32 | ForEach-Object {[char]$_})
$rabbitmqPassword = -join ((65..90) + (97..122) + (48..57) | Get-Random -Count 32 | ForEach-Object {[char]$_})
$redisPassword = -join ((65..90) + (97..122) + (48..57) | Get-Random -Count 32 | ForEach-Object {[char]$_})

Write-Host "Secrets generated ✓" -ForegroundColor Green
Write-Host ""

# Kubeconfig handling
Write-Host "Step 4: Kubeconfig (Optional)" -ForegroundColor Yellow
Write-Host "----------------------------------------"
$addKubeConfig = Read-Host "Add kubeconfig? (y/n)"
$kubeConfigBase64 = ""

if ($addKubeConfig -eq "y") {
    $kubeConfigPath = Read-Host "Path to kubeconfig (default: ~/.kube/config)"
    if ([string]::IsNullOrWhiteSpace($kubeConfigPath)) {
        $kubeConfigPath = "$HOME\.kube\config"
    }
    
    if (Test-Path $kubeConfigPath) {
        $kubeConfigBase64 = [Convert]::ToBase64String([System.IO.File]::ReadAllBytes($kubeConfigPath))
        Write-Host "Kubeconfig encoded ✓" -ForegroundColor Green
    } else {
        Write-Host "Kubeconfig not found, skipping..." -ForegroundColor Yellow
    }
}
Write-Host ""

Write-Host "Step 5: Adding Variables to GitLab" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Define all variables
$variables = @(
    # Registry
    @{Key="CI_REGISTRY"; Value="registry.gitlab.com"; Protected=$false; Masked=$false},
    
    # Kubernetes
    @{Key="K8S_NAMESPACE"; Value="red-shopping"; Protected=$false; Masked=$false},
    
    # JWT Secret
    @{Key="JWT_SECRET"; Value=$jwtSecret; Protected=$true; Masked=$true},
    @{Key="JWT_EXPIRATION"; Value="24h"; Protected=$false; Masked=$false},
    
    # PostgreSQL
    @{Key="POSTGRES_USER"; Value="postgres"; Protected=$true; Masked=$false},
    @{Key="POSTGRES_PASSWORD"; Value=$postgresPassword; Protected=$true; Masked=$true},
    @{Key="PRODUCT_DB_NAME"; Value="products_db"; Protected=$false; Masked=$false},
    @{Key="ORDER_DB_NAME"; Value="orders_db"; Protected=$false; Masked=$false},
    
    # MongoDB
    @{Key="MONGO_URI"; Value="mongodb://mongodb:27017/users_db"; Protected=$false; Masked=$false},
    @{Key="MONGO_DB_NAME"; Value="users_db"; Protected=$false; Masked=$false},
    
    # RabbitMQ
    @{Key="RABBITMQ_HOST"; Value="rabbitmq"; Protected=$false; Masked=$false},
    @{Key="RABBITMQ_PORT"; Value="5672"; Protected=$false; Masked=$false},
    @{Key="RABBITMQ_USER"; Value="guest"; Protected=$false; Masked=$false},
    @{Key="RABBITMQ_PASSWORD"; Value=$rabbitmqPassword; Protected=$true; Masked=$true},
    @{Key="RABBITMQ_QUEUE"; Value="notifications"; Protected=$false; Masked=$false},
    
    # Redis
    @{Key="REDIS_HOST"; Value="redis"; Protected=$false; Masked=$false},
    @{Key="REDIS_PORT"; Value="6379"; Protected=$false; Masked=$false},
    @{Key="REDIS_PASSWORD"; Value=$redisPassword; Protected=$true; Masked=$true},
    
    # Environment
    @{Key="NODE_ENV"; Value="development"; Protected=$false; Masked=$false},
    @{Key="FLASK_ENV"; Value="development"; Protected=$false; Masked=$false},
    @{Key="LOG_LEVEL"; Value="info"; Protected=$false; Masked=$false}
)

# Add Kubeconfig if provided
if ($kubeConfigBase64 -ne "") {
    $variables += @{Key="KUBE_CONFIG_STAGING"; Value=$kubeConfigBase64; Protected=$true; Masked=$false; Type="file"}
    $variables += @{Key="KUBE_CONFIG_PROD"; Value=$kubeConfigBase64; Protected=$true; Masked=$false; Type="file"}
}

# Add variables
$successCount = 0
$failCount = 0
$skipCount = 0

foreach ($var in $variables) {
    $varType = if ($var.ContainsKey("Type")) { $var.Type } else { "env_var" }
    
    $result = Add-GitLabVariable `
        -Key $var.Key `
        -Value $var.Value `
        -Protected $var.Protected `
        -Masked $var.Masked `
        -VariableType $varType
    
    if ($result) {
        $successCount++
    } else {
        $failCount++
    }
    
    Start-Sleep -Milliseconds 200  # Rate limiting
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Summary" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "✅ Added: $successCount" -ForegroundColor Green
Write-Host "❌ Failed: $failCount" -ForegroundColor Red
Write-Host ""

# Save secrets to file
Write-Host "Step 6: Saving Secrets Locally" -ForegroundColor Yellow
Write-Host "----------------------------------------"
$secretsFile = "gitlab-secrets-backup.txt"
$secrets = @"
========================================
GitLab Secrets - Backup
Generated: $(Get-Date)
========================================

JWT_SECRET=$jwtSecret
POSTGRES_PASSWORD=$postgresPassword
RABBITMQ_PASSWORD=$rabbitmqPassword
REDIS_PASSWORD=$redisPassword

⚠️  KEEP THIS FILE SECURE!
⚠️  DO NOT COMMIT TO GIT!

========================================
"@

$secrets | Out-File $secretsFile -Encoding UTF8
Write-Host "Secrets saved to: $secretsFile" -ForegroundColor Green
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "✅ Variables Added Successfully!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. Verify in GitLab: Settings > CI/CD > Variables" -ForegroundColor White
Write-Host "  2. Enable GitLab Runners" -ForegroundColor White
Write-Host "  3. Push code to trigger pipeline" -ForegroundColor White
Write-Host ""
Write-Host "View variables: $GitLabUrl/$ProjectPath/-/settings/ci_cd" -ForegroundColor Cyan
Write-Host ""
