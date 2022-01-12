Import-Module "$PSScriptRoot\install_commons.ps1"

<#
.SYNOPSIS
  Installs JetBrains Toolbox if it's not found in the system.
#>
function Install-JetBrainsToolbox {
  Install-Package -ProcessName 'jetbrains-toolbox.exe' -Name 'JetBrains Toolbox' -InstallScript {
    choco install jetbrainstoolbox
  }
}