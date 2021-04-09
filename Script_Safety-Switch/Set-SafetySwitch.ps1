Function Set-SafetySwitch
{
  <#
      .SYNOPSIS
      Turns on "WhatIf" for the entire script

      .PARAMETER toggle
      Currently does nothing.  I may set it up to take an ON/OFF later on

      .PARAMTER Bombastic
      Another word for verbose

      .EXAMPLE
      Set-SafetySwitch 
      Sets the WhatIfPreference to the opposite of its current setting

      .NOTES
      Best to just copy this into your script and call it how ever you want.  I use a menu

  #>
  [CmdletBinding()]
  param
  (
    [Switch]$Bombastic,
    [Object]$toggle
  )

  $Message = @{
    NormalOff    = 'Safety OFF - Script will run'
    NormalOn     = 'Safety ON'
    BombasticOff = 'Safety is OFF - Script is active and will make changes'
    BombasticOn  = 'Safety is ON - Script is TESTING MODE'
  }
  $MsgOn = $Message.NormalOn
  $MsgOff = $Message.NormalOff

  if ($Bombastic)
  {
    $MsgOn = $Message.BombasticOn
    $MsgOff = $Message.BombasticOff
  }

  If ($WhatIfPreference -eq $true)
  {
    $Script:WhatIfPreference = $false
    Write-Host $MsgOff -ForegroundColor Red
  }
  else
  {
    $Script:WhatIfPreference = $true
    Write-Host $MsgOn -ForegroundColor Green
  }
}
