#requires -Version 2
function Get-Something
{
  param
  (
    $Name = $(
      Add-Type -AssemblyName Microsoft.VisualBasic
      [Microsoft.VisualBasic.Interaction]::InputBox('Enter Name','Name', $env:username)
    )
  )

  "You entered $Name."
}

Get-ADComputer -Filter 'Name -like "D114*"' -searchbase "OU=OMC South,OU=MASH Services,DC=rsrc,DC=osd,DC=mil"-Properties IPv4Address |where IPv4Address -like "214.18.207.*" | FT Name,DNSHostName,IPv4Address -A
$a=Get-ADComputer -Filter 'Name -like "D*"' -searchbase "OU=OMC South,OU=MASH Services,DC=rsrc,DC=osd,DC=mil"-Properties IPv4Address |where IPv4Address -like "214.18.*.*" | sort Name | FT Name

