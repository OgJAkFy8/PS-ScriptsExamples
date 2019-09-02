#requires -version 3.0



Function Download-DefenderDefinitions
{
  <#
      .SYNOPSIS
      Simple script to download the Windows Defender definitions.
      .DESCRIPTION
      This script checks the version of the latest against what is available online.  If the versions don't match
      it will download the new version.
      .EXAMPLE
      C:\PS> .\Download_Defender.ps1
      .NOTES
      Author: Generik
      .OUTPUTS
      No output except for the download.
      .LINK
      https://github.com/OgJAkFy8/PowerShell_VM-Modules/edit/master/Download_Defender.ps1
  #>
  
  
  [CmdletBinding()]
  param
  (
    [string]$WebFileURL = 'http://go.microsoft.com/fwlink/?LinkID=87341',
    [string]$FileName = 'mpam-feX64.exe',
    [string]$FileExtension = 'exe',
    [string]$LocalFilePath = "$env:HOMEDRIVE\temp\Defender"
  )

 
  # End Settings 

  #=======================

  # Start Functions 

  Function Get-tdFileName
  {
    [CmdletBinding()]
    param
    (
      $baseNAME,

      $t
    )
    $t = Get-Date -UFormat '%d%H%M%S'
    return  $baseNAME + '_' + $t + '.bkp'
  }

  Function Rename-FileAddVersion
  {
    [CmdletBinding()]
    param
    (
      $baseNAME
    )
    $t = (Get-Item -Path $baseNAME).VersionInfo.FileVersion
    return  $baseNAME + '_' + $t + '.bkp'
  }

  Function Get-FileDownload ()
  {
    #Invoke-WebRequest $WebFileURL -OutFile $FileDL
  }

  # End Functions

  #=======================

  # Begin Script

  # Test and create path for download location
  if(!(Test-Path -Path $LocalFilePath))
  {
    Write-Verbose -Message 'Creating Folder'
    New-Item -Path $LocalFilePath -ItemType Directory
  }

  # Change the working location
  Write-Verbose -Message ('Setting location to {0}' -f $LocalFilePath)
  Set-Location -Path $LocalFilePath

  # Get file information from Internet
  Write-Verbose -Message ('Downloading {0} file information' -f $FileName)
  
  $FileTst = <#Invoke-WebRequest -URI #>$WebFileURL 
  $OnlineFileVer = $FileTst.versionInfo.FileVersion

  $OnlineFileVer = (Get-Item -Path '.\Copy mpam-feX64 - Copy.exe').versionInfo.FileVersion  #Testing

  #Get file information from local file
  $LocalFileVer = (Get-Item -Path $FileName).versionInfo.FileVersion

  <# Test to see if the file exists. Download the file if it does not exist.
  If it does exist, it checks to see if the latest version has already been downloaded. #>
  if($LocalFileVer -ne $OnlineFileVer)
  {
    Write-Verbose -Message 'Getting New filename'
    $NewName = Rename-FileAddVersion -baseNAME $FileName

    if (Test-Path -Path $FileName)
    {
      Write-Verbose -Message 'Rename local file'
      Rename-Item -Path $FileName -NewName $NewName
    }

    Write-Verbose -Message 'There is an update available.  Starting Download'
    Try 
    {
      Invoke-WebRequest -Uri $WebFileURL -OutFile $FileName
    }
    Catch [System.Net.WebException] 
    {
      # On error, the SecurityProtocol for the local PowerShell session will be updated to access TLS 1.2 and the download will be attempted again.
      $secProtocol = [Net.ServicePointManager]::SecurityProtocol
      [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
      
      Invoke-WebRequest -Uri $WebFileURL -OutFile $FileName 
      
      # The SecurityProtocol will be then reverted back to the state it was at prior
      [Net.ServicePointManager]::SecurityProtocol = $secProtocol
    } 
  }

  Write-Host 'Finished!'
}

<#
# Download-File_Example
# Download the 1.0 release of the VMware.vSphereDSC module from GitHub
Try {
    Invoke-WebRequest -Uri 'https://github.com/vmware/dscr-for-vmware/releases/download/v1.0/VMware.vSphereDSC.zip' -OutFile $env:userprofile\Downloads\VMware.vSphereDSC.zip
}
Catch [System.Net.WebException] {
    # On error, the SecurityProtocol for the local PowerShell session will be updated to access TLS 1.2 and the download will be attempted again.
    $secProtocol = [Net.ServicePointManager]::SecurityProtocol
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest -Uri 'https://github.com/vmware/dscr-for-vmware/releases/download/v1.0/VMware.vSphereDSC.zip' -OutFile $env:userprofile\Downloads\VMware.vSphereDSC.zip
    # The SecurityProtocol will be then reverted back to the state it was at prior
    [Net.ServicePointManager]::SecurityProtocol = $secProtocol
}
 
# Create a new VMware.vSphereDSC directory in the PowerShell Modules folder which is located in the Program Files directory
$dscDirectory = New-Item -Path “$env:ProgramFiles\WindowsPowerShell\Modules” -Name 'VMware.vSphereDSC' -Type Directory
 
# Expand the downloaded zip file containing the VMware.vSphereDSC module into the prior directory
Expand-Archive -Path $env:USERPROFILE\Downloads\VMware.vSphereDSC.zip -DestinationPath $dscDirectory
#>