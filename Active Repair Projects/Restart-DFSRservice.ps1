#requires -Version 2.0
function Restart-DFSRservice
{
  <#
      .SYNOPSIS
      Check to see if DFSR service is running on the FS02 server and stops it for restarting the server.
      Great for rebooting the server without having to log into the server to stop the service.

      .DESCRIPTION
      Check to see if DFSR service is running on the FS02 server and stops it for restarting the server.
      Great for rebooting the server without having to log into the server to stop the service.

      .PARAMETER ServerName
      Name of the server that is running DFSR

      .EXAMPLE
      Restart-DFSRservice -ServerName Value
      Describe what this call does

  #>

  param
  (
    [Parameter(Position = 0)]
    [string]$ServerName = 'FileServerName'
  )
  
  BEGIN{

    $ServiceStatus = 'Running'
    $ServiceName = 'DFSR'
    $UserAnswer = 'N'
  }
  PROCESS{ 
    $SelectedService = Get-Service -ComputerName $ServerName -Name $ServiceName #-DependentServices
    if ($SelectedService.Status -eq 'Stopped')
    {
      Write-Host -Object 'DFS Replication Service is Off.... '
      $UserAnswer = Read-Host -Prompt 'Do you want to start it? [N]'
      if($UserAnswer -eq 'Y')
      {
        Write-Verbose -Message 'Starting Service...'
        Set-Service -ComputerName $ServerName -Name $ServiceName-Status -ComputerName $ServiceStatus -StartupType Automatic
      }
    }
  
    if ($SelectedService.Status -eq $ServiceStatus)
    {
      Write-Host -Object 'DFS Replication Service is On....'
      $UserAnswer = Read-Host -Prompt 'Do you want to stop it? [N]'
      if($UserAnswer -eq 'Y')
      {
        Write-Verbose -Message 'Stopping Service...'
        Get-Service -ComputerName $ServerName -Name $ServiceName | Stop-Service -Force
      }
    }
    Get-Service -ComputerName $ServerName -Name $ServiceName |   Select-Object -Property Status, Name
  }
  END
  {}
}



