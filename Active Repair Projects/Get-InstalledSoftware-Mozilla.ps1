
try
{
  function Test-SoftwareVersion
  {
    <#
        .SYNOPSIS
        Describe purpose of "Test-SoftwareVersion" is to ensure the version is at what you expect.  This is for the stand alone systems.

        .DESCRIPTION
        Add a more complete description of what the function does.

        .PARAMETER Software
        Either a full or partial name of the software you are testing.  
        Moz or Mozilla are both okay, but Moz might get some othersoftware

        .PARAMETER CurrentVersion
        The version that you want to test against.  This is most of the time the version you are installing.

        .EXAMPLE
        Test-SoftwareVersion -Software Value -CurrentVersion Value
    #>


    [CmdletBinding(SupportsShouldProcess = $true)]
    param
    (
      [Parameter(Mandatory,HelpMessage = 'At least part of the software name to test', Position = 0)]
      [String]$Software,
      [Parameter(Mandatory,HelpMessage = 'Current version of software to test against', Position = 1)]
      [String]$CurrentVersion
    )
    $SoftwarePackage = Get-Package | Where-Object -Property name -Match -Value $Software
    foreach($Package in $SoftwarePackage)
    {
      if($Package.version -lt $CurrentVersion)
      {
        Write-Host 'Update Needed for'$Package.Name': ' -NoNewline
        Write-Host 'Yes' -ForegroundColor red
      }
      if($Package.version -gt $CurrentVersion)
      {
        Write-Host 'Version'$Package.version'running. Update Needed for'$Package.Name': ' -NoNewline
        Write-Host 'No' -ForegroundColor green
      }
    }
  }
}
# NOTE: When you use a SPECIFIC catch block, exceptions thrown by -ErrorAction Stop MAY LACK
# some InvocationInfo details such as ScriptLineNumber.
# REMEDY: If that affects you, remove the SPECIFIC exception type [System.Management.Automation.RuntimeException] in the code below
# and use ONE generic catch block instead. Such a catch block then handles ALL error types, so you would need to
# add the logic to handle different error types differently by yourself.
catch [System.Management.Automation.RuntimeException]
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



# Easy way to loop a couple of tests
Test-SoftwareVersion -CurrentVersion 60 -Software Mozilla
Test-SoftwareVersion -CurrentVersion 2 -Software green

