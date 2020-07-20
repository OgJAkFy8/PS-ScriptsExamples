

$DateStamp = Get-Date -Format G # "G" (general date / long time; standard format string)
#$TimeStamp = Get-Date -Format s # "s" (sortable date/time; standard format string)
$Sites = @('localhost', 'www.google.com', 'www.bing.com', 'www.cnn.com', 'www.yahoo.com', '192.168.1.3')

#$columns = @()
$PingReport = 'C:\temp\Reports\Ping.csv'
$PingReportInput = Import-Csv -Path $PingReport
$ColumnNames = ($PingReportInput[0].psobject.Properties).name

$PingStat = [Ordered]@{
  'DateStamp' = $DateStamp
}

# Add any new sites to the report file
foreach($site in $Sites)
{
  Write-Verbose -Message ('1. {0}' -f $site)
  if(! $ColumnNames.contains($site))
  {
    Write-Verbose -Message ('2. {0}' -f $site)
    $PingReportInput | Add-Member -MemberType NoteProperty -Name $site -Value $null -Force
    $PingReportInput  | Export-Csv -Path $PingReport -NoTypeInformation
  }
}

# Ping the Sites  
$j=2
for($i=2;$i -lt 1025;($i=[math]::Pow(2,$j++))){
$Results  = Test-Connection -ComputerName $Sites -Count 1 -BufferSize $i
#$Pingjob = Test-Connection -ComputerName $Sites -AsJob -Count 1 #-BufferSize 1024
#Wait-Job -Job $Pingjob
#$Results = Receive-Job -Job $Pingjob


# Move the results to the hashtable
foreach ($Item in $Results)
{ 
  $Target = $Item.Address
  $TimeMS = $Item.ResponseTime
  $PingStat[$Target] = [string]$TimeMS
}

# Export the hashtable to the file
$PingStat |
ForEach-Object -Process {
  [pscustomobject]$_
} |     
Export-Csv -Path $PingReport -NoTypeInformation -Force -Append

}

