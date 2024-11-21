# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
# Install global packages for various programming environments
# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

# --- Julia ---
$juliaPM = Get-Command juliaup -ErrorAction SilentlyContinue
if ($juliaPM) {
	$version = julia -v
	$pmVersion = juliaup -V
	Write-Host "✔ $version is installed ($pmVersion)" -ForegroundColor Green
}

# --- NodeJS ---
$packages = @(
	"neovim"
	"npm"
)

$nodePM = Get-Command npm -ErrorAction SilentlyContinue
if ($nodePM) {
	$version = node -v
	$pmVersion = npm -v
	Write-Host "✔ NodeJS $version is installed (npm $pmVersion)" -ForegroundColor Green
	
	foreach ($tool in $tools) {
		try {
			npm install -g $tool
		} catch {
			Write-Host "Error processing: $tool" -ForegroundColor Red
		}
	}
}

# --- Python ---
$packages = @(
	"neovim"
	"pip"
	"pipdeptree"
)

$pythonPM = Get-Command pip -ErrorAction SilentlyContinue
if ($pythonPM) {	
	try {
		deactivate
	}
	$version = python -V
	$pmVersion = python -m pip -V
	Write-Host "✔ $version is installed ($pmVersion)" -ForegroundColor Green
	
	foreach ($tool in $tools) {
		
		try {
			python -m pip install $tool --upgrade
		} catch {
			Write-Host "Error processing: $tool" -ForegroundColor Red
		}
	}
}

# --- Rust ---
$tools = @(
	"ast-grep"
	"neovim"
)

$rustPM = Get-Command cargo -ErrorAction SilentlyContinue
if ($rustPM) {
	$version = rustc -V
	$pmVersion = cargo -V
	$tcVersion = rustup -V
	Write-Host "✔ $version is installed ($pmVersion - $tcVersion)" -ForegroundColor Green
	
	# Required for cargo (requires link.exe)
	winget install --id Microsoft.VisualStudio.2022.BuildTools --force --override "--wait --passive --add Microsoft.VisualStudio.ComponentGroup.UWP.VC.BuildTools"

	foreach ($tool in $tools) {
		try {
			cargo install $tool --locked
		} catch {
			Write-Host "Error processing: $tool" -ForegroundColor Red
		}
	}
}