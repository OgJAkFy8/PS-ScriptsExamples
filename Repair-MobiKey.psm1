#requires -runasadministrator

function Repair-MobiKey 
{
  <#
      .SYNOPSIS
      Repairs the Mobkey Installation
   
      .EXAMPLE
      Repair-MobiKey
         
      .NOTES
      Place additional notes here.

      .LINK
      https://github.com/KnarrStudio/PS-Scripts
      The first link is opened by Get-Help -Online Repair-MobiKey

  #>

  [CmdletBinding(HelpUri = 'https://github.com/KnarrStudio/PS-Scripts',
  ConfirmImpact='Medium')]
  [OutputType([String])]
   
   
  $MobikeyNetworkPath = '\\Networkshare\mobikey\certs'
  $ServiceName = 'Route1*'
  $MobikeyLocalPath = "$env:ProgramData\Mobikey\certs"
  
  
  # First Stop the Mobikey Service 
  Write-Verbose -Message ('Stop Mobikey Service')
  Stop-Service -Name $ServiceName
     
  # Delete the old files out of the ProgramData Dir
  if (Test-Path -Path $MobikeyLocalPath){
    Write-Verbose -Message ('Delete old Certificate files')
    Get-ChildItem -Path $MobikeyLocalPath -Recurse | Remove-Item -Force -WhatIf
  }
  
  # Copy files from the File share to the local drive
  if (Test-Path -Path $MobikeyNetworkPath){
    Write-Verbose -Message ('Copy Files from Network to Localhost')
    Copy-Item -Path $MobikeyNetworkPath -Include *.* -Destination $MobikeyLocalPath -Force
  }
  # Start the Mobikey service 
  Write-Verbose -Message ('Start Mobikey Service')
  Start-Service -Name $ServiceName
   
  $ServiceStatus = (Get-Service -Name $ServiceName).Status
  Write-Verbose -Message ('Mobikey Service is {0}' -f $ServiceStatus)

}
