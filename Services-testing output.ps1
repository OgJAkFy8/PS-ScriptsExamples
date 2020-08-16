#requires -Version 4.0

function Show-Output
{
  param
  (
    [Parameter(Mandatory, ValueFromPipeline, HelpMessage = 'Data to filter')]
    [Object]$InputObject,
    [Parameter(Mandatory,HelpMessage = 'Service Status')]
    [ValidateSet('Running','Stopped')]
    [Object]$Status
  )
  
  $AsciiCheckBox = '[ ]'
  $DoubleLineBoarder = "`n=============================`n"

  If($Status -eq 'Running')
  {
    $HighLightColor = 'Green'
  }
  else
  {
    $HighLightColor = 'Red'
  }

  If ($InputObject.count -ne 0)
  {
    Write-Host $AsciiCheckBox -foreground White -BackgroundColor $HighLightColor -NoNewline
    Write-Output -InputObject " Services $Status"
    $InputObject
    Write-Host $DoubleLineBoarder -foregroundcolor $HighLightColor
  }
}

function Get-ServiceList
{
  param
  (
    [Parameter(Mandatory, ValueFromPipeline, HelpMessage = 'Data to filter')]
    [Object]$InputObject,
    [Parameter(Mandatory,HelpMessage = 'Servive Status')]
    [ValidateSet('Running','Stopped')]
    [Object]$Status,
    [Parameter(Mandatory,HelpMessage = 'Service Starup Type')]
    [ValidateSet('Automatic','Manual')]
    [Object]$StartType
  )
  process
  {
    if (($InputObject.Status -eq $Status) -and ($InputObject.StartType -eq $StartType))
    {
      $InputObject
    }
  }
}

$ServiceStopped = Get-Service | Get-ServiceList -Status Stopped -StartType Automatic

$ServiceRunning = Get-Service | Get-ServiceList -Status Running -StartType Automatic


$ServiceRunning | Show-Output -Status Running
$ServiceStopped | Show-Output -Status Stopped

#


