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
  $title = "Add employee?"
  $message = "You want to add a new employee to your organisation?"
  $yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", "Yes"
  $no = New-Object System.Management.Automation.Host.ChoiceDescription "&No", "No"
  $options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
  $choice = $host.ui.PromptForChoice($title, $message, $options, 0)



$title = "Backup"
$message = "Please select resources for backup!"
$option1 = New-Object System.Management.Automation.Host.ChoiceDescription "Set Safety &On/Off", "Set-Safety"
$option2 = New-Object System.Management.Automation.Host.ChoiceDescription "&Add New COOPs (Remove Old)", "Remove-New"
$option3 = New-Object System.Management.Automation.Host.ChoiceDescription "&Remove Old COOPs", "Remove-COOPs"
$option4 = New-Object System.Management.Automation.Host.ChoiceDescription "&Create New COOPs", "New-COOPs"
$options = [System.Management.Automation.Host.ChoiceDescription[]]($option1, $option2, $option3, $option4)
$backup=$host.ui.PromptForChoice($title, $message, $options, [int[]](1))

}