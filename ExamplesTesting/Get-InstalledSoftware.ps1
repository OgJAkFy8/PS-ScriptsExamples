#!/usr/bin/env powershell
#requires -version 3.0

<#
    .SYNOPSIS
    Find the installed software on a Windows Compter

    .DESCRIPTION
    Lists all of the software in the system's "uninstall" Registry path

    .PARAMETER <Parameter_Name>
    <Brief description of parameter input required. Repeat this attribute if required>

    .INPUTS
    None

    .OUTPUTS
    Log file stored in C:\Windows\Temp\InstalledSoftware.log

    .NOTES
    Version:        1.0
    Author:         Arnesen
    Creation Date:  3/6/2018
    Purpose/Change: Initial script development
  
    .EXAMPLE
    <Example goes here. Repeat this attribute for more than one example>
#>


#Set Error Action to Silently Continue
$ErrorActionPreference = 'SilentlyContinue'

#Dot Source required Function Libraries
. "$env:HOMEDRIVE\Scripts\Functions\Logging_Functions.ps1"

#Script Version
$sScriptVersion = '1.0'

#Log File Info
$sLogPath = "$env:windir\Temp"
$sLogName = 'InstalledSoftware.log'
$sLogFile = Join-Path -Path $sLogPath -ChildPath $sLogName


Function script:Get-InsalledSoftware
{
  <#
      .SYNOPSIS
      "Get-InsalledSoftware" collects all the software listed in the Uninstall registry.
    
      .INPUTS
      List of input types that are accepted by this function.

      .OUTPUTS
      List of output types produced by this function.
  #>


  Param(
  
    [Parameter(Mandatory,HelpMessage = 'Get list of installed software by installed date or alphabeticlly')]
    [ValidateSet('InstallDate', 'DisplayName')] [Object]$SortList
  )
  
  Begin{
    Log-Write -LogPath $sLogFile -LineValue 'Finding installed software'
  }
  
  Process {
    Try
    {
      $InstalledSoftware = (Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*)
      
      $InstalledSoftware |
      Sort-Object -Descending -Property $SortList |
      Select-Object -Property Installdate, DisplayVersion, DisplayName
    }
     
    
    Catch
    {
      Log-Error -LogPath $sLogFile -ErrorDesc $_.Exception -ExitGracefully $True
      Break
    }
  }
  
  End{
    If($?)
    {
      Log-Write -LogPath $sLogFile -LineValue 'Completed Successfully.'
      Log-Write -LogPath $sLogFile -LineValue ' '
    }
  }
}


Log-Start -LogPath $sLogPath -LogName $sLogName -ScriptVersion $sScriptVersion

Get-InsalledSoftware 'InstallDate' | Format-Table -AutoSize

Log-Finish -LogPath $sLogFile
