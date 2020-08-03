function Test-AuthentationServer
{
  try
  {
    # Check if computer is connected to domain network
    [void]::([System.DirectoryServices.ActiveDirectory.Domain]::GetComputerDomain())
    Write-Output -InputObject ('Authentication Server: {0}' -f $env:LOGONSERVER)
  }
  catch
  {
    Write-Output -InputObject ('Authentication Server: Not Available') 
    Write-Output -InputObject ('Local Workstation: {0}' -f $env:COMPUTERNAME)
  }
}
    