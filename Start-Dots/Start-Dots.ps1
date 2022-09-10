function Start-Dots
{
  <#
      .SYNOPSIS
      Shows start dots
  #>
  if (-not (Test-Path -Path variable:global:psISE))
  {
    Clear-Host
    $i = 0 
    do 
    { 
      Start-Sleep -Milliseconds 100
      Write-Host -Object '.  ' -NoNewline -ForegroundColor ('Green', 'Red', 'Cyan', 'Yellow' | Get-Random)
      $i++
    }
    until (($i -gt 20) -or [System.Console]::KeyAvailable)  
    Write-Host -Object "`n"
  }
}

Start-Dots