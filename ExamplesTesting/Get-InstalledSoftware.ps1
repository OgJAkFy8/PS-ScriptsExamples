#!/usr/bin/env powershell
#requires -version 3

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

#----------------------[Initialisations]--------------------------------------------------------

#Set Error Action to Silently Continue
$ErrorActionPreference = 'SilentlyContinue'

#Dot Source required Function Libraries
. "$env:HOMEDRIVE\Scripts\Functions\Logging_Functions.ps1"

#----------------------[Declarations]----------------------------------------------------------

#Script Version
$sScriptVersion = '1.0'

#Log File Info
$sLogPath = "$env:windir\Temp"
$sLogName = 'InstalledSoftware.log'
$sLogFile = Join-Path -Path $sLogPath -ChildPath $sLogName

#---------------------[Functions]------------------------------------------------------------

Function script:Get-InsalledSoftware{
  <#
      .SYNOPSIS
      "Get-InsalledSoftware" collects all the software listed in the Uninstall registry.
    
      .INPUTS
      List of input types that are accepted by this function.

      .OUTPUTS
      List of output types produced by this function.
  #>


  Param(
  
    [Parameter(Mandatory,HelpMessage='Get list of installed software by installed date or alphabeticlly')]
    [ValidateSet('InstallDate', 'DisplayName')] [Object]$SortList
  )
  
  Begin{
    Log-Write -LogPath $sLogFile -LineValue 'Finding installed software'
  }
  
  Process {
    Try{
      $InstalledSoftware = (Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*)
      
$InstalledSoftware | Sort-Object -Descending -Property $SortList |  Select-Object -Property Installdate,DisplayVersion,DisplayName

    }
     
    
    Catch{
      Log-Error -LogPath $sLogFile -ErrorDesc $_.Exception -ExitGracefully $True
      Break
    }
  }
  
  End{
    If($?){
      Log-Write -LogPath $sLogFile -LineValue 'Completed Successfully.'
      Log-Write -LogPath $sLogFile -LineValue ' '
    }
  }
}


#---------- [Execution]------------------------------------------------------------

Log-Start -LogPath $sLogPath -LogName $sLogName -ScriptVersion $sScriptVersion

Get-InsalledSoftware 'InstallDate' | Format-Table -AutoSize

Log-Finish -LogPath $sLogFile


# SIG # Begin signature block
# MIID7QYJKoZIhvcNAQcCoIID3jCCA9oCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUUyFZ7o7UBPCKxjtWFoGZBI0T
# ELugggINMIICCTCCAXagAwIBAgIQyWSKL3Rtw7JMh5kRI2JlijAJBgUrDgMCHQUA
# MBYxFDASBgNVBAMTC0VyaWtBcm5lc2VuMB4XDTE3MTIyOTA1MDU1NVoXDTM5MTIz
# MTIzNTk1OVowFjEUMBIGA1UEAxMLRXJpa0FybmVzZW4wgZ8wDQYJKoZIhvcNAQEB
# BQADgY0AMIGJAoGBAKYEBA0nxXibNWtrLb8GZ/mDFF6I7tG4am2hs2Z7NHYcJPwY
# CxCw5v9xTbCiiVcPvpBl7Vr4I2eR/ZF5GN88XzJNAeELbJHJdfcCvhgNLK/F4DFp
# kvf2qUb6l/ayLvpBBg6lcFskhKG1vbEz+uNrg4se8pxecJ24Ln3IrxfR2o+BAgMB
# AAGjYDBeMBMGA1UdJQQMMAoGCCsGAQUFBwMDMEcGA1UdAQRAMD6AEMry1NzZravR
# UsYVhyFVVoyhGDAWMRQwEgYDVQQDEwtFcmlrQXJuZXNlboIQyWSKL3Rtw7JMh5kR
# I2JlijAJBgUrDgMCHQUAA4GBAF9beeNarhSMJBRL5idYsFZCvMNeLpr3n9fjauAC
# CDB6C+V3PQOvHXXxUqYmzZpkOPpu38TCZvBuBUchvqKRmhKARANLQt0gKBo8nf4b
# OXpOjdXnLeI2t8SSFRltmhw8TiZEpZR1lCq9123A3LDFN94g7I7DYxY1Kp5FCBds
# fJ/uMYIBSjCCAUYCAQEwKjAWMRQwEgYDVQQDEwtFcmlrQXJuZXNlbgIQyWSKL3Rt
# w7JMh5kRI2JlijAJBgUrDgMCGgUAoHgwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKA
# ADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYK
# KwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUe+znNIj6C1vXQ0InhME70oJh0+4w
# DQYJKoZIhvcNAQEBBQAEgYB5/dvdQEgRGZkYOkl4NkzkMPWWALXvl8k2OjxMBPO2
# zgG4lAORFkLNxZkelaKEEKNwjq0oJS9zro49V/DlQ2JFByZyQKdP0COU7FZ7/YFh
# bls430gopsFwJJ7tMwOdaX6mrieOrcFifZCb9gFOYCTMBFRqooUPFLH7/HC9Y1t3
# 0w==
# SIG # End signature block
