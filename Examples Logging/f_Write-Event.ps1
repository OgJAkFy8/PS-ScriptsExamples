Function f_Write-Event 
{
  <#
      .SYNOPSIS
      Write-Event function writes messages to the event log.
 
      .DESCRIPTION
      Write-Event function writes messages to the event log 
      after creating the logname and source if not already defined.
 
      .PARAMETER  $Message
      The message you want displayed in the event log body. 
      Required.
 
      .PARAMETER  $EventId
      The entryid number you wanted displayed in the event log. 
      Default is 0.
 
      .PARAMETER  $Source
      The source of the event log you wanted displayed in the event log. 
      Default is the PowerShell script name the function was invoked from.
 
      .PARAMETER  $LogName
      The log that you want the event loged in. Default is the Application log.
      If the Log and source pair do not exist on the machine this scirpt is 
      invoked on the pair will be created.
 
      .EXAMPLE
      PS C:\> Write-Event -Message "Process Started." -EntryId 0 -Information
 
      .EXAMPLE
      PS C:\> Write-Event "Process Started." -Information
 
      .EXAMPLE
      PS C:\> Write-Event "Process Failed." -EntryId 161 -Error
 
      .EXAMPLE
      PS C:\> Write-Event "Process Started."
 
      .INPUTS
      System.String,System.Int32,System.String,System.String,System.Switch,System.Switch
 
      .OUTPUTS
      None
 
      .NOTES
      Additional information about the function go here.
 
      .LINK
 
      http://jeffmurr.com/blog
 
  #>

  [CmdletBinding()]   
  param(
    [Parameter(Position = 0, Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [System.String]
    $Message,
 
    [Parameter(Position = 1, Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [System.Int32]
    $EventId = 0,
 
    [Parameter(Position = 2, Mandatory = $false)]
    [System.String]
    $Source = 'PowerShellScript',
 
    [Parameter(Position = 3, Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [System.String]
    $LogName = 'Application',
 
    [Switch]
    $Information,
 
    [Switch]
    $Warning,
 
    [Switch]
    $Error
  )
 
  $ErrorActionPreference = 'SilentlyContinue'
  if(!(Get-EventLog -LogName $LogName -Source $Source))
  {
    $ErrorActionPreference = 'Continue'
    try 
    {
      $null = New-EventLog -LogName $LogName -Source $Source
    }
    catch [System.Security.SecurityException] 
    {
      Write-Error -Message 'Error:  Run as elevated user.  Unable to write or read to event logs.'
    }
  }
 
  If ($Warning.IsPresent)
  {    
    try 
    {
      $null = Write-EventLog -LogName $LogName -Source $Source -EntryType 'Warning' -EventId $EventId -Message $Message
    }
    catch [System.Security.SecurityException] 
    {
      Write-Error -Message 'Error:  Run as elevated user.  Unable to write or read to event logs.'
    }
  }
  ElseIf ($Error.IsPresent) 
  {
    try 
    {
      $null = Write-EventLog -LogName $LogName -Source $Source -EntryType 'Error' -EventId $EventId -Message $Message
    }
    catch [System.Security.SecurityException] 
    {
      Write-Error -Message 'Error:  Run as elevated user.  Unable to write or read to event logs.'
    }   
  }
  Else 
  {
    try 
    {
      $null = Write-EventLog -LogName $LogName -Source $Source -EntryType 'Information' -EventId $EventId -Message $Message
    }
    catch [System.Security.SecurityException] 
    {
      Write-Error -Message 'Error:  Run as elevated user.  Unable to write or read to event logs.'
    }
  }
}
