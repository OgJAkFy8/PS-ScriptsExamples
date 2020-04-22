$a = $env:USERNAME
$b = $env:COMPUTERNAME
$r = Read-Host -Prompt 'Username ', $a
$t = Read-Host -Prompt 'ComputerName ', $b
Write-Host -Message 'Press any key to exit ...'
$null = $host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
$r
$t
