$a = $env:USERNAME
$b = $env:COMPUTERNAME
Read-Host 'Username ',$a
Read-Host 'ComputerName ',$b
Write-Host 'Press any key to exit ...'
$x = $host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
