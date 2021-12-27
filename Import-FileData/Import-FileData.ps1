
$fileName = "$env:TMP/Example.csv"
#Get-Process | Select-Object -Last 10 | Export-Csv -Path $fileName

function Import-FileData
{
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
  

