# Установка окружения: orders-analytics

Инструкция для курса (Epic-01 — Epic-03). Всё ставится на вашу машину. GitHub-аккаунт и `gh` не нужны, кроме случая, когда вы сами клонируете репозиторий.

## 0. Что нужно и зачем

| Компонент | Версия | Для чего | Проверка |
|---|---|---|---|
| PowerShell 7 (`pwsh`) | 7.4+ | команда `accelerator` | `pwsh --version` |
| Git | 2.45.1+ | загрузка каталога accelerator | `git --version` |
| Python | **3.11.x** (3.9–3.11) | dbt 1.7 не работает на 3.12+ | `py -3.11 --version` |
| Claude Code | любая актуальная | навык `accelerator-setup` | `claude --version` |
| accelerator | 0.18.0 | сканирование и установка навыков | `accelerator --version` |
| Pester | **5.6.1** | тесты Epic-03 | `Get-Module -ListAvailable Pester` |

Пакеты Python (закреплены в `requirements.txt` и в скрипте):
`dbt-core==1.7.9`, `dbt-snowflake==1.7.2`, `pytest==8.1.1`, `dbt-duckdb==1.7.5`, `duckdb==0.10.2`.

> `dbt-duckdb` и `duckdb` **не** добавлять в `requirements.txt` — это изменит профиль, который сканирует accelerator (Epic-01).
> Ставить все пакеты **одной командой** (см. скрипт). Если сначала поставить dbt-core, а потом dbt-duckdb, dbt-core заменится, и появится ошибка `No module named 'dbt.adapters.factory'`.

## 1. Установить программы

Windows (PowerShell, от обычного пользователя):

```powershell
winget install --id Microsoft.PowerShell
winget install --id Git.Git
winget install --id Python.Python.3.11
```

Claude Code: установите по официальной инструкции Anthropic, затем проверьте `claude --version`.

Перезапустите терминал после установки, чтобы обновился `PATH`.

## 2. Установить accelerator и навык

Скачайте папку **installation** из курса (из неё нужен `install-accelerator.ps1`), распакуйте и запустите **из этой папки**:

```powershell
cd C:\путь\к\installation
pwsh -File install-accelerator.ps1 --agent claude
```

Если PowerShell не даёт запустить скрипт:

```powershell
Set-ExecutionPolicy -Scope Process Bypass -Force
```

Затем откройте **новое** окно терминала и проверьте:

```powershell
accelerator --version
```

Не используйте `install.ps1` и `install.sh` — они ставят только команду, без навыка.

## 3. Установить Pester 5.6.1 (для Epic-03)

```powershell
Install-Module Pester -RequiredVersion 5.6.1 -Scope CurrentUser -Force -SkipPublisherCheck
Import-Module Pester -RequiredVersion 5.6.1
```

## 4. Подготовить проект

Скопируйте практический проект (папку `fixture` из папки **exercises**) в рабочую папку, например `C:\Users\<вы>\orders-analytics`. Туда же положите файлы этого репозитория (`scripts\`, `profiles.yml` при необходимости).

```powershell
Copy-Item -Recurse C:\путь\к\exercises\fixture C:\Users\<вы>\orders-analytics
cd C:\Users\<вы>\orders-analytics
```

## 5. Создать окружение Python

Скрипт `scripts\setup-env.ps1` (сохраните его текст из раздела «Скрипты» ниже):

```powershell
powershell -ExecutionPolicy Bypass -File scripts\setup-env.ps1
```

Он находит Python 3.11, создаёт `.venv`, ставит все пакеты одной командой и запускает `pip check`. Вывод `No broken requirements found.` означает успех.

## 6. Проверить всё

```powershell
powershell -ExecutionPolicy Bypass -File scripts\check-env.ps1
```

Ожидаемо: `pwsh`, `git`, `accelerator`, `claude` — версии; `pester` — `True`; `pip check` — без конфликтов; `dbt` — 1.7.9; `pytest` — 8.1.1; `duckdb` — 0.10.2.

## 7. Известная проблема: Application Control

На некоторых рабочих машинах Windows Application Control (WDAC/AppLocker) блокирует `dbt.exe` и DLL `_duckdb`. Симптомы:

- `dbt.exe` → `Permission denied`;
- `import duckdb` → `An Application Control policy has blocked this file`.

Что делать: **не обходить политику самостоятельно**. Попросите администратора добавить исключение для папки `.venv` (или для файлов `duckdb` и `_duckdb*.pyd`) и приложите вывод `scripts\check-env.ps1`. Пока исключения нет, dbt можно запускать через `python -m dbt.cli.main`, но `duckdb` при импорте всё равно будет заблокирован.

## 8. Что запускать дальше

- Epic-01: в Claude Code в папке проекта запустите `/accelerator:accelerator-setup`.
- Epic-02: `.venv\Scripts\Activate.ps1`, затем `dbt` (или `python -m dbt.cli.main`) в папке проекта.
- Epic-03: тесты Pester запускаются с `Import-Module Pester -RequiredVersion 5.6.1`.

## Скрипты

Тексты скриптов лежат в папке `scripts/` этого репозитория:

- `scripts/setup-env.ps1` — создание `.venv` и установка пакетов;
- `scripts/check-env.ps1` — проверка без изменений.

## Частые ошибки

| Ошибка | Что сделать |
|---|---|
| `Python 3.11 not found` | Установите 3.11, перезапустите терминал |
| `No module named 'dbt.adapters.factory'` | Удалите `.venv`, запустите `setup-env.ps1` заново |
| `pip check` сообщает конфликт | То же: удалите `.venv` и переустановите, не правьте версии вручную |
| `Profile not found` после `accelerator scan` | Ожидаемо до шага установки; `scan` пишет черновик, `install` читает `profile.json` |
| `accelerator install` не находит каталог | Проверьте интернет и `git ls-remote https://github.com/innowise-ai/data-accelerator-toolset.git` |
