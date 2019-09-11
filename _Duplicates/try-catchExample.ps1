
try
{
  $a = $env:USERNAME
$b = $env:COMPUTERNAME
Read-Host "Username:", $a
Read-Host "ComputerName:", $b
Write-Warning "$a on $b"
Write-Host "Press any key to exit ..."
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

}
# NOTE: When you use a SPECIFIC catch block, exceptions thrown by -ErrorAction Stop MAY LACK
# some InvocationInfo details such as ScriptLineNumber.
# REMEDY: If that affects you, remove the SPECIFIC exception type [System.NotImplementedException] in the code below
# and use ONE generic catch block instead. Such a catch block then handles ALL error types, so you would need to
# add the logic to handle different error types differently by yourself.
catch [System.NotImplementedException]
{
  # get error record
  [Management.Automation.ErrorRecord]$e = $_

  # retrieve information about runtime error
  $info = [PSCustomObject]@{
    Exception = $e.Exception.Message
    Reason    = $e.CategoryInfo.Reason
    Target    = $e.CategoryInfo.TargetName
    Script    = $e.InvocationInfo.ScriptName
    Line      = $e.InvocationInfo.ScriptLineNumber
    Column    = $e.InvocationInfo.OffsetInLine
  }
  
  # output information. Post-process collected info, and log info (optional)
  $info
}
