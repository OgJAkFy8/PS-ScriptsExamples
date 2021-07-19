#requires -Version 3.0
$ScriptName = Read-Host('Enter the file or script name ')
$HshTbl = [ordered]@{
  SYNOPSIS    = "SYNOPSIS - Describe purpose of '$ScriptName' in 1-2 sentences "
  DESCRIPTION = "DESCRIPTION - Add a more complete description of what '$ScriptName'  does "
  EXAMPLE     = 'EXAMPLE - Provied an example '
  NOTES       = 'NOTES - Place additional notes here '
  LINK        = 'LINK - URLs to related sites.  The first link is opened by Get-Help -Online test '
  INPUTS      = 'INPUTS - List of input types that are accepted by this function '
  OUTPUTS     = 'OUTPUTS - List of output types produced by this function '
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
  
Write-Host $OutClip
$OutClip | clip.exe
