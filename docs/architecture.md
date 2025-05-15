# Architecture

`ToggleDarkMode.ps1` works by editing two registry keys in the current user's hive:

| Key | Value | Meaning |
|-----|-------|---------|
| `SystemUsesLightTheme` | `0` = dark, `1` = light | Windows surfaces |
| `AppsUseLightTheme` | `0` = dark, `1` = light | Store/UWP apps |

After updating, the script broadcasts a `WM_SETTINGCHANGE` message to force the shell to repaint without logout.

See [Microsoft Docs](https://learn.microsoft.com/windows) for details.
