$Title = "VM Tools Not Up to Date"
$Header = "VM Tools Not Up to Date: [count]"
$Display = "Table"
$Author = "Alan Renouf, Shawn Masterson"
$PluginVersion = 1.1
$PluginCategory = "vSphere"




Write-EventLog –LogName "PS Test Log" –Source “My Script” –EntryType Information –EventID 100 –Message “This is a test message.”

$ArrayList = New-Object -TypeName 'System.Collections.ArrayList';
$Array = @();


Measure-Command
{
	for($i = 0; $i -lt 10000; $i++)
	{
		$null = $ArrayList.Add("Adding item $i")
	}
};
Measure-Command
{
	for($i = 0; $i -lt 10000; $i++)
	{
		$Array += "Adding item $i"
	}
};

###########################

#Have you tried changing the SelectionMode attribute to "One"?

$checkedlistbox2.SelectionMode = "One"

#Alternatively, you could use a radio button control, which allows only one selection at a time? Something like this:

$radioButton1 = New-Object System.Windows.Forms.RadioButton
$radioButton2 = New-Object System.Windows.Forms.RadioButton
$radioButton1.Checked = $True
$radioButton1.Name = "W2K"
$radioButton1.Text = "W2K"
$radioButton1.Location = New-Object System.Drawing.Point(10,10)
$radioButton2.Name = "WXP"
$radioButton2.Text = "WXP"
$radioButton2.Location = New-Object System.Drawing.Point(10,30)
$form.Panel1.Controls.Add($radioButton1)
$form.Panel1.Controls.Add($radioButton2)

###############################

$Services = get-wmiobject win32_service -ErrorAction SilentlyContinue #| Where-Object {$_.DisplayName -like "Win*" }

$myCol = @()
Foreach ($service in $Services){
	$MyDetails = "" | select-Object Name, State, StartMode, Health
	If ($service.StartMode -eq "Auto")
	{
		if ($service.State -eq "Stopped")
		{
			$MyDetails.Name = $service.Displayname
			$MyDetails.State = $service.State
			$MyDetails.StartMode = $service.StartMode
			$MyDetails.Health = "Unexpected State"
		}
	}
	If ($service.StartMode -eq "Auto")
	{
		if ($service.State -eq "Running")
		{
			$MyDetails.Name = $service.Displayname
			$MyDetails.State = $service.State
			$MyDetails.StartMode = $service.StartMode
			$MyDetails.Health = "OK"
		}
	}
	If ($service.StartMode -eq "Disabled")
	{
		If ($service.State -eq "Running")
		{
			$MyDetails.Name = $service.Displayname
			$MyDetails.State = $service.State
			$MyDetails.StartMode = $service.StartMode
			$MyDetails.Health = "Unexpected State"
		}
	}
	If ($service.StartMode -eq "Disabled")
	{
		if ($service.State -eq "Stopped")
		{
			$MyDetails.Name = $service.Displayname
			$MyDetails.State = $service.State
			$MyDetails.StartMode = $service.StartMode
			$MyDetails.Health = "OK"
		}
	}
	$myCol += $MyDetails
}

$Results = $MyCol | Where-Object {$_.Name -ne $null -and $_.Health -ne "OK"}
$Results


################################################3

# Case Study 1 - Solution with PowerShell 'Switch' Param
Clear-Host
$Disk = Get-WmiObject win32_logicaldisk
Foreach ($Drive in $Disk) {
	Switch (14) {
		1{ $Drive.DeviceID + " Unknown" }
		2{ $Drive.DeviceID + " Floppy or Removable Drive" }
		3{ $Drive.DeviceID + " Hard Drive" }
		14{ $Drive.DeviceID + " Network Drive" }
		5{ $Drive.DeviceID + " CD" }
		6{ $Drive.DeviceID + " RAM Disk" }
	}
}


$o = new-object PSObject
$o | add-member NoteProperty PhysicalMemory $PhysicalMemory


$o | export-csv "outputfile.csv" -notypeinformation


#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Testing some filtering of AD Computers >>>>>>>>>>>>>>>>>>
# Get-ADComputer -filter {samAccountName -like "D114*"} | foreach {Get-WmiObject -Class Win32_ComputerSystem -ComputerName $_.Name } | where {$_.UserName -eq "Resource\brushde" } | Format-Table Name, UserName
# Get-ADComputer -filter {samAccountName -like "D114*"} | foreach {Get-WmiObject -Class Win32_ComputerSystem -ComputerName $_.Name } | where {($_.PrimaryOwnerName -ne "OSD-CIO") -or ($_.PrimaryOwnerName -ne "EITSD")} | Format-Table Name,PrimaryOwnerName -a


#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Get and display ENV data >>>>>>>>>#
$UserInfo = 0..5
$UserInfo[0] =$env:COMPUTERNAME
$UserInfo[1]=$env:USERNAME
$UserInfo[2]=$env:HOMESHARE
$UserInfo[3]=$env:LOGONSERVER
$UserInfo[4]=$env:USERDOMAIN 


Get-Childitem -Path Env:* | Out-GridView -Title "Session Information from Get-ChildItem -path Env:*" 
$UserInfo[0..4] | Out-GridView
Get-Childitem -Path Env:* | select COMPUTERNAME,$_.USERNAME,$_.HOMESHARE

#<<<<<<<<<<<<<<<<<<<<<<<<<<<<# Example to show the InputBox on button click and display entered text #>


[void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 
[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.VisualBasic") 

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
	$EnteredText = [Microsoft.VisualBasic.Interaction]::InputBox("Prompt", "Title", "Default value",$Form.Left + 50, $Form.Top + 50) 

	<# If the InputBox Cancel button is clicked the InputBox returns an empty string so don't change the TextBox value #>

	if($EnteredText.Length -gt 0) 
	{
		$TextBox.Text = $EnteredText 
	} 
} 

$Button.Add_Click($Button_Click) 

$Form.ShowDialog()



#<<<<<<<<<<<<<<<<<<<<<<<<<<< This is pulled out of another script to delete files >>>>>>>>>>>#

$t = split-path $PSCommandPath -Parent
set-location $t
.\DeleteFilesOlder.ps1


if ($asAdmin -ne $true){

    # Set working and log location
    f_make-filefold $workingLocation "folder"
    Set-Location $workingLocation

    # Set name of file
    f_make-filefold $Logfile "file"
    $Script:Outputfile = $Logfile


    # Math
    $Script:limit = (Get-Date).AddDays(-$dayLimit)
    $Script:fileCount = f_fileMath "cnt"

    # Test if there are files to be deleted
    if ($fileCount -gt 5){
        $strtTime = Get-Date #f_TimeStamp
        f_serviceControl $Service "stop"
        f_deleteFileFold
        f_serviceControl $Service "start"
        $stopTime = Get-Date # f_TimeStamp
        f_Output $Outputfile $strtTime $stopTime
        Write-Host "Job Completed!  View Log: $workingLocation\$Logfile" -ForegroundColor White -BackgroundColor DarkGreen

    }
}


else{
    Write-Host "*** Re-run as an administrator ******" -ForegroundColor Black -BackgroundColor Yellow
}

# <<<<<<<<<<<<<<<<<<<<<<<<< Try Catch >>>>>>>>>>>>>>#
try
{
  $a = $env:USERNAME
$b = $env:COMPUTERNAME
Read-Host "Username:", $a
Read-Host "ComputerName:", $b
Write-Warning "$a on $b"
Write-Host "Press any key to exit ..."
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

}
# NOTE: When you use a SPECIFIC catch block, exceptions thrown by -ErrorAction Stop MAY LACK
# some InvocationInfo details such as ScriptLineNumber.
# REMEDY: If that affects you, remove the SPECIFIC exception type [System.NotImplementedException] in the code below
# and use ONE generic catch block instead. Such a catch block then handles ALL error types, so you would need to
# add the logic to handle different error types differently by yourself.
catch [System.NotImplementedException]
{
  # get error record
  [Management.Automation.ErrorRecord]$e = $_

  # retrieve information about runtime error
  $info = [PSCustomObject]@{
    Exception = $e.Exception.Message
    Reason    = $e.CategoryInfo.Reason
    Target    = $e.CategoryInfo.TargetName
    Script    = $e.InvocationInfo.ScriptName
    Line      = $e.InvocationInfo.ScriptLineNumber
    Column    = $e.InvocationInfo.OffsetInLine
  }
  
  # output information. Post-process collected info, and log info (optional)
  $info
}

#<<<<<<<<<<<<<<<<<<<<<<<<<<<  More Experimental Snippets  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>#

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
Get-WmiObject -Class Win32_Process -Filter 'Name="explorer.exe"' |
ForEach-Object {
	$owner = $_.GetOwner()
	'{0}\{1}' -f $owner.Domain, $owner.User
} | 
Sort-Object -Unique








