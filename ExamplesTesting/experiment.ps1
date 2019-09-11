$a = $env:USERNAME
$b = $env:COMPUTERNAME
Write-Host "Username: ",$a
Write-Host "ComputerName: ",$b
Write-Host "Press any key to exit ..."
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")


Get-Service | ForEach-Object -Process { if ($_.Status -eq 'Running') { $_ } }

Unlock-ADAccount -Identity "CN=service-omc-south-digsend,OU=OMC South,OU=MASH Services,DC=rsrc,DC=osd,DC=mil"


$a = (Get-ADComputer -Filter 'Name -like "D*"' -searchbase "OU=OMC South,OU=MASH Services,DC=rsrc,DC=osd,DC=mil"-Properties IPv4Address |where IPv4Address -like "214.18.*.*" | FT Name -A)
$a | Out-File -filepath Workstations.txt
 .count

Set-Location "E:\Scripts\test"
$a = get-content Workstations.txt
$a | foreach {
    if (!(get-hotfix -id KB3114409 -computername $_)) {
    $_ | out-file -filepath Installed-KB3114409.txt}}


    add-content $_ -path Installed-KB3114409.txt 

    # User logged on to a physical box
$a = (Get-ADComputer -Filter 'Name -like "D*"' -searchbase "OU=OMC South,OU=MASH Services,DC=rsrc,DC=osd,DC=mil"-Properties IPv4Address |where IPv4Address -like "214.18.*.*" | FT Name -A)
Get-WmiObject -Class Win32_ComputerSystem | Select-object -ExpandProperty UserName


# Owners of explorer.exe processes (desktop is an Explorer process)
Get-WmiObject -Class Win32_Process -Filter 'Name="explorer.exe"'  |
  ForEach-Object {
    $owner = $_.GetOwner()
    '{0}\{1}' -f  $owner.Domain, $owner.User
  } | 
  Sort-Object -Unique



