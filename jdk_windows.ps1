#Requires -RunAsAdministrator

Import-Module "$PSScriptRoot\install_commons.ps1" -Scope Local
$Script:ORIGINAL_LOCATION = Get-Location

<#region : OpenJDK #>
$Script:OPENJDK_DISTRIBUTION = 'jdk-17.0.1'
$Script:PLATFORM = 'windows-x64'
$Script:JAVA_JDK_URL = 'https://download.java.net/java/GA'
$Script:OPENJDK_HASH = '2a2082e5a09d4267845be086888add4f/12/GPL'
$Script:OPENJDK_ZIP = "open$OPENJDK_DISTRIBUTION_$PLATFORM_bin.zip"
$Script:OPENJDK_URL = "$JAVA_JDK_URL/$OPENJDK_DISTRIBUTION/$OPENJDK_HASH/$OPENJDK_ZIP"

<#
.SYNOPSIS
  Downloads the binaries of OpenJDK.
#>
function Script:Get-OpenJDKBinaries {
  # Creamos una carpeta para instalar Java
  if (-not $(Test-Path $Env:ProgramFiles)) {
    New-Item -Path '$Env:ProgramFiles' -Name 'Java' -ItemType Directory
  }
  Set-Location '$Env:ProgramFiles\Java'
  # Descargamos y descomprimimos el JDK
  Invoke-WebRequest -Uri $OPENJDK_URL -OutFile $OPENJDK_ZIP
  Expand-Archive ".\$OPENJDK_ZIP" -DestinationPath .
  Remove-Item ".\$OPENJDK_ZIP"
}

<#
.SYNOPSIS
  Installs OpenJDK if there's no default Java installation.
#>
function Install-OpenJDK {
  try {
    Install-Package -ProcessName 'java' -Name 'Java' -InstallScript {
      choco install openjdk -y
    }
  } catch {
    Write-Error $_
    Write-Host 'Trying to install OpenJDK without Chocolatey.'
    Install-Package -ProcessName java -Name Java -InstallScript {
      Get-OpenJDKBinaries
      Set-Location $OPENJDK_DISTRIBUTION
      [Environment]::SetEnvironmentVariable('JAVA_HOME', "$(Get-Location)")
      [Environment]::SetEnvironmentVariable(
        'Path', 
        [Environment]::GetEnvironmentVariable('Path', [EnvironmentVariableTarget]::Machine) `
          + ";$(Get-Location)\bin", 
        [EnvironmentVariableTarget]::Machine
      )
      Update-SessionEnvironment  
    }
  } finally {
    Set-Location $ORIGINAL_LOCATION
  }
}
<#endregion#>