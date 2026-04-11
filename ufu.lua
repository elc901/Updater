local repo-link = "https://github.com/elc901/updater/tree/main"
local function download_files(url, output_path):
    local cmd
    if package.config:sub(1, 1) == "\\" then
        cmd = string.format