function Get-CurrentLineNumber
{
  <#
      .SYNOPSIS
      A quick way to write where in the code you are

      .EXAMPLE
      Write-Verbose  -Message ('{0}' -f $(Get-CurrentLineNumber -MsgNum 1 ))

      .NOTE
      1 = 'Set Variable'
      2 = 'Set Switch Variable'
      3 = 'Set Path/FileName'
      4 = 'Start Function'
      5 = 'Start Loop'
      6 = 'End Loop'
      7 = 'Write Data'
      99 = 'Current line number'
  #>
  param
  (
    [Parameter(Mandatory,HelpMessage = 'Add help message for user', Position = 0)]
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

#   Write-Verbose  -Message ('{0} {1}' -f $(Get-CurrentLineNumber -MsgNum 7 ),'') 

