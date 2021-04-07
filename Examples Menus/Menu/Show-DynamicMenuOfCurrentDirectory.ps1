#requires -Version 3.0

Function Show-DynamicMenu
{
  <#
      .SYNOPSIS
      Creates a menu based on items in a file or directory

      .DESCRIPTION
      Checks for the menu.csv file and displays the contents as a menu. If the file does not exist, it looks in the local directory and returns a menu based on the folders or files.  
      By default it shows files, but you can pass a "Folders" and get a list of folders

      .EXAMPLE
      Show-DynamicMenu
      Shows a menu base on the files in the current directory. 

      .EXAMPLE
      Show-DynamicMenu -Folders
      Shows Menu base on the folders in the current directory
 
      .EXAMPLE
      Show-DynamicMenu -MenuFileCsv .\test2.csv
      Shows Menu base on the files in the file.
      The file must have "Name" as the title of the column. ("Name" must be on the first line)
      
      MenuFileCsv Format:
      "Name"
      "Move"
      "Delete"
          
      Output:
      0. Exit
      1. Move
      2. Delete
      Select number: 


      .NOTES
      Handly way to provide a selection if you want to have a menu that needs to be dynamic.  
      When you need to modify something in the directory which changes regularly.
      Or you don't want to rebuild a menu.

      .INPUTS
      File based on parameter - MenuFileCsv or Get-ChildItem of current Directory (folder)

      .OUTPUTS
      Passes or prints the selection of the menu as a name
  #>
  [cmdletbinding(DefaultParameterSetName = 'Files')]
  param
  (
    [Parameter(Position = 0,ValueFromPipeline = $true,ValueFromPipelineByPropertyName = $true,ParameterSetName = 'InputFile')]
    [AllowNull()]
    [ValidateScript({
          $_ -match '.csv'
    })]
    [String]$MenuFileCsv,
    [Parameter(Position = 1,ParameterSetName = 'Folder')]
    [switch]$Folders,
    [Parameter(Position = 1,ParameterSetName = 'Files')]
    [Switch]$Files
  )
      
  $ans = $null
  $exit = 'Exit'
  $menu = [Ordered]@{}
 
  Write-Verbose -Message ('{0} :: {1} :: {2}' -f $MenuFileCsv,$Folders,$Files)        
   
  Switch ($PsBoundParameters.keys){
    'Folders' 
    {
      $DirectoryItems = Get-ChildItem -Directory 
      Write-Verbose -Message ('Folders Switch True - {0}' -f $DirectoryItems)        
    }
    'Files' 
    {
      $DirectoryItems = Get-ChildItem -File
      Write-Verbose -Message ('Files switch True - {0}' -f $DirectoryItems)
    }
    'MenuFileCsv'
    {
      $DirectoryItems = Import-Csv -Path $MenuFileCsv
      Write-Verbose -Message ('CSV File True - {0}' -f $DirectoryItems)
    }
    'Default'
    {
      $DirectoryItems = Get-ChildItem -File
      Write-Verbose -Message ('Default Switch - {0}' -f $DirectoryItems)
    }
  }
  
  $folderCount = ($DirectoryItems.Count - 1)
  
  for($i = 0;($i -lt $DirectoryItems.Count);$i++)
  {
    if($i -eq 0)
    {
      $menu.Add($i,$exit)
    }
    else
    {
      $menu.Add($i,($DirectoryItems[$i].name))
    }
    
    Write-Output -InputObject ('{0}. {1}' -f $i, $menu[$i])
  }

  do
  {
    try
    {
      [int]$ans = Read-Host -Prompt 'Select number'
      if(($ans -ge $folderCount) -or ($ans -lt 0))
      {
        Write-Warning -Message ('Select a number from 0 to {0}' -f $folderCount)
      }
    }
    catch
    {
      Write-Warning -Message ('Retry with number.')
    }    
  } 
  
  while($ans -notin 0..$folderCount)
 
<<<<<<< HEAD
  $script:selection = $menu.Item($ans)
  
  #Return $selection
=======
  $selection = $menu.Item($ans)
  
  Return $selection
>>>>>>> 74882c3c79fac3f05b8bc84fc005460e7c679f72
}

Clear-Host
Write-Verbose -Message 'Show Dynamic Menu'
<<<<<<< HEAD
Show-DynamicMenu -Files -Verbose

# Visual output for Testing
Write-Output -InputObject ('You selected: {0}' -f $selection)
=======
Show-DynamicMenu  -Verbose

# Visual output for Testing
Write-Output -InputObject ('You selected: {0}' -f $selection)
>>>>>>> 74882c3c79fac3f05b8bc84fc005460e7c679f72
