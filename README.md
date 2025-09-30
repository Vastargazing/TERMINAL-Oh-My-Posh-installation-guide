# 🚀 PowerShell Supercharged Setup

> Transform your PowerShell into a modern, productive terminal with smart autocomplete, fuzzy search, and beautiful themes

<img width="2559" alt="PowerShell Setup Preview" src="https://github.com/user-attachments/assets/89050ab9-ffc9-4c29-83e7-d09fb88d6255" />

**Perfect for:** Backend Engineers, ML Engineers, DevOps, or anyone who lives in the terminal

---

## 📋 Table of Contents

- [Why This Setup?](#-why-this-setup)
- [Features](#-features)
- [Prerequisites](#-prerequisites)
- [Installation](#-installation)
- [Configuration](#-configuration)
- [Usage Guide](#-usage-guide)
- [Customization](#-customization)
- [Troubleshooting](#-troubleshooting)

---

## 🎯 Why This Setup?

Stop wasting time typing long commands and navigating directories. This setup gives you:

- **Smart autocomplete** from command history (like Fish shell)
- **Fuzzy search** through commands and files (`Ctrl+R`, `Ctrl+T`)
- **Smart directory jumping** - type `z project` instead of `cd ~/long/path/to/project`
- **Beautiful themes** with git status, execution time, and icons
- **Production-ready aliases** for Git, Python, Docker workflows

---

## ✨ Features

### Core Components

- **Oh My Posh** - Beautiful, customizable prompt with themes
- **PSReadLine** - Smart autocomplete from history
- **Terminal-Icons** - File type icons in directory listings
- **FZF** - Fuzzy finder for commands and files (game changer!)
- **Z** - Jump to frequently used directories instantly

### Included Aliases

- **Git shortcuts** - `gs`, `gp`, `glog`, `gca`, and 30+ more
- **Python helpers** - `venv`, `activate`, `pir`, `pytest`, `testcov`
- **Docker shortcuts** - `dps`, `dcu`, `dcd`
- **Quality checks** - `vulture-check`, `radon-cc`
- **Utility functions** - `proj-status`, `precommit`

---

## 📋 Prerequisites

- **Windows 10/11**
- **PowerShell 5.1+** (usually pre-installed)
- **Windows Terminal** (recommended but optional - [Download here](https://aka.ms/terminal))

Check your PowerShell version:
```powershell
$PSVersionTable.PSVersion
```

---

## 🚀 Script (Quick Install) - https://github.com/Vastargazing/TERMINAL-Oh-My-Posh-installation-guide/blob/main/install.ps1

### One-Command Install (Recommended)

Run this in PowerShell **as Administrator**:

```powershell
irm https://raw.githubusercontent.com/YOUR_USERNAME/powershell-supercharged/main/install.ps1 | iex
```

### Manual Install

1. Download `install.ps1`
2. Right-click → **Run with PowerShell**
3. Follow the prompts

### Custom Install Options

```powershell
# Choose a different theme
.\install.ps1 -Theme "agnoster"

# Skip font installation
.\install.ps1 -SkipFont

# Don't modify profile (manual setup)
.\install.ps1 -SkipProfile
```

### After Installation

1. **Restart PowerShell** (close and reopen)
2. **Set Nerd Font** in Windows Terminal:
   - `Ctrl+,` → Profile → Appearance → Font → "MesloLGM Nerd Font"
3. **Start using!** Try `Ctrl+R` to search commands

---

### Manual Step 1: Install Core Tools

Open PowerShell and run each command:

```powershell
# 1. Oh My Posh - Beautiful prompt
winget install JanDeDobbeleer.OhMyPosh -s winget

# 2. FZF - Fuzzy finder
winget install fzf

# 3. Enable script execution (IMPORTANT!)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

When asked to confirm execution policy, type `Y` and press Enter.

---

### Step 2: Install PowerShell Modules

```powershell
# Smart autocomplete
Install-Module -Name PSReadLine -Force -SkipPublisherCheck

# File icons
Install-Module -Name Terminal-Icons -Repository PSGallery -Force

# FZF integration
Install-Module -Name PSFzf -Force

# Smart directory navigation
Install-Module -Name z -Force -AllowClobber
```

---

### Step 3: Install Nerd Font

These fonts include icons that make your terminal beautiful:

```powershell
oh-my-posh font install
```

**Choose one:**
- `Meslo` (recommended)
- `CascadiaCode`
- `FiraCode`

**Then configure Windows Terminal:**
1. Open Windows Terminal
2. Press `Ctrl + ,` to open settings
3. Select your PowerShell profile → Appearance → Font face
4. Choose the Nerd Font you installed (e.g., "MesloLGM Nerd Font")
5. Save

---

## ⚙️ Configuration

### Create Your PowerShell Profile

1. **Open your profile for editing:**

```powershell
notepad $PROFILE
```

If the file doesn't exist, Notepad will ask to create it - click "Yes".

---

2. **Copy this complete configuration:**

```powershell
# ============================================
# OH MY POSH - THEME
# ============================================
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\atomicBit.omp.json" | Invoke-Expression

# To try other themes: explorer $env:POSH_THEMES_PATH
# Popular themes: atomicBit, agnoster, jandedobbeleer, paradox, powerlevel10k_rainbow

# ============================================
# PSREADLINE - SMART AUTOCOMPLETE
# ============================================
Import-Module PSReadLine
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

# ============================================
# TERMINAL-ICONS - FILE ICONS
# ============================================
Import-Module Terminal-Icons

# ============================================
# PSFZF - FUZZY FINDER
# ============================================
Import-Module PSFzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'

# ============================================
# Z - SMART DIRECTORY JUMPING
# ============================================
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
function gc { param($m) git commit -m $m }
function gp { git pull }
function gps { git push }
function gco { param($b) git checkout $b }

# History and logs
function glog { git log --oneline --graph --decorate --all }
function glogme { git log --oneline --graph --decorate --author="$(git config user.name)" }
function glast { git log -1 HEAD --stat }

# Diff and changes
function gdiff { git diff }
function gds { git diff --staged }
function gshow { param($commit) git show $commit }

# Branches
function gbr { git branch -a }
function gbd { param($branch) git branch -d $branch }
function gbD { param($branch) git branch -D $branch }

# Stash operations
function gst { git stash }
function gstp { git stash pop }
function gstl { git stash list }

# Sync operations
function gf { git fetch --all --prune }
function gpl { git pull origin $(git branch --show-current) }
function gpsh { git push origin $(git branch --show-current) }

# Cleanup (use with caution!)
function gclean { git clean -fd }
function greset { git reset --hard HEAD }

# Commit shortcuts
function gca { param($msg) git commit -am $msg }
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

# FastAPI shortcuts (if you use it)
function api-dev { uvicorn main:app --reload }
function api-prod { uvicorn main:app --host 0.0.0.0 --port 8000 }

# ============================================
# DOCKER ALIASES
# ============================================
function dps { docker ps }
function dpsa { docker ps -a }
function dcu { docker-compose up -d }
function dcd { docker-compose down }
function dlogs { param($container) docker logs -f $container }
function dexec { param($container) docker exec -it $container /bin/bash }

# ============================================
# UTILITY FUNCTIONS
# ============================================

# Full pre-commit checks
function precommit {
    Write-Host "🔍 Running code quality checks..." -ForegroundColor Yellow
    Write-Host "`n📊 Checking code complexity..." -ForegroundColor Cyan
    python -m radon cc . -a
    Write-Host "`n🧪 Running tests..." -ForegroundColor Cyan
    python -m pytest
    Write-Host "`n✅ Pre-commit checks complete!" -ForegroundColor Green
}

# Quick project status
function proj-status {
    Write-Host "📁 Git Status:" -ForegroundColor Cyan
    git status
    Write-Host "`n🌿 Current Branch:" -ForegroundColor Cyan
    git branch --show-current
    Write-Host "`n📊 Last Commit:" -ForegroundColor Cyan
    git log -1 --oneline
}

# Quick system info
function sysinfo {
    Write-Host "💻 System Information" -ForegroundColor Cyan
    Write-Host "OS: $([System.Environment]::OSVersion.VersionString)"
    Write-Host "PowerShell: $($PSVersionTable.PSVersion)"
    Write-Host "User: $env:USERNAME"
    Write-Host "Computer: $env:COMPUTERNAME"
}
```

---

3. **Save and reload:**

```powershell
# Save the file (Ctrl+S in Notepad), then reload:
. $PROFILE
```

---

## 📖 Usage Guide

### 🎯 Essential Hotkeys

| Hotkey | Action | Example Use |
|--------|--------|-------------|
| `Ctrl+R` | Fuzzy search command history | Find that complex command you ran last week |
| `Ctrl+T` | Fuzzy search files | Quickly find files in large projects |
| `→` (Right Arrow) | Accept autocomplete suggestion | Speeds up typing repeated commands |
| `Tab` | Standard autocomplete | Path and command completion |

---

### 📁 Smart Navigation with Z

**How Z works:** It learns your frequently visited directories and lets you jump to them with partial names.

**Training Z (visit directories a few times):**
```powershell
cd ~/projects/my-app
cd ~/Documents
cd ~/projects/my-app
cd ~/Desktop
cd ~/projects/my-app
```

**Using Z (the magic!):**
```powershell
z app          # → jumps to ~/projects/my-app
z doc          # → jumps to ~/Documents
z desk         # → jumps to ~/Desktop

z -l           # → list all tracked directories with scores
```

**Pro tip:** The more you visit a directory, the higher its priority!

---

### 🔧 Git Workflow Examples

**Daily workflow:**
```powershell
# Start your day
z my-project   # Jump to project
gs             # Check status
glog           # See commit history
gp             # Pull latest changes

# Make changes
ga             # Stage all changes
gc "feat: add new feature"  # Commit
gps            # Push

# Quick commits
gca "fix: bug in parser"  # Add + Commit in one command
```

**Branch workflow:**
```powershell
gbr                          # List all branches
gco -b feature-new-thing     # Create and checkout new branch
# ... make changes ...
gca "feat: implement X"      # Commit
gpsh                         # Push current branch
```

**Checking changes:**
```powershell
gdiff          # See unstaged changes
gds            # See staged changes
glast          # See last commit details
gshow abc123   # See specific commit
```

---

### 🐍 Python Development Examples

**Setting up a new project:**
```powershell
z my-project
venv           # Create virtual environment
activate       # Activate it
pipu           # Upgrade pip
pir            # Install requirements.txt
```

**Testing workflow:**
```powershell
testall        # Run all tests with verbose output
testcov        # Generate HTML coverage report
```

**Before committing:**
```powershell
precommit      # Runs: radon (complexity) + pytest (tests)
```

---

### 🐳 Docker Examples

```powershell
dps            # See running containers
dpsa           # See all containers (including stopped)
dcu            # Start services
dcd            # Stop services
dlogs app      # Follow logs for 'app' container
dexec app      # Enter 'app' container shell
```

---

### 🔍 Fuzzy Search Power

**Searching command history (`Ctrl+R`):**

1. Press `Ctrl+R`
2. Type partial command (e.g., "pytest")
3. See filtered list of all matching commands
4. Use arrows to select
5. Press `Enter` to run or `Esc` to edit

**Searching files (`Ctrl+T`):**

1. Press `Ctrl+T`
2. Type partial filename (e.g., "config")
3. See all matching files
4. Select with arrows, `Enter` inserts the path

---

### 💡 Utility Commands

```powershell
proj-status    # Quick project overview (git status + branch + last commit)
precommit      # Run all code quality checks before committing
sysinfo        # Display system information
ll             # List files with icons
```

---

## 🎨 Customization

### Change Theme

1. **Browse available themes:**
```powershell
explorer $env:POSH_THEMES_PATH
```

2. **Edit your profile:**
```powershell
notepad $PROFILE
```

3. **Change the theme line:**
```powershell
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\YOUR_THEME.omp.json" | Invoke-Expression
```

4. **Reload:**
```powershell
. $PROFILE
```

**Recommended themes:**
- `atomicBit` - Minimal and clean
- `agnoster` - Classic, information-rich
- `jandedobbeleer` - Balanced default
- `paradox` - Colorful and vibrant
- `powerlevel10k_rainbow` - Maximum information

---

### Add Your Own Aliases

1. Open profile:
```powershell
notepad $PROFILE
```

2. Add your aliases at the end:
```powershell
# My custom aliases
function mycommand { your-actual-command }
function deploy { docker-compose up -d --build }
```

3. Save and reload:
```powershell
. $PROFILE
```

---

### Project-Specific Aliases

Add aliases specific to your project:

```powershell
# Django project
function runserver { python manage.py runserver }
function migrate { python manage.py migrate }

# Node project  
function dev { npm run dev }
function build { npm run build }

# Data science project
function notebook { jupyter notebook }
function lab { jupyter lab }
```

---

## 🔧 Troubleshooting

### ❌ "Script execution is disabled"

**Solution:**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```
Run this in PowerShell as Administrator, then restart PowerShell.

---

### ❌ Icons showing as squares/boxes

**Problem:** Nerd Font not properly configured.

**Solution:**
1. Install font: `oh-my-posh font install`
2. Set in Windows Terminal: `Ctrl+,` → Profile → Appearance → Font
3. Select your Nerd Font (e.g., "MesloLGM Nerd Font")
4. Restart Windows Terminal completely

---

### ❌ "Module not found" errors

**Solution:**
```powershell
# Reinstall the module that's missing
Install-Module -Name PSReadLine -Force -SkipPublisherCheck
Install-Module -Name Terminal-Icons -Force
Install-Module -Name PSFzf -Force
Install-Module -Name z -Force -AllowClobber
```

---

### ❌ FZF hotkeys not working

**Solution:**
1. Check fzf is installed: `fzf --version`
2. If not: `winget install fzf`
3. Reinstall PSFzf: `Install-Module -Name PSFzf -Force`
4. Reload profile: `. $PROFILE`
5. Restart PowerShell

---

### ❌ Z not jumping to directories

**Cause:** Z needs to "learn" your directories first.

**Solution:**
Visit each directory 3-5 times manually:
```powershell
cd ~/projects/my-app  # Visit 1
cd ~
cd ~/projects/my-app  # Visit 2
cd ~
cd ~/projects/my-app  # Visit 3
```

Now try: `z app` - should work!

---

### ❌ Profile loads slowly (>2 seconds)

**Solution:**
Comment out modules you don't use:

```powershell
# Import-Module Terminal-Icons  # Disable if you don't need icons
```

---

## 🚀 Pro Tips

### 1. Master `Ctrl+R` - It's Life-Changing
Instead of retyping or scrolling through history, just press `Ctrl+R` and type a few characters. Game changer for long commands!

### 2. Train Z Immediately
First day: visit all your important project directories 3-5 times. From day 2 onwards, you'll be teleporting everywhere!

### 3. Create Project-Specific Aliases
Every project has repetitive commands. Add them to your profile:
```powershell
function myapp-test { cd ~/projects/myapp && pytest }
function myapp-deploy { cd ~/projects/myapp && docker-compose up -d }
```

### 4. Use Tab Completion Everywhere
Type first few letters + `Tab` - PowerShell will complete paths, commands, even git branches!

### 5. Combine Tools
```powershell
z project      # Jump to project
Ctrl+R         # Find that complex command you ran before
→              # Accept autocomplete from history
```

---

## 📦 Useful Commands Reference

### Profile Management
```powershell
notepad $PROFILE              # Edit profile
. $PROFILE                    # Reload profile
$PROFILE                      # Show profile path
Get-Module -ListAvailable     # List installed modules
```

### Theme Management
```powershell
explorer $env:POSH_THEMES_PATH    # Browse themes
oh-my-posh --version              # Check version
winget upgrade JanDeDobbeleer.OhMyPosh  # Update Oh My Posh
```

### Alias Management
```powershell
Get-Alias                    # List all aliases
Get-Command function:*       # List all functions
```

---

## 🤝 Contributing

Found a bug? Have a cool alias to share? Contributions welcome!

1. Fork this repo
2. Add your improvements
3. Submit a pull request

---

## 📄 License

MIT License - Use it, share it, modify it as you like!

---

## ⭐ Star This Repo!

If this setup saved you time, give it a star! ⭐

---

## 🙏 Credits

Inspired by the best practices from:
- Backend Engineers at top tech companies
- ML Platform Engineers
- DevOps communities
- The amazing PowerShell community

---

## 📞 Support

- **Issues?** Open an issue on GitHub
- **Questions?** Start a discussion
- **Want to share your setup?** Submit a PR!

---

Made with ❤️ for developers who love productivity

**Happy coding! 🚀**


