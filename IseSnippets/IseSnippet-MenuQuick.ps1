
$m = (@'
#####   MENU TESTING #####
Clear-Host
$MenuTitle = 'Welcome to the Quick Menu'
$MenuList = (@"
--------------------------------------------------

       {0}

    0 = Exit
    1 = Option One
    2 = Option Two

--------------------------------------------------
"@  -f $MenuTitle )
Write-Host $MenuList -ForegroundColor Green
$answer = Read-Host -Prompt 'Please Make a Selection'  
#Quick Menu. 
while ($choice -ne 0)
{
  #Display the menu options function
  $choice = Read-Host -Prompt "`nSelection"
  switch ($choice)
  {
    0 
    {
      break
    } #Return to main menu
    1 
    {
      Get-Service
    }
    2 
    {
      Get-Printer
    }
    default 
    {
      Write-Host "`nPlease choose a selection." -foregroundcolor red
    }
  }
}
'@ )

New-IseSnippet -Text $m -Title 'ks: Menu - Quick' -Description 'A quick menu.' -Author 'Knarr Studio' -Force

