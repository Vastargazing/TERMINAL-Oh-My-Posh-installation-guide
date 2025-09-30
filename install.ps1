# ============================================
# PowerShell Supercharged - Auto Installer
# ============================================
# Run this script to automatically set up your terminal
# Usage: Right-click -> Run with PowerShell (as Administrator)
#
# Or from PowerShell: .\install.ps1

param(
    [switch]$SkipFont,
    [switch]$SkipProfile,
    [string]$Theme = "atomicBit"
)

# ============================================
# CONFIGURATION
# ============================================
$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

# Colors for output
function Write-ColorOutput($ForegroundColor) {
    $fc = $host.UI.RawUI.ForegroundColor
    $host.UI.RawUI.ForegroundColor = $ForegroundColor
    if ($args) {
        Write-Output $args
    }
    $host.UI.RawUI.ForegroundColor = $fc
}

function Write-Success { Write-ColorOutput Green "✅ $args" }
function Write-Info { Write-ColorOutput Cyan "ℹ️  $args" }
function Write-Warning { Write-ColorOutput Yellow "⚠️  $args" }
function Write-Error { Write-ColorOutput Red "❌ $args" }
function Write-Step { Write-ColorOutput Magenta "`n🚀 $args" }

# ============================================
# HELPER FUNCTIONS
# ============================================

function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Test-CommandExists {
    param($Command)
    $null -ne (Get-Command $Command -ErrorAction SilentlyContinue)
}

function Install-WingetPackage {
    param($PackageId, $Name)
    
    if (Test-CommandExists $PackageId.Split('.')[-1].ToLower()) {
        Write-Info "$Name is already installed"
        return $true
    }
    
    Write-Info "Installing $Name..."
    try {
        winget install $PackageId -s winget --accept-package-agreements --accept-source-agreements --silent | Out-Null
        Write-Success "$Name installed successfully"
        return $true
    }
    catch {
        Write-Error "Failed to install $Name`: $_"
        return $false
    }
}

function Install-PSModule {
    param($ModuleName, $DisplayName)
    
    if (Get-Module -ListAvailable -Name $ModuleName) {
        Write-Info "$DisplayName is already installed"
        return $true
    }
    
    Write-Info "Installing $DisplayName..."
    try {
        Install-Module -Name $ModuleName -Force -Scope CurrentUser -AllowClobber -SkipPublisherCheck | Out-Null
        Write-Success "$DisplayName installed successfully"
        return $true
    }
    catch {
        Write-Error "Failed to install $DisplayName`: $_"
        return $false
    }
}

# ============================================
# MAIN INSTALLATION
# ============================================

Write-Step "PowerShell Supercharged - Auto Installer"
Write-Host ""
Write-Info "This script will install and configure:"
Write-Host "  • Oh My Posh (beautiful prompt)"
Write-Host "  • FZF (fuzzy finder)"
Write-Host "  • PSReadLine (smart autocomplete)"
Write-Host "  • Terminal-Icons (file icons)"
Write-Host "  • PSFzf (FZF integration)"
Write-Host "  • Z (smart directory jumping)"
Write-Host "  • Nerd Font (icons support)"
Write-Host "  • PowerShell profile with aliases"
Write-Host ""

# Check if running as Administrator
if (-not (Test-Administrator)) {
    Write-Warning "This script should be run as Administrator for best results"
    Write-Info "Some features may not install correctly"
    $continue = Read-Host "Continue anyway? (y/N)"
    if ($continue -ne 'y' -and $continue -ne 'Y') {
        Write-Info "Installation cancelled"
        exit
    }
}

# Check if winget is available
if (-not (Test-CommandExists winget)) {
    Write-Error "Winget is not installed. Please install App Installer from Microsoft Store"
    Write-Info "https://aka.ms/getwinget"
    exit 1
}

# ============================================
# STEP 1: Set Execution Policy
# ============================================
Write-Step "Step 1: Setting Execution Policy"

try {
    $currentPolicy = Get-ExecutionPolicy -Scope CurrentUser
    if ($currentPolicy -eq "Restricted" -or $currentPolicy -eq "Undefined") {
        Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
        Write-Success "Execution policy set to RemoteSigned"
    } else {
        Write-Info "Execution policy is already set to $currentPolicy"
    }
}
catch {
    Write-Error "Failed to set execution policy: $_"
}

# ============================================
# STEP 2: Install Core Tools
# ============================================
Write-Step "Step 2: Installing Core Tools"

$success = $true
$success = (Install-WingetPackage "JanDeDobbeleer.OhMyPosh" "Oh My Posh") -and $success
$success = (Install-WingetPackage "fzf" "FZF") -and $success

if (-not $success) {
    Write-Warning "Some core tools failed to install. Continuing anyway..."
}

# Refresh PATH
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# ============================================
# STEP 3: Install PowerShell Modules
# ============================================
Write-Step "Step 3: Installing PowerShell Modules"

$success = $true
$success = (Install-PSModule "PSReadLine" "PSReadLine (Smart Autocomplete)") -and $success
$success = (Install-PSModule "Terminal-Icons" "Terminal-Icons (File Icons)") -and $success
$success = (Install-PSModule "PSFzf" "PSFzf (Fuzzy Finder Integration)") -and $success
$success = (Install-PSModule "z" "Z (Smart Navigation)") -and $success

if (-not $success) {
    Write-Warning "Some modules failed to install. Check errors above."
}

# ============================================
# STEP 4: Install Nerd Font
# ============================================
if (-not $SkipFont) {
    Write-Step "Step 4: Installing Nerd Font"
    
    Write-Info "Installing Meslo Nerd Font..."
    Write-Warning "A font installation window will appear - click Install"
    
    try {
        oh-my-posh font install Meslo
        Write-Success "Nerd Font installed"
        Write-Info "Remember to set the font in Windows Terminal settings!"
        Write-Info "Ctrl+, → Profile → Appearance → Font → MesloLGM Nerd Font"
    }
    catch {
        Write-Warning "Font installation failed. You can install it manually later."
        Write-Info "Run: oh-my-posh font install"
    }
} else {
    Write-Info "Skipping font installation (--SkipFont flag)"
}

# ============================================
# STEP 5: Create PowerShell Profile
# ============================================
if (-not $SkipProfile) {
    Write-Step "Step 5: Creating PowerShell Profile"
    
    # Backup existing profile if it exists
    if (Test-Path $PROFILE) {
        $backupPath = "$PROFILE.backup.$(Get-Date -Format 'yyyyMMdd_HHmmss')"
        Copy-Item $PROFILE $backupPath
        Write-Info "Existing profile backed up to: $backupPath"
    }
    
    # Ensure profile directory exists
    $profileDir = Split-Path $PROFILE
    if (-not (Test-Path $profileDir)) {
        New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
    }
    
    # Create profile content
    $profileContent = @"
# ============================================
# PowerShell Supercharged Profile
# Generated by Auto Installer
# ============================================

# OH MY POSH - THEME
oh-my-posh init pwsh --config "`$env:POSH_THEMES_PATH\$Theme.omp.json" | Invoke-Expression

# PSREADLINE - SMART AUTOCOMPLETE
Import-Module PSReadLine
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

# TERMINAL-ICONS - FILE ICONS
Import-Module Terminal-Icons

# PSFZF - FUZZY FINDER
Import-Module PSFzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'

# Z - SMART DIRECTORY JUMPING
Import-Module z

# ============================================
# BASIC ALIASES
# ============================================
Set-Alias -Name ll -Value Get-ChildItem

# ============================================
# GIT ALIASES
# ============================================

# Basic operations
function gs { git status }
function ga { git add . }
function gc { param(`$m) git commit -m `$m }
function gp { git pull }
function gps { git push }
function gco { param(`$b) git checkout `$b }

# History and logs
function glog { git log --oneline --graph --decorate --all }
function glogme { git log --oneline --graph --decorate --author="`$(git config user.name)" }
function glast { git log -1 HEAD --stat }

# Diff and changes
function gdiff { git diff }
function gds { git diff --staged }
function gshow { param(`$commit) git show `$commit }

# Branches
function gbr { git branch -a }
function gbd { param(`$branch) git branch -d `$branch }
function gbD { param(`$branch) git branch -D `$branch }

# Stash operations
function gst { git stash }
function gstp { git stash pop }
function gstl { git stash list }

# Sync operations
function gf { git fetch --all --prune }
function gpl { git pull origin `$(git branch --show-current) }
function gpsh { git push origin `$(git branch --show-current) }

# Cleanup (use with caution!)
function gclean { git clean -fd }
function greset { git reset --hard HEAD }

# Commit shortcuts
function gca { param(`$msg) git commit -am `$msg }
function gamend { git commit --amend --no-edit }

# ============================================
# PYTHON ALIASES
# ============================================

# Virtual environment
function venv { python -m venv .venv }
function activate { 
    if (Test-Path .\.venv\Scripts\Activate.ps1) {
        .\.venv\Scripts\Activate.ps1
    } else {
        Write-Host "No virtual environment found in current directory" -ForegroundColor Red
    }
}

# Pip management
function pir { pip install -r requirements.txt }
function pipu { pip install --upgrade pip }
function pipf { pip freeze > requirements.txt }
function piplist { pip list }

# Testing
function pytest { python -m pytest }
function testall { python -m pytest --verbose }
function testcov { python -m pytest --cov=. --cov-report=html }

# Code quality
function vulture-check { python -m vulture . }
function radon-cc { python -m radon cc . -a }
function radon-mi { python -m radon mi . }

# FastAPI shortcuts
function api-dev { uvicorn main:app --reload }
function api-prod { uvicorn main:app --host 0.0.0.0 --port 8000 }

# ============================================
# DOCKER ALIASES
# ============================================
function dps { docker ps }
function dpsa { docker ps -a }
function dcu { docker-compose up -d }
function dcd { docker-compose down }
function dlogs { param(`$container) docker logs -f `$container }
function dexec { param(`$container) docker exec -it `$container /bin/bash }

# ============================================
# UTILITY FUNCTIONS
# ============================================

# Full pre-commit checks
function precommit {
    Write-Host "🔍 Running code quality checks..." -ForegroundColor Yellow
    Write-Host "``n📊 Checking code complexity..." -ForegroundColor Cyan
    python -m radon cc . -a
    Write-Host "``n🧪 Running tests..." -ForegroundColor Cyan
    python -m pytest
    Write-Host "``n✅ Pre-commit checks complete!" -ForegroundColor Green
}

# Quick project status
function proj-status {
    Write-Host "📁 Git Status:" -ForegroundColor Cyan
    git status
    Write-Host "``n🌿 Current Branch:" -ForegroundColor Cyan
    git branch --show-current
    Write-Host "``n📊 Last Commit:" -ForegroundColor Cyan
    git log -1 --oneline
}

# Quick system info
function sysinfo {
    Write-Host "💻 System Information" -ForegroundColor Cyan
    Write-Host "OS: `$([System.Environment]::OSVersion.VersionString)"
    Write-Host "PowerShell: `$(`$PSVersionTable.PSVersion)"
    Write-Host "User: `$env:USERNAME"
    Write-Host "Computer: `$env:COMPUTERNAME"
}

# ============================================
# WELCOME MESSAGE
# ============================================
Write-Host "🚀 PowerShell Supercharged loaded!" -ForegroundColor Green
Write-Host "💡 Try: Ctrl+R (search commands), Ctrl+T (search files), z <dir> (jump)" -ForegroundColor Cyan
"@

    # Write profile
    try {
        $profileContent | Out-File -FilePath $PROFILE -Encoding UTF8 -Force
        Write-Success "PowerShell profile created successfully"
    }
    catch {
        Write-Error "Failed to create profile: $_"
    }
} else {
    Write-Info "Skipping profile creation (--SkipProfile flag)"
}

# ============================================
# STEP 6: Verify Installation
# ============================================
Write-Step "Step 6: Verifying Installation"

$verifications = @(
    @{ Command = "oh-my-posh"; Name = "Oh My Posh" },
    @{ Command = "fzf"; Name = "FZF" }
)

$allGood = $true
foreach ($check in $verifications) {
    if (Test-CommandExists $check.Command) {
        Write-Success "$($check.Name) is available"
    } else {
        Write-Warning "$($check.Name) not found in PATH"
        $allGood = $false
    }
}

# Check modules
$modules = @("PSReadLine", "Terminal-Icons", "PSFzf", "z")
foreach ($module in $modules) {
    if (Get-Module -ListAvailable -Name $module) {
        Write-Success "$module module installed"
    } else {
        Write-Warning "$module module not found"
        $allGood = $false
    }
}

# ============================================
# FINAL STEPS
# ============================================
Write-Step "Installation Complete!"

if ($allGood) {
    Write-Host ""
    Write-Success "All components installed successfully! 🎉"
} else {
    Write-Host ""
    Write-Warning "Some components had issues. Check the warnings above."
}

Write-Host ""
Write-Info "Next Steps:"
Write-Host "  1. Close and reopen PowerShell (or Windows Terminal)"
Write-Host "  2. Set your Nerd Font in Windows Terminal:"
Write-Host "     Ctrl+, → Profile → Appearance → Font → MesloLGM Nerd Font"
Write-Host "  3. Start using your superpowered terminal!"
Write-Host ""
Write-Info "Quick Start:"
Write-Host "  • Ctrl+R - Search command history"
Write-Host "  • Ctrl+T - Search files"
Write-Host "  • z <dirname> - Jump to directory (after visiting it a few times)"
Write-Host "  • ll - List files with icons"
Write-Host "  • gs - Git status"
Write-Host "  • glog - Beautiful git log"
Write-Host ""
Write-Info "Documentation: Check README.md for full usage guide"
Write-Host ""
Write-Success "Happy coding! 🚀"
