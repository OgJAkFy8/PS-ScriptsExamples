#requires -Version 1.0

function Verb-Noun
{
  [CmdletBinding(SupportsShouldProcess = $true,ConfirmImpact = 'Low',DefaultParameterSetName = 'Default')]

  Param
  ([Parameter(
        Mandatory = $false,
        Position = 0,
        ParameterSetName = 'Default'
    )]
    [Alias('session')]
    [ValidateSet('All','User','Default')]
    $SessionType = 'All',
    $test
  )


  DynamicParam {
    if ($SessionType -eq 'User') 
    {
      $UserSessionAttribute = New-Object -TypeName System.Management.Automation.ParameterAttribute
      $UserSessionAttribute.Position = 1
      $UserSessionAttribute.Mandatory = $true
      $UserSessionAttribute.HelpMessage = 'Enter Session Name'
      $UserSessionCollection = New-Object -TypeName System.Collections.ObjectModel.Collection[System.Attribute]
      $UserSessionCollection.Add($UserSessionAttribute)
      $UserSession = New-Object -TypeName System.Management.Automation.RuntimeDefinedParameter -ArgumentList ('SessionName', [String], $UserSessionCollection)
      $paramDictionary = New-Object -TypeName System.Management.Automation.RuntimeDefinedParameterDictionary
      $paramDictionary.Add('SessionName', $UserSession)
      return $paramDictionary
    }
  }



  Begin
  {
    $session = $PSBoundParameters.SessionName
    $HkcuPuttyReg = 'HKCU:\Software\Simontatham\PuTTY\Sessions'
    $PuTTYSessions = Get-ChildItem -Path $HkcuPuttyReg -Name
    if($UserSession)
    {
      if ($PuTTYSessions -notcontains $session)
      {
        Write-Error 'Not a session name.  Try Using the - SessionType "All"' -ErrorAction Stop
      }
    }
  }
  Process
  {
  }
  End
  {
  }
}

Verb-Noun -SessionType All
 
Verb-Noun -SessionType User