Function Show-DynamicMenu
{
  <#
      .SYNOPSIS
      Creates a menu of folders or files

      .DESCRIPTION
      Looks at the folder shows a list of numbered options based on the items in the folder.  
      By default it shows folders, but you can pass a "a" and get a list of files

      .EXAMPLE
      Show-DynamicMenu
      Shows Menu base on the Directories in the current locations

      .NOTES
      Handly way to provide a selection if you want to have a menu that needs to be dynamic

      .INPUTS
      A - To get a menu of files

      .OUTPUTS
      Passes or prints the selection of the menu as a name
  #>
  param
  (
    [Parameter(Mandatory = $false)]
    [switch]$Files,
    [Switch]$Folders,
    [Switch]$All
  )
  


  $ConslHt = ($Host.UI.RawUI.WindowSize.Height - 4)
  if($ConslHt -lt 22){
  $DisplayFirst = 20}
  if($Files)
  {
    $DirectoryItems = Get-ChildItem -File | Select-Object -First $DisplayFirst
  }
  if($Folders)
  {
    $DirectoryItems = Get-ChildItem -Directory | Select-Object -First $DisplayFirst
  }
  if($All)
  {
    $DirectoryItems = Get-ChildItem | Select-Object -First $DisplayFirst
  }

  $menu = @{}
  $ItemCount = $DirectoryItems.Count


Write-Host ('0. {0}' -f 'Exit')
  for($i = 0;$i -lt $DirectoryItems.count;$i++)
  {
    #Write-Host ('{0}. {1}' -f ($i+1), $DirectoryItems[$i].name)
    $menu.Add($i,($DirectoryItems[$i].name))
  }

  $menu
  $ans = 99
  do
  {
    [int]$ans = Read-Host -Prompt 'Select number'
    if($ans -ge $ItemCount )
    {
      Write-Host ('Select {0} or below' -f $ItemCount)
    }
  }
  while($ans -notin 0..$ItemCount)

  $selection = $menu.Item($ans)
  
  # Visual output for Testing
  Write-Host 'You selected:'$selection -ForegroundColor Magenta
}
