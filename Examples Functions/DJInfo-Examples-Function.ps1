function get-DJOSinfo {
	[CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='Low')]
	param(
		[Parameter(Mandatory=$true, ValueFromPipeline=$true,
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
					Select-Object caption,buildnumber,osarchitecture,servicepackmajorversion
				} 
				catch {
					$continue = $false
					$computer | Out-File '.\error.txt'
					#$myErr | Out-File '.\errormessages.txt'
				}
				if($continue) {
					$bios = Get-WmiObject -ComputerName $computer -Class win32_operatingsystem | Select-Object serialnumber
					$processor = Get-WmiObject -ComputerName $computer -Class win32_processor | Select-Object addresswidth -First 1
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

get-DJOSinfo -computername localhost, offline -Verbose 
