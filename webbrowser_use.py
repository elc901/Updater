import winreg
import webbrowser
import subprocess
import json
import os

with open("config.json", "r", encoding='utf-8') as f:
    file = json.load(f)
url = file["dev-link"]

def get_default_browser_from_registry():
    reg_path = r"Software\Microsoft\Windows\Shell\Associations\UrlAssociations\http\UserChoice"
    try:
        with winreg.OpenKey(winreg.HKEY_CURRENT_USER, reg_path) as key:
            progid, _ = winreg.QueryValueEx(key, "ProgId")

        if "Chrome" in progid:
            return "Google Chrome"
        elif "Firefox" in progid:
            return "Mozilla Firefox"
        elif "Edge" in progid:
            return "Microsoft Edge"
        elif "Brave" in progid:
            return "Brave"
        elif "Opera" in progid:
            return "Opera"
        else:
            return None
        
    except:
        return None

browser_paths = {
    "Google Chrome": r"C:\Program Files\Google\Chrome\Application\chrome.exe",
    "Microsoft Edge": r"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe",
    "Mozilla Firefox": r"C:\Program Files\Mozilla Firefox\firefox.exe",
    "Brave": r"C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe",
    "Opera": r"C:\Program Files\Opera\launcher.exe"
}

# дефолтный браузер
browser_name = get_default_browser_from_registry()


if browser_name and browser_name in browser_paths:
    browser_path = browser_paths[browser_name]
    if os.path.exists(browser_path):
        subprocess.run([browser_path, url])
    else:
        webbrowser.open(url)
else:
    webbrowser.open(url)