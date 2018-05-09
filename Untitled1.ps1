Get-ADComputer -filter {samAccountName -like "D114*"} | foreach {Get-WmiObject -Class Win32_ComputerSystem -ComputerName $_.Name } | where {$_.UserName -eq "Resource\brushde" } | Format-Table Name, UserName
Get-ADComputer -filter {samAccountName -like "D114*"} | foreach {Get-WmiObject -Class Win32_ComputerSystem -ComputerName $_.Name } | where {($_.PrimaryOwnerName -ne "OSD-CIO") -or ($_.PrimaryOwnerName -ne "EITSD")} | Format-Table Name,PrimaryOwnerName -a

                                                                                                                                  
$UserInfo = 0..5
$UserInfo[0] =$env:COMPUTERNAME
$UserInfo[1]=$env:USERNAME
$UserInfo[2]=$env:HOMESHARE
$UserInfo[3]=$env:LOGONSERVER
$UserInfo[4]=$env:USERDOMAIN 


Get-Childitem -Path Env:* | GridView -Title "Session Info" $UserInfo[0..4] | Out-GridView
Get-Childitem -Path Env:* | ft $env:COMPUTERNAME,USERNAME,HOMESHARE

<# Example to show the InputBox on button click and display entered text #>
 
 
[void][System.Reflection.Assembly]::LoadWithPartialName( 
    "System.Windows.Forms") 
[void][System.Reflection.Assembly]::LoadWithPartialName( 
    "Microsoft.VisualBasic") 
     
$Form = New-Object System.Windows.Forms.Form 
$Button = New-Object System.Windows.Forms.Button 
$TextBox = New-Object System.Windows.Forms.TextBox 
 
$Form.Text = "Visual Basic InputBox Example" 
$Form.StartPosition =  
    [System.Windows.Forms.FormStartPosition]::CenterScreen 
 
$Button.Text = "Show Input Box" 
$Button.Top = 20 
$Button.Left = 90 
$Button.Width = 100 
 
$TextBox.Text = "Old value" 
$TextBox.Top = 60 
$TextBox.Left = 90 
 
$Form.Controls.Add($Button) 
$Form.Controls.Add($TextBox) 
 
$Button_Click =  
{ 
    $EnteredText =  
        [Microsoft.VisualBasic.Interaction]::InputBox( 
        "Prompt", "Title", "Default value",  
        $Form.Left + 50, $Form.Top + 50) 
     
    <# If the InputBox Cancel button is clicked the InputBox returns an empty string so don't change the TextBox value #>
     
    if($EnteredText.Length -gt 0) 
    { 
        $TextBox.Text = $EnteredText 
    } 
} 
 
$Button.Add_Click($Button_Click) 
 
$Form.ShowDialog()