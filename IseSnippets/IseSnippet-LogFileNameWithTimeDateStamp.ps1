$m = @'

  <#
      .SYNOPSIS
      Standardizing filenames with timestamps.  Does not create the file.  Just the file name.
      .DESCRIPTION
      Allows you to create a file with a time stamp.  You provide the base name, extension, date Uformat and it should do the rest. It should be setup to be a plug-n-play function that can be used in or out of another script.
      .PARAMETER baseNAME
      This is the primary name of the file.  It will be followed by the date/time stamp.
      .PARAMETER FileType
      The extension. ig. csv, txt, log
      .PARAMETER Stampformat
      1: YYMMDDhhmm  (Two digit year followed by two digit month day hours minutes.  This is good for the report that runs more than once a day)  -example 1703162145
      2: YYYYMMDD  (Four digit year two digit month day.  This is for the once a day report)  -example 20170316 
      3: jjjhhmmss (Julian day then hours minutes seconds.  Use this when you are testing, troubleshooting or creating.  You won't have to worry about overwrite or append errors)  -example 160214855 
      4: YY-MM-DD_hh.mm  (Two digit year-month-day _ Hours:Minutes)  -example 17-03-16_21.52
      5: yyyy-mm-ddThour.min.sec.milsec-tzOffset (Four digit year two digit month and day "T" starts the time section two digit hour minute seconds then milliseconds finish with the offset from UTC -example 2019-04-24T07:23:51.3195398-04:00
      .EXAMPLE
      New-TimedStampFileName TestFile txt
      TestFile-2009110641.txt
      .EXAMPLE
      New-TimedStampFileName -baseNAME test -FileType txt -StampFormat 2
      test-20200911.txt
      .EXAMPLE
      New-TimedStampFileName test.txt -StampFormat 3
      test_255070418.txt
      .EXAMPLE
      New-TimedStampFileName -baseNAME TestFile -FileType txt -StampFormat 5
      TestFile-2020-09-11T06.36.40.2147602-04.00.txt
      .INPUTS
      String, String, Integer
      .OUTPUTS
      String
  #>

  function New-TimedStampFileName 
  {
  [cmdletbinding(DefaultParameterSetName = 'FileName')]
  param
  (
    [Parameter(Mandatory,Position = 0,HelpMessage = 'Prefix of file or log name',ParameterSetName = 'BaseName')]
    [String]$baseNAME,
    [Parameter(Mandatory,Position = 0,HelpMessage = 'Full file name',ParameterSetName = 'FileName')]
    [String]$FileName,
    [Parameter(Mandatory,Position = 1,HelpMessage = 'Extention of file.  txt, csv, log',ParameterSetName = 'BaseName')]
    [alias('Extension')]
    [String]$FileType,
    [Parameter(Mandatory = $False,Position = 2,HelpMessage = 'Formatting Choice 1 to 4')]
    [ValidateRange(1,5)]
    [int]$StampFormat = 1
  )
  $Uformat = '%y', '%y%m%d%H%M', '%Y%m%d', '%j%H%M%S', '%y-%m-%d_%H.%M'
  $DateStamp = Get-Date -UFormat $Uformat[$StampFormat]
  if($StampFormat -eq 5)
  {
    $DateStamp = Get-Date -Format o | ForEach-Object -Process {
      $_ -replace ':', '.'
    }
  }
  if($FileName)
  {
    [String]$($FileName.Replace('.',('_{0}.' -f $DateStamp)))
  }
  Else
  {
    ('{0}-{1}.{2}' -f $baseNAME, $DateStamp, $FileType)
  }
}
'@
New-IseSnippet -Text $m -Title 'ks: New-TimedStampFileName' -Description 'Standard filenames with timestamps.  Does not create the file.  Just the file name.' -Author 'Knarr Studio'

