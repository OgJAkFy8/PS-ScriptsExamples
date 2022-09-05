function Get-MyCredential
{
  <#
      .SYNOPSIS
      Stores and retrieves credentials from a file. 
    
      .DESCRIPTION
      Stores your credentials in a file and retreives them when you need them.
      Allows you to speed up your scripts.  
      It looks at when your password was last reset and forces an update to the file if the dates don't match.  
      Because this only works with the specific user logged into a specific computer the name of the file will alway have both bits of information in it.
    
      .PARAMETER Reset
      Allows you to force a password change.

      .PARAMETER Path
      Path to the credential file, if not in current directory.

      .EXAMPLE
      Get-MyCredential

      .EXAMPLE
      Get-MyCredential -Reset -Path Value
      Allows you to change (reset) the password in the password file located at the path.  Then returns the credentials

      .NOTES
      Place additional notes here.

      .LINK
      'https://github.com/KnarrStudio/ITPS.OMCS.CodingFunctions/blob/master/Scripts/Get-MyCredential.ps1'

      .INPUTS
      String

      .OUTPUTS
      Object
  #>
  [CmdletBinding(SupportsShouldProcess, PositionalBinding = $false, ConfirmImpact = 'Medium',DefaultParameterSetName = 'Set 1',
  HelpUri = 'https://github.com/KnarrStudio/ITPS.OMCS.CodingFunctions/blob/master/Scripts/Get-MyCredential.ps1')]
  [Alias('gmc')]
  #[OutputType([Object])]
  param
  (  
    [Parameter(ParameterSetName = 'Set 2',Mandatory = $false,Position = 0)]
    [String]$UserName,
    [Parameter(ParameterSetName = 'Set 2',Mandatory = $false,Position = 1)]
    [ValidateSet('Domain', 'Local')]
    [String]$Type,
    [Parameter(ParameterSetName = 'Set 1',Mandatory = $false,Position = 2)]
    [Parameter(ParameterSetName = 'Set 2',Mandatory = $false,Position = 2)]
    [Switch]$Reset,
    [Parameter(ParameterSetName = 'Set 1',Mandatory = $false,Position = 1)]
    [Parameter(ParameterSetName = 'Set 2',Mandatory = $false,Position = 1)]
    [String]$Path = "$env:USERPROFILE\.PsCredentials"
  )
  Begin
  {
      function Script:Set-MyCredential
    {
      param
      (
        [Parameter(Mandatory = $true)]
        [string]$UserName,
        [Parameter(Mandatory = $true)]
        [string]$credentialPath
      )
      $credential = Get-Credential -Message 'Credentials to Save' -UserName $UserName
      $credential | Export-Clixml -Path $credentialPath -Force
    }  

    if(-not $UserName)
    {
      $UserName = ${env:USERNAME}
    }
    $ComputerName = ${env:COMPUTERNAME} # This is the computer it is running from

    if($Type -eq 'Domain')
    {
      $PasswordLastSet = (Get-AdUser -Name $UserName -ErrorAction Stop).PasswordLastSet #| Select-Object -Property PasswordLastSet
    }
    else        
    {
      $PasswordLastSet = (Get-LocalUser -Name $UserName -ErrorAction Stop).PasswordLastSet #| Select-Object -Property PasswordLastSet }
    }

    $credentialPath = ('{0}\myCred_{1}_{2}.xml' -f $Path, $($UserName.Split('@')[0]), $ComputerName)
  
  }
  Process
  {
    if(-not (Test-Path -Path $credentialPath))
    {
      Set-MyCredential -credentialPath $credentialPath -UserName $UserName
    }

    $LastWriteTime = (Get-ChildItem -Path $credentialPath).LastWriteTime

    if(($Reset -eq $true) -or ($LastWriteTime -lt $PasswordLastSet))
    {
      Set-MyCredential -credentialPath $credentialPath -UserName $UserName
    }

    $creds = Import-Clixml -Path $credentialPath
    
  }
  End
  {
    Return $creds
  }
}

Export-ModuleMember Get-MyCredential