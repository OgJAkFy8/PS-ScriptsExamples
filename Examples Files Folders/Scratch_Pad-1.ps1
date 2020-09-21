. .\Variables.ps1


####   EVENT LOG TESTING ######

#  Test to see if the source is on the computer
[System.Diagnostics.EventLog]::Exists("PS Test Log") # Tests for the actual log
[System.Diagnostics.EventLog]::SourceExists("My Script") # Tests for the source which will write to the log



##3  ====
function Test-EventLogSource() {
  Param(
    [Parameter(Mandatory=$true)]
    [string] $SourceName
  )

  [System.Diagnostics.EventLog]::SourceExists($SourceName)
}

Test-EventLogSource "My Script"
# >




$eventlogexists = [System.Diagnostics.EventLog]::Exists("System")
if ([System.Diagnostics.EventLog]::Exists("PS Test Log") -eq $false) {
  [System.Diagnostics.EventLog]::SourceExists("Get-Drives")

} 




#####   MENU TESTING #####

    Clear-Host
$MenuTitle = 'Quick'
$MenuList = (@"
--------------------------------------------------

      Welcome to the {0} Menu

    0 = Exit
    1 = Option One
    2 = Option Two

--------------------------------------------------
"@  -f $MenuTitle )

Wrtie-Host $MenuList -ForegroundColor Green

    $answer = read-host "Please Make a Selection"  


#Quick Menu. 
while ($choice -ne 0){
    #Display the menu options function

    $choice = read-host "`nSelection"
    switch ($choice)
        {
            0 {break} #Return to main menu
            1 {add-ADUser}
            2 {create-HomeFolder}
            default {write-host "`nPlease choose a selection." -foregroundcolor red}
        }
}

$d = @{
  'foo' = 'something'
  'bar' = 42
}

     $r = ("Set Safety On/Off","
    Move all VM's to one host","
    Reboot Empty host","
    Balance all VM's per 'tag'","
    Move, Reboot and Balance VM environment","
    VM/Host information","
    to Exit")

for ($i=0;$i -le $r.length; $i++) {
    "`$r[{0}] = {1}" -f $i,$r[$i]}



$Title = "Select OS"
$Message = "What OS is your favorite?"
$WindowsME = New-Object System.Management.Automation.Host.ChoiceDescription "&Windows ME", `
    "Windows ME"
$MacOSX = New-Object System.Management.Automation.Host.ChoiceDescription "&MacOSX", `
    "MacOSX"
$Options = [System.Management.Automation.Host.ChoiceDescription[]]($WindowsME, $MacOSX)
$SelectOS = $host.ui.PromptForChoice($title, $message, $options, 0) 
 
    switch($SelectOS){
  1 {
    Clear-Host
    $HostOne = Read-Host "Enter IP Address of host to move from"
    $HostTwo = Read-Host "Enter IP Address of host to move to"
    Write-Host "If this is taking to long to run, manually check status of servers by running 'get-vm | ft name, vmhost' from PowerCLI" -ForegroundColor DarkYellow
    Write-Host "This processes can be completed by using the following command in the PowerCLI: 'move-vm VM-SERVER -destination VM-HOST'"  -ForegroundColor DarkYellow
    if($HostTwo -ne $HostOne){
        MoveVMs $HostOne $HostTwo
        }}
  2 {
    Clear-Host
    Remove-COOPs}
  3 {
    Clear-Host
    Create-COOPs}
  4 {
    Clear-Host
    BalanceVMs}
  Default {Write-Host "Exit"}
}






Function Invoke-Menu {
  [cmdletbinding()]
  Param(
    [Parameter(Position=0,Mandatory=$True,HelpMessage="Enter your menu text")]
    [ValidateNotNullOrEmpty()]
    [string]$Menu,
    [Parameter(Position=1)]
    [ValidateNotNullOrEmpty()]
    [string]$Title = "My Menu",
    [Alias("cls")]
    [switch]$ClearScreen
  )
 
  #clear the screen if requested
  if ($ClearScreen) { 
    Clear-Host 
  }
 
  #build the menu prompt
  $menuPrompt = $title
  #add a return
  $menuprompt+="`n"
  #add an underline
  $menuprompt+="-"*$title.Length
  #add another return
  $menuprompt+="`n"
  #add the menu
  $menuPrompt+=$menu
 
  Read-Host -Prompt $menuprompt
 
} #end function
        
Invoke-Menu



#---------------------------
[array]$DropDownArrayItems = "","Group1","Group2","Group3"
[array]$DropDownArray = $DropDownArrayItems | sort

# This Function Returns the Selected Value and Closes the Form

function Return-DropDown {
    if ($DropDown.SelectedItem -eq $null){
        $DropDown.SelectedItem = $DropDown.Items[0]
        $script:Choice = $DropDown.SelectedItem.ToString()
        $Form.Close()
    }
    else{
        $script:Choice = $DropDown.SelectedItem.ToString()
        $Form.Close()
    }
}

function SelectGroup{
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")


    $Form = New-Object System.Windows.Forms.Form

    $Form.width = 300
    $Form.height = 150
    $Form.Text = ”DropDown”

    $DropDown = new-object System.Windows.Forms.ComboBox
    $DropDown.Location = new-object System.Drawing.Size(100,10)
    $DropDown.Size = new-object System.Drawing.Size(130,30)

    ForEach ($Item in $DropDownArray) {
     [void] $DropDown.Items.Add($Item)
    }

    $Form.Controls.Add($DropDown)

    $DropDownLabel = new-object System.Windows.Forms.Label
    $DropDownLabel.Location = new-object System.Drawing.Size(10,10) 
    $DropDownLabel.size = new-object System.Drawing.Size(100,40) 
    $DropDownLabel.Text = "Select Group:"
    $Form.Controls.Add($DropDownLabel)

    $Button = new-object System.Windows.Forms.Button
    $Button.Location = new-object System.Drawing.Size(100,50)
    $Button.Size = new-object System.Drawing.Size(100,20)
    $Button.Text = "Select an Item"
    $Button.Add_Click({Return-DropDown})
    $form.Controls.Add($Button)
    $form.ControlBox = $false

    $Form.Add_Shown({$Form.Activate()})
    [void] $Form.ShowDialog()


    return $script:choice
}

$Group = $null
$Group = SelectGroup
while ($Group -like ""){
    $Group = SelectGroup
}