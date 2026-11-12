# Контекст проекта

## Что это
Учебный dbt-проект `orders-analytics` из комплекта сертификации Accelerator (версия 0.18.0, каталог навыков v1.3.0). Хранилище: DuckDB, файл `orders.duckdb` создаётся командами `dbt seed` и `dbt build` и в репозиторий не входит.

## Цель
Пройти упражнения 01 и 02 комплекта (упражнение 03 необязательное), затем применить Accelerator к другому, веб-проекту.

## Как устроено на машине (Windows 11)
| Что | Где |
|---|---|
| Команда `accelerator` | `E:\accelerator\bin\accelerator.ps1`, версия 0.18.0 |
| Плагин Claude Code | `accelerator@accelerator-installation`, область user |
| Исходный комплект | `E:\accelerator-kit` (README, упражнения, архивы, установщик) |
| Рабочий проект | `E:\orders-analytics` |
| Python | `py -3.11` (3.11.9 на диске E:); `python` в PATH — 3.9 на C:, `py` по умолчанию — 3.13 из Anaconda, для dbt 1.7 не подходит |
| Окружение | `.venv` в проекте, dbt-core 1.7.9, dbt-duckdb 1.7.5, одна команда pip для манифеста и адаптера |

## Что сделано
1. Accelerator перенесён на диск E:, старая установка в `%LOCALAPPDATA%` удалена.
2. Упражнение 01: `accelerator scan -ToolsetRef refs/tags/v1.3.0`, профиль `claude-code` + темы `data-quality`, `testing`, установлены `DBT-LAYER-BOUNDARIES`, `DBT-MODEL-TESTING`, `PYTEST-DATA-PIPELINES` (версия 0.1.1).
3. Упражнение 02, шаги 1–2: окружение, сиды, замена `source()` на `ref()`, `dbt build` зелёный (PASS=9).
4. Созданы артефакты «Карта комплекта Accelerator» и «Журнал Accelerator» (`docs/artifacts/`), инструкция с промптом для веб-проекта (`_steps/accelerator-web-project-prompt.md`).
5. Проект отправлен в этот репозиторий.

## Что осталось
- Упражнение 02, шаг 3: прочитать `.claude/skills/DBT-MODEL-TESTING/SKILL.md`, записать правило выбора тестов по роли столбца и два анти-паттерна.
- Шаг 4: отправить агенту фразу `Add tests to models/schema.yml` и проверить дифф по тексту навыка.
- Шаг 5: `dbt test` должен покраснеть на двух дефектах в данных; для каждого падения решить, что неверно: данные или тест.
- Шаг 6: три заметки. Письменные ответы (a), (b), (c) к упражнению 01.
- Проверить доступ к GitHub-каталогу навыков с этой машины (`git ls-remote https://github.com/innowise-ai/data-accelerator-toolset.git`).

## Дефекты в данных (заложены нарочно)
| Заказ | Что не так | Какой тест поймает |
|---|---|---|
| `O1005` | клиент `C999` не существует | `relationships` |
| `O1006` | статус `refunded`, согласованы `pending`, `shipped`, `completed`, `cancelled` | `accepted_values` |

## Что не вошло в репозиторий
`.venv`, `target`, `logs`, `dbt_packages`, `orders.duckdb`, `.user.yml`, а также `profile.user.json`, `registry.user.json`, `profile.draft.json`, `catalog-topics.json` из `.accelerator/` (см. `.gitignore`).

## Оговорки
- Первые версии артефактов лежали в другой организации claude.ai и из этой сессии не открывались. Страницы в `docs/artifacts/` собраны заново по файлам комплекта и могут отличаться от оригиналов.
- Ответы (a) и (b) к упражнению 01 — вывод из правил отбора, их нужно сверить с сертификатором.
- Упражнение 03 прочитано по оглавлению и таблицам, команды в нём нужно сверить с текстом файла.
