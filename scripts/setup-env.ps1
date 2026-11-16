# Creates the Python 3.11 virtual environment and installs the project
# requirements plus the DuckDB adapter in ONE pip command (see Epic-02).
# Run from the project root:  powershell -ExecutionPolicy Bypass -File scripts\setup-env.ps1
# This script changes nothing outside the project's .venv folder.

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
Set-Location $root

# 1. Find Python 3.11 (dbt 1.7 does not support 3.12+).
$py = $null
try { $py = (& py -3.11 -c "import sys; print(sys.executable)") } catch {}
if (-not $py) {
    Write-Error "Python 3.11 not found. Install it from python.org (3.11.x) and run this script again."
    exit 1
}
Write-Host "Using Python: $py"

# 2. Create .venv (recreate it if it exists, as Epic-02 asks on any failure).
if (Test-Path .venv) { Remove-Item -Recurse -Force .venv }
& py -3.11 -m venv .venv

$venvPy = Join-Path $root '.venv\Scripts\python.exe'

# 3. One install command: pinned requirements + DuckDB adapter.
#    duckdb is pinned to 0.10.2: newer duckdb (2.x) is not compatible with dbt-duckdb 1.7.5.
& $venvPy -m pip install --upgrade "pip<26" | Out-Null
& $venvPy -m pip install -r requirements.txt "dbt-duckdb==1.7.5" "duckdb==0.10.2"
if ($LASTEXITCODE -ne 0) { Write-Error "pip install failed."; exit 1 }

# 4. pip check must report no conflicts.
& $venvPy -m pip check
if ($LASTEXITCODE -ne 0) { Write-Error "pip check reports a conflict. Delete .venv and run this script again."; exit 1 }

Write-Host "Done. Next: scripts\check-env.ps1"
