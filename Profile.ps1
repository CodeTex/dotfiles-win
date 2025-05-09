# Aliases ---------------------------------------
Set-Alias -Name cat -Value bat
Set-Alias -Name df -Value Get-Volume
Set-Alias -Name l -Value Get-ChildItemPretty
Set-Alias -Name la -Value Get-ChildItemPretty
Set-Alias -Name lgit -Value lazygit
Set-Alias -Name ll -Value Get-ChildItemPretty
Set-Alias -Name ls -Value Get-ChildItemPretty
Set-Alias -Name make -Value "$ENV:PROGRAMDATA\mingw64\mingw64\bin\mingw32-make.exe"
Set-Alias -Name np -Value "$ENV:PROGRAMFILES\Notepad++\notepad++.exe"
Set-Alias -Name touch -Value New-File
Set-Alias -Name vi -Value nvim
Set-Alias -Name vim -Value nvim
Set-Alias -Name which -Value Show-Command

# Functions -------------------------------------
function Find-DotfilesRepository {
    <#
    .SYNOPSIS
        Finds the local dofiles repository.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$ProfilePath
    )

    Write-Verbose "Resolving the symbolic link for the profile"
    $profileSymbolicLink = Get-ChildItem $ProfilePath | Where-Object FullName -EQ $PROFILE.CurrentUserAllHosts
    return Split-Path $profileSymbolicLink.Target
}

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

function Get-Subnet-Devices {
	<#
    .SYNOPSIS
        Wrapper for ping, arp and nslookup to get available information about all devices in subnet.
    #>
	param (
        $Subnet
    )
	1..254 | ForEach-Object{
		Start-Process -WindowStyle Hidden ping.exe -Argumentlist "-n 1 -l 0 -f -i 2 -w 1 -4 $SubNet$_"
	}
	$Computers = (arp.exe -a | Select-String "$SubNet.*dynam") -replace ' +',',' | 
		ConvertFrom-Csv -Header Computername,IPv4,MAC,x,Vendor |
		Select Computername,IPv4,MAC

	ForEach ($Computer in $Computers){
		nslookup $Computer.IPv4 |
		Select-String -Pattern "^Name:\s+([^\.]+).*$" |
		ForEach-Object{
		  $Computer.Computername = $_.Matches.Groups[1].Value
		}
	}
	$Computers
}

# Environment Variables -------------------------
$ENV:DotfilesLocalRepo = Find-DotfilesRepository -ProfilePath $PSScriptRoot
$ENV:STARSHIP_CONFIG = "$ENV:DotfilesLocalRepo\starship\starship.toml"
$ENV:_ZO_DATA_DIR = $ENV:DotfilesLocalRepo
$ENV:BAT_CONFIG_DIR = "$ENV:DotfilesLocalRepo\bat"
$ENV:FZF_DEFAULT_OPTS = '--color=fg:-1,fg+:#ffffff,bg:-1,bg+:#3c4048 --color=hl:#5ea1ff,hl+:#5ef1ff,info:#ffbd5e,marker:#5eff6c --color=prompt:#ff5ef1,spinner:#bd5eff,pointer:#ff5ea0,header:#5eff6c --color=gutter:-1,border:#3c4048,scrollbar:#7b8496,label:#7b8496 --color=query:#ffffff --border="rounded" --border-label="" --preview-window="border-rounded" --height 40% --preview="bat -n --color=always {}"'

# Set for lazyvim
$systemLocale = Get-Culture
$ENV:LANG = "$($systemLocale.Name).UTF-8"

# Prompt & Shell Configuration ------------------

# Starship
Invoke-Expression (&starship init powershell)

# Zoxide
Invoke-Expression (& { (zoxide init powershell | Out-String) })

# Skip fastfetch for non-interactive shells
if ([Environment]::GetCommandLineArgs().Contains("-NonInteractive")) {
    return
}
# fastfetch
