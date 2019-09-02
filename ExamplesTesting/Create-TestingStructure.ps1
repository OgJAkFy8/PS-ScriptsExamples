function add-testFolders {

	<#
.SYNOPSIS
    This is a simple Powershell script to create a group of nested folders. 
    The depth is decided by the number you pass.
.DESCRIPTION
    The function will create a group of nested folders for testing other scripts.
.EXAMPLE
    Add-TestFolders 2 
.NOTES
    Script Name: test-folders.ps1
    Author Name: Erik
    Date: 10/5/2017
    Contact : 
.LINK
    PowerShell_VM-Modules/Create-TestingStructure.ps1 

	function test-set {
		[CmdletBinding(DefaultParameterSetName = 3)]
		param(
			[parameter(mandatory=$true, parametersetname="FooSet")]
			[switch]$FldrDpth,[parameter(mandatory=$true,position=0,parametersetname="Folder Depth")]
			[string]$TargFldr,[parameter(mandatory=$true,position=1)]
			[io.fileinfo]$FilePath)
}

#>

	# [CmdletBinding(DefaultParameterSetName = 'TargetFolder', SupportsShouldProcess=$true, ConfirmImpact='Low')]
	[CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Low')]
	param(
		[Parameter(Mandatory=$true,
			ValueFromPipeline=$true,
			ValueFromPipelineByPropertyName=$true)]
		[Int]$FldrDpth = 2,[parameter(mandatory=$true,position=0,parametersetname="DepthofFolderStructure")]
		[Int]$FolderAmount = 4,[parameter(mandatory=$true,position=1,parametersetname="AmountOfFolders")]
		[STRING]$TargFldr = 'c:\Temp\TestingFolders',
		[STRING]$tpLevFldr = 'TopLev',
		[STRING]$NstFldr = 'NestFoldr',
		[STRING]$TstFile = 'TestFile'
	)
	BEGIN{}
	PROCESS {
		WRITE-DEBUG -Message ("`$TargFldr: {0}" -f $TargFldr)
		WRITE-DEBUG -Message ("`$tpLevFldr: {0}" -f $tpLevFldr)
		WRITE-DEBUG -Message ("`$NstFldr: {0}" -f $NstFldr)

<#
		@"
		Parameterset is: {0}
		Bar is: '{1}'
		-TargFldr present: {2}
		FilePath: {3}
		"@ -f $PSCmdlet.ParameterSetName, $FolderDepth, $TargFldr.IsPresent, $FilePath
#>
		Set-Location 'c:\temp\TestingFolders' #$TargFldr

		$i = 1
		Do {
			Write-Debug "c:\temp\TestingFolders\NestedFolders-$i"
			$TargFldr = "c:\temp\TestingFolders\NestedFolders-$i"
			$i++
		}while (Test-Path $TargFldr)
		if(!(Test-Path $TargFldr)){
			New-Item -ItemType Directory -Path $TargFldr -Force
		}


		$i = 0
		While ($i -le $FolderDepth) {
			$i++
			<# $FolderAmount
			While ($h -lt $FolderAmount){
			Write-Debug "TargFldr: $TargFldr"
			New-Item -ItemType Directory -Path $TargFldr"\"$tpLevFldr"-"$h -Force
			$j = 0
			While ($j -le $FolderAmount) {
				$j +=1
				New-Item -ItemType Directory -Path $TargFldr"\"$tpLevFldr"-"$h"\"$NstFldr"-"$i"-"$j -Force
				#Set-Location .\$NstFldr"-"$i"-"$j
				$k = 0
				While ($k -le $FolderDepth) {
					$k += 1
					#New-Item -ItemType File -path 
					New-EmptyFile $TargFldr"\"$tpLevFldr"-"$h"\"$NstFldr"-"$i"-"$j"\"$TstFile"-"$i"-"$j"-"$k".txt" $FolderDepth # -Force
				}
				}
				#>
																					
			H =0
			While ($h -lt $FolderAmount){
				h++
				Write-Debug "TargFldr: $TargFldr"
				New-Item -ItemType Directory -Path $TargFldr"\"$tpLevFldr"-"$h -Force
			}




		}
	}
END{}
}

function New-EmptyFile {
	param( [string]$FilePath,[double]$Size )
	$file = [System.IO.File]::Create($FilePath)
	$file.SetLength($Size * 1024)
	$file.Close()
	Get-Item $file.Name
}


function Remove-TestFolders {
	$limit = (Get-Date).AddDays(-0)
	Set-Location 'C:\Temp\TestingFolders'

	$NestedFolders = Get-ChildItem | Where-Object{$_.Name -match 'NestedFolders'} | Sort-Object -Property $_.Lastwritetime
	$menu = @{}
	$folderCount = $NestedFolders.Count-1

	for($i = 0;$i -lt $NestedFolders.count;$i++){
		Write-Host ('{0}. {1}' -f $i, $NestedFolders[$i].name)
		$menu.Add($i,($NestedFolders[$i].name))
	}

	do{[int]$ans = Read-Host -Prompt 'Select number to Remove'
		if($ans -ge $folderCount ){
			Write-Host ('Select a number between 0 and {0}' -f $folderCount)
		}
	}until($ans -in 0..$folderCount)

	$selection = $menu.Item($ans)

	#$folder = Read-Host "Enter Folder Name"
	$path = Resolve-Path $selection
	$ans = 3
	$ans = Read-Host -Prompt "`n1-Delete Files`n2) Delete Folders and Files (All)`n[3].Exit"

	# Delete files older than the $limit.
	Get-ChildItem -Path $path -Recurse -Force | 
	Where-Object { !$_.PSIsContainer -and $_.CreationTime -lt $limit } | 
	Remove-Item -Force -WhatIf

	# Delete any empty directories left behind after deleting the old files.
	Get-ChildItem -Path $path -Recurse -Force | 
	Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | 
			Where-Object { !$_.PSIsContainer }) -eq $null } | 
	Remove-Item -Force -Recurse -WhatIf
}


## Begin script

# Write-Host "Options `nAdd-TestFolders`nRemove-TestFolders"

# SIG # Begin signature block
# MIID7QYJKoZIhvcNAQcCoIID3jCCA9oCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUsMQWRb90dZLZL1RtHivYUv0N
# PWmgggINMIICCTCCAXagAwIBAgIQyWSKL3Rtw7JMh5kRI2JlijAJBgUrDgMCHQUA
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
# KwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUm9PkYqQwGYpxmdBc9ctk5coerNMw
# DQYJKoZIhvcNAQEBBQAEgYCTO41BCJNhyWTAmr+4TlcmjN5PkwvOWmpsON+EfjvJ
# fsvD15N9l3fZ0dL3bLIiF8iV+ZaufNoSGFCQAmL0iM4PM4zSzAbcTJhmmOTQ5D0i
# EzK3Wyr08fCWDOMRuRH4EPZYrLDBFVF6R/bpjiIOdhTdCsrOJ/W9OxCcb+1Cza0p
# lw==
# SIG # End signature block
