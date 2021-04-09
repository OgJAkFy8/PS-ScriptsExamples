function Write-ToEventLog
{
  [cmdletbinding()]
  param(  
    [Parameter(Mandatory = $false,ValueFromPipelineByPropertyName)]
    [String]$LogName,
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [String]$Source,
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [int]$EventId,
    [Parameter(ValueFromPipelineByPropertyName)]
    [Diagnostics.EventLogEntryType]$EntryType,
    [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
    [String]$Message,
    [Parameter(ValueFromPipelineByPropertyName)]
    [Int16]$Category,
    [Parameter(ValueFromPipelineByPropertyName)]
    [String]$ComputerName,
    [Parameter(ValueFromPipelineByPropertyName)]
    [Byte[]]$RawData,   
    [Switch]$Force 
  )

  begin
  {
    if($Force)
    {
      if (-not ([Diagnostics.EventLog]::Exists($LogName) -and [Diagnostics.EventLog]::SourceExists($Source))) 
      {
        New-EventLog -LogName $LogName -Source $Source
      }
    }
  }
  process 
  {
    $EventLogSplat = @{
      LogName = $LogName
      Source  = $Source
      EventId = $EventId
    }

    if($EntryType) 
    {
      $EventLogSplat.Add('EntryType', $EntryType)
    }
    if($Message) 
    {
      $EventLogSplat.Add('Message', $Message)
    }
    if($Category) 
    {
      $EventLogSplat.Add('Category', $Category)
    }
    if($ComputerName) 
    {
      $EventLogSplat.Add('ComputerName', $ComputerName)
    }
    if($null -ne $RawData) 
    {
      $EventLogSplat.Add('RawData', $RawData)
    }

    #since your parameters are named the same way as Write-EventLog parameters, and you use cmdlet binding
    #you might get away with just specifying @PSBoundParameters
    Write-EventLog @EventLogSplat 
  }
}

Write-ToEventLog -LogName 'PS Test Log' -Source 'My Script' -EntryType Error -EventId 300 -Message 'This is a test message.' -Force

