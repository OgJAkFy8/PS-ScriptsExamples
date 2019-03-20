#requires -Version 2 -Modules ActiveDirectory

Get-ADOrganizationalUnit -Filter 'Name -like "OMC South*"' | 
  ForEach-Object {
    $OU = $_
    Get-ADComputer -Filter * -SearchBase $OU.DistinguishedName -SearchScope SubTree -Properties Enabled, OperatingSystem, Name | Where-Object { $_.Enabled -eq $true } | Group-Object -Property OperatingSystem -NoElement | Select-Object -Property Count, Name
    } | ft 
  Out-GridView
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")


