# Aliases ---------------------------------------

# better cd
function Get-GoBack { & z ../. }
Set-Alias -Name zz -Value Get-GoBack

# pretty ls
Set-Alias -Name l -Value Get-ChildItemPretty
Set-Alias -Name la -Value Get-ChildItemPretty
Set-Alias -Name ll -Value Get-ChildItemPretty
Set-Alias -Name ls -Value Get-ChildItemPretty -Option AllScope
function Get-PrettyTree { & eza -la --tree --level=3 --ignore-glob='.cache|.git' $args }
Set-Alias -Name lt -Value Get-PrettyTree -Option AllScope

# bash imitators
# Set-Alias -Name cat -Value bat
Set-Alias -Name df -Value Get-Volume
Set-Alias -Name touch -Value New-File
Set-Alias -Name which -Value Show-Command

# Profile
function Get-EditProfile { & nvim $PROFILE }
Set-Alias -Name vz -Value Get-EditProfile

# git
Set-Alias -Name lgit -Value lazygit
function Get-GitClone { & git clone $args }
Set-Alias -Name gcl -Value Get-GitClone -Force -Option AllScope
function Get-GitStatus { & git status -sb $args }
Set-Alias -Name gs -Value Get-GitStatus -Force -Option AllScope
function Get-GitTree { & git log --graph --oneline --decorate $args }
Set-Alias -Name gt -Value Get-GitTree -Force -Option AllScope

# misc
Set-Alias -Name ff -Value fastfetch
function Get-FontList { & (New-Object System.Drawing.Text.InstalledFontCollection).Families }
Set-Alias -Name flist -Value Get-FontList
Set-Alias -Name make -Value "$ENV:PROGRAMDATA\mingw64\mingw64\bin\mingw32-make.exe"
Set-Alias -Name ghc -Value Get-GitHubContent

# applications
Set-Alias -Name np -Value "$ENV:PROGRAMFILES\Notepad++\notepad++.exe"
function Get-BTop { & "$env:USERPROFILE\AppData\Local\BTTop4Win\btop4win.exe" $args }
Set-Alias -Name btop -Value Get-BTop

# editor
# Set-Alias -Name vim -Value nvim

# Functions -------------------------------------
function Get-ChildItemPretty {
    <#
    .SYNOPSIS
        Runs eza with a specific set of arguments. Plus some line breaks before and after the output.
        Alias: ls, ll, la, l
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, Position = 0)]
        [string]$Path = $PWD
    )

    Write-Host ""
    eza -a -l --header --icons --hyperlink --time-style relative $Path
    Write-Host ""
}

function New-File {
    <#
    .SYNOPSIS
        Creates a new file with the specified name and extension. Alias: touch
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Name
    )

    Write-Verbose "Creating new file '$Name'"
    New-Item -ItemType File -Name $Name -Path $PWD | Out-Null
}

function Show-Command {
    <#
    .SYNOPSIS
        Displays the definition of a command. Alias: which
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Name
    )
    Write-Verbose "Showing definition of '$Name'"
    Get-Command $Name | Select-Object -ExpandProperty Definition
}

function note {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$FileName
    )

    $NotesDir = "$HOME\Notes"
    if (-not (Test-Path -Path $NotesDir)) {
        New-Item -Path $NotesDir -ItemType Directory | Out-Null
    }

    $FilePath = Join-Path -Path $NotesDir -ChildPath $FileName
    $DirectoryPath = Split-Path -Path $FilePath -Parent

    if (-not (Test-Path -Path $DirectoryPath)) {
        New-Item -Path $DirectoryPath -ItemType Directory | Out-Null
    }

    if (-not (Test-Path -Path $FilePath)) {
        New-Item -Path $FilePath -ItemType File | Out-Null
    }

    Push-Location -Path $NotesDir
    nvim $FilePath
    Pop-Location
}

function Get-GitHubContent {
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$User,
        
        [Parameter(Mandatory = $true, Position = 1)]
        [string]$Repository,
        
        [Parameter(Mandatory = $true, Position = 2)]
        [string]$Path,
        
        [Parameter(Mandatory = $false, Position = 3)]
        [string]$OutputPath = (Get-Location).Path,
        
        [Parameter(Mandatory = $false, Position = 4)]
        [string]$Token
    )
    
    begin {
        if (-not (Test-Path $OutputPath)) {
            New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
        }
        
        $baseUrl = "https://api.github.com/repos/$User/$Repository/contents/$Path"
        
        $headers = @()
        if ($Token) {
            $headers += "-H", "Authorization: token $Token"
        }
    }
    
    process {
        try {
            Write-Host "Fetching content from: $baseUrl" -ForegroundColor Cyan
            
            $response = if ($Token) {
                curl.exe -s $headers $baseUrl | ConvertFrom-Json
            } else {
                curl.exe -s $baseUrl | ConvertFrom-Json
            }
            
            $files = @()
            if ($response -is [Array]) {
                $files = $response | Where-Object { $_.type -eq "file" }
            } else {
                if ($response.type -eq "file") {
                    $files = @($response)
                }
            }
            
            foreach ($file in $files) {
                $outputFile = Join-Path $OutputPath $file.name
                Write-Host "Downloading: $($file.name) -> $outputFile" -ForegroundColor Green
                
                if ($Token) {
                    curl.exe -s -L $headers -o $outputFile $file.download_url
                } else {
                    curl.exe -s -L -o $outputFile $file.download_url
                }
            }
            
            Write-Host "Download completed! Files saved to: $OutputPath" -ForegroundColor Green
        }
        catch {
            Write-Error "An error occurred: $_"
        }
    }
}

# Environment Variables -------------------------
$ENV:STARSHIP_CONFIG = "C:\Users\z003z8wr\.config\starship\starship.toml"
$ENV:_ZO_DATA_DIR = "C:\Users\z003z8wr\.config"
$ENV:BAT_CONFIG_DIR = "C:\Users\z003z8wr\bat"
$ENV:FZF_DEFAULT_OPTS = '--color=fg:-1,fg+:#ffffff,bg:-1,bg+:#3c4048 --color=hl:#5ea1ff,hl+:#5ef1ff,info:#ffbd5e,marker:#5eff6c --color=prompt:#ff5ef1,spinner:#bd5eff,pointer:#ff5ea0,header:#5eff6c --color=gutter:-1,border:#3c4048,scrollbar:#7b8496,label:#7b8496 --color=query:#ffffff --border="rounded" --border-label="" --preview-window="border-rounded" --height 40% --preview="bat -n --color=always {}"'
$ENV:EDITOR = "nvim"

# Set for lazyvim
$systemLocale = Get-Culture
$ENV:LANG = "$($systemLocale.Name).UTF-8"

# Prompt & Shell Configuration ------------------

# Starship
Invoke-Expression (&starship init powershell)

# Zoxide
Invoke-Expression (& { (zoxide init powershell | Out-String) })

# fastfetch
# Skip fastfetch for non-interactive shells
if ([Environment]::GetCommandLineArgs().Contains("-NonInteractive")) {
    return
}
