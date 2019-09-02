#requires -runasadministrator

function Repair-MobiKey 
{
  <#
      .SYNOPSIS
      Repairs the Mobkey Installation
   
      .EXAMPLE
      Repair-MobiKey

      Repair-MobiKey -MobikeyCertsPath '\\Networkshare\mobikey\certs'
         
      .NOTES
      You will need to make the following changes

      .LINK
      https://github.com/KnarrStudio/PS-Scripts/wiki/Repair-MobiKey

      The first link is opened by Get-Help -Online Repair-MobiKey

  #>

  [CmdletBinding(HelpUri = 'https://github.com/KnarrStudio/PS-Scripts/wiki/MobiKey-Repair',
  ConfirmImpact = 'Medium')]
  [OutputType([String])]
  Param
  (
    # Param1 help description
    [Parameter(Mandatory = $false, Position = 0)]
    [string]$MobikeyCertsPath = '\\Networkshare\mobikey\certs'
  )
  
  $ServiceName = 'Route1*'
  $MobikeyLocalPath = "$env:ProgramData\Mobikey\certs"
  
  
  # First Stop the Mobikey Service 
  Write-Verbose -Message ('Stop Mobikey Service')
  Stop-Service -Name $ServiceName
     
  # Delete the old files out of the ProgramData Dir
  if (Test-Path -Path $MobikeyLocalPath)
  {
    Write-Verbose -Message ('Delete old Certificate files')
    Get-ChildItem -Path $MobikeyLocalPath -Recurse | Remove-Item -Force -WhatIf
  }
  
  # Copy files from the File share to the local drive
  if (Test-Path -Path $MobikeyCertsPath)
  {
    Write-Verbose -Message ('Copy Files from Network to Localhost')
    Copy-Item -Path $MobikeyCertsPath -Include *.* -Destination $MobikeyLocalPath -Force
    # $MobiKeyCerts = Get-ChildItem -Path .\ 
  }
  # Start the Mobikey service 
  Write-Verbose -Message ('Start Mobikey Service')
  Start-Service -Name $ServiceName


  # Working on testing dates to compare files
  <#  foreach($MobiKeyCert in $MobiKeyCerts)
      {
      $MobiKeyCertOrgDate = $MobiKeyCertDate.lastwritetime

      For($i = 0;$i -lt 6;$i++)
      {
      if(($f[$i].CreationTimeUtc) -ne ($f[$i].lastwritetime))
      {
      Write-Host ('not equal {0} -- {1}' -f $f[$i].CreationTimeUtc, $f[$i].lastwritetime)
      }
      }
  }#>
   
  $ServiceStatus = (Get-Service -Name $ServiceName).Status
  Write-Verbose -Message ('Mobikey Service is {0}' -f $ServiceStatus)
}







