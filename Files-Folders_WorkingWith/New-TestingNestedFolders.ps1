

function script:New-TestFolders{
  <#
      .SYNOPSIS
      This is a simple Powershell script to create a group of nested folders. The depth is decided by the number you add.
      .DESCRIPTION
      The script itself will only print 'Hello World'. But that's cool. It's main objective is to create a group of items to test against anyway.
      
      .EXAMPLE
      c:\Temp> .\test-folders.ps1 2 

      .NOTES
      Script Name: test-folders.ps1
      Author Name: Erik
      Date: 10/5/2017
      Contact : 
      
      .LINK
      https://github.com/../VM-Modules/test-folders.ps1 

      function test-set {
      [CmdletBinding(DefaultParameterSetName = 3)]
      param(
        [parameter(mandatory=$true, parametersetname="FooSet")]
        [switch]$FldrDpth,[parameter(mandatory=$true,position=0,parametersetname="Folder Depth")]
        [string]$TargFldr,[parameter(mandatory=$true,position=1)]
        [io.fileinfo]$FilePath)
      @"
      Parameterset is: {0}
      Bar is: '{1}'
      -TargFldr present: {2}
      FilePath: {3}
      "@ -f $PSCmdlet.ParameterSetName, $FldrDpt, $TargFldr.IsPresent, $FilePath
      }
  #>
  [CmdletBinding(
      DefaultParameterSetName = 'TargetFolder', 
    SupportsShouldProcess)]

  param(
    [Int]$FolderDepth = 3,
    [STRING]$TargFldr = 'c:\Temp\NestedFolders',
    [STRING]$tpLevFldr = 'TopLev',
    [STRING]$NstFldr = 'NestFoldr',
    [STRING]$TstFile = 'TestFile'
    )

    WRITE-DEBUG -Message ("`$TargFldr: {0}" -f $TargFldr)
    WRITE-DEBUG -Message ("`$tpLevFldr: {0}" -f $tpLevFldr)
    WRITE-DEBUG -Message ("`$NstFldr: {0}" -f $NstFldr)


  #[CmdletBinding(DefaultParameterSetName = "c:\Temp\NestedFolders")]
    param(
        [parameter(
            mandatory=$true, 
            parametersetname="FooSet")]
    [switch]$FolderDepth,
        [parameter(
            mandatory=$true,
            position=0,
            parametersetname="Folder Depth")]
    [string]$TargFldr,
        [parameter(
            mandatory=$true,
            position=1)]
    [io.fileinfo]$FilePath)


  @"
  Parameterset is: {0}
  Bar is: '{1}'
  -TargFldr present: {2}
  FilePath: {3}
"@ -f $PSCmdlet.ParameterSetName, $FolderDepth, $TargFldr.IsPresent, $FilePath


  # PowerShell Nested Folders
  # Set Variables
  #$FolderDepth = 3
  #$TargFldr = "c:\Temp\1001"
  #$tpLevFldr = "TopLev"
  #$NstFldr = "NestFoldr"
  #$TstFile = "TestFile"
  $i = 0

  if(!(Test-Path -Path $TargFldr)){
    New-Item -ItemType Directory -Path $TargFldr -Force
    }

  Set-Location -Path $TargFldr

  While ($i -le $FolderDepth) {
    $i +=1
    Set-Location -Path $TargFldr
    New-Item -ItemType Directory -Path $TargFldr"\"$tpLevFldr"-"$i -Force
    #Set-Location .\$tpLevFldr"-"$i
    $j=0
    While ($j -le $FolderDepth) {
      $j +=1
      #Set-Location .\$tpLevFldr"-"$i
      New-Item -ItemType Directory -Path $TargFldr"\"$tpLevFldr"-"$i"\"$NstFldr"-"$i"-"$j -Force
      #Set-Location .\$NstFldr"-"$i"-"$j
      $k=0
      While ($k -le $FolderDepth) {
        $k+=1
        New-Item -ItemType File -path $TargFldr"\"$tpLevFldr"-"$i"\"$NstFldr"-"$i"-"$j"\"$TstFile"-"$i"-"$j"-"$k".txt" -Force
        }
    }
  }
}

<#
function remove-folder (){
  <#
    .SYNOPSIS
    Describe purpose of "remove-folder" in 1-2 sentences.

    .DESCRIPTION
    Add a more complete description of what the function does.

    .EXAMPLE
    remove-folder
    Describe what this call does

    .NOTES
    Place additional notes here.

    .LINK
    URLs to related sites
    The first link is opened by Get-Help -Online remove-folder

    .INPUTS
    List of input types that are accepted by this function.

    .OUTPUTS
    List of output types produced by this function.
  #>


$limit = (Get-Date).AddDays(-0)
$path = 'c:\Temp\NestedFolders'

# Delete files older than the $limit.
Get-ChildItem -Path $path -Recurse -Force | Where-Object { !$_.PSIsContainer -and $_.CreationTime -lt $limit } | Remove-Item -Force

# Delete any empty directories left behind after deleting the old files.
Get-ChildItem -Path $path -Recurse -Force | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse
#>

}