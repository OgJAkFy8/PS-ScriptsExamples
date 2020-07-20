#requires -Version 3.0 -Modules NetTCPIP
function Test-FiberSatellite
{
  [cmdletbinding(DefaultParameterSetName = 'Default')]
  param
  (
    [Parameter(Position = 0)]
    [String[]] $Sites = ('localhost', 'www.google.com', 'www.bing.com', 'www.cnn.com', 'www.yahoo.com'),
    [Parameter (ParameterSetName = 'Default')]
    [Switch]$Simple,
    [Parameter (ParameterSetName = 'Log')]
    [Switch]$Log,
    [Parameter (ParameterSetName = 'Log')]
    [String]$ReportFolder = "$env:temp\Reports\FiberSatellite\FiberSatellite.log"
  )
  
  $ReportList = [Collections.ArrayList]@()
  $RttTotal = $NotRight = 0
  $TotalResponses = $TotalSites = $Sites.Count
  $ReportFile = (('{0}\FiberSatellite.log' -f $ReportFolder))
  
  $OutputTable = @{
    Title  = "`nThe Ping-O-Matic Fiber Tester!"
    Green  = ' Round Trip Time is GOOD!'
    Yellow = ' Although not always the case this could indicate that you are on the backup fiber.'
    Red    = ' Although not always the case this could indicate that you are on the Satellite.'
    Report = ''
  }


  $job = Test-Connection -ComputerName $Sites -AsJob -Count 1 #-BufferSize 1024
  if ($job.JobStateInfo.State -ne "Running") {$Results = Receive-Job $job}

  $TTL = @{
    'Cisco' = 254
    'HP' = 255
    'Linux' = 64
    'Mac' = 64
    'Windows' = 128
  }
  
  $PingStat = @{}


  foreach ($Item in $Results){
    
    #Write-Host $Item.Address
    #$ResponseTime = [string]($item.ResponseTime)
    
    #if((-not $ResponseTime)){$ResponseTime = 1000}
    
    $PingStat[$Item.Address] = [string]($item.ResponseTime)
   
  }
  $pintreport = Import-Csv C:\temp\Reports\Ping2.csv
  
    $PingStat | ForEach-Object -Process {
      [pscustomobject]$_ } |     
    Export-Csv -Path C:\temp\Reports\Ping2.csv -NoTypeInformation -Force
  
  
  ######################
  
  
  
  ForEach ($Site in $Sites)  
  {
    $PingReply = Test-NetConnection -ComputerName $Site 
    if($PingReply.PingSucceeded -eq $true)
    {
      $RTT = $PingReply.PingReplyDetails.RoundtripTime
      $RttTotal = $RttTotal + $RTT
    
      if($RTT -eq 0)
      {
        $TotalResponses = $TotalResponses - 1
        $NotRight = $NotRight + 1
      }
      
      $OutputMessage = ('{0} - RoundTripTime is {1} ms.' -f $PingReply.Computername, $RTT)
      Write-Verbose  -Message $OutputMessage
      $ReportList += $OutputMessage
    }
    Else
    {
      $TotalResponses = $TotalResponses - 1
    }
  }

  $RTT = $RttTotal/$TotalResponses
  $TimeStamp = Get-Date -Format G 

  $OutputTable.Report = ('{1} - {3} tested {0} remote sites and {2} responded. The average response time: {4}ms' -f $TotalSites, $TimeStamp, $TotalResponses, $env:USERNAME, [int]$RTT) 
 
  Write-Verbose -Message $OutputTable.Report
  #$OutputTable.Report | Out-File $ReportFile
  
  If(-Not $Log)
  {
    Write-Output -InputObject $OutputTable.Report
  }

  if((-not $Simple) -and (-not $Log))
  {
    Write-Output -InputObject $OutputTable.Title 
    if($RTT -gt 380)
    {
      Write-Host -Object ('  ') -BackgroundColor Red -ForegroundColor White -NoNewline
      Write-Output -InputObject ($OutputTable.Red)
    }
    ElseIf($RTT -gt 90)
    {
      Write-Host -Object ('  ') -BackgroundColor Yellow -ForegroundColor White -NoNewline
      Write-Output -InputObject ($OutputTable.Yellow)
    }
    ElseIf($RTT -gt 1)
    {
      Write-Host -Object ('  ') -BackgroundColor Green -ForegroundColor White -NoNewline
      Write-Output -InputObject ($OutputTable.Green) 
    }
    if($NotRight -gt 0)
    {
      Write-Output -InputObject ('{0} Responded with 0 ms.  If you tested the "Localhost" one would be expected.' -f $NotRight)
    }
  }
  If($Log)
  {
    If(-not (Test-Path -Path $ReportFolder))
    {
      New-Item -Path $ReportFolder -ItemType Directory
    }
    $OutputTable.Report | Out-File -FilePath $ReportFile -Append
    $ReportList | Out-File -FilePath $ReportFile -Append
    ('-' * 30) | Out-File -FilePath $ReportFile -Append
    Write-Output -InputObject ('You can find the full report at: {0}' -f $ReportFile)
    Start-Process -FilePath notepad -ArgumentList $ReportFile
  }
}


# For Testing:
#Test-FiberSatellite
#Test-FiberSatellite -Sites localhost,'yahoo.com'
#Test-FiberSatellite -Sites localhost,'yahoo.com' -Simple 
#Test-FiberSatellite -Sites localhost,'yahoo.com' -Simple -Verbose
#Test-FiberSatellite -Log -ReportFolder C:\Temp
#Test-FiberSatellite -Log -Verbose


