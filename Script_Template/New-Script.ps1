#requires -Version 2.0 
<#
    .Synopsis
    Creates a new script using the template
    .DESCRIPTION
    Get
    .EXAMPLE
    Example of how to use this cmdlet
    .EXAMPLE
    Another example of how to use this cmdlet
#>
[CmdletBinding()]
param(
  [Parameter(Mandatory = $true,HelpMessage='Name of script in Verb-Noun format',Position = 0)][String]$scriptName,
  [Parameter(Mandatory = $false,Position = 1)][String]$scriptPath
)
if(-not (Get-Module -Name ITPS.OMCS.CodingFunctions))
{
  Import-Module -Name '.\ITPS.OMCS.CodingFunctions.psm1'
}

if($scriptName -notmatch 'ps1')
{
  $scriptName = ('{0}.ps1' -f $scriptName)
}
if(-not $scriptPath)
{
  $scriptPath = '.'
}
$fullScriptname = ('{0}\{1}' -f $scriptPath, $scriptName)

if(Test-Path -Path $fullScriptname)
{
  $scriptName = New-File -Filename $scriptName -Increment
  $fullScriptname = ('{0}\{1}' -f $scriptPath, $scriptName)
}


$scriptTemplate = Get-Content -Path .\Script-Template.ps1

$scriptTemplate | Set-Content -Path $fullScriptname

& "$PSHome\powershell_ise.exe" $fullScriptname


