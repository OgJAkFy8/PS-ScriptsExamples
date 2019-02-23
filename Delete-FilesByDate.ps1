#!/usr/bin/env powershell
#Requires -Version 3 
#R equiresRunAsAdministrator

function Delete-Files 
{
<#
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
.PARAMETER 
	Logfile
	You can create a name for your log file or leave the default which is "Cleanup.log" 
.PARAMETER 
	DaysBack
 	This is the amount of days you want to save.  Any file older than X days will be deleted. The default for this is "4"
 	Which means that 5+ days will be deleted
.PARAMETER
	workingLocation
	This is where the file outputs to and should be where you are running this from.  The default is ".\CleanUpScript"
.NOTES
	Author Name: Raydi H. //rjh
	Requirements - Powershell / Must be run on locally on Event Log Analyzer
	
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
[CmdletBinding()]
param(
    
    [Parameter()]
    [String]$FilePath,
    [String]$FileType,
    [String]$FileSize,
    [String]$FileExtention,
    [String]$FileName,
    [String]$FileDate,

    [String]$Logfile='Cleanup.log',
    [String]$Script:path = "$env:homedrive\Temp", #"D:\ManageEngine\EventLog Analyzer\ES\data\ELA-C1\nodes\0\indices",
    $DayLimit = 4,
    [Parameter(Mandatory,HelpMessage'Attribute criteria')]
    [String]$FileCriteria

    )

$ScriptName = $MyInvocation.MyCommand.Name

# Set date of when files will be deleted before.  
# Amount of days to keep.  Delete all files older than X days back.
# $Script:dayLimit = $DaysBack

# Service Name
# $Script:Service = Get-Service -Name netman #Eventloganalyzer  #Future option make this a null option in cases that it does not need to be stopped.


# Event Log
$Script:e_logname = 'JIOR Log' 
$Script:e_source = 'My Script'  #"DeleteFilesOlder"
New-EventLog -LogName "PS Test Log" -Source $ScriptName



if($FileName)
{
    $FileList = Get-ChildItem -Path $FilePath -Name $FileName
    }
    $FileDate {$FileList = Get-ChildItem -Path $FilePath -Name $FileName}
    $FileExtention {$FileList = Get-ChildItem -Path $FilePath -Name $FileName}
    #$FileList = {Get-ChildItem -Path $FilePath -Name $FileName}
}

#Functions 
#------------

# Test if the script is "RunasAdminsitrator"
<# Future Use:
$asAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
#>

function f_make-filefold{
    
  [CmdletBinding()]
  param
  (
    [Parameter(Mandatory=$true)][string]$Outputfile,

    [Parameter(Mandatory=$true)][string]$it
  )
f_Event -e_id 100 -e_message 'Start f_make-filefold'
    if($it -eq 'File'){
        if(!(test-path -Path $Outputfile)){New-Item -Path $Outputfile -ItemType file -Force}
        }
    else{
        if(!(test-path -Path $Outputfold)){New-Item -Path $Outputfold -ItemType Directory -Force}
        }}



# Creates a unique name for the log file
function f_make-tdFILEname ($baseNAME) {
    f_Event -e_id 100 -e_message 'start function make-tdFILEname'

    #$t = Get-Date -uformat "%y%m%d%H%M" # 1703162145 YYMMDDHHmm
    $t = Get-Date -uformat '%Y%m%d' # 20170316 YYYYMMDD
    #$t = Get-Date -uformat "%d%H%M%S" # 16214855 DDHHmmss
    #$t = Get-Date -uformat "%y/%m/%d_%H:%M" # 17/03/16_21:52
    return $baseNAME + '-'+ $t + '.log'
}

# Time Stamp
Function f_TimeStamp(){
    f_Event -e_id 100 -e_message 'start function f_TimeStamp'

    # 10/27/2017 21:52:34 (This matches the output for "Date Deleted to" to help readablity
    $Script:TimeStamp = Get-Date -uformat '%m/%d/%y %H:%M:%S'
    return $TimeStamp
}

# Stops and starts services
Function f_serviceControl($Service, $state){
f_Event -e_id 100 -e_message 'start function - serviceControl'

if($state -eq 'Stop'){
    Stop-Service -InputObject $Service -WhatIf
    }
if($state -eq 'Start'){
    Start-Service -InputObject $Service -WhatIf
    }
}


function f_Event($e_id,$e_message,$e_type){
    #Used to ease the writing events to the log.
    # e_logname and e_source are defined in the User Settings


    if($e_type -eq $null){$e_type = 'Information'}
    Write-EventLog -LogName $e_logname -Source $e_source -EntryType $e_type -EventID $e_id -Message $e_message
    ##     Write-EventLog -LogName $e_logname -Source $e_source -EntryType $e_type -EventID $e_id -Message $e_message
}

# Output File
# Create the output file and setup the output
function f_Output($Outputfile, $strtTime, $stopTime){
    f_Event -e_id 100 -e_message 'Start Function - f_Output'
    $r = @($strtTime,$dayLimit,$limit,$fileCount,$spaceRecovered,$(($stopTime-$strtTime).totalseconds),$stopTime,$env:USERNAME)
    if(!(test-path -Path $Outputfile)){
    'Time Started,Time Stopped,Time Elapsed,Folders Deleted,Space Recovered,Before Date,Run by'| Out-File -FilePath $Outputfile -Append 
    }
    $r -join ',' | Out-File -FilePath $Outputfile -Append

    }

# For testing only  ---  f_Output 'c:\Temp\test22.txt' 3 4



# Delete files and folders
function f_deleteFileFold(){
    f_Event -e_id 100 -e_message 'Start deleteFileFold'
    
    $bforSum = f_fileMath -r 'sum'
    (Get-ChildItem -Directory -Path $path -Recurse | Where-Object CreationTime -lt $limit).Attributes #| Remove-Item -Force -Recurse  -WhatIf
    Start-Sleep -Seconds 20
    $aftrSum = f_fileMath -r 'sum'
    $Script:spaceRecovered = ($bforSum.sum + $aftrSum.sum)/1MB
}

function f_fileMath($r){
    if ($r -eq 'cnt'){
        # Count
        (Get-ChildItem -Directory -Path $path | Where-Object CreationTime -lt $limit).count
        }
    else{
        # if ($r -eq 'sum'){}
        Get-ChildItem -Path $path -Recurse | Measure-Object -Property Length -Sum
    }
}



# Begin Script
# ========================
$t = split-path -Path $PSCommandPath -Parent
set-location -Path $t
#.\DeleteFilesOlder.ps1


#if ($asAdmin -ne $true){

# Set working and log location
#f_make-filefold $workingLocation "folder"
#Set-Location $workingLocation

# Set name of file
f_make-filefold -Outputfile $Logfile -it 'file'
$Script:Outputfile = $Logfile


# Math
$Script:limit = (Get-Date).AddDays(-$dayLimit)
$Script:fileCount = f_fileMath -r 'cnt'

# Test if there are files to be deleted
if ($fileCount -gt 5){
    Write-Debug -Message 'Script Loop'
    $strtTime = Get-Date #f_TimeStamp
    f_serviceControl -Service $Service -state 'stop'
    f_deleteFileFold
    f_serviceControl -Service $Service -state 'start'
    $stopTime = Get-Date # f_TimeStamp
    f_Output -Outputfile $Outputfile -strtTime $strtTime -stopTime $stopTime
    Write-Host ('Job Completed!  View Log: {0}\#' -f $workingLocation, $Logfile) -ForegroundColor White -BackgroundColor DarkGreen
    # Write-Host "Job Completed!  View Log: $workingLocation\$Logfile" -ForegroundColor White -BackgroundColor DarkGreen

}
}