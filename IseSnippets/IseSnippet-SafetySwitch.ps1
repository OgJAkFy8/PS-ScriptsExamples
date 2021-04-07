$m = @'

Function Set-SafetySwitch
{
  <#
      .SYNOPSIS
      Turns on "WhatIf" for the entire script
  #>
  If ($WhatIfPreference -eq $true)
  {
    $Script:WhatIfPreference = $false
    Write-Host 'Safety OFF' -ForegroundColor Red
  }
  else
  {
    $Script:WhatIfPreference = $true
    Write-Host 'Safety ON' -ForegroundColor Green
  }
}

'@
New-IseSnippet -Text $m -Title 'ks: Set-SafetySwitch' -Description 'Turns on "WhatIf" for the entire script' -Author 'Knarr Studio'
