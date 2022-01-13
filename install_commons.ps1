Import-Module "$PSScriptRoot\pwsh-fun\Utility.ps1"
$ORIGINAL_ERROR_ACTION = $ErrorActionPreference

<#
.SYNOPSIS
  Checks if a command exists.
#>
function Script:Test-Command {
  param (
    # The name of the command to check.
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [string]
    $Command
  )
  $ErrorActionPreference = 'Stop'
  try {
    if (Get-Command $Command) {
      return $true
    }
  } catch {
    return $false
  } finally {
    $ErrorActionPreference = $ORIGINAL_ERROR_ACTION
  } 
}

<#
.SYNOPSIS
  Installs a package if it's not installed.
#>
function Install-Package {
  param (
    # The name of the process that identifies the application to be installed.
    [Parameter(Mandatory = $true)]
    [string]
    $ProcessName,
    # A name to identify the package.
    [Parameter(Mandatory = $true)]
    [string]
    $Name,
    # The installation script.
    [Parameter(Mandatory = $true)]
    [ScriptBlock]
    $InstallScript
  )
  if ($(Test-Command $ProcessName) -or $(Test-Application $ProcessName)) {
    Write-Output "$Name is already installed c:"
    return
  } else {
    & $InstallScript
  }
  if (-not $($(Test-Command $ProcessName) -or $(Test-Application $ProcessName))) {
    throw "There was an error installing $Name u.u"
  }
  Write-Output "$Name was installed successfully C:"
}

<#
.SYNOPSIS
  Installs Chocolatey if it's not installed.
#>
function Install-Chocolatey {
  Install-Package -ProcessName choco -Name Chocolatey -InstallScript {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force
    Invoke-WebRequest 'https://chocolatey.org/install.ps1' -UseBasicParsing | Invoke-Expression 
  }
}