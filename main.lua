--Вскрытие Json
local json = require("dkjson")
local file = io.open("config.json", "r")
local content = file:read("all")
file:close()

--Парсинг в таблицу 
local config = json.decode(content)


--Присовение 
local branch = config.repo.branch
local repo_url = config.repo["repo-link"]
local repo_name = config.repo["repo-name"]
local repo_owner = config.developers.owner
local contributors = config.developers.contributors
local protected_folder = "updater"
           




-- file to start after update
local file_to_run = "name_flie.exe/py/lua/html/js..."                     

function exec(cmd) -- старт cmd
    print("> " .. cmd)
    os.execute(cmd)
end


os.execute("chcp 65001 > nul")
-- где все лежит
local script_path = debug.getinfo(1).source:sub(2)
local current_dir = script_path:match("(.*[\\/])") or ".\\"
print("Текущая папка (updater): " .. current_dir)

-- Главная папка 
local parent_dir = current_dir .. "..\\"
print("Главная папка: " .. parent_dir)

-- 1. Скачивание архива
local zip_url = repo_url .. "/archive/refs/heads/" .. branch .. ".zip"
local zip_file = "temp_repo.zip"
print("Download... " .. zip_url)
exec(string.format('curl -L -o "%s" "%s"', zip_file, zip_url))

-- 2. Временная папка
local temp_dir = "temp_repo_extract"
exec('rmdir /S /Q "' .. temp_dir .. '" 2>nul')
exec('mkdir "' .. temp_dir .. '"')

-- 3. Распаковка
exec(string.format('tar -xf "%s" -C "%s" --strip-components=1', zip_file, temp_dir))

-- 4. Удаление updater из новой папки
exec(string.format('rmdir /S /Q "%s\\%s" 2>nul', temp_dir, protected_folder))

-- 5. Очистка ГЛАВНОЙ папки (parent_dir), КРОМЕ папки updater
print("remove main folder, excludes:  " .. protected_folder .. ")...")

-- Удаление файлов в главной папке
exec(string.format('for %%i in ("%s*") do if not "%%~nxi"=="%s" del /Q "%%i"', parent_dir, protected_folder))

-- Удаление папки в главной папке (кроме updater)
exec(string.format('for /d %%i in ("%s*") do if not "%%~nxi"=="%s" rmdir /S /Q "%%i"', parent_dir, protected_folder))

-- 6. Копировка новых файлов из временной папки в ГЛАВНУЮ
print("Copy new files...")
exec(string.format('xcopy /E /Y /I "%s\\*" "%s"', temp_dir, parent_dir))

-- 7. Очистка временных файлов
exec('rmdir /S /Q "' .. temp_dir .. '"')
exec('del "' .. zip_file .. '"')

print("Update succesful")

--вывод доп.инфы

if repo_name ~= "your-name ( optional )" then
    print("Repository Name -> ", repo_name)
end
if repo_owner ~= "link ( optional )" then
    print("Repository Owner -> ", repo_owner)
end

if contributors ~= "links ( optional ); " then
    print("Contributors -> ", contributors)
end
local file_path = parent_dir .. file_to_run
local file = io.open(file_path, "r")
if file then
    file:close()
    print("Run...  " .. file_path)
    os.execute('start "" "' .. file_path .. '"')
else
    print("Error: file not found:  - " .. file_path)
end



