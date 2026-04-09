local repo = "https://github.com/elc901/updater"
local error = false

local function cmd(c)
    local h = io.popen(c)
    if not h then return false end
    h:close()
    return true
end

cmd('rmdir /s /q "updater" 2>nul')

local zip = "updater.zip"
local url = repo .. "/archive/refs/heads/main.zip"
if not cmd(string.format('powershell -c "Invoke-WebRequest -Uri \'%s\' -OutFile \'%s\'"', url, zip)) then
    error = true
elseif not cmd(string.format('powershell -c "Expand-Archive -Force \'%s\' \'.\'"', zip)) then
    error = true
elseif not cmd('move updater-main\\* updater\\ 2>nul') then
    error = true
else
    cmd('rmdir /s /q updater-main 2>nul')
    cmd('del /q ' .. zip .. ' 2>nul')
end

local f = io.open("updater_status.txt", "w")
f:write(error and "True" or "False")
f:close()