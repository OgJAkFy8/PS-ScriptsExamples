#!/usr/bin/env powershell
Function Set-SafetySwitch
{
  <#
      .SYNOPSIS
      Turns on "WhatIf" for the entire script.
      Like a gun safety, "ON" will prevent the script from running and "OFF" will allow the script to make changes.

      .PARAMETER RunScript
      Manually sets the "Safety" On/Off.

      .PARAMETER Toggle
      changes the setting from its current state

      .PARAMTER Bombastic
      Another word for verbose
      It also is a toggle, so that you can add it to a menu.

      .EXAMPLE
      Set-SafetySwitch 
      Sets the WhatIfPreference to the opposite of its current setting

      .NOTES
      Best to just copy this into your script and call it how ever you want.I use a menu

  #>
  
  [CmdletBinding(SupportsShouldProcess,ConfirmImpact = 'Low',DefaultParameterSetName = 'Default')]
  param
  (
    [Parameter(Position = 1)]
    [Switch]$Bombastic,
    [Parameter(Mandatory,HelpMessage='Hard set on/off',Position = 0,ParameterSetName = 'Switch')]
    [ValidateSet('No','Yes')]
    [String]$RunScript,
    [Parameter(Position = 0, ParameterSetName = 'Default')]
    [Switch]$Toggle = $true
  )

  $Message = @{
    BombasticOff = 'Safety is OFF - Script is active and will make changes'
    BombasticOn= 'Safety is ON - Script is TESTING MODE'
  }

  function Set-WhatIfOn{$Script:WhatIfPreference = $true}
  function Set-WhatIfOff{$Script:WhatIfPreference = $false}

  if($Toggle){
    If ($WhatIfPreference -eq $true)
    {
      Set-WhatIfOff
      if ($Bombastic){Write-Host $($Message.BombasticOff) -ForegroundColor Red}
    }
    else
    {
      Set-WhatIfOn
      if ($Bombastic){Write-Host $($Message.BombasticOn) -ForegroundColor Green}
    }
  }

  if($RunScript -eq 'Yes'){Set-WhatIfOff}
  elseif($RunScript -eq 'No'){Set-WhatIfOn}
}

