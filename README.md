<div align="center">
<h1>updater</h1>
  
[![Typing SVG](https://readme-typing-svg.demolab.com?font=Fira+Code&weight=600&size=24&duration=3000&pause=500&color=5e9dab&center=true&vCenter=true&width=435&lines=Fast;+Work+On+Lua+and+Python;+Open+Source)](https://git.io/typing-svg)

</div>

> [!CAUTION]
> **ФЕЙКИ**
> Это единственный репозиторий с оригинальным updater. [Это единственная ссылка на оригинальный репозиторий.](github.com/elc901/updater).
> Если кто то будет просить установить "модификацию updater" - не верьте, вероятно это будет вредоносное программное обеспечение. Все модификации updater будут [тут](https://github.com/elc901/updater/releases) с припиской "-m". Это единственные модификации проверенные и одобренные разработчиком.




<div align="center">
<h1>Описание</h1>

**Роль: обновлять ваши файлы из репозитория на GitHub.**

**▫️Языки программирование▫️**

![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Lua](https://img.shields.io/badge/Lua-2C2D72?style=for-the-badge&logo=lua&logoColor=white)

**Библиотеки: dkjson**
</div>
<div align="center">
  
## Как установить

### Скачивание
<div align="center">
  
Скачайте последнюю версию из [релизов](https://github.com/elc901/updater/releases).
Распакуйте архив и переместите папку в удобную директорию.

### Загрузка в репозиторий

Создайте **отдельную ветку** для обновлений (например, `updates` или `release`).
Поместите в эту ветку:
- папку `updater` (переименуйте скачанную папку именно в `updater`);
- ваш исполняемый файл (`main.exe`, `app.exe` и т.д.);
- дополнительные файлы (`.dll`, ресурсы, конфиги).
Запомните название ветки — оно понадобится в `config.json`.

### Настройка

В папке `updater` отредактируйте `config.json`:

| Поле | Обязательное | Описание |
|---|:---:|---|
| `branch` | ✅ | Ветка репозитория, откуда брать обновления |
| `repo-link` | ✅ | Полная ссылка на GitHub-репозиторий |
| `start-file` | ✅ | Файл, который запускается после обновления |
| `repo-name` | - | Отображаемое имя программы |
| `owner` | - | Ссылка на профиль разработчика |
| `contributors` | - | Ссылки на соавторов (через запятую, в кавычках) |
| `autoload` | - | `true` — устанавливать сразу, `false` — спрашивать |
| `hotbar` | - | Показывать прогресс-бар |
| `dev-log` | - | Ссылка на лог изменений (откроется в браузере) |
| `dev-link` | - | Ссылка на блог или Telegram/Discord и прочие-каналы разработки |
| `excludes` | - | папки которые не должны быть удалены |

### Компиляция

Если вы распространяете программу в виде `.exe`, скомпилируйте `main.lua` со всеми зависимостями.

**Рекомендации:**
Используйте LuaJIT + luapower или srlua.
Убедитесь, что `dkjson` и другие библиотеки встроены в бинарник или лежат рядом.

Пример команды для srlua:

```bash
glue.exe main.lua updater.exe
```
</div>



