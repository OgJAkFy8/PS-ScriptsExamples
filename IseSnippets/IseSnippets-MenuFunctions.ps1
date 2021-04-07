
$m = (@'

function Show-QuickMenu 
{
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
}
**********************************************************************
**********************************************************************
function Show-MainMenu
{
  <#
      .SYNOPSIS
      Short Description
      .DESCRIPTION
      Detailed Description
      .EXAMPLE
      Show-MainMenu
      explains how to use the command
      can be multiple lines
      .EXAMPLE
      Show-MainMenu
      another example
      can have as many examples as you like
  #>
  $title = 'Add employee?'
  $message = 'You want to add a new employee to your organisation?'
  $yes = New-Object -TypeName System.Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes', 'Yes'
  $no = New-Object -TypeName System.Management.Automation.Host.ChoiceDescription -ArgumentList '&No', 'No'
  $options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
  $choice = $host.ui.PromptForChoice($title, $message, $options, 0)
  $title = 'Backup'
  $message = 'Please select resources for backup!'
  $option1 = New-Object -TypeName System.Management.Automation.Host.ChoiceDescription -ArgumentList 'Set Safety &On/Off', 'Set-Safety'
  $option2 = New-Object -TypeName System.Management.Automation.Host.ChoiceDescription -ArgumentList 'Remove Old COOPs &And Create New', 'Remove-New'
  $option3 = New-Object -TypeName System.Management.Automation.Host.ChoiceDescription -ArgumentList '&Remove Old COOPs', 'Remove-COOPs'
  $option4 = New-Object -TypeName System.Management.Automation.Host.ChoiceDescription -ArgumentList '&Create New COOPs', 'New-COOPs'
  $options = [System.Management.Automation.Host.ChoiceDescription[]]($option1, $option2, $option3, $option4)
  $backup = $host.ui.PromptForChoice($title, $message, $options, [int[]](1))
}
**********************************************************************
**********************************************************************
function Show-InputBoxButtonClick
{
  <# Example to show the InputBox on button click and display entered text #>
  $null = Add-Type -AssemblyName System.Windows.Forms 
  $null = Add-Type -AssemblyName Microsoft.VisualBasic 
  $Form = New-Object -TypeName System.Windows.Forms.Form 
  $Button = New-Object -TypeName System.Windows.Forms.Button 
  $TextBox = New-Object -TypeName System.Windows.Forms.TextBox 
  $Form.Text = 'Visual Basic InputBox Example' 
  $Form.StartPosition = 
  [System.Windows.Forms.FormStartPosition]::CenterScreen 
  $Button.Text = 'Show Input Box' 
  $Button.Top = 20 
  $Button.Left = 90 
  $Button.Width = 100 
  $TextBox.Text = 'Old value' 
  $TextBox.Top = 60 
  $TextBox.Left = 90 
  $Form.Controls.Add($Button) 
  $Form.Controls.Add($TextBox) 
  $Button_Click = 
  { 
    $EnteredText = 
    [Microsoft.VisualBasic.Interaction]::InputBox('Prompt', 'Title', 'Default value',  $Form.Left + 50, $Form.Top + 50) 
    <# If the InputBox Cancel button is clicked the InputBox returns an empty string so don't change the TextBox value #>
    if($EnteredText.Length -gt 0) 
    {
      $TextBox.Text = $EnteredText
    } 
    $Selection = $TextBox.text
    ####   Use the $Selection variable ######
  } 
  $Button.Add_Click($Button_Click) 
  $Form.ShowDialog()
}
**********************************************************************
**********************************************************************
function Show-GuiMenu
{
  <#
      .SYNOPSIS
      Describe purpose of "Show-GuiMenu" in 1-2 sentences.

      .DESCRIPTION
      Add a more complete description of what the function does.

      .EXAMPLE
      Show-GuiMenu
      Describe what this call does

      .NOTES
      Place additional notes here.

      .LINK
      URLs to related sites
      The first link is opened by Get-Help -Online Show-GuiMenu

      .INPUTS
      List of input types that are accepted by this function.

      .OUTPUTS
      List of output types produced by this function.
  #>
  param
  (
    [Parameter(Mandatory = $true,HelpMessage = 'Add a single or multiple functions comma separated')]
    [string[]]$computerNames,
    [string]$ButtonText = 'Start Process'
  )
  Add-Type -AssemblyName System.Windows.Forms
  Add-Type -AssemblyName System.Drawing
  $Form1 = New-Object -TypeName System.Windows.Forms.Form
  $Form1.ClientSize = New-Object -TypeName System.Drawing.Size -ArgumentList (407, 390)
  $Form1.topmost = $true
  $comboBox1 = New-Object -TypeName System.Windows.Forms.ComboBox
  $comboBox1.Location = New-Object -TypeName System.Drawing.Point -ArgumentList (25, 55)
  $comboBox1.Size = New-Object -TypeName System.Drawing.Size -ArgumentList (350, 310)
  foreach($computer in $computerNames)
  {
    $comboBox1.Items.add($computer)
  }
  $Form1.Controls.Add($comboBox1)
  $Button = New-Object -TypeName System.Windows.Forms.Button
  $Button.Location = New-Object -TypeName System.Drawing.Point -ArgumentList (25, 20)
  $Button.Size = New-Object -TypeName System.Drawing.Size -ArgumentList (98, 23)
  $Button.Text = $ButtonText
  $Button.add_Click({
      $label.Text = $comboBox1.SelectedItem.ToString()
  })
  $Form1.Controls.Add($Button)
  $label = New-Object -TypeName System.Windows.Forms.Label
  $label.Location = New-Object -TypeName System.Drawing.Point -ArgumentList (70, 90)
  $label.Size = New-Object -TypeName System.Drawing.Size -ArgumentList (98, 23)
  $label.Text = ''
  $Form1.Controls.Add($label)
  $null = $Form1.showdialog()
}
#Show-GuiMenu -computerNames test1, test2
**********************************************************************
**********************************************************************
Function Show-DynamicMenu
{
  <#
      .SYNOPSIS
      Creates a menu of folders or files

      .DESCRIPTION
      Looks at the folder shows a list of numbered options based on the items in the folder.  
      
      .EXAMPLE
      Show-DynamicMenu -Files
      Shows Menu based on the Files in the current locations

      0    Exit
      1    autovar.csv
      2    Commands.csv
      3    Commands.xlsx 

      Selecting the #2 will return $selection = to 'Commands.csv'

      Add the Folders or All switches to create menus with those items

      .PARAMETER Files
      Builds the Menu based on the Files

      .PARAMETER Folders
      Builds the Menu based on the Folders.

      .PARAMETER All
      Builds the Menu based on All items.

      .NOTES
      Handly way to provide a selection if you want to have a menu that needs to be dynamic

      .OUTPUTS
      Returns the $Selection as a name
  #>
  param
  (
    [Parameter(HelpMessage = 'Select what you want a menu of.  Files, Folders, or all')]
    [switch]$Files,
    [Switch]$Folders,
    [Switch]$All
  )
  $i = 0
  $ans = $null
  $menu = [ordered]@{}
  if($Files)  
  {
    $DirectoryItems = Get-ChildItem -File
  }
  if($Folders)  
  {
    $DirectoryItems = Get-ChildItem -Directory
  }
  if($All)  
  {
    $DirectoryItems = Get-ChildItem
  }
  foreach($DirectoryItem in $DirectoryItems)
  {
    if($i -eq 0)
    {
      $menu.Add($i, 'Exit')
    }
    $i++
    $menu.Add($i,($DirectoryItem.name))
  }
  $menu | Format-Table -HideTableHeaders -AutoSize
  $ItemCount = $DirectoryItems.name.Count
  while($ans -notin 0..$ItemCount)
  {
    [int]$ans = Read-Host -Prompt 'Select number'
    if($ans -ge $ItemCount )
    {
      Write-Host ('Select {0} or below' -f $ItemCount)
    }
    $Selection = $menu.Item($ans)
    Write-Host 'You selected:'$Selection -ForegroundColor Magenta
  }
  Return $Selection
}
**********************************************************************
**********************************************************************
function Show-AsciiMenu
{
  <#
      .SYNOPSIS
      Describe purpose of "Show-AsciiMenu" in 1-2 sentences.

      .DESCRIPTION
      Add a more complete description of what the function does.

      .PARAMETER Title
      Describe parameter -Title.

      .PARAMETER MenuItems
      Describe parameter -MenuItems.

      .PARAMETER TitleColor
      Describe parameter -TitleColor.

      .PARAMETER LineColor
      Describe parameter -LineColor.

      .PARAMETER MenuItemColor
      Describe parameter -MenuItemColor.

      .EXAMPLE
      Show-AsciiMenu -Title Value -MenuItems Value -TitleColor Value -LineColor Value -MenuItemColor Value
      Describe what this call does

      .NOTES
      Place additional notes here.

      .LINK
      URLs to related sites
      The first link is opened by Get-Help -Online Show-AsciiMenu

      .INPUTS
      List of input types that are accepted by this function.

      .OUTPUTS
      List of output types produced by this function.
  #>
  [CmdletBinding()]
  param
  (
    [string]$title = 'Title',
    [String[]]$MenuItems = 'None',
    [string]$TitleColor = 'Red',
    [string]$LineColor = 'Yellow',
    [string]$MenuItemColor = 'Cyan'
  )
  Begin{
    # Set Variables
    $i = 1
    $Tab = "`t"
    $VertLine = '║'
    function Write-HorizontalLine
    {
      param
      (
        [Parameter(Position = 0)]
        [string]
        $DrawLine = 'Top'
      )
      Switch ($DrawLine) {
        Top 
        {
          Write-Host ('╔{0}╗' -f $HorizontalLine) -ForegroundColor $LineColor
        }
        Middle 
        {
          Write-Host ('╠{0}╣' -f $HorizontalLine) -ForegroundColor $LineColor
        }
        Bottom 
        {
          Write-Host ('╚{0}╝' -f $HorizontalLine) -ForegroundColor $LineColor
        }
      }
    }
    function Get-Padding
    {
      param
      (
        [Parameter(Mandatory, Position = 0)]
        [int]$Multiplier 
      )
      "`0"*$Multiplier
    }
    function Write-MenuTitle
    {
      Write-Host ('{0}{1}' -f $VertLine, $TextPadding) -NoNewline -ForegroundColor $LineColor
      Write-Host ($title) -NoNewline -ForegroundColor $TitleColor
      if($TotalTitlePadding % 2 -eq 1)
      {
        $TextPadding = Get-Padding -Multiplier ($TitlePaddingCount + 1)
      }
      Write-Host ('{0}{1}' -f $TextPadding, $VertLine) -ForegroundColor $LineColor
    }
    function Write-MenuItems
    {
      foreach($menuItem in $MenuItems)
      {
        $number = $i++
        $ItemPaddingCount = $TotalLineWidth - $menuItem.Length - 6 #This number is needed to offset the Tab, space and 'dot'
        $ItemPadding = Get-Padding -Multiplier $ItemPaddingCount
        Write-Host $VertLine  -NoNewline -ForegroundColor $LineColor
        Write-Host ('{0}{1}. {2}{3}' -f $Tab, $number, $menuItem, $ItemPadding) -NoNewline -ForegroundColor $LineColor
        Write-Host $VertLine -ForegroundColor $LineColor
      }
    }
  }
  Process
  {
    $TitleCount = $title.Length
    $LongestMenuItemCount = ($MenuItems | Measure-Object -Maximum -Property Length).Maximum
    Write-Debug -Message ('LongestMenuItemCount = {0}' -f $LongestMenuItemCount)
    if  ($TitleCount -gt $LongestMenuItemCount)
    {
      $ItemWidthCount = $TitleCount
    }
    else
    {
      $ItemWidthCount = $LongestMenuItemCount
    }
    if($ItemWidthCount % 2 -eq 1)
    {
      $ItemWidth = $ItemWidthCount + 1
    }
    else
    {
      $ItemWidth = $ItemWidthCount
    }
    Write-Debug -Message ('Item Width = {0}' -f $ItemWidth)
    $TotalLineWidth = $ItemWidth + 10
    Write-Debug -Message ('Total Line Width = {0}' -f $TotalLineWidth)
    $TotalTitlePadding = $TotalLineWidth - $TitleCount
    Write-Debug -Message ('Total Title Padding  = {0}' -f $TotalTitlePadding)
    $TitlePaddingCount = [math]::Floor($TotalTitlePadding / 2)
    Write-Debug -Message ('Title Padding Count = {0}' -f $TitlePaddingCount)
    $HorizontalLine = '═'*$TotalLineWidth
    $TextPadding = Get-Padding -Multiplier $TitlePaddingCount
    Write-Debug -Message ('Text Padding Count = {0}' -f $TextPadding.Length)
    Write-HorizontalLine -DrawLine Top
    Write-MenuTitle
    Write-HorizontalLine -DrawLine Middle
    Write-MenuItems
    Write-HorizontalLine -DrawLine Bottom
  }
  End
  {}
}
#Show-AsciiMenu -Title 'THIS IS THE TITLE' -MenuItems 'Exchange Server', 'Active Directory', 'Sytem Center Configuration Manager', 'Lync Server' -TitleColor Red  -MenuItemColor green
#Show-AsciiMenu -Title 'THIS IS THE TITLE' -MenuItems 'Exchange Server', 'Active Directory', 'Sytem Center Configuration Manager' #-Debug
**********************************************************************
**********************************************************************
function Show-OneClickGuiMenu 
{
  [void][reflection.assembly]::Load('System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
  $formShowmenu = New-Object -TypeName 'System.Windows.Forms.Form'
  $comboBox1 = New-Object -TypeName 'System.Windows.Forms.ComboBox'
  $combobox1_SelectedIndexChanged = {
    $script:var = $comboBox1.SelectedItem
    $formShowmenu.Close()
  }
  $formShowmenu.Controls.Add($comboBox1)
  $formShowmenu.AutoScaleDimensions = '6, 13'
  $formShowmenu.AutoScaleMode = 'Font'
  $formShowmenu.ClientSize = '284, 70'
  #add array of items
  #[void]$combobox1.Items.Addrange(1 .. 10)
  #add single item
  $r = 'Staple', 'Horse', 'Video'
  foreach($SingleItem in $r)
  {
    #[void]$combobox1.Items.Add('Single Item')
    [void]$comboBox1.Items.Add($SingleItem)
  }
  $comboBox1.Location = '45, 25'
  $comboBox1.Size = '187, 21'
  $comboBox1.add_SelectedIndexChanged($combobox1_SelectedIndexChanged)
  $null = $formShowmenu.ShowDialog()
  Write-Output -InputObject $var
}
#Show-OneClickGuiMenu
**********************************************************************
**********************************************************************
function Show-ChoiceGuiMenu 
{
  $MenuObject = 'System.Management.Automation.Host.ChoiceDescription'
  $red1 = New-Object -TypeName $MenuObject -ArgumentList '&Red1', 'Favorite color: Red1'
  $blue1 = New-Object -TypeName $MenuObject -ArgumentList '&Blue1', 'Favorite color: Blue1'
  $yellow1 = New-Object -TypeName $MenuObject -ArgumentList '&Yellow1', 'Favorite color: Yellow1'
  $red2 = New-Object -TypeName $MenuObject -ArgumentList '&Red2', 'Favorite color: Red2'
  $blue2 = New-Object -TypeName $MenuObject -ArgumentList '&Blue2', 'Favorite color: Blue2'
  $yellow2 = New-Object -TypeName $MenuObject -ArgumentList '&Yellow2', 'Favorite color: Yellow2'
  $red3 = New-Object -TypeName $MenuObject -ArgumentList '&Red3', 'Favorite color: Red3'
  $blue3 = New-Object -TypeName $MenuObject -ArgumentList '&Blue3', 'Favorite color: Blue3'
  $yellow3 = New-Object -TypeName $MenuObject -ArgumentList '&Yellow3', 'Favorite color: Yellow3'
  $red4 = New-Object -TypeName $MenuObject -ArgumentList '&Red4', 'Favorite color: Red4'
  $blue4 = New-Object -TypeName $MenuObject -ArgumentList '&Blue4', 'Favorite color: Blue4'
  $yellow4 = New-Object -TypeName $MenuObject -ArgumentList '&Yellow4', 'Favorite color: Yellow4'
  $options = [System.Management.Automation.Host.ChoiceDescription[]]($red1, $blue1, $yellow1, $red2, $blue2, $yellow2, $red3, $blue3, $yellow3, $red4, $blue4, $yellow4)
  $title = 'Favorite color'
  $message = 'What is your favorite color?'
  $result = $host.ui.PromptForChoice($title, $message, $options, 0)
  Write-Output -InputObject $result
}

'@)

New-IseSnippet -Text $m -Title 'ks: Menus' -Description 'A selection of different menus.' -Author 'Knarr Studio' -Force

