-- main.lua — обновляет ГЛАВНУЮ папку (на уровень выше updater)

local repo_url = "https://github.com/elc901/pixel"  -- тут другой репозиторий
local branch = "main"
local protected_folder = "updater"  -- папку updater не трогаем

function exec(cmd)
    print("> " .. cmd)
    os.execute(cmd)
end

-- Определяем папку, где лежит этот скрипт (updater)
local script_path = debug.getinfo(1).source:sub(2)
local current_dir = script_path:match("(.*[\\/])") or ".\\"
print("Текущая папка (updater): " .. current_dir)

-- Главная папка (my_game) — на уровень выше
local parent_dir = current_dir .. "..\\"
print("Главная папка: " .. parent_dir)

-- 1. Скачиваем архив
local zip_url = repo_url .. "/archive/refs/heads/" .. branch .. ".zip"
local zip_file = "temp_repo.zip"
print("Скачиваю " .. zip_url)
exec(string.format('curl -L -o "%s" "%s"', zip_file, zip_url))

-- 2. Временная папка
local temp_dir = "temp_repo_extract"
exec('rmdir /S /Q "' .. temp_dir .. '" 2>nul')
exec('mkdir "' .. temp_dir .. '"')

-- 3. Распаковываем
exec(string.format('tar -xf "%s" -C "%s" --strip-components=1', zip_file, temp_dir))

-- 4. Удаляем из временной папки папку updater (если есть)
exec(string.format('rmdir /S /Q "%s\\%s" 2>nul', temp_dir, protected_folder))

-- 5. Очищаем ГЛАВНУЮ папку (parent_dir), КРОМЕ папки updater
print("Очистка главной папки (кроме " .. protected_folder .. ")...")

-- Удаляем файлы в главной папке
exec(string.format('for %%i in ("%s*") do if not "%%~nxi"=="%s" del /Q "%%i"', parent_dir, protected_folder))

-- Удаляем папки в главной папке (кроме updater)
exec(string.format('for /d %%i in ("%s*") do if not "%%~nxi"=="%s" rmdir /S /Q "%%i"', parent_dir, protected_folder))

-- 6. Копируем новые файлы из временной папки в ГЛАВНУЮ
print("Копирование новых файлов...")
exec(string.format('xcopy /E /Y /I "%s\\*" "%s"', temp_dir, parent_dir))

-- 7. Очистка
exec('rmdir /S /Q "' .. temp_dir .. '"')
exec('del "' .. zip_file .. '"')

print("Главная папка обновлена!")