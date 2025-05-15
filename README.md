# dark
One-click Windows dark/light switch⚡️PowerShell script for Win 10/11
![License](https://img.shields.io/badge/license-MIT-blue) ![license-fabidev](docs/fabidevlicense.svg)

## Features

* **Instant toggle** between dark and light without signing out.
* Supports **Windows 11** and **Windows 10 (21H2+)**.
* No admin rights required (modifies only HKCU registry hive).
* Works with batch wrappers, scheduled tasks, or as a **PowerShell module**.
* Returns structured objects so you can pipe the result to other cmdlets.

## Demo

![dark-demo](docs/demo.gif)

## Getting Started

### Prerequisites

* PowerShell 5.1 (Windows) or PowerShell 7+ (cross‑platform)
* .NET Framework 4.7.2+ (already present on Windows 10/11)

### Installation

</details>

<details>
<summary>PowerShell Command</summary>

```powershell
git clone https://github.com/fabianserna/dark.git
cd script
mkdir C:\utl\
[Environment]::SetEnvironmentVariable('Path', "$env:Path;C:\utl", 'User')
Get-ItemProperty -Path HKCU:\Environment -Name Path
Copy-Item -Path "dark.bat" -Destination "C:\utl\"
Copy-Item -Path "dark.ps1" -Destination "C:\utl\"
```

</details>

<details>
<summary>Manual clone</summary>

English 
You can create a separate folder where you can store your bat files or executables that you want to access quickly. In my case, do the following:

1. Create a folder in c:/utl/
2. Enter it in your PC's path. I won't explain this here because it's very easy.
3. Paste the files found in the script, both dark.bat and dark.ps1
4. Run it from Win + R or run "dark"

Español 
puedes crear una carpeta propia donde tengas tus bat o ejecutables a los que quieras acceder rapidamente para mi caso realice lo siguiente:

1. Crea una carpeta en c:/utl/
2. Ingresala en el path de tu pc, aqui no te lo explico porque es muy facil.
3. pega los archivos que se encuentran en script tanto el dark.bat como el dark.ps1
4. ejecuta desde win + r o ejecutar "dark"

```powershell
Install-Module ToggleDarkMode -Scope CurrentUser
```

</details>

### Usage

```powershell
# Toggle both system and app themes automatically
dark.bat
```



### Batch wrapper example

```bat
@echo off
powershell -NoLogo -NoProfile -File "%~dp0scripts\\dark.ps1" %*
```

Add the wrapper to a folder in your *PATH* and you can type `dark` from `cmd` or *Run...*

## How It Works

The script flips two registry values under `HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize`:

* `AppsUseLightTheme` — app ("App mode")
* `SystemUsesLightTheme` — system surfaces ("Windows mode")

A value of `0` = dark, `1` = light. The change is pushed to the shell with `user32.dll` broadcast messages, so no reboot or log‑off is required.

## Uninstallation

If you installed via winget:

```powershell
winget uninstall FabiDev.ToggleDarkMode
```

If you cloned manually, simply delete the folder.

## Roadmap

* [ ] GUI tray companion
* [ ] Scheduled automatic switch at sunset/sunrise
* [ ] Localization support

## Development

```powershell
# Lint
Invoke-ScriptAnalyzer -Path scripts\\dark.ps1

# Tests
Invoke-Pester -Path tests
```

CI runs on Windows Server 2022 and PowerShell 7.4 using the workflow in `.github/workflows/ci.yml`.

## Contributing

Pull requests are welcome! Please open an issue first to discuss big changes.

1. Fork the repo
2. Create your feature branch (`git checkout -b feat/awesome`)
3. Commit your changes (`git commit -m 'Add awesome feature'`)
4. Push to the branch (`git push origin feat/awesome`)
5. Open a PR

Make sure `Invoke-ScriptAnalyzer` and `Pester` pass.

## Security

If you discover a security vulnerability, please email [security@fabidev.io](mailto:security@fabidev.io) for responsible disclosure.

## License

Distributed under the **MIT** License. See `LICENSE` for more information.

## Credits

Created with ❤️ by **FabiDev** and the help of his faithful artificial intelligence companion **Cleo**.

## Acknowledgements

* [PSScriptAnalyzer](https://github.com/PowerShell/PSScriptAnalyzer)
* [Pester](https://github.com/pester/Pester)
* Inspired by countless Stack Overflow answers and cups of coffee ☕
