<#
███████╗ █████╗ ██████╗ ██╗██████╗ ███████╗██╗   ██╗  ██╗██████╗
██╔════╝██╔══██╗██╔══██╗██║██╔══██╗██╔════╝██║   ██║ ██╔╝╚════██╗
█████╗  ███████║██████╔╝██║██║  ██║█████╗  ██║   ██║██╔╝  █████╔╝
██╔══╝  ██╔══██║██╔══██╗██║██║  ██║██╔══╝  ╚██╗ ██╔╝╚██╗  ╚═══██╗
██║     ██║  ██║██████╔╝██║██████╔╝███████╗ ╚████╔╝  ╚██╗██████╔╝
╚═╝     ╚═╝  ╚═╝╚═════╝ ╚═╝╚═════╝ ╚══════╝  ╚═══╝    ╚═╝╚═════╝
          🧠  Automation CLI by: FabiDev<3
#>

param(
    [ValidateSet('Dark','Light','Toggle')]
    [string]$Mode     = 'Toggle',   # <— al llamar el archivo sin args entra aquí
    [switch]$PassThru                 # ← útil para las pruebas
)

function Toggle-DarkMode {
    [CmdletBinding()]
    param(
        [ValidateSet('Dark','Light','Toggle')]
        [string]$Mode = 'Toggle',
        [switch]$PassThru
    )

    $regPath = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize'

    # Lee los valores actuales (0 = dark, 1 = light)
    $currentApps    = (Get-ItemProperty -Path $regPath -Name AppsUseLightTheme).AppsUseLightTheme
    $currentSystem  = (Get-ItemProperty -Path $regPath -Name SystemUsesLightTheme).SystemUsesLightTheme

    switch ($Mode) {
        'Dark'   { $new = 0 }
        'Light'  { $new = 1 }
        'Toggle' { $new = if ($currentApps -eq 1 -or $currentSystem -eq 1) { 0 } else { 1 } }
    }

    # Solo escribe si hay cambio
    if ($currentApps -ne $new -or $currentSystem -ne $new) {
        Set-ItemProperty -Path $regPath -Name AppsUseLightTheme   -Value $new
        Set-ItemProperty -Path $regPath -Name SystemUsesLightTheme -Value $new
    }

    # Mensaje amigable
    if ($new -eq 0) {
        Write-Host "🖤 Cambiado a modo oscuro para apps y sistema"
    } else {
        Write-Host "🤍 Cambiado a modo claro para apps y sistema"
    }

    # Notifica al shell sin cerrar sesión (silencioso si falla en pruebas)
    try {
        if (-not ('NativeMethods' -as [type])) {
            Add-Type @"
using System;
using System.Runtime.InteropServices;
public class NativeMethods {
  [DllImport("user32.dll", SetLastError=true)]
  public static extern IntPtr SendMessageTimeout(
      IntPtr hWnd, uint Msg, UIntPtr wParam, string lParam,
      uint fuFlags, uint uTimeout, out UIntPtr lpdwResult);
}
"@
        }
        [UIntPtr]$dummy = [UIntPtr]::Zero
        [NativeMethods]::SendMessageTimeout([IntPtr]::Zero, 0x1A,
            [UIntPtr]::Zero, 'ImmersiveColorSet', 0x0000, 100, [ref]$dummy) | Out-Null
    } catch {
        # Ignorar en entornos sin GUI (p.ej., GitHub Actions)
    }

    if ($PassThru) {
        [PSCustomObject]@{
            Mode      = if ($new -eq 0) { 'Dark' } else { 'Light' }
            Timestamp = Get-Date
        }
    }
}

# ------------------------------------------------------------------
# Si este archivo se ejecuta **directamente** (no dot-sourced), llama
# a la función con los parámetros recibidos.
# ------------------------------------------------------------------
if ($MyInvocation.InvocationName -eq $MyInvocation.MyCommand.Path) {
    Toggle-DarkMode @PSBoundParameters
}

# Exporta la función si alguien dot-sourcó el archivo o lo importó
if ($ExecutionContext.SessionState.Module) {
    Export-ModuleMember -Function Toggle-DarkMode
}

