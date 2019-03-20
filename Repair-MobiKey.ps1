#requires -runasadministrator

  <#
      .SYNOPSIS
      Repairs the Mobkey Installation
   
      .DESCRIPTION
      Add a more complete description of what the function does.

      .EXAMPLE
      Repair-MobiKey
         
      .NOTES
      Place additional notes here.

      .LINK
      URLs to related sites
      The first link is opened by Get-Help -Online Repair-MobiKey

  #>
   
  # First Stop the Mobikey Service 
  $MobikeyCertPath = "$env:ProgramData\Mobikey\certs"
  Stop-Service -Name 'Route1*'
   
  # Delete the old files out of the ProgramData Dir
  if (Test-Path -Path $MobikeyCertPath){
    Get-ChildItem -Path $MobikeyCertPath -Recurse | Remove-Item -Force -WhatIf
  }
  # Copy files from the File share to the local drive

  Copy-Item -Path \\resorce\share\mobikeey\certs -Include *.* -Destination $env:ProgramData\mobikey\certs -Force

  # Start the Mobikey service 
  Start-Service -Name 'Route1*'
   
  $ServiceStatus = (Get-Service -Name 'Route1*').Status
  Write-Host ('Mobikey Service is {0}' -f $ServiceStatus)

