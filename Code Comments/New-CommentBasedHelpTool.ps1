#requires -Version 3.0

$HshTbl = [ordered]@{
  SYNOPSIS    = 'Describe purpose of "test" in 1-2 sentences.'
  DESCRIPTION = 'Add a more complete description of what the function does.'
  EXAMPLE     = 'Provied an example'
  NOTES       = 'Place additional notes here.'
  LINK        = 'URLs to related sites.  The first link is opened by Get-Help -Online test'
  INPUTS      = 'List of input types that are accepted by this function.'
  OUTPUTS     = 'List of output types produced by this function.'
}

foreach($key in $HshTbl.Keys.Clone())
{
  $response = Read-Host -Prompt $HshTbl[$key]
  if($response -eq '')
  {
    $response = 'N/A'
  }

  $HshTbl[$key] = $response
  }


$OutClip = (@'

    .SYNOPSIS
    {0}

    .DESCRIPTION
    {1}

    .EXAMPLE
    {2}

    .NOTES
    {3}

    .LINK
    {4}

    .INPUTS
    {5}

    .OUTPUTS
    {6}
'@ -f $HshTbl['SYNOPSIS'], $HshTbl['DESCRIPTION'], $HshTbl['EXAMPLE'], $HshTbl['NOTES'], $HshTbl['LINK'], $HshTbl['INPUTS'], $HshTbl['OUTPUTS'])
  
$OutClip | clip.exe
