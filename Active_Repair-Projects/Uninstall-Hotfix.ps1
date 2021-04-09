## Not operational Might be a good start



#requires -Version 3.0
function Uninstall-Hotfix 
{
  <#
      .SYNOPSIS
      Describe purpose of "Uninstall-Hotfix" in 1-2 sentences.
  #>


  [cmdletbinding()]
  Param(
    [Parameter(Position=0)]
    [string] $computername = $env:computername,
    [Parameter(Mandatory,HelpMessage='Enter the Hotfix with or without "KB"')]
    [string] $HotfixID = 'KB4516058'
  )            


  $hotfixes = Get-WmiObject -ComputerName $computername -Class Win32_QuickFixEngineering | Select-Object -ExpandProperty hotfixid 

  if($hotfixes -match $HotfixID) 
  {
    $HotfixID = $HotfixID.Replace('KB','')
    Write-Output -InputObject ('Found the hotfix {0}' -f $HotfixID) 
    
    Write-Verbose -Message 'Uninstalling the hotfix'
    $UninstallString = "cmd.exe /c wusa.exe /uninstall /KB:$HotfixID /quiet /norestart"
    $null = ([WMICLASS]"\\$computername\ROOT\CIMV2:win32_process").Create($UninstallString) 

    while (@(Get-Process -Name wusa -ComputerName $computername -ErrorAction SilentlyContinue).Count -ne 0) 
    {
      Start-Sleep -Seconds 3
      Write-Verbose -Message 'Waiting for update removal to finish ...'
    }
    Write-Verbose -Message ('Completed the uninstallation of {0}' -f $HotfixID)
  }
  else 
  {
   
    Write-Verbose "List of installed Hotfixes:"
    Write-Verbose $hotfixes

    Write-Output -InputObject ('Given hotfix({0}) not found' -f $HotfixID)
    return
  }
}
