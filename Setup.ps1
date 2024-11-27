# Check if running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "This script must be run as Administrator." -ForegroundColor Red
    exit 1
}

# Linked Files (Destination => Source)
$symlinks = @{
    $PROFILE.CurrentUserAllHosts                                                                    = ".\Profile.ps1"
    "$HOME\.gitconfig"                                                                              = ".\.gitconfig"
    "$HOME\AppData\Local\fastfetch"                                                                 = ".\fastfetch"
    "$HOME\AppData\Local\nvim"                                                                      = ".\nvim"
    "$HOME\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" = ".\windowsterminal\settings.json"
    "$HOME\AppData\Roaming\lazygit"                                                                 = ".\lazygit"
	"$ENV:PROGRAMFILES\WezTerm\wezterm_modules"                                                     = ".\wezterm\"
}

$wingetDeps = @(
# Programs
  "Google.Chrome.Dev"
  "Microsoft.PowerShell"
	"Microsoft.PowerToys"
	"Microsoft.VisualStudioCode"
	"Microsoft.WindowsTerminal"
	"Neovim.Neovim"
	"Notepad++.Notepad++"
	"SumatraPDF.SumatraPDF"
	"Zen-Team.Zen-Browser.Optimized"
# Tools
	"ajeetdsouza.zoxide"
	"BurntSushi.ripgrep.MSVC"
	"Chocolatey.Chocolatey"
	"eza-community.eza"
	"Fastfetch-cli.Fastfetch"
	"Git.Git"
	"GitHub.cli"
	"JesseDuffield.lazygit"
	"junegunn.fzf"
	"sharkdp.bat"
	"sharkdp.fd"
	"Starship.Starship"
	"wez.wezterm"
# Programming Languages
	"Python.Launcher"
	"Python.Python.3.12"
	"Python.Python.3.13"
)

$wingetDepsOpt = @(
# Programs
	"Discord.Discord"
	"Google.AndroidStudio"
	"Readdle.Spark"
	"Valve.Steam"
# Tools
# Programming Languages
	"DenoLand.Deno"
	"GoLang.Go"
	"Julialang.Julia"
	"OpenJS.NodeJS"
	"Rustlang.Rustup"
	"zig.zig"
)

$chocoDeps = @(
	"firacode"
  "mingw"
	"nerd-fonts-jetbrainsmono"
  "sqlite"
)

# PS Modules
$psModules = @(
    "CompletionPredictor"
    "PSScriptAnalyzer"
    "ps-color-scripts"
)

# Prompt user to install optional dependencies
$installOptional = Read-Host "Do you want to install optional dependencies? (yes/no)"
if ($installOptional -eq "yes") {
    # Merge the main and optional dependencies
    $wingetDeps = $wingetDeps + $wingetDepsOpt
    Write-Host "Installing all dependencies..."
} else {
    # Use only the main dependencies
    Write-Host "Installing main dependencies only..."
}

# Set working directory
Set-Location $PSScriptRoot
[Environment]::CurrentDirectory = $PSScriptRoot

Write-Host "Installing missing dependencies..."
$installedWingetDeps = winget list | Out-String
foreach ($wingetDep in $wingetDeps) {
    if ($installedWingetDeps -notmatch [regex]::Escape($wingetDep)) {
		winget install --id $wingetDep
		if ($LASTEXITCODE -ne 0) {
			Write-Host "Failed to install: $wingetDep (Exit Code: $LASTEXITCODE)" -ForegroundColor Red
		}
    }
}

# Path Refresh
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

$installedChocoDeps = (choco list --limit-output --id-only).Split("`n")
foreach ($chocoDep in $chocoDeps) {
    if ($installedChocoDeps -notcontains $chocoDep) {
        choco install $chocoDep -y
    }
}

# Install PS Modules
foreach ($psModule in $psModules) {
    if (!(Get-Module -ListAvailable -Name $psModule)) {
        Install-Module -Name $psModule -Force -AcceptLicense -Scope CurrentUser
    }
}

# Persist Environment Variables
[System.Environment]::SetEnvironmentVariable('WEZTERM_CONFIG_FILE', "$PSScriptRoot\wezterm\wezterm.lua", [System.EnvironmentVariableTarget]::User)

# Create Symbolic Links
Write-Host "Creating Symbolic Links..."
foreach ($symlink in $symlinks.GetEnumerator()) {
	Get-Item -Path $symlink.Key -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
	New-Item -ItemType SymbolicLink -Path $symlink.Key -Target (Resolve-Path $symlink.Value) -Force | Out-Null
}

# Prompt user for Git username and email
$gitUsername = Read-Host "Enter your Git username (leave blank to skip)"
$gitEmail = Read-Host "Enter your Git email (leave blank to skip)"

# Check if the user entered a username and email, if so, set them
if ($gitUsername -and $gitEmail) {
    # Set Git username and email
	git config --global --unset user.name
    git config --global user.name "$gitUsername"
	git config --global --unset user.email
    git config --global user.email "$gitEmail"
    
    # Confirm changes
    Write-Host "Git username and email have been set globally:"
    Write-Host "Username: $gitUsername"
    Write-Host "Email: $gitEmail"
} else {
    Write-Host "No changes made to Git configuration."
}

# Install bat themes
bat cache --clear
bat cache --build
