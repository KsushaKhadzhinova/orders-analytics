# Read-only check of the environment. Changes nothing.
# Run from the project root:  powershell -ExecutionPolicy Bypass -File scripts\check-env.ps1

$root = Split-Path -Parent $PSScriptRoot
Set-Location $root
$venvPy = Join-Path $root '.venv\Scripts\python.exe'

function Show($name, $cmd) {
    try { $out = & $cmd 2>&1 | Out-String; Write-Host ("[{0}] {1}" -f $name, $out.Trim()) }
    catch { Write-Host ("[{0}] FAILED: {1}" -f $name, $_.Exception.Message) }
}

Show 'pwsh'    { pwsh --version }
Show 'git'     { git --version }
Show 'accelerator' { accelerator --version | Select-Object -First 1 }
Show 'claude'  { claude --version }
Show 'pester'  { (Get-Module -ListAvailable Pester | Where-Object Version -eq '5.6.1') -ne $null }

if (-not (Test-Path $venvPy)) { Write-Host "[venv] missing: run scripts\setup-env.ps1 first"; exit 1 }

Show 'python'  { & $venvPy --version }
Show 'pip check' { & $venvPy -m pip check }
Show 'dbt'     { & $venvPy -m dbt.cli.main --version | Select-Object -First 3 }
Show 'pytest'  { & $venvPy -m pytest --version }
Show 'duckdb'  { & $venvPy -c "import duckdb; print(duckdb.__version__)" }

# If the duckdb DLL is blocked by Application Control, say so; do NOT try to bypass it.
$dll = & $venvPy -c "import duckdb" 2>&1 | Out-String
if ($dll -match 'Application Control') {
    Write-Host "[policy] Windows Application Control blocks the duckdb DLL."
    Write-Host "         This needs an administrator decision (an exception for the .venv folder)."
}
