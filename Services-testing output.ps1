#requires -Version 4.0


function Get-ServiceList {
  param
  (
    [Parameter(Mandatory, ValueFromPipeline, HelpMessage = 'Data to filter')]
    [Object[]]$InputObject,
    [Parameter(Mandatory,HelpMessage = 'Servive Status')]
    [ValidateSet('Running','Stopped')]
    [Object]$Status,
    [Parameter(Mandatory,HelpMessage = 'Service Starup Type')]
    [ValidateSet('Automatic','Manual')]
    [Object]$StartType
  )
  Begin
  {
   $ServiceList = [PSCustomobject]@{
   Name = ''
   Status = ''
   DisplayName = ''
   }
    
  }

  process {
   foreach($Service in $InputObject){
    $Svc = Get-Service -Name $Service.Name | select -Property * 

    if (($Svc.Status -eq $Status) -and ($Svc.StartType -eq $StartType)) {
    $ServiceList.Name = $Svc.Name
    #Status = $Svc.Status
    $ServiceList.DisplayName = $Svc.DisplayName
    If($Svc.Status -eq 'Running')
  {
    $HighLightColor = 'Green'
  }
  else
  {
    $HighLightColor = 'Red'
  }

  If ($ServiceList.count -ne 0)
  {
    Write-Host $AsciiCheckBox -foreground White -BackgroundColor $HighLightColor -NoNewline
    Write-Output -InputObject (" {0,-9} : {1,-34} : {2,-$(($Svc.displayName).length +2)}" -f $Svc.StartType, $Svc.Name, $Svc.DisplayName)
    }

    }
  }
  }
  End {  }
}


Get-Service | Get-ServiceList -Status Running -StartType Automatic


