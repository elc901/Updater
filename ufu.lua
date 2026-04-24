-- обновления самого обновлятора ( не трогает программу, которая за пределами updater)
local repo_url = "https://github.com/elc901/updater" -- не трогать
local branch = "main"   
local self_name = "ufu.lua"
local protected_file = "config.json"  

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

-- 4. Удаление из временной папки защищённые файлы 
cmd(string.format('del /Q "%s\\%s" 2>nul', temp_dir, self_name))
cmd(string.format('del /Q "%s\\%s" 2>nul', temp_dir, protected_file))

-- 5. Очищение текущей папки
print("Очистка старых файлов (кроме " .. self_name .. ", " .. protected_file .. ")...")

-- Удаление файлов
local del_files = string.format(
    'for %%i in (*) do if not "%%i"=="%s" if not "%%i"=="%s" if not "%%i"=="%s" del /Q "%%i"',
    self_name, protected_file, temp_dir
)
cmd(del_files)

-- Удаление папок 
local del_dirs = string.format('for /d %%i in (*) do if not "%%i"=="%s" rmdir /S /Q "%%i"', temp_dir)
cmd(del_dirs)

-- 6. Копирование новых файлов 
print("Копирование новых файлов...")
cmd(string.format('xcopy /E /Y /I "%s\\*" "%s"', temp_dir, current_dir))

-- 7. Очистка временных файлов
cmd('rmdir /S /Q "' .. temp_dir .. '"')
cmd('del "' .. zip_file .. '"')

print("Обновление завершено. Защищённые файлы сохранены: " .. self_name .. ", " .. protected_file)

-- старт main.lua
os.execute("lua main.lua")