#requires -Version 3.0


function Get-ServiceList 
{
  param
  (
    [Parameter(Mandatory, Position = 0, HelpMessage = 'Data to filter')]
    [Object[]]$InputObject,
    [Parameter(Mandatory,Position = 1,HelpMessage = 'Servive Status')]
    [ValidateSet('Running','Stopped')]
    [String]$Status,
    [Parameter(Mandatory = $false,Position = 2,HelpMessage = 'Service Starup Type')]
    [ValidateSet('Automatic','Manual')]
    [String]$StartType = 'Automatic'
  )
  Begin
  {
    $ServiceList = [PSCustomobject]@{
      Name        = ''
      Status      = ''
      DisplayName = ''
    }
    
    $AsciiCheckBox = '[ ]'
    $CharLength = 20
   
    $InputObjectModified = $InputObject |
    Where-Object -FilterScript {
      $_.StartType -eq $StartType
    } |
    Select-Object -Property Name, DisplayName, Status, StartType
    
    $CharLength = ($InputObjectModified |
      Sort-Object -Property {
        $_.Name.Length
      } |
    Select-Object -expand Name -Last 1).length
 
  }

  process {


  
    foreach($Service in $InputObjectModified)
    {
      if ($Service.Status -ne $Status) {
          $ServiceList.Name = $Service.Name
          $ServiceList.DisplayName = $Service.DisplayName
          

      If($Service.Status -eq 'Running')
      {
        $AsciiCheckBox = '( )'
        $HighLightColor = 'black'
      }
      else
      {
        $AsciiCheckBox = '[X]'
        $HighLightColor = 'Red'
      }

      If ($ServiceList.count -ne 0)
      {
        Write-Host -Object $AsciiCheckBox -ForegroundColor White -BackgroundColor $HighLightColor -NoNewline
        Write-Output -InputObject (" {0,-9} : {1,-$($CharLength+1)} : {2}" -f $Service.StartType, $Service.Name, $Service.DisplayName)
      }

       }
    }
  }
  End {  

  }
}


Get-ServiceList -InputObject (Get-Service) -Status Running


