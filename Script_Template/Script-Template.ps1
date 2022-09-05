#requires -Version 2.0 
<#
    .Synopsis
    This is a simple script template
    .DESCRIPTION
    Long description
    .EXAMPLE
    Example of how to use this cmdlet
    .EXAMPLE
    Another example of how to use this cmdlet
#>

[CmdletBinding()]
Param
(
  # Output filename
  [Parameter(Mandatory = $false,ValueFromPipelineByPropertyName = $true)]
  [String]$OutputFile
)

if(-not (Get-Module -Name ITPS.OMCS.CodingFunctions))
{
  Import-Module -Name '.\ITPS.OMCS.CodingFunctions.psm1'
}
if($OutputFile)
{
  $OutputFile = New-File -Filename $OutputFile -Increment -Tag $(Get-Date -UFormat %j)
}



