Function Write-ToConsole {
  [CmdletBinding(DefaultParameterSetName = 'Set 1')]
  param
  (
    [Parameter(Mandatory)][string]$Details,
    [Parameter(ParameterSetName = 'Set 1')]
    [Parameter(ParameterSetName = 'Set 2')]
    [switch]$Green,

    [Parameter(ParameterSetName = 'Set 1')]
    [Parameter(ParameterSetName = 'Set 3')]
    [switch]$Red,

    [Parameter(ParameterSetName = 'Set 1')]
    [Parameter(ParameterSetName = 'Set 4')]
    [switch]$Yellow
  )
  $Color = 'Gray'
  if($Green){$Color = 'Green'}
  if($Red{$Color = 'Red'}
  if($Yellow{$Color = 'Yellow'}

  $LogDate = Get-Date -Format T
  Write-Host -Object ('{0} {1}' -f ($LogDate), $Details) -ForegroundColor $Color
}

