#requires -Version 1.0

function Set-DenyPermissions 
{
  [CmdletBinding()]
  param(
    [String]$FileName,
    [String]$UserName 
  )

  $Acl = Get-Acl -Path $FileName
  $AccessRule = New-Object  -TypeName system.security.accesscontrol.filesystemaccessrule -ArgumentList ("$UserName, ListDirectory, ReadAttributes, Allow") 
  $Acl.SetAccessRule($AccessRule)
  Start-Sleep -Seconds 4
  Set-Acl -Path $FileName -AclObject $Acl
}

function Set-ReadPermissions 
{
  [CmdletBinding()]
  param(
    [String]$FileName,
    [String]$UserName,
    [Switch]$Remove
  )

  $Acl = Get-Acl -Path $FileName

  $AccessRule = New-Object  -TypeName system.security.accesscontrol.filesystemaccessrule -ArgumentList ($UserName, 'ExecuteFile', 'Allow')
    
  $Acl.SetAccessRule($AccessRule)
  


  Start-Sleep -Seconds 4
  Set-Acl -Path $FileName -AclObject $Acl
}

function Remove-Permissions 
{
  [CmdletBinding()]
  param(
    [String]$FileName
  )

  $Acl = Get-Acl -Path $FileName
  Foreach ($AccessRule in $Acl) 
  {
    $Acl.RemoveAccessRule($AccessRule)
  }
  $Acl.RemoveAccessRule($AccessRule)
}
$AccessRule = New-Object  -TypeName system.security.accesscontrol.filesystemaccessrule -ArgumentList ('BUILTIN\Administrators', 'FullControl', 'ContainerInherit, ObjectInherit', 'Allow')
    
$Acl.SetAccessRule($AccessRule)

Set-Acl -Path $FileName -AclObject $Acl





# $Files = "C:\Windows\INF\usbstor.pnf","C:\Windows\INF\usbstor.inf",$filename = 'C:\DirectoryEditor'
$Files = 'C:\Temp\USBSTOR\TestACL.txt', 'C:\OCADirectory\Editor', 'C:\OCADirectory\Transporter'

Foreach($FileName in $Files)
{
  <#
      Editor - Allow / ReadWrite to the Editor Directory.
      Editor - Allow / Write to the Transporter Directory.
      Editor - Deny / Access to USBSTOR
      Transporter - Allow / Access to USBSTOR
      Transporter - Allow / ReadExecute to the Trasporter Directory
      Transporter - Deny / Access to Editor Directory
  #>

  Write-Verbose -Message 'Setting Directory Permissions'
  Set-DenyPermissions -fileName 'C:\OCADirectory\Transporter' -UserName 'Editor'
  Set-ReadPermissions -FileName 'C:\OCADirectory\Editor' -UserName 'Editor'
  Set-DenyPermissions -fileName 'C:\OCADirectory\Transporter' -UserName 'Transporter'
}

