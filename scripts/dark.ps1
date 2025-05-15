function ToggleDarkMode {
    $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"
    
    $appsMode = Get-ItemProperty -Path $regPath -Name "AppsUseLightTheme"
    $systemMode = Get-ItemProperty -Path $regPath -Name "SystemUsesLightTheme"

    # Si está en modo claro, cambia ambos a oscuro
    if ($appsMode.AppsUseLightTheme -eq 1 -or $systemMode.SystemUsesLightTheme -eq 1) {
        Set-ItemProperty -Path $regPath -Name "AppsUseLightTheme" -Value 0
        Set-ItemProperty -Path $regPath -Name "SystemUsesLightTheme" -Value 0
        Write-Host "🖤 Cambiado a modo oscuro para apps y sistema"
    }
    else {
        Set-ItemProperty -Path $regPath -Name "AppsUseLightTheme" -Value 1
        Set-ItemProperty -Path $regPath -Name "SystemUsesLightTheme" -Value 1
        Write-Host "🤍 Cambiado a modo claro para apps y sistema"
    }

    ## Option Reinicia el explorador para aplicar los cambios
    # Stop-Process -Name explorer -Force
    # Start-Process explorer
}

# Ejecutar la función
ToggleDarkMode
