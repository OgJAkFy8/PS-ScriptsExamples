#Requires -Version 3 
#R equires -RunAsAdministrator


<#
Author Name: Raydi H. //rjh

Requirements - Powershell / Must be run on locally on Event Log Analyzer

.NAME 
DeleteFilesOlder.ps1


.SYNOPSIS
Searches a directory for files older than a certain date a deletes the files and folders.  If there isn't more then 5 folders to delete it does not run.

.Description
 Stops the Services - Eventloganalyzer
 Deletes files and folders in "D:\ManageEngine\EventLog Analyzer\ES\data\ELA-C1\nodes\0\indices"
 Starts the Services - Eventloganalyzer


.EXAMPLE
 DeleteFilesOlder.ps1 

.EXAMPLE
 DeleteFilesOlder.ps1  -workingLocation "D:\Clean UpScript" -Logfile "Cleanup.log"
 
.EXAMPLE
 DeleteFilesOlder.ps1  -workingLocation "D:\Clean UpScript" -Logfile "Cleanup.log" -DaysBack 4

 .PARAMETER Logfile
 You can create a name for your log file or leave the default which is "Cleanup.log" 

 .PARAMETER DaysBack
 This is the amount of days you want to save.  Any file older than X days will be deleted. The default for this is "4"
 Which means that 5+ days will be deleted

 .PARAMETER workingLocation
 This is where the file outputs to and should be where you are running this from.  The default is ".\CleanUpScript"

.NOTES
Change Log:
 1.0 New Script //rjh
 1.1 Added a little more detail //eja
 1.2 Changed name to "DeleteFilesOlder-Indices.ps1" and added more detail //eja
 1.3 Added function to deal with the services. //eja
 1.4 Corrected the f_serviceControl function //eja
 1.5 A number of changes to combine tasks //eja
 1.6 Much more clean up and added Recovered amount //eja
 
#>


# Parameters
param(
    [String]$LogLocation = "$env:HOMEDRIVE\temp\test", #".\CleanUpScript",
    [String]$Logfile="Cleanup.log",
    [Int]$DaysBack = 0
    ) 

# User Settings
#<><><><><><><><><><><><><><><><><><><>

# Sets Path for file deletion
$Script:path = "$env:HOMEDRIVE\temp\test" #"D:\ManageEngine\EventLog Analyzer\ES\data\ELA-C1\nodes\0\indices"
 
# Set date of when files will be deleted before.  
# Amount of days to keep.  Delete all files older than X days back.
$Script:dayLimit = $DaysBack

# Service Name
$Script:Service = Get-Service -Name netman #Eventloganalyzer  #Future option make this a null option in cases that it does not need to be stopped.

$ScriptName = $MyInvocation.MyCommand.Name

# Event Log
$Script:e_logname = "PS Test Log"#"JIOR Log" 
$Script:e_source = "My Script"  #"DeleteFilesOlder"

#<><><><><><><><><><><><><><><><><><><>

# Create Event
#New-EventLog -LogName "PS Test Log" -Source $ScriptName

#Functions 
#------------

# Test if the script is "RunasAdminsitrator"
$asAdmin = ([Security.Principal.WindowsPrincipal] `
  [Security.Principal.WindowsIdentity]::GetCurrent() `
).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)


function f_make-filefold($OutputFileFold,$it){
    f_Event -e_id 100 -e_message "Start f_make-filefold"
    if($it -eq "File"){
        if(!(test-path -Path $OutputFileFold)){New-Item -Path $OutputFileFold -ItemType file -Force}
        }
    if($it -eq "Folder"){
        if(!(test-path -Path $OutputFileFold)){New-Item -Path $OutputFileFold -ItemType Directory -Force}
        }}



# Creates a unique name for the log file
function f_make-tdFILEname ($baseNAME, $format) {
    f_Event -e_id 100 -e_message "start function make-tdFILEname"

    switch ($format){
    1{$t = Get-Date -uformat "%y%m%d%H%M"} # 1703162145 YYMMDDHHmm
    2{$t = Get-Date -uformat "%Y%m%d"} # 20170316 YYYYMMDD
    3{$t = Get-Date -uformat "%d%H%M%S"} # 16214855 DDHHmmss
    4{$t = Get-Date -uformat "%y/%m/%d_%H:%M"} # 17/03/16_21:52
    default{f_Event -e_id 200 -e_message "No format selected for make-tdFILEname"}
    }
    return $baseNAME + "-"+ $t + ".log"
}

# Time Stamp
Function f_TimeStamp(){
    f_Event -e_id 100 -e_message "start function f_TimeStamp"

    # 10/27/2017 21:52:34 (This matches the output for "Date Deleted to" to help readablity
    $Script:TimeStamp = Get-Date -uformat "%m/%d/%y %H:%M:%S"
    return $TimeStamp
}

# Stops and starts services
Function f_serviceControl($Service, $state){
f_Event -e_id 100 -e_message "start function - serviceControl"

if($state -eq "Stop"){
    Stop-Service -InputObject $Service -WhatIf
    }
if($state -eq "Start"){
    Start-Service -InputObject $Service -WhatIf
    }
}


function f_Event($e_id,$e_message,$e_type){
    #Used to ease the writing events to the log.
    # e_logname and e_source are defined in the User Settings
    
    if($e_type -eq $null){$e_type = "Information"}
    Write-EventLog -LogName $e_logname -Source $e_source -EntryType $e_type -EventID $e_id -Message $e_message
}


function f_Output($Outputfile, $strtTime, $stopTime){
    f_Event -e_id 100 -e_message "Start Function - f_Output | $ScriptName"
    
    $o = New-Object -TypeName PSObject
    $o | Add-Member -MemberType NoteProperty -Name 'Time Started' -value $strtTime
    $o | Add-Member -MemberType NoteProperty -Name 'Time Stopped' -value $dayLimit
    $o | Add-Member -MemberType NoteProperty -Name 'Time Elapsed' -value $limit
    $o | Add-Member -MemberType NoteProperty -Name 'Folders Deleted' -value $fileCount
    $o | Add-Member -MemberType NoteProperty -Name 'Space Recovered' -value $spaceRecovered
    $o | Add-Member -MemberType NoteProperty -Name 'Before Date' -value $(($stopTime-$strtTime).totalseconds)
    $o | Add-Member -MemberType NoteProperty -Name 'Run by' -value $env:USERNAME
        
    $o | Export-Csv -Path $Outputfile -NoTypeInformation -Append
    f_Event -e_id 100 -e_message "$o"
    }




# Output File
# Create the output file and setup the output
function testf_Output($Outputfile, $strtTime, $stopTime){
    f_Event -e_id 100 -e_message "Start Function - f_Output | $ScriptName"
    $r = @($strtTime,$dayLimit,$limit,$fileCount,$spaceRecovered,$(($stopTime-$strtTime).totalseconds),$stopTime,$env:USERNAME)
    if(!(test-path -Path $Outputfile)){
    "Time Started,Time Stopped,Time Elapsed,Folders Deleted,Space Recovered,Before Date,Run by"| Out-File -FilePath $Outputfile -Append 
    }
    $r -join "," | Out-File -FilePath $Outputfile -Append
    
    f_Event -e_id 100 -e_message "f_Output | $ScriptName | $r"
    

    }

#f_Output "c:\temp\test\out22.txt" 3 4



# Delete files and folders
function f_deleteFileFold(){
    
                           function Where-Archive
                           {
                             param
                             (
                               [Object]
                               [Parameter(Mandatory=$true, ValueFromPipeline=$true, HelpMessage="Data to filter")]
                               $InputObject
                             )
                             process
                             {
                               if ($InputObject.Attributes -eq "Archive")
                               {
                                 $InputObject
                               }
                             }
                           }

f_Event -e_id 100 -e_message "Start deleteFileFold"
    
    $bforSum = f_fileMath -r "sum | $ScriptName"
    #(Get-ChildItem -Directory $path -Recurse | where CreationTime -lt $limit).Attributes #| Remove-Item -Force -Recurse  -WhatIf
    #Get-ChildItem -path $path -name "test*" | 
    #Remove-Item -Force  -whatif # where CreationTime -lt $limit).Attributes #| Remove-Item -Force -Recurse  -WhatIf
    Get-ChildItem -Path "$path\*" | Where-Archive | Remove-Item -exclude "*.log" -Confirm
    Start-Sleep -Seconds 9
    $aftrSum = f_fileMath -r "sum"
    $Script:spaceRecovered = ($bforSum.sum + $aftrSum.sum)/1MB
}

function f_fileMath([Parameter(Mandatory)]$r){
    if ($r -eq "cnt"){
        # Count
        (Get-ChildItem -Directory -Path $path | Where-Object CreationTime -lt $limit).count
        }
    else{
        # if ($r -eq "sum"){}
        Get-ChildItem -Path $path -Recurse | Measure-Object -Property Length -Sum
    }
}



# Begin Script
# ========================
f_Event -e_id 100 -e_message "Start Script | $ScriptName"

#$t = split-path $PSCommandPath -Parent
#set-location $t
#.\DeleteFilesOlder.ps1


#if ($asAdmin -ne $true){

# Set working and log location
f_make-filefold -OutputFileFold $LogLocation -it "folder"
Set-Location -Path $LogLocation

# Set name of log file
f_make-filefold -OutputFileFold $Logfile -it "file"
$Script:Outputfile = $Logfile


# Math
$Script:limit = (Get-Date).AddDays(-$dayLimit)
$Script:fileCount = f_fileMath -r "cnt"

# Test if there are files to be deleted
if ($fileCount -gt 0){
    Write-Debug -Message "Script Loop"
    $strtTime = Get-Date #f_TimeStamp
    #f_serviceControl $Service "stop"
    f_deleteFileFold
    #f_serviceControl $Service "start"
    $stopTime = Get-Date # f_TimeStamp
    f_Output -Outputfile $Outputfile -strtTime $strtTime -stopTime $stopTime
    Write-Host "Job Completed!  View Log: $LogLocation\$Logfile" -ForegroundColor White -BackgroundColor Green

}
#}