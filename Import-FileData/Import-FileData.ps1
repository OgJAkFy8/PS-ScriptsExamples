#!/usr/bin/env powershell
$fileName = "$env:TMP/Example.csv"
#Get-Process | Select-Object -Last 10 | Export-Csv -Path $fileName

function Import-FileData
{
  <#
    .SYNOPSIS
    A function that will help import files

    .DESCRIPTION
    Add a more complete description of what the function does.

    .PARAMETER fileName
    Filename and path of the file you need to import data from

    .PARAMETER FileType
    File type to be imported, but really how you want it to be handled.  i.e.
    Basically how you want to manage the import.  In otherwords, a 'txt' file could be imported as a csv.

    .EXAMPLE
    Import-FileData -fileName Value -FileType Value
    
  #>


  param(
    [Parameter(Mandatory,HelpMessage = 'Name of file to be imported.')]
    [String]$fileName,
    [Parameter(Mandatory,HelpMessage = 'File type to be imported, but really how you want it to be handled.  ie txt could be a csv')]
    [ValidateSet('csv','txt','json')]
    [String]$FileType
  )
  
  switch ($FileType)
  {
    'csv'    {
      $importdata = Import-Csv -Path $fileName
    }
    'txt'    {
      $importdata = Get-Content -Path $fileName -Raw
    }  
    'json'   {
      $importdata = Get-Content -Path .\config.json
    }
    default    {
      $importdata = $null
    }
  }
  return $importdata
}
  

