# PowerShell testbed.  Example of the -f format output
$EventVwr = Get-EventLog -List
foreach ($Log in $EventVwr) 
{
  '{0,-28} {1,-20} {2,-8}' -f $Log.log, $Log.OverflowAction, $Log.MaximumKilobytes
}

Write-Host "`nInformation to be used to create the COOPs:`n " -foregroundcolor black -backgroundcolor yellow #
Write-Host '=============================' -foregroundcolor Yellow
Write-Host 'Writing to: '$DataStoreStore -foregroundcolor Yellow
Write-Host 'On VM Host: '$VMHostIP -foregroundcolor Yellow
Write-Host 'Example of COOP file name: '$COOPPrefix$($VMServer.Name[1]) -foregroundcolor Yellow
Write-Host -Separator `n 

#Set "$OkADD" to "N" and confirm addition of COOPs
$OkADD = 'N'
$OkADD = Read-Host -Prompt "Preparing to Create ALL New COOP servers with information above. `nIs this Okay? Y,S,[N] "



 	
$r = Get-LocalGroup
Write-Host "`nInformation to be used to create the COOPs: `n" -foregroundcolor black -backgroundcolor yellow #
'{0,-58} {1,-155}' -f 'Name', 'description'
foreach($t in $r)
{
  '{0,-58} {1,-155}' -f $t.Name, $t.description
}


$split = Get-Content -Path $env:HOMEDRIVE\temp\services.txt

#-----------------------------

foreach ($line in $split) 
{
  #append some space after the line
  $params = @{
    Object = ' '
  }
 
  Write-Host ('{0} ' -f $line) -NoNewline
  #look at the line and add a parameter based on the results
  #of a regular expression match
  switch -Regex ($line) {
    'Stopped' 
    {
      $params.BackgroundColor = 'Red' 
    }
    'Running' 
    {
      $params.BackgroundColor = 'Green' 
    }
    'Pending' 
    {
      $params.BackgroundColor = 'Magenta' 
    }
    'Paused' 
    {
      $params.BackgroundColor = 'Yellow' 
    }
  }
  #write the line with the splatted parameters
  Write-Host @params
} #close foreach 

#-----------------

foreach ($line in $split) 
{
  $params = @{
    Object = $line
  }
 
  switch -Regex ($line) {
    'Stopped' 
    {
      $params.BackgroundColor = 'Red'
    }
    'Running' 
    {
      $params.BackgroundColor = 'DarkGreen'
    }
    'Pending' 
    {
      $params.BackgroundColor = 'Magenta'
    }
    'Paused' 
    {
      $params.BackgroundColor = 'Yellow'
    }
  }
 
  Write-Host @params
}

[regex]$rx = ([enum]::GetNames([System.ServiceProcess.ServiceControllerStatus])) -join '|'


foreach ($line in $split) 
{
  Write-Host ('Line {0}' -f $line)
  $m = $rx.match($line)
  #only process if there is a match
  if ($m.success) 
  {
    #get the point in the string where the match starts
    $i = $m.Index
    #display the line from start up to the match
    $line.Substring(0,$i) | Write-Host -NoNewline
    #select a foreground color based on matching status. Default should never be reached
    switch -Regex ($m.value) {
      'Stopped' 
      {
        $fg = 'Red' 
      }
      'Running' 
      {
        $fg = 'Green' 
      }
      'Pending' 
      {
        $fg = 'Magenta' 
      }
      'Paused' 
      {
        $fg = 'Yellow' 
      }
      Default 
      {
        Write-Warning -Message 'Somehow there is an unexpected status' 
      }
    }
    $line.substring($i) | Write-Host -ForegroundColor $fg
  }
  else 
  {
    #just write the line as is if no match
    Write-Host $line
  }
} #close foreach

$j = 'ActivID Shared Store Service   ActivID Shared Store Service      Running'
