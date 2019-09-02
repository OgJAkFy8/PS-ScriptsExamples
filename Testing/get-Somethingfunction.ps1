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
