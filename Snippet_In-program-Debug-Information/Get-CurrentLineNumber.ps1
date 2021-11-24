#requires -Version 3.0

function Get-CurrentLineNumber
{
  <#
    .SYNOPSIS
    Add-In to aid troubleshooting. A quick way to mark sections in the code.  
    This is a relitive location, so running thirty lines from the middle of your 1000 line code is only going to give you 0-30 as a line number.  Not 490-520 

    .PARAMETER MsgNum
    Selects the message to be displayed.
    1 = 'Set Variable'
    2 = 'Set Switch Variable'
    3 = 'Set Path/FileName'
    4 = 'Start Function'
    5 = 'Start Loop'
    6 = 'End Loop'
    7 = 'Write Data'
    99 = 'Current line number'


    .EXAMPLE
    Write-Verbose  -Message ('{0} {1}' -f $(Get-CurrentLineNumber -MsgNum 7 ),'') 
    
    Output:
    Line 23:  Write Data

    .NOTES
    Get-CurrentLineNumber must be accessed using the full script or it will only give you Line #1.  
  #>


  param
  (
    [Parameter(Mandatory=$true,HelpMessage='See "get-help Get-CurrentLineNumber" for different options',Position = 0)]
    [int]$MsgNum
  )
  $VerboseMsg = @{
    1 = 'Set Variable'
    2 = 'Set Switch Variable'
    3 = 'Set Path/FileName'
    4 = 'Start Function'
    5 = 'Start Loop'
    6 = 'End Loop'
    7 = 'Write Data'
    99 = 'Current line number'
  }
  if($MsgNum -gt $VerboseMsg.Count)
  {
    $MsgNum = 99
  }#$VerboseMsg.Count}
  'Line {0}:  {1}' -f $MyInvocation.ScriptLineNumber, $($VerboseMsg.$MsgNum)
} 
