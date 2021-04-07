$m = @'

For the whole script to require admin rights:
#Requires -RunAsAdministrator

If only some parts of the script need admin rights, then you can test at that point:
# Test if the script is "RunasAdminsitrator"
$asAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if ($asAdmin -ne $true){ Script }
else{
   Write-Host '*** Re-run as an administrator ******' -ForegroundColor Black -BackgroundColor Yellow
}
  
'@
New-IseSnippet -Text $m -Title 'ks: Test Admin Rights' -Description 'Test for Admin Rights for the whole script or just part.' -Author 'Knarr Studio'

