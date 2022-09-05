#function Test-NetworkConnection
#{
<#
    .SYNOPSIS
    Ping function for use inside the script ping test
        
    .DESCRIPTION
    Uses Test-Netconnect to test an IP address while presenting the name 
        
    .PARAMETER TestName
    Name of the test that you want to present while testing.  Most often user friendly name.  i.e. Gateway, or DHCP server
        
    .PARAMETER TargetNameIp
    IP Address of the system that needs to be tested.
        
    .EXAMPLE
    Test-NetworkConnection -TestName 'My Gateway' -TargetNameIp 192.168.0.1 -NetworkReportFullName test.txt
    This will ping the 192.168.0.1 address and lable it 'My Gateway' and send the results to the file test.txt
        
#>
      
param
(
  [Parameter(Position = 0)]
  [string]$TestName = 'Loopback connection',
  [Parameter(Position = 1)]
  [AllowNull()]
  [AllowEmptyCollection()]
  [AllowEmptyString()]
  [string[]]$TargetNameIp = '127.0.0.1',
  [Parameter(Mandatory = $false)]
  [Alias('NetworkReportFullName')]
  [String]$OutputFile = (New-TemporaryFile).Name
)
$Delimeter = ':'
$FormatTestWidth = ($TestName.Length + 1)
$Formatting = '{0,-($FormatTestWidth)}{1,-2}{2,-24}'

Write-Verbose -Message $([String]$TargetNameIp)
Write-Host -Object ('Testing {0}:' -f $TestName) -ForegroundColor Yellow
Add-Content -Value ('Testing {0}:' -f $TestName) -Path $OutputFile
    
function Script:Write-Info 
{
  <#
      .SYNOPSIS
      Output function

      .INPUTS
      Filename, title of data and data

      .OUTPUTS
      Formatted input information to the screen and file
  #>

  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true)][string]$Title,
    [Parameter(Mandatory = $true)][Object]$Value,
    [Parameter(Mandatory = $true)][String]$FilePath
  )

  $Delimeter = ':'
  $Formatting = '{0,-23}{1,-2}{2,-24}'
    
  Tee-Object -InputObject ($Formatting -f $Title, $Delimeter, $Value) -FilePath $FilePath  -Append
} #End: Write-Info 

ForEach($Target in $TargetNameIp) 
{ 
  try
  {
    Write-Verbose -Message ([IpAddress]$Target).IPAddressToString -ErrorAction Stop
    $PingSucceeded = (Test-NetConnection -ComputerName $Target).PingSucceeded
    if($PingSucceeded -eq $true)
    {
      $TestResults = 'Passed'
    }
    elseif($PingSucceeded -eq $false)
    {
      $TestResults = 'Failed'
    }
  }
  Catch
  {
    if(($Target -eq $Null) -or ($Target -eq ''))
    {
      $TestResults = 'Null or Blank IPAddress'
    }
    else
    {
      $TestResults = 'Invalid IPAddress'
    }
    Write-Verbose -Message ($Formatting -f $Target, $Delimeter, $TestResults) 
  }
  if($OutputFile)
  {
    Write-Info -Title $Target -Value $TestResults -FilePath $OutputFile
    #Tee-Object -InputObject ($Formatting -f $Target, $Delimeter, $TestResults) -FilePath $OutputFile -Append
  }
  else
  {
    Write-Output -InputObject ($Formatting -f $Target, $Delimeter, $TestResults)
  }
}
Write-Output -InputObject (Get-Item -Path $OutputFile).FullName
#} #End: Test-NetworkConnection
    