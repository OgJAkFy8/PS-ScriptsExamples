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
		[Parameter(Mandatory=$true,HelpMessage='Add help message for user',
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
			Write-Verbose -Message 'Finding name log file'
			$i = 0
			Do {
				$logfile = ".\names-$i.txt"
				$i++
			}while (Test-Path -Path $logfile)
		} else {
			Write-Verbose -Message 'Name log off'
		}
		Write-Debug -Message 'finished setting name log'
	}
	PROCESS{ 
		Write-Debug -Message 'Starting Process'

		foreach ($computer in $computername){
			if($PSCmdlet.ShouldProcess($computer)){
				Write-Verbose -Message ('Connecting to {0}' -f $computer)
				if($nameLog){
					$computer | Out-File -FilePath $logfile -Append
				}
				try {
					$continue = $true
					$os = Get-WmiObject -ErrorAction 'Stop' -ErrorVariable myErr -ComputerName $computer -Class win32_operatingsystem | 
					select -Property caption,buildnumber,osarchitecture,servicepackmajorversion
				} 
				catch {
					$continue = $false
					$computer | Out-File -FilePath '.\error.txt'
					#$myErr | Out-File '.\errormessages.txt'
				}
				if($continue) {
					$bios = Get-WmiObject -ComputerName $computer -Class win32_operatingsystem | 
					select -Property serialnumber
					$processor = Get-WmiObject -ComputerName $computer -Class win32_operatingsystem | 
					select -Property address -First 1
					$osarchitecture = $os.osarchitecture -replace '-bit',''
					$properties = @{'ComputerName'=$computer;
						'OSVersion'=$os.caption;
						'OSBuild'=$os.buildnumber;
						'OSArchitecture'=$osarchitecture;
						'OSSPVersion'=$os.servicepackmajorversion;
						'BIOSSerial'=$bios.serialnumber;
						'ProcArchitecture'=$processor.addresswidth}
					$obj = New-Object -TypeName psobject -Property $properties
					Write-Output -InputObject $obj
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
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUHuY8JhcFHhpOHjtgl2FJzD+P
# EUagggINMIICCTCCAXagAwIBAgIQyWSKL3Rtw7JMh5kRI2JlijAJBgUrDgMCHQUA
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
# KwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUAAk8hQ9/u/JZ6ON6kzb9malbIx8w
# DQYJKoZIhvcNAQEBBQAEgYBDuG4y6GqMQ8dneTjR8MPVEB8TUEaZEVkQFaEnnxEY
# nhkdEjQI7EzjgtkvXyVRwHdZm5O8hUsD6cX4U8/hXxlPaDH/IaLAcuCvhZYjlDoN
# E35PkvUH+DXs7wT/DtWtMvcVHdOQ/jqOLn4ZV0zO5IW42hfd5hHqWCuigiAoO1K4
# sA==
# SIG # End signature block
