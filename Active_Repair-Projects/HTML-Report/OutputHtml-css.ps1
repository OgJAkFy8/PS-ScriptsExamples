[CmdletBinding()]
param
(
  [string]$Title = 'Title',
  [String[]]$Systems = ('Generikstorage', '192.168.1.3', '192.168.1.10', '192.168.1.11'),
  [string]$HtmlReport = '.\ADReport.htm',
  [string]$TitleColor = 'Red',
  [string]$LineColor = 'Yellow',
  [string]$MenuItemColor = 'Cyan'
)
Begin {
  # Set Variables
  $null = 1
  $null = "`t"

  $HtmlTableHeaderSplat = @{
    HtmlReport  = $HtmlReport
    ReportTitle = 'HTML Report'
    ResultTitle = 'Identity'
    TestTitle   = 'PingStatus'
  }
  $OpenHtmlTable = @'
<tbody>
'@
  $CloseHtmlTable = @'
</tbody>
</table>
</body>
</html>
'@


  if(-not (Test-Path -Path $HtmlReport))
  {
    New-Item -Path $HtmlReport -ItemType file -Force
  }
  
  function New-HtmlTableHeader
  {
    <#
        .SYNOPSIS
        Adds a new header row to the HTML file

    #>
    param
    (
      [Parameter(Mandatory,HelpMessage='Report Name', Position = 0)]
      [string]
      $HtmlReport,
      [Parameter(Position = 1)]
      [string]$ReportTitle = 'HTML Report',
      [Parameter(Position = 2)]
      [string]
      $ResultTitle = 'Identity',
      [Parameter(Position = 3)]
      [string]
      $TestTitle = 'PingStatus'
    )
    $reportHeader = (@'
<thead>
<tr>
<th>{0}</th>
<th>{1}</th>
<th>{2}</th>
</tr>
</thead>
'@ -f $ReportTitle, $ResultTitle, $TestTitle)
    Add-Content -Path $HtmlReport -Value $reportHeader
  }
  function New-HtmlTableRow
  {
    <#
        .SYNOPSIS
        Adds a new row to the HTML file.
    #>


    param
    (
      [Parameter(Mandatory,HelpMessage='Report Name', Position = 0)]
      [Object]$Report,
      [Parameter(Mandatory,HelpMessage='Column 1')][Object]$Column1,
      [Parameter(Mandatory,HelpMessage='Column 2')][Object]$Column2,
      [Parameter(Mandatory,HelpMessage='Column 3')][Object]$Column3,
      [Parameter(Mandatory,HelpMessage='Cell Color')][Object]$CellBckRndColor
    )
    $CellColor = $null
    if($CellBckRndColor)
    {
      $CellColor = (' bgcolor = {0}' -f $CellBckRndColor)
    }
    $ReportRow = (@'
<tr>
<td><B>{0}</B></td>
<td><B>{1}</B></td>
<td{3}> <B>{2}</B></td>
</tr>
'@ -f $Column1, $Column2, $Column3, $CellColor)
    Add-Content -Path $Report -Value $ReportRow
  }
} 
Process {
  Get-Content -Path .\CssHeader.txt | Out-File -FilePath $HtmlReport -Force
  New-HtmlTableHeader @HtmlTableHeaderSplat
  Add-Content -Path $HtmlReport -Value $OpenHtmlTable
  foreach ($System in $Systems)
  {
    $NewRowSplat = @{
      Report  = $HtmlReport
      Column1 = $System
      Column2 = $(Get-Date)
    }
    $PingResults = Test-NetConnection -ComputerName $System -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
    $Column2 = $PingResults.PingReplyDetails.RoundtripTime
    $Column3         = $PingResults.PingReplyDetails.Status
    $CellBckRndColor = $(if($Column3 -eq 'Success')
      {
        'Orange'
      }
      else
      {
        'Red'
      }
    )
    New-HtmlTableRow @NewRowSplat -Column3 $Column3 -CellBckRndColor $CellBckRndColor
  }
}
End
{Add-Content -Path $HtmlReport  -Value $CloseHtmlTable
}
		