#!/usr/bin/env powershell
#requires -Modules ActiveDirectory

<#

    Author: Erik
    Version: 1.0
    Purpose: Count the amount of different operating systems per organizational unit

#>


function Get-OperatingSystemsPerOU
{
  param
  (
    [Parameter(Mandatory, ValueFromPipeline, HelpMessage='Data to process')]
    $SelectedOU
  )

  function Get-UserSelectedOU
  {
    param
    (
      [Parameter(Mandatory, ValueFromPipeline, HelpMessage='Data to filter')]
      $InputObject
    )
    process
    {
      if ($InputObject.Name -match $SelectedOU)
      {
        $InputObject
      }
    }
  }
  
  function Get-ComputersInOU
  {
    param
    (
      [Parameter(Mandatory, ValueFromPipeline, HelpMessage='Data to process')]
      $InputObject

    )
    process
    {
    
        
      function Select-EnabledComputers
      {
        param
        (
          [Parameter(Mandatory, ValueFromPipeline, HelpMessage='Data to filter')]
          $InputObject
        )
        process
        {
          if ($InputObject.Enabled -eq $true)
          {
            $InputObject
          }
        }
      }
    
      $OU = $InputObject
      Get-ADComputer -SearchBase $OU.DistinguishedName -SearchScope SubTree -Properties * | Select-EnabledComputers
        
    }
  }
  
  
  $FilteredOu = Get-ADOrganizationalUnit -Filter * | Get-UserSelectedOU | Get-OperatingSystemsPerOU | Select-Object -Property *
  
  $FilteredOu | Out-GridView
  
  $null = $host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')


}
