$m = @'

function get-AdvancedFunction
{
  [CmdletBinding()]
  param(
    [Parameter(Mandatory,
        ValueFromPipeline,
    ValueFromPipelineByPropertyName)]
    [Alias('hostname')]
    [string[]]$computername,

    [switch]$namelog
  )
  BEGIN {}
  PROCESS {

    foreach ($computer in $computername)
    {
      Write-Verbose -Message $computer
    }

  }
  END {}
}


get-OurVMInfo -computername localhost -Verbose

'@
New-IseSnippet -Text $m -Title 'ks: get-AdvancedFunction' -Description 'Provides an example of an advaced function that uses parameters' -Author 'Knarr Studio'
