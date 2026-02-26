# GitLab CI/CD - Quick Setup Script
# Run this script to configure GitLab CI/CD variables

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "GitLab CI/CD Configuration Helper" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Project information
$GitLabProjectUrl = Read-Host "Enter your GitLab project URL (e.g., https://gitlab.com/username/red-shopping)"
Write-Host ""

Write-Host "Step 1: Configure Container Registry" -ForegroundColor Yellow
Write-Host "----------------------------------------"
Write-Host "Registry URL: registry.gitlab.com/username/red-shopping" -ForegroundColor Green
Write-Host ""
Write-Host "Add these variables in GitLab:" -ForegroundColor White
Write-Host "  Settings > CI/CD > Variables > Add Variable" -ForegroundColor Gray
Write-Host ""
Write-Host "  CI_REGISTRY = registry.gitlab.com" -ForegroundColor Cyan
Write-Host "  CI_REGISTRY_USER = gitlab-ci-token (auto)" -ForegroundColor Cyan
Write-Host "  CI_REGISTRY_PASSWORD = `$CI_JOB_TOKEN (auto)" -ForegroundColor Cyan
Write-Host ""

Write-Host "Step 2: Encode Kubernetes Config" -ForegroundColor Yellow
Write-Host "----------------------------------------"

$hasKubeConfig = Read-Host "Do you have a kubeconfig file? (y/n)"

if ($hasKubeConfig -eq "y") {
    $kubeConfigPath = Read-Host "Enter path to kubeconfig file (default: ~/.kube/config)"
    
    if ([string]::IsNullOrWhiteSpace($kubeConfigPath)) {
        $kubeConfigPath = "$HOME\.kube\config"
    }
    
    if (Test-Path $kubeConfigPath) {
        $kubeConfigBase64 = [Convert]::ToBase64String([System.IO.File]::ReadAllBytes($kubeConfigPath))
        $outputFile = "kube-config-base64.txt"
        $kubeConfigBase64 | Out-File $outputFile
        Write-Host ""
        Write-Host "✅ Kubeconfig encoded successfully!" -ForegroundColor Green
        Write-Host "Saved to: $outputFile" -ForegroundColor Green
        Write-Host ""
        Write-Host "Add this as KUBE_CONFIG_STAGING or KUBE_CONFIG_PROD in GitLab variables" -ForegroundColor Cyan
        Write-Host "Type: File | Protected: Yes | Masked: No" -ForegroundColor Gray
        Write-Host ""
    } else {
        Write-Host "❌ Kubeconfig file not found: $kubeConfigPath" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Step 3: Generate JWT Secret" -ForegroundColor Yellow
Write-Host "----------------------------------------"

# Generate random JWT secret
$jwtSecret = -join ((65..90) + (97..122) + (48..57) | Get-Random -Count 64 | ForEach-Object {[char]$_})
Write-Host "Generated JWT_SECRET:" -ForegroundColor Cyan
Write-Host $jwtSecret -ForegroundColor Green
Write-Host ""
Write-Host "Add this as JWT_SECRET in GitLab variables" -ForegroundColor White
Write-Host "Type: Variable | Protected: Yes | Masked: Yes" -ForegroundColor Gray
Write-Host ""

Write-Host "Step 4: Database Passwords" -ForegroundColor Yellow
Write-Host "----------------------------------------"

# Generate PostgreSQL password
$postgresPassword = -join ((65..90) + (97..122) + (48..57) | Get-Random -Count 32 | ForEach-Object {[char]$_})
Write-Host "Generated POSTGRES_PASSWORD:" -ForegroundColor Cyan
Write-Host $postgresPassword -ForegroundColor Green
Write-Host ""

# Generate RabbitMQ password
$rabbitmqPassword = -join ((65..90) + (97..122) + (48..57) | Get-Random -Count 32 | ForEach-Object {[char]$_})
Write-Host "Generated RABBITMQ_PASSWORD:" -ForegroundColor Cyan
Write-Host $rabbitmqPassword -ForegroundColor Green
Write-Host ""

Write-Host "Step 5: Summary of Variables to Add" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Go to: $GitLabProjectUrl/-/settings/ci_cd" -ForegroundColor White
Write-Host ""
Write-Host "Add these variables:" -ForegroundColor White
Write-Host ""

$variables = @(
    @{Name="CI_REGISTRY"; Value="registry.gitlab.com"; Type="Variable"; Protected=$false; Masked=$false},
    @{Name="K8S_NAMESPACE"; Value="red-shopping"; Type="Variable"; Protected=$false; Masked=$false},
    @{Name="KUBE_CONFIG_STAGING"; Value="(base64 from kube-config-base64.txt)"; Type="File"; Protected=$true; Masked=$false},
    @{Name="KUBE_CONFIG_PROD"; Value="(base64 from kube-config-base64.txt)"; Type="File"; Protected=$true; Masked=$false},
    @{Name="JWT_SECRET"; Value=$jwtSecret; Type="Variable"; Protected=$true; Masked=$true},
    @{Name="POSTGRES_PASSWORD"; Value=$postgresPassword; Type="Variable"; Protected=$true; Masked=$true},
    @{Name="RABBITMQ_PASSWORD"; Value=$rabbitmqPassword; Type="Variable"; Protected=$true; Masked=$true}
)

foreach ($var in $variables) {
    Write-Host "  $($var.Name)" -ForegroundColor Cyan
    Write-Host "    Value: $($var.Value)" -ForegroundColor Gray
    Write-Host "    Type: $($var.Type) | Protected: $($var.Protected) | Masked: $($var.Masked)" -ForegroundColor DarkGray
    Write-Host ""
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Step 6: Enable GitLab Runner" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Option 1: Use Shared Runners (Recommended)" -ForegroundColor Green
Write-Host "  Go to: Settings > CI/CD > Runners" -ForegroundColor White
Write-Host "  Enable: Shared runners for this project" -ForegroundColor White
Write-Host ""
Write-Host "Option 2: Install Specific Runner" -ForegroundColor Yellow
Write-Host "  1. Install GitLab Runner:" -ForegroundColor White
Write-Host "     https://docs.gitlab.com/runner/install/" -ForegroundColor Gray
Write-Host ""
Write-Host "  2. Register runner:" -ForegroundColor White
Write-Host "     gitlab-runner register" -ForegroundColor Gray
Write-Host ""
Write-Host "  3. Configuration:" -ForegroundColor White
Write-Host "     - Executor: docker" -ForegroundColor Gray
Write-Host "     - Default image: docker:24-dind" -ForegroundColor Gray
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Step 7: First Pipeline Run" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Commit and push .gitlab-ci.yml:" -ForegroundColor White
Write-Host "   git add .gitlab-ci.yml" -ForegroundColor Gray
Write-Host "   git commit -m 'Add GitLab CI/CD pipeline'" -ForegroundColor Gray
Write-Host "   git push origin develop" -ForegroundColor Gray
Write-Host ""
Write-Host "2. Go to: CI/CD > Pipelines" -ForegroundColor White
Write-Host "3. Monitor the pipeline execution" -ForegroundColor White
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "✅ Configuration Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. Add all variables in GitLab" -ForegroundColor White
Write-Host "  2. Enable runners" -ForegroundColor White
Write-Host "  3. Push code to trigger first pipeline" -ForegroundColor White
Write-Host "  4. Read docs/GITLAB-CI-CD.md for more info" -ForegroundColor White
Write-Host ""
Write-Host "Documentation: $GitLabProjectUrl/-/blob/main/docs/GITLAB-CI-CD.md" -ForegroundColor Cyan
Write-Host ""
