# Check if running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "This script must be run as Administrator." -ForegroundColor Red
    exit 1
}

# Registry settings to change
$settings = @(
	# File explorer settings
    @{
        KeyPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer";
        ValueName = "ShowFrequent";
        ValueData = "0";
        ValueType = "DWORD";
		Comment = "Show recently used files";
    },
	@{
        KeyPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer";
        ValueName = "ShowRecent";
        ValueData = "0";
        ValueType = "DWORD";
		Comment = "Show frequently used folders";
    },
	@{
        KeyPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer";
        ValueName = "ShowCloudFilesInQuickAccess";
        ValueData = "0";
        ValueType = "DWORD";
		Comment = "Show files from Office.com";
    },
	@{
        KeyPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced";
        ValueName = "Hidden";
        ValueData = "1";
        ValueType = "DWORD";
		Comment = "Show hidden files, folders, and drives";
    },
	@{
        KeyPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced";
        ValueName = "HideFileExt";
        ValueData = "0";
        ValueType = "DWORD";
		Comment = "Hide extensions for known file types";
    },
	@{
        KeyPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced";
        ValueName = "UseCompactMode";
        ValueData = "1";
        ValueType = "DWORD";
		Comment = "Decrease space between items (compact view)";
    },
	# Taskbar settings
	@{
        KeyPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search";
        ValueName = "SearchboxTaskbarMode";
        ValueData = "0";
        ValueType = "DWORD";
		Comment = "Remove search from the taskbar";
    },
	@{
        KeyPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced";
        ValueName = "ShowTaskViewButton";
        ValueData = "0";
        ValueType = "DWORD";
		Comment = "Remove task view from taskbar";
    },
	@{
        KeyPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced";
        ValueName = "TaskbarAl";
        ValueData = "1";
        ValueType = "DWORD";
		Comment = "Specify location of taskbar (0 - left, 1 - center)";
    },
<# 	@{
        KeyPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced";
        ValueName = "TaskbarDa";
        ValueData = "0";
        ValueType = "DWORD";
		Comment = "Remove widgets from taskbar";
    }, #>
	@{
        KeyPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced";
        ValueName = "TaskbarMn";
        ValueData = "0";
        ValueType = "DWORD";
		Comment = "Remove chat from taskbar";
    }
)

# Loop through each setting
foreach ($setting in $settings) {
    try {
        # Apply registry change
        Set-ItemProperty -Path $setting.KeyPath -Name $setting.ValueName -Value $setting.ValueData -Type $setting.ValueType

        # Verify the change
        $currentValue = Get-ItemProperty -Path $setting.KeyPath -Name $setting.ValueName
        if ($currentValue.$($setting.ValueName) -eq $setting.ValueData) {
            Write-Host "Successfully updated $($setting.ValueName) at $($setting.KeyPath)" -ForegroundColor Green
        } else {
            Write-Host "Failed to update $($setting.ValueName) at $($setting.KeyPath)" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "Error updating $($setting.ValueName) at $($setting.KeyPath): $_" -ForegroundColor Red
    }
}

# Need to stop Explorer process for changes to apply
Stop-Process -ProcessName explorer