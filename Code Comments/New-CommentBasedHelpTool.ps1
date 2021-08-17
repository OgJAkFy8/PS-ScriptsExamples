#!/usr/bin/env powershell
#requires -Version 3.0


if( -not (Get-Module -Name ITPS.OMCS.CodingFunctions))
{
  try
  {
    Import-Module -Name ITPS.OMCS.CodingFunctions
  }
  catch
  {
    Throw "Unable to import 'ITPS.OMCS.CodingFunctions' module"
  }
}
$ScriptName = Read-Host -Prompt ('Enter the file or script name')
$HshTbl = [ordered]@{
  SYNOPSIS    = ("SYNOPSIS - Describe purpose of '{0}' in 1-2 sentences" -f $ScriptName)
  DESCRIPTION = ("DESCRIPTION - Add a more complete description of what '{0}'  does" -f $ScriptName)
  EXAMPLE     = 'EXAMPLE - Provied an example '
  NOTES       = 'NOTES - Place additional notes here '
  LINK        = 'LINK - URLs to related sites.  The first link is opened by Get-Help -Online test'
  INPUTS      = 'INPUTS - List of input types that are accepted by this function'
  OUTPUTS     = 'OUTPUTS - List of output types produced by this function'
}

foreach($key in $HshTbl.Keys.Clone())
{
  $response = $null
  $response = Read-Host -Prompt $HshTbl[$key]
  if($response -eq '')
  {
    $response = 'N/A'
  }

  $HshTbl[$key] = $response
}


$OutClip = (@'

function {7}

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


'@ -f $HshTbl['SYNOPSIS'], $HshTbl['DESCRIPTION'], $HshTbl['EXAMPLE'], $HshTbl['NOTES'], $HshTbl['LINK'], $HshTbl['INPUTS'], $HshTbl['OUTPUTS'], ($ScriptName.Split('.')[0]))
  
New-Item -Path ('.\{0}' -f $ScriptName)
$OutClip | Out-File -FilePath $('.\{0}' -f $ScriptName) -Append
powershell_ise.exe -file $('.\{0}' -f $ScriptName)

<#
    $OutClip

    if($(Get-Versions).osversion -eq 'Windows')
    {
    $OutClip | & "$env:windir\system32\clip.exe"
    }
#>