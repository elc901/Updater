-- обновления самого обновлятора ( не трогает программу, которая за пределами updater)
local repo_url = "https://github.com/elc901/updater"
local branch = "main"   
local self_name = "ufu.lua"

function cmd(cmd)
    print("> " .. cmd)
    os.execute(cmd)
end

local script_path = debug.getinfo(1).source:sub(2)
local current_dir = script_path:match("(.*[\\/])") or ".\\"
print("Рабочая папка: " .. current_dir)

-- 1. Скачивание архива
local zip_url = repo_url .. "/archive/refs/heads/" .. branch .. ".zip"
local zip_file = "temp_repo.zip"
print("Скачиваю " .. zip_url)
cmd(string.format('curl -L -o "%s" "%s"', zip_file, zip_url))

-- 2. Создание временной папки
local temp_dir = "temp_repo_extract"
cmd('rmdir /S /Q "' .. temp_dir .. '" 2>nul')
cmd('mkdir "' .. temp_dir .. '"')

-- 3. Распаковка
cmd(string.format('tar -xf "%s" -C "%s" --strip-components=1', zip_file, temp_dir))

-- 4. Снос ufu.lua из временной папки
cmd(string.format('del /Q "%s\\%s" 2>nul', temp_dir, self_name))

-- 5. Снос всего, кроме ufu.lua
print("Очистка старых файлов (кроме " .. self_name .. ")...")

-- Удаление файлов
local del_files = string.format('for %%i in (*) do if not "%%i"=="%s" if not "%%i"=="%s" del /Q "%%i"', self_name, temp_dir)
cmd(del_files)

-- Удаление папок
local del_dirs = string.format('for /d %%i in (*) do if not "%%i"=="%s" if not "%%i"=="%s" rmdir /S /Q "%%i"', self_name, temp_dir)
cmd(del_dirs)

-- 6. Копирование 
print("Копирование новых файлов...")
cmd(string.format('xcopy /E /Y /I "%s\\*" "%s"', temp_dir, current_dir))

-- 7. Очистка
cmd('rmdir /S /Q "' .. temp_dir .. '"')
cmd('del "' .. zip_file .. '"')

print("Обновление завершено! Ваш " .. self_name .. " не тронут.")
-- конец

-- запуск main.lua ( главного файла обновлятора )
os.execute('start cmd /С lua main.lua')