function Get-GpoInfo
{
  <#
      .SYNOPSIS
      Short Description
      .DESCRIPTION
      Detailed Description
      .EXAMPLE
      Get-Something
      explains how to use the command
      can be multiple lines
      .EXAMPLE
      Get-Something
      another example
      can have as many examples as you like
  #>
  [CmdletBinding()]
  param
  (
    [Parameter(Position = 0)]
    [string]
    $OutputPath = "$env:HOMEDRIVE\Temp\GPOReports\",
    [Parameter(Position = 1)]
    [string]
    $FileName = 'GPO-Report',  
    [Parameter(Mandatory,HelpMessage = 'sales.contoso.com', Position = 2)]
    [string]
    $Domain,
    [Parameter(Mandatory,HelpMessage = 'NETBIOS name of Domain Controller', Position = 3)]
    [string]
    $ServerName,
    [Parameter(Mandatory,HelpMessage = 'html or xml', Position = 4)]
    [ValidatePattern('html','xml')]
    [string]
    $ReportType 
  )
  
  $SplatGpoReport = @{
    All        = $true
    Domain     = $Domain
    Server     = $ServerName
    ReportType = $ReportType
    Path       = (('{0}\{1}' -f $OutputPath, $FileName))
  }
  # Get HTML/XML report of all GPO's
  Get-GPO -All | ForEach-Object -Process {
    $_.GenerateReport($ReportType) | 
    Out-File -FilePath ('{2}\Temp\GPOReports\{0}.{1}' -f $_.DisplayName, $ReportType, $env:HOMEDRIVE)
  }

  Get-GPOReport @SplatGpoReport
}

