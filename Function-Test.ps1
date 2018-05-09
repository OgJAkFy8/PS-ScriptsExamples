<#
.SYNOPSIS
   <A brief description of the script>
.DESCRIPTION
   <A detailed description of the script>
.PARAMETER <paramName>
   <Description of script parameter>
.EXAMPLE
   <An example of using the script>
#>

function get-DJOSinfo {
	[CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='Low')]
	param(
		[Parameter(Mandatory=$true,
			ValueFromPipeline=$true,
			ValueFromPipelineByPropertyName=$true)]
		[Alias('hostname')]
		[ValidateLength(4,14)]
		[ValidateCount(1,10)]
		[string[]]$computername,

		[switch]$nameLog
	)
	BEGIN{
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

		foreach ($computer in $computername){
			if($PSCmdlet.ShouldProcess($computer)){
				Write-Verbose "Connecting to $computer"
				if($nameLog){
					$computer | Out-File $logfile -Append
				}
				try {
					$continue = $true
					$os = Get-WmiObject -EA 'Stop' -EV myErr -ComputerName $computer -Class win32_operatingsystem | 
					select caption,buildnumber,osarchitecture,servicepackmajorversion
				} 
				catch {
					$continue = $false
					$computer | Out-File '.\error.txt'
					#$myErr | Out-File '.\errormessages.txt'
				}
				if($continue) {
					$bios = Get-WmiObject -ComputerName $computer -Class win32_operatingsystem | 
					select serialnumber
					$processor = Get-WmiObject -ComputerName $computer -Class win32_operatingsystem | 
					select address -First 1
					$osarchitecture = $os.osarchitecture -replace '-bit',''
					$properties = @{'ComputerName'=$computer;
						'OSVersion'=$os.caption;
						'OSBuild'=$os.buildnumber;
						'OSArchitecture'=$osarchitecture;
						'OSSPVersion'=$os.servicepackmajorversion;
						'BIOSSerial'=$bios.serialnumber;
						'ProcArchitecture'=$processor.addresswidth}
					$obj = New-Object -TypeName psobject -Property $properties
					Write-Output $obj
				}
			}
		}
	}
	END{}

}

get-DJOSinfo #-computername localhost, offline -Verbose -nameLog

# SIG # Begin signature block
# MIID7QYJKoZIhvcNAQcCoIID3jCCA9oCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU9qbXXf/A27NzmMMT+R0+76tX
# QFygggINMIICCTCCAXagAwIBAgIQyWSKL3Rtw7JMh5kRI2JlijAJBgUrDgMCHQUA
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
# KwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUbAMijVn0YcSGuhsqF7erOX30WWgw
# DQYJKoZIhvcNAQEBBQAEgYCHDFvrY+Bc+nFGeCVTy6QqLJ/i/VoPI5fwflaPGYxt
# XSLFbytnidYfm9isC8FyqYc6R9gQeowJBDMDFA3m2SdgFdBGfrtjtQKFiSi/UwlN
# OD+cyd31zqzIXCk2mkRXIxtRaoGI7aXptZzjM8SQQN9Y4GMPLv+7/bsBhdlEHcVe
# mg==
# SIG # End signature block
