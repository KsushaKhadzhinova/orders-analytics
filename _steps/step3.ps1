# Упражнение 02, шаг 3: подключить данные и собрать проект.
# Запускать в окне PowerShell с активным окружением (.venv).
param([string] $Project = 'E:\orders-analytics')

$ErrorActionPreference = 'Stop'
$kitData = 'E:\accelerator-kit\exercises\epic-02-data'

Set-Location -LiteralPath $Project

if (-not (Get-Command dbt -ErrorAction SilentlyContinue)) {
    throw 'dbt не найден. Сначала активируйте окружение: .venv\Scripts\Activate.ps1'
}

Write-Host '1. Копирую seeds и ORDER-STATUSES.md'
Copy-Item -Recurse -Force "$kitData\seeds" .\
Copy-Item -Force "$kitData\ORDER-STATUSES.md" .\

Write-Host '2. Меняю source() на ref() в моделях staging'
$orders = '.\models\staging\stg_orders.sql'
(Get-Content $orders -Raw).Replace("source('shop', 'raw_orders')", "ref('raw_orders')") | Set-Content $orders -NoNewline
$customers = '.\models\staging\stg_customers.sql'
(Get-Content $customers -Raw).Replace("source('shop', 'raw_customers')", "ref('raw_customers')") | Set-Content $customers -NoNewline

Write-Host '3. Удаляю блок sources из models\schema.yml'
$schema = '.\models\schema.yml'
$lines = @(Get-Content $schema)
$s = [array]::IndexOf($lines, 'sources:')
$m = [array]::IndexOf($lines, 'models:')
if ($s -ge 0 -and $m -gt $s) {
    $lines = @($lines[0..($s - 1)]) + @($lines[$m..($lines.Count - 1)])
    $lines | Set-Content $schema
} else {
    Write-Host '   блока sources уже нет, пропускаю'
}

Write-Host '4. dbt seed'
dbt seed
if ($LASTEXITCODE -ne 0) { throw 'dbt seed завершился с ошибкой' }

Write-Host '5. dbt build'
dbt build
if ($LASTEXITCODE -ne 0) { throw 'dbt build завершился с ошибкой' }

Write-Host ''
Write-Host 'Готово: сборка зелёная. Тесты для новых данных ещё не написаны, поэтому дефекты пока не видны.'
