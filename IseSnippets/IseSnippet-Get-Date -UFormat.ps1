$m = @'

    [Parameter(Mandatory = $False,Position = 2,HelpMessage = 'Formatting Choice 1 to 4')]
    [ValidateRange(1,5)]
    [int]$StampFormat = 1
  )
  $Uformat = '%y', '%y%m%d%H%M', '%Y%m%d', '%j%H%M%S', '%y-%m-%d_%H.%M'
  $DateStamp = Get-Date -UFormat $Uformat[$StampFormat]
  if($StampFormat -eq 5)
  {
    $DateStamp = Get-Date -Format o | ForEach-Object -Process {
      $_ -replace ':', '.'
    }
  }
  
'@
New-IseSnippet -Text $m -Title 'ks: Get-Date -UFormat' -Description 'Setting up a datestamp in parameters' -Author 'Knarr Studio'
