--Вскрытие Json
local json = require("dkjson")
local file = io.open("config.json", "r")
local content = file:read("*a")
file:close()

--Парсинг в таблицу 
local config = json.decode(content)

--Присвоение 
local branch = config.repo.branch
local repo_url = config.repo["repo-link"]
local repo_name = config.repo["repo-name"]
local repo_owner = config.developers.owner
local contributors = config.developers.contributors
local protected_folder = "updater"

-- файл для запуска после обновления (читаем из config.json)
local file_to_run = config["start-file"]
local web_browser = "webbrowser_use.py"

function exec(cmd) -- старт cmd
    print("> " .. cmd)
    os.execute(cmd)
end

os.execute("chcp 65001 > nul")
function download()
    -- где все лежит
    local script_path = debug.getinfo(1).source:sub(2)
    local current_dir = script_path:match("(.*[\\/])") or ".\\"
    print("Текущая папка (updater): " .. current_dir)

    -- Главная папка (на уровень выше)
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

    -- 4. Удаление папки updater из новой версии (чтобы не затереть саму себя)
    exec(string.format('rmdir /S /Q "%s\\%s" 2>nul', temp_dir, protected_folder))

    -- 5. Очистка ГЛАВНОЙ папки (parent_dir), КРОМЕ папки updater
    print("Очистка главной папки (кроме " .. protected_folder .. ")...")
    exec(string.format('for %%i in ("%s*") do if not "%%~nxi"=="%s" del /Q "%%i"', parent_dir, protected_folder))
    exec(string.format('for /d %%i in ("%s*") do if not "%%~nxi"=="%s" rmdir /S /Q "%%i"', parent_dir, protected_folder))

    -- 6. Копирование новых файлов из временной папки в ГЛАВНУЮ
    print("Копирование новых файлов...")
    exec(string.format('xcopy /E /Y /I "%s\\*" "%s"', temp_dir, parent_dir))

    -- 7. Очистка временных файлов
    exec('rmdir /S /Q "' .. temp_dir .. '"')
    exec('del "' .. zip_file .. '"')

    print("Обновление завершено успешно")

    -- Вывод дополнительной информации
    if repo_name and repo_name ~= "your-name ( optional )" then 
    print("Repository Name -> " .. repo_name)
    end
    if repo_owner and repo_owner ~= "link ( optional )" then    
    print("Repository Owner -> " .. repo_owner)
    end
    if contributors and contributors ~= "links ( optional ); " then 
    print("Contributors -> " .. contributors)
    end

    -- Запуск целевого файла
    if file_to_run and file_to_run ~= "path ( /game/file.name.py/js/lua/html/css )" then    
        local target_path = parent_dir .. file_to_run
        local target_path2 = parent_dir .. web_browser
        local check_file = io.open(target_path, "r")
        if check_file then
            check_file:close()
            print("Запуск: " .. target_path)
            os.execute('start "" "' .. target_path .. '"')
            --os.execute('start "" " ' .. web_browser .. '"')
        else
            print("Ошибка: файл не найден - " .. target_path)
        end
    else
        print("В config.json не указан start-file")
    end
end
print("Write 'y' or 'n' for download")
local accept = io.read()

local script_path = debug.getinfo(1).source:sub(2)
local current_dir = script_path:match("(.*[\\/])") or ".\\"
local parent_dir = current_dir .. "..\\"

if accept == "y" then
    download() 
else
    if file_to_run and file_to_run ~= "path ( /game/file.name.py/js/lua/html/css )" then    
        local target_path = parent_dir .. file_to_run
        local check_file = io.open(target_path, "r")
        if check_file then
            check_file:close()
            print("Запуск: " .. target_path)
            os.execute('start "" "' .. target_path .. '"')
        else
            print("Ошибка: файл не найден - " .. target_path)
        end
    else
        print("В config.json не указан start-file")
    end
end