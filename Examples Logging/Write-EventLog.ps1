#region Come on man
throw "You're not supposed to hit F8"
#endregion"

function Write-EventLog
{
    [cmdletbinding()]
    param(  
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)][String]$LogName,
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)][String]$Source,
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)][int]$EventId,
        [Parameter(ValueFromPipelineByPropertyName)][Diagnostics.EventLogEntryType]$EntryType,
        [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)][String]$Message,
        [Parameter(ValueFromPipelineByPropertyName)][Int16]$Category,
        [Parameter(ValueFromPipelineByPropertyName)][String]$ComputerName,
        [Parameter(ValueFromPipelineByPropertyName)][Byte[]]$RawData,   
        [Switch]$Force 
    )

    begin
    {
        if($Force)
        {
            if (! ([Diagnostics.EventLog]::Exists($LogName) -and [Diagnostics.EventLog]::SourceExists($Source) )) 
            {
                New-EventLog -LogName $LogName -Source $Source 
            }
        }
    }
    process 
    {
        $params = @{
            #put mandatory params here directly
            LogName = $LogName
            Source = $Source
            EventId = $EventId
        }
        if($EntryType) { $params.Add('EntryType', $EntryType) }
        if($Message) { $params.Add('Message', $Message) }
        if($Category) {$params.Add('Category', $Category) }
        if($ComputerName) { $params.Add('ComputerName', $ComputerName) }
        if($null -ne $RawData) { $params.Add('RawData', $RawData) }

        #since your parameters are named the same way as Write-EventLog parameters, and you use cmdlet binding
        #you might get away with just specifying @PSBoundParameters
        Write-EventLog @params 
    }
}

Write-EventLog -LogName 'PS Test Log' -Source 'My Script' -EntryType Information -EventID 100 -Message 'This is a test message.'



$Script:e_logname = 'PS Test Log' 
$Script:e_source = 'DeleteFilesOlder'


function f_Event{
    #Used to ease the writing events to the log.
    # e_logname and e_source are defined in the User Settings
    
  param
  (
    [Parameter(Mandatory=$true)]
    $e_message,

    [Parameter(Mandatory=$true)]
    [Object]$e_id,

    [Parameter(Mandatory=$true)]
    [Object]$e_type
  )
if($e_type -eq $null){$e_type = 'Information'}
    Write-EventLog -LogName $e_logname -Source $e_source -EntryType $e_type -EventID $e_id -Message $e_message
    }


