#Requires -RunAsAdministrator

$Script:originalErrorAction = $ErrorActionPreference
$Script:originalLocation = Get-Location

function Script:Test-Command {
  param (
    [Parameter(Mandatory = $true)]
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
    $ErrorActionPreference = $originalErrorAction
  }
  <#
  .SYNOPSIS
    Checks if a command exists.
  #>
}

<#region 7-zip#>
function Install-Chocolatey {
  if (Test-Command choco) {
    Write-Output 'Chocolatey is already installed c:'
  } else {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force
    Invoke-WebRequest 'https://chocolatey.org/install.ps1' -UseBasicParsing | Invoke-Expression
  }
  if (Test-Command choco) {
    Write-Output 'Chocolatey was installed successfully c:'
  }
  <#
  .SYNOPSIS
    Installs Chocolatey if it's not installed.
  #>
}