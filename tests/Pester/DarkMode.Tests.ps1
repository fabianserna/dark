# tests\Pester\DarkMode.Tests.ps1
BeforeAll {
    $ScriptPath = Join-Path $PSScriptRoot '..\..\scripts\dark.ps1'

    # Evita que el script escriba en el registro
    Mock -CommandName Set-ItemProperty -MockWith {}

    # Carga dark.ps1 y expone la función Toggle-DarkMode
    . $ScriptPath
}

Describe 'DarkMode' {

    Context 'Modo forzado' {

        It 'Devuelve Dark al usar -Mode Dark' {
            (Toggle-DarkMode -Mode Dark  -PassThru).Mode | Should -Be 'Dark'
        }

        It 'Devuelve Light al usar -Mode Light' {
            (Toggle-DarkMode -Mode Light -PassThru).Mode | Should -Be 'Light'
        }
    }

    Context 'Cambio automático (Toggle)' {

        It 'Alterna de Light a Dark' {
            # Simula que el sistema está en modo claro
            Mock -CommandName Get-ItemProperty -MockWith {
                @{ SystemUsesLightTheme = 1; AppsUseLightTheme = 1 }
            }

            (Toggle-DarkMode -Mode Toggle -PassThru).Mode | Should -Be 'Dark'
        }
    }
}
