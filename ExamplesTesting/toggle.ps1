$i=1;for(;$i -le 10;$i++){
$p = new-item -path . -name testfile$i.txt -itemtype "file" -WhatIf:$false
Get-ChildItem . | Format-Table Name | Out-File $p -WhatIf:$false
}


Function Private:Set-safety{
Do {
$SafetyToggle = [int](Read-Host "Toggle")
if ($SafetyToggle -eq 0){
    if($WhatIfPreference -eq $true){
    $WhatIfPreference = "False"
    Write-Host "Safety Off" -BackgroundColor Red
    }
Else{
    $WhatIfPreference ="True"
    Write-Host "Safety On" -BackgroundColor Green
    }
    }
    #cls
}While ($SafetyToggle -eq 0) }

Function private:Safety-Switch (){
  $COOPprocess
  $WhatIfPreference
  If ($COOPprocess -eq 0){    
    If ($WhatIfPreference -eq $true){
    $WhatIfPreference = $false}
    else{$WhatIfPreference = $true}
  }
  $COOPprocess
  return $WhatIfPreference
}