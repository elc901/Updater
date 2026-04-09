import webbrowser
with open("updater_status.txt", "r") as f:
    error = f.read().strip() == "True"