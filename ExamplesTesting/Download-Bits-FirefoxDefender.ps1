#requires -version 3.0

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
      https://github.com/OgJAkFy8/PowerShell_VM-Modules/edit/master/
#>


# Start Settings


function Select-LocalFireFoxProgram
{
   param
   (
      [Parameter(Mandatory, ValueFromPipeline, HelpMessage='Data to filter')]
      $InputObject
   )
   process
   {
      if (($InputObject.DisplayName -like '*Firefox*' ) -and ($InputObject.DisplayName -match 'ESR') -and ($InputObject.Publisher -like 'Mozilla*' ))
      {
         $InputObject
      }
   }
}

Import-Module -Name BitsTransfer

# User Modifications
$url = 'https://download.mozilla.org/?product=firefox-esr-latest-ssl&os=win64&lang=en-US'
$FileName = 'FirefoxSetup'
$FileExtension = 'exe'
$LocalFilePath = "$env:HOMEDRIVE\Temp"
$CurrentFile = "$env:ProgramW6432\Mozilla Firefox\firefox.exe"
$LocalDownloadPath = ''

# End Settings 

#=======================

# Start Functions 

Function Set-FileName{
	
   param
   (
      [Parameter(Mandatory)][string]
      $baseNAME,

      [Parameter(Mandatory)][string]
      $t
   )
   $t = Get-Date -uformat '%d%H%M%S'
   return $baseNAME + '_' + $t + '.bkp'
}

Function Get-FileVersion{
	
   param
   (
      [Parameter(Mandatory)][string]
      $baseNAME
   )
   $t = (get-item -Path $baseNAME).VersionInfo.FileVersion
   return $baseNAME + '_' + $t + '.bkp'
}

Function Start-BitsDownload (){
   Import-Module -Name BitsTransfer
   Start-BitsTransfer -Source $url -Destination $output
   #	Invoke-WebRequest $Site -OutFile $FileDL
}

Function Start-FileDownload {
   Start-BitsTransfer -Source $url -Destination $output
}
# End Functions

#=======================

# Begin Script

# Test and create path for download location
if(!(Test-Path -Path $LocalDownloadPath)){
   Write-Verbose -Message 'Creating Folder'
   New-Item -path $LocalDownloadPath -ItemType Directory 
}

# Change the working location
Write-Information -MessageData ('Setting location to {0}' -f $LocalDownloadPath)
Set-Location -Path $LocalDownloadPath


# Download the file from the Internet
Write-Verbose -Message ('Downloading {0} file information' -f $FileName)
Start-BitsTransfer -Source $url -Destination ('{0}.new' -f $FileName)
	
	
#Get file information from local file
$ProgramProperties = Get-ItemProperty -Path $registry_paths -ErrorAction SilentlyContinue | Select-LocalFireFoxProgram
$LocalFileVer = $ProgramProperties.DisplayVersion #

<# Test to see if the file exists. Download the file if it does not exist.
If it does exist, it checks to see if the latest version has already been downloaded. #>
if($LocalFileVer -ne $OnlineFileVer){
   Write-Verbose -Message 'Getting New filename'
   $NewName = Start-BitsDownload ('{0}.{1}' -f $FileName, $FileExtension)

   if (Test-Path -Path ('{0}.{1}' -f $FileName, $FileExtension)){
      Write-Verbose -Message 'Rename local file'
      Rename-Item -Path ('{0}.{1}' -f $FileName, $FileExtension) -NewName $NewName
   }

   Write-Verbose -Message 'There is an update available.  Starting Download'
   Invoke-WebRequest -Uri $Site -OutFile ('{0}.{1}' -f $FileName, $FileExtension) 
}

Write-Verbose -Message 'Finished!'

