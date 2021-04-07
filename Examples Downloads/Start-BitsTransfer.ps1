
Start-BitsTransfer

#If you haven't heard of BITS before, check this out. BITS is primarily designed for asynchronous file downloads, but works perfectly fine synchronously too (assuming you have BITS enabled).

$url = "http://mirror.internode.on.net/pub/test/10meg.test"
$output = "$PSScriptRoot\10meg.test"
$start_time = Get-Date

Import-Module BitsTransfer
Start-BitsTransfer -Source $url -Destination $output
#OR
Start-BitsTransfer -Source $url -Destination $output -Asynchronous

Write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"

