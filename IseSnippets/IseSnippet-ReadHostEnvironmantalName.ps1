
$m = @'

$a = $env:USERNAME
$b = $env:COMPUTERNAME
$r = Read-Host -Prompt 'Username ', $a
$t = Read-Host -Prompt 'ComputerName ', $b
Write-Output 'Press any key to exit ...'
if(-not (Test-Path variable:global:psISE)){
    $null = $Host.UI.RawUI.ReadKey("NoEcho, IncludeKeyDown") #
    Write-output "This test prevents: Exception calling "ReadKey" error when running in Powershell ISE.  This is by design."
}
$r
$t
  
'@
New-IseSnippet -Text $m -Title 'ks: Read from Host' -Description 'User inputs with default values' -Author 'Knarr Studio'
