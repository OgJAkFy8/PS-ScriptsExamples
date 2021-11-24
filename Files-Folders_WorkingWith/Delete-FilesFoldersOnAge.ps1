#Requires -Version 3 
#Requires -RunAsAdministrator

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
    1.4 Corrected the Invoke-ServiceControl function //eja
    1.5 A number of changes to combine tasks //eja
    1.6 Much more clean up and added Recovered amount //eja
    2.0 Removed aliases and made code more verbose.
    2.1 Renamed again this time to a more PowerShell Verb-Noun name Delete-ELAInicesFilesOlderThan.ps1
	
#>


# Parameters
[CmdletBinding()]
param(
  [String]$workingLocation = '.\CleanUpScript',
  [String]$Logfile = 'Cleanup.log',
  [Int]$DaysBack = 4
) 
# User Settings <><><><><><><><><><><><><><><><><><><>
# Sets WorkingPath for file deletion
$Script:WorkingPath = 'D:\ManageEngine\EventLog Analyzer\ES\data\ELA-C1\nodes\0\indices'

# Set date of when files will be deleted before.  
# Amount of days to keep.  Delete all files older than X days back.
$Script:dayLimit = $DaysBack

# Service Name
$Script:Service = Get-Service -Name Eventloganalyzer #Future option make this a null option in cases that it does not need to be stopped.

$ScriptName = $MyInvocation.MyCommand.Name
#<><><><><><><><><><><><><><><><><><><>

# Create Event
# Future use for adding the log file to the event log.
#New-EventLog -LogName "PS Test Log" -Source $ScriptName

#--------------------------
# Internal Script Functions 
# These are recycled scripts which have been turned into function for F2 of this script.

# Test if the script is "RunasAdminsitrator"
$asAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

function Test-FileExists
{
  param
  (
    [Parameter(Mandatory,HelpMessage = 'Output file')]
    [String]$Outputfile
  )
  if(!(Test-Path -Path $Outputfile))
  {
    New-Item -Path $Outputfile -ItemType file -Force
  }
}

function Test-FolderExists
{
  param
  (
    [Parameter(Mandatory,HelpMessage = 'Output Folder')]
    [String]$Outputfold
  )
  if(!(Test-Path -Path $Outputfold))
  {
    New-Item -Path $Outputfold -ItemType Directory -Force
  }
}

function get-TimeStamp
{
  param
  (
    [Parameter(Mandatory,HelpMessage = 'Use the following formats - YYYYMMDD, DDHHmmss, YYMMDD_HHMM, YYMMDDHHmm')]
    [ValidateSet('YYYYMMDD', 'DDHHmmss', 'YYMMDD_HHMM', 'YYMMDDHHmm')] 
    [String]$Format
  )
  switch ($Format) {
    YYYYMMDD 
    {
      $Script:TimeStamp = Get-Date -UFormat '%Y%m%d'
    } # 20170316 YYYYMMDD
    DDHHmmss 
    {
      $Script:TimeStamp = Get-Date -UFormat '%d%H%M%S'
    } # 16214855 DDHHmmss
    YYMMDD_HHMM 
    {
      $Script:TimeStamp = Get-Date -UFormat '%y/%m/%d_%H:%M'
    } # 17/03/16_21:52 YYMMDD_HHMM
    YYMMDDHHmm 
    {
      $Script:TimeStamp = Get-Date -UFormat '%y%m%d%H%M'
    } # 1703162145 YYMMDDHHmm
    MMDDYY-Time 
    {
      $Script:TimeStamp = Get-Date -UFormat '%m/%d/%y %H:%M:%S'
    }
    Default 
    {
      $Script:TimeStamp = Get-Date -UFormat '%d/%m/%Y'
    } # 03/16/2018
  }
  return $Script:TimeStamp
}

<# Unneeded section
    function f_tdFILEname ($baseName){
    ## 
    $t = get-TimeStamp -format YYYYMMDD
    return $baseNAME + '-'+ $t + '.log'
    }

    # Time Stamp
    Function f_TimeStamp(){
    # 10/27/2017 21:52:34 (This matches the output for "Date Deleted to" to help readablity
    get-TimeStamp MMDDYY-Time
    return $TimeStamp
    }

#>

# Stops and starts services
Function Invoke-ServiceControl
{
  param
  (
    [Parameter(Mandatory,HelpMessage = 'The service that needs to be controlled')]
    [String]$Service,
    [Parameter(Mandatory,HelpMessage = 'The state to put the service in')]
    [String]$state
  )
  Write-Debug -Message 'ServiceControl'
  if($state -eq 'Stop')
  {
    Stop-Service -InputObject $Service #-WhatIf
  }
  if($state -eq 'Start')
  {
    Start-Service -InputObject $Service #-WhatIf
  }
}


# Output File
# Create the output file and setup the output
function Write-OutputToFile
{
  #Write-EventLog -LogName "PS Test Log" -Source "My Script" -EntryType Information -EventID 100 -Message "This is a test message."

  #if(!(test-WorkingPath $Outputfile)){New-Item $Outputfile -type file -Force}

  [CmdletBinding()]
  param
  (
    [Parameter(Mandatory = $true)][Parameter]
    [String]$Outputfile,
    [Parameter(Mandatory = $true)][Parameter]
    [String]$strtTime,
    [Parameter(Mandatory = $true)][Parameter]
    [String]$stopTime,
    [Parameter(Mandatory = $true)][Parameter]
    [String]$limit, 
    [Parameter(Mandatory = $true)][Parameter]
    [String]$dayLimit,
    [Parameter(Mandatory = $true)][Parameter]
    [String]$fileCount,
    [Parameter(Mandatory = $true)][Parameter]
    [String]$spaceRecovered






  )
   
  $doubleLine = '='*40

  $ScriptOutput = (@'
 {0}
 Start Time: {1} 
 Amount of days to save: {3}
 Deleted files created before: {2}

 Items deleted: {4}
 Space recovered: {5} GB

Elapsed Time: {6} seconds
Run by: {0}


'@ -f $doubleLine, $strtTime, $limit, $dayLimit, $fileCount, $spaceRecovered, (($stopTime - $strtTime).totalseconds), $env:USERNAME)

  $ScriptOutput | Out-File -FilePath $Outputfile -Append

  <#if($fileCount -gt 4){
   
      (		'Folders deleted: {0}' -f $fileCount) | Out-File -FilePath $Outputfile -Append
      (		'Space recovered: {0} GB' -f $spaceRecovered) | Out-File -FilePath $Outputfile -Append
  #>
}








# Delete files and folders
function Remove-FilesAndFolders()
{
  $bforSum = Measure-Files
  Get-ChildItem -Directory -Path $WorkingPath -Recurse | Where-Object -Property CreationTime -LT -Value $limit #| Remove-Item -Force -Recurse  -WhatIf
  $aftrSum = Measure-Files
  $Script:spaceRecovered = ($bforSum.sum + $aftrSum.sum)/1GB
}

function Measure-Files
{
  [CmdletBinding()]
  param
  (
    [Switch]$CountFiles,
    [Switch]$sumFiles
      
  )
  if ($CountFiles)
  {
    Write-Verbose -Message 'Count Files True'
    (Get-ChildItem -Directory -Path $WorkingPath | Where-Object -Property CreationTime -LT -Value $limit).count
  }
  if ($sumFiles)
  {
    # if ($r -eq "sum"){}
    (Get-ChildItem -Path $WorkingPath -Recurse | Measure-Object -Property Length -Sum).sum
  }
}

# Begin Script
# ========================

if ($asAdmin -ne $true)
{
  # Set working and log location
  Test-FolderExists -Outputfold $workingLocation
  Set-Location -Path $workingLocation

  # Set name of file
  Test-FileExists -Outputfile $Logfile
  $Script:Outputfile = $Logfile

  # Math
  $Script:limit = (Get-Date).AddDays(-$dayLimit)
  $Script:fileCount = Measure-Files -CountFiles
  $StrtFileSize = Measure-Files -sumFiles

  # Test if there are files to be deleted
  if ($fileCount -gt 5)
  {
    $strtTime = Get-Date #f_TimeStamp
    Invoke-ServiceControl -Service $Service -state 'stop'
    Remove-FilesAndFolders
    Invoke-ServiceControl -Service $Service -state 'start'
    $stopTime = Get-Date # f_TimeStamp
    $stopFileSize = Measure-Files -sumFiles
    Write-OutputToFile -Outputfile $Outputfile -strtTime $strtTime -stopTime $stopTime -limit $Script:limit -dayLimit $dayLimit -fileCount $fileCount -spaceRecovered $($stopFileSize - $StrtFileSize)
    #Write-Host ('Job Completed!  View Log: {0}\{1}' -f $workingLocation, $Logfile) -ForegroundColor White -BackgroundColor DarkGreen
    Write-Verbose -Message ('Job Completed!  View Log: {0}\{1}' -f $workingLocation, $Logfile)
  }
}
else
{
  Write-Host -Object '*** Re-run as an administrator ******' -ForegroundColor Black -BackgroundColor Yellow
}
