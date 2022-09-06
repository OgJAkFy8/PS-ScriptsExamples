function Uninstall-Hotfix 
{
  [cmdletbinding()]
  param(
    [String]$computername = $env:computername,
    [String] $HotfixID
  )            
  $hotfixes = (Get-WmiObject -ComputerName $computername -Class Win32_QuickFixEngineering).Hotfixid  #| Select-Object -Property hotfixid            
  if($hotfixes -match $HotfixID) 
  {
    Write-Verbose -Message 'Found the hotfix {0}' -f $HotfixID
    Write-Verbose -Message 'Uninstalling the hotfix'
    $UninstallString = ('cmd.exe /c wusa.exe /uninstall /KB:{0} /quiet /norestart' -f $($HotfixID.Replace('KB','')))
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
    Write-Verbose -Message ('Given hotfix({0}) not found' -f $HotfixID)
    return
  }
}

