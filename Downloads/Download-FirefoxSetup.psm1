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

# User Modifications
$Site = "https://download.mozilla.org/?product=firefox-esr-latest-ssl&os=win64&lang=en-US"
$FileName = "FirefoxSetup"
$FileExtension = "exe"
$LocalFilePath = "c:\temp"

# End Settings 

#=======================

# Start Functions 

Function f_tdFileName ($baseNAME, $t){
	$t = Get-Date -uformat "%d%H%M%S"
	return $baseNAME + "_" + $t + ".bkp"
}

Function f_verFileName ($baseNAME){
	$t = (get-item $baseNAME).VersionInfo.FileVersion
	return $baseNAME + "_" + $t + ".bkp"
}

Function f_FileDownload (){
	Invoke-WebRequest $Site -OutFile $FileDL
}

# End Functions

#=======================

# Begin Script

# Test and create path for download location
if(!(Test-Path $LocalFilePath)){
	Write-Host "Creating Folder"
	New-Item -path $LocalFilePath -ItemType Directory 

}

# Change the working location
Write-Host "Setting location to $LocalFilePath"
Set-Location $LocalFilePath

# Get file information from Internet
Write-Host "Downloading $FileName file information"
$FileTst = <#Invoke-WebRequest -URI #>$Site 
$OnlineFileVer = $FileTst.versionInfo.FileVersion

if(Test-Path ".\FirefoxSetup - Copy.exe" -eq $true){
	$OnlineFileVer = (get-item ".\FirefoxSetup - Copy.exe").versionInfo.FileVersion #Testing
}
#Get file information from local file
$LocalFileVer = (Get-Item "$FileName.$FileExtension").versionInfo.FileVersion

<# Test to see if the file exists. Download the file if it does not exist.
If it does exist, it checks to see if the latest version has already been downloaded. #>
if($LocalFileVer -ne $OnlineFileVer){
	Write-Host "Getting New filename"
	$NewName = f_verFileName "$FileName.$FileExtension"

	if (Test-Path "$FileName.$FileExtension"){
		Write-Host "Rename local file"
		Rename-Item "$FileName.$FileExtension" $NewName
	}

	Write-Host "There is an update available.  Starting Download"
	Invoke-WebRequest $Site -OutFile "$FileName.$FileExtension" 
}

Write-Host "Finished!"


# SIG # Begin signature block
# MIID7QYJKoZIhvcNAQcCoIID3jCCA9oCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUnaanotwNqT7lvoTCsV0V9Mde
# YWqgggINMIICCTCCAXagAwIBAgIQyWSKL3Rtw7JMh5kRI2JlijAJBgUrDgMCHQUA
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
# KwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUvB0u1SyeRMkmZrQ3+EgC5E8CSMkw
# DQYJKoZIhvcNAQEBBQAEgYALL0WvqDKyk7vS+S7+CiKIyr698vTEHrAbKcI/a/Wb
# b53DQM0kAapYMpcqpntwmsPlSTlKm9uvWI1tzXINbt8fNowv/6OGuVHfbhPoFKl6
# XYtixkvCxBILgAsnvueNwUA7RoldAyu12NSh0ZAunMtgO9K/prSB1UHPw3NWQa+i
# xQ==
# SIG # End signature block
