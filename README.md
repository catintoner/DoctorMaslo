#www.doctormaslo.ru

# DoctorMaslo — Монорепозиторий проекта

Добро пожаловать в проект! Здесь описан регламент работы, деплоя и структура проекта.

## Структура проекта
- `/frontend` — React-приложение (Create React App).
- `/backend` — Node.js API (в разработке).
- `/compose.yaml` — Docker-конфигурация для локальной разработки БД и бэка.
- `_backups/` — локальная папка для бэкапов (игнорируется Git).

## Работа с Git (Правила)
В проекте настроена защита ветки `main` через GitHub Rulesets.
Прямые пуши в `main` запрещены! Работаем только через ветку `dev`.

Как добавить изменения:
1. Убедись, что ты на ветке `dev`:
   `git checkout dev`
2. Внеси изменения в код.
3. Закоммить и отправь:
   `git add .`
   `git commit -m "feat: описание изменений"`
   `git push origin dev`
4. Зайди на GitHub, создай Pull Request из `dev` в `main` и нажми Merge.

## Как выкатить обновления на сервер (Деплой фронтенда)

0. Подготовка (если нужно):
Убедись, что ты на ветке `dev` и в ней актуальный код:
`git checkout dev`
`git pull origin dev`

1. Собрать проект локально:
`cd frontend`
`npm run build`
(В конце должно появиться `The build folder is ready to be deployed`).

2. Сделать бэкап текущей версии на сервере (ОБЯЗАТЕЛЬНО):
`ssh root@IP_СЕРВЕРА`
`cp -r /var/www/doctormaslo-frontend/build /var/www/doctormaslo-frontend/build_backup_$(date +%F)`
`exit`

3. Залить новые файлы на сервер:
Открой локальный терминал в папке `frontend` и выполни:
`scp -r .\build\* root@IP_СЕРВЕРА:/var/www/doctormaslo-frontend/build/`

4. Перезагрузить Nginx на сервере:
`ssh root@IP_СЕРВЕРА "systemctl reload nginx"`

5. Проверка и откат (если что-то сломалось):
Открой сайт, обнови страницу с `Ctrl + F5`.
Если сайт сломался, зайди на сервер и откатись:
`rm -rf /var/www/doctormaslo-frontend/build`
`mv /var/www/doctormaslo-frontend/build_backup_YYYY-MM-DD /var/www/doctormaslo-frontend/build`
`systemctl reload nginx`

## Работа с бэкапами

Мы не храним бэкапы на сервере, чтобы не забивать диск. После успешного деплоя их нужно скачивать на локальный компьютер.

Скачать бэкап с сервера:
Создай локальную папку `_backups` (если её нет) и выполни:
`scp -r root@IP_СЕРВЕРА:/var/www/doctormaslo-frontend/build_backup_YYYY-MM-DD F:\catintoner\DoctorMaslo\_backups\`

Удалить бэкап с сервера (после скачивания):
`ssh root@IP_СЕРВЕРА`
`rm -rf /var/www/doctormaslo-frontend/build_backup_YYYY-MM-DD`
`exit`
(Папка `_backups/` добавлена в `.gitignore`, поэтому бэкапы не попадут в репозиторий).

## Частые проблемы и решения

Git блокирует пуш с ошибкой `GH006: Protected branch update failed`
Решение: Ты пытаешься запушить в `main`. Переключись на `dev` (`git checkout dev`) и пуш туда.

Сайт после деплоя показывает белый экран
Решение: Сделай жесткое обновление (`Ctrl + F5`). Если не помогло — проверь консоль браузера на ошибки JS. Если ошибки критичные — сделай откат к бэкапу (см. пункт "Деплой").

`scp` ругается на `Permission denied`
Решение: Проверь, что ты копируешь файлы в правильную папку, и что у тебя есть права на запись (пользователь root). Если менял права — верни их: `chown -R root:root /var/www/doctormaslo-frontend/build`.