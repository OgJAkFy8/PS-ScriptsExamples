#!/usr/bin/env powershell
#requires -Version 2.0
function Get-Versions
{
  <#
      .SYNOPSIS
      A way to get the OS version you are running
  #>
  [CmdletBinding()]
  param
  ([Parameter(Mandatory = $false, Position = 0)]$input
  )
  [String]$MagMinVer = '{0}.{1}'
  [Float]$PsVersion = ($MagMinVer -f [int]($psversiontable.PSVersion).Major, [int]($psversiontable.PSVersion).Minor)
  if($PsVersion  -ge 6)
  {
    if ($IsLinux) 
    {
      $OperatingSys = 'Linux'
    }
    elseif ($IsMacOS) 
    {
      $OperatingSys = 'macOS'
      $OsMac
    }
    elseif ($IsWindows) 
    {
      $OperatingSys = 'Windows'
    }
  }
  Else
  {
    Write-Output -InputObject ($MagMinVer -F ($(($psversiontable.PSVersion).Major), $(($psversiontable.PSVersion).Minor)))
    if($env:os)
    {
      $OperatingSys = 'Windows'
    }
  }
  $x = @{
    PSversion = $PsVersion
    OSVersion = $OperatingSys
  }
  return $x
}
Export-ModuleMember -Function Get-Versions
