

<#
.NOTE
How to sign a PS script
    https://www.hanselman.com/blog/SigningPowerShellScripts.aspx
How to set the Execution Policy
    https://technet.microsoft.com/en-us/library/ee176961.aspx
How to create Scheduled Tasks
    http://duffney.io/Create-ScheduledTasks-SecurePassword

#>


function copy-VMdatastoreItem{
<#
.SYNOPSIS
 Copies files between local computer and datastore

.DESCRIPTION
When you need to copy files from or to a datastore which can be automated

.PARAMETER filename
Used when you want to copy a specific file. You can use wild cards. By default it will copy only iso's

.EXAMPLE
copy-VMdatastoreItem -filename random.iso -direction down

.PARAMETER copydown
Used when you want to copy file down from datastore.

.EXAMPLE
copy-VMdatastoreItem -filename random.iso -copydown

.PARAMETER LocalPath
assign a local path different from the default of "C:\temp\VMDS"

#>

param(
	[CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='Low')]
	[Parameter(Mandatory=$false)]
	[Alias('File_Name')]
	[string]$filename,

	[Alias('Local_Path')]
	[string]$LocalPath = "C:\temp\VMDS",

	[switch]$copydown,
	[switch]$nameLog

)
BEGIN{
	write-debug "Start Begin"

	#New-PSDrive -location (get-datastore template-01) -name tpl01 -PSProvider VimDatastore -Root '\'
	#New-PSDrive -location (get-datastore template-02) -name tpl02 -PSProvider VimDatastore -Root '\'
	#$isos = ls tpl01:\iso\ | % {$_.Name}
	$isos = (Get-ChildItem c:\temp\test).name

		if ($nameLog){
			Write-Verbose "Finding name log file"
			$i = 0
			Do {
				$logfile = ".\names-$i.txt"
				$i++
			}while (Test-Path $logfile)
		} else {
			Write-Verbose "Name log off"
		}
		Write-Debug "finished setting name log"
	}

	PROCESS{ 

		Write-Debug "Starting Process"

		foreach($iso in $isos) {
			Write-Debug "Starting foreach"
			<#

            if($PSCmdlet.ShouldProcess($computer)){
                Write-Verbose "Connecting to $computer"
                
#>
			if($nameLog){
				$iso | Out-File $logfile -Append
			}
			try {
				if ($copydown){
					Write-Host "copy $($iso) to C:\tmp" -fore Yellow
					#Copy-DatastoreItem -item tpl01:\iso\$iso -Destination C:\temp\VMDS
				}else{
					Write-Host "copy $($iso) to template-02\iso" -fore Yellow
					#Copy-DatastoreItem -item C:\tmp\$iso -Destination tpl02:\iso
				}
			} 
			catch {
				$continue = $false
				$iso | Out-File '.\error.txt'
				#$myErr | Out-File '.\errormessages.txt'
			}

			#Write-Host "removing the tmp file $($iso) from C:\tmp" -fore Yellow
			#Remove-Item C:\tmp\$iso -confirm:$false

			Write-Host "done" -fore Green
		}
	}

	END{
    }
}

# copy-VMdatastoreItem 
# SIG # Begin signature block
# MIID7QYJKoZIhvcNAQcCoIID3jCCA9oCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUdZOQ1t/tOd4iLHB/WRMQaKoH
# EwqgggINMIICCTCCAXagAwIBAgIQyWSKL3Rtw7JMh5kRI2JlijAJBgUrDgMCHQUA
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
# KwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUwA97aaCtakdKr98UJTPGgx7Pc/cw
# DQYJKoZIhvcNAQEBBQAEgYBU2AjY6Z6Zf++Me1SfxvbD/zEveU0cD+8PDZhJbb4A
# V1FBMVD1fM8zSnrFBYk6p0dmxwERvHTapi9TDiRjkBuEwF4LsPksFWhzE0zcsCRH
# 7nCOJz45MOwJL4TdD6+5BporDNe2hSt3SM2GcVywiI3Y6iCSDmoJbUGJkXKeWVo/
# ZQ==
# SIG # End signature block
