function Uninstall-Hotfix {
  <#
    .SYNOPSIS
    Describe purpose of "Uninstall-Hotfix" in 1-2 sentences.

    .DESCRIPTION
    Add a more complete description of what the function does.

    .PARAMETER computername
    Describe parameter -computername.

    .PARAMETER HotfixID
    Describe parameter -HotfixID.

    .EXAMPLE
    Uninstall-Hotfix -computername Value -HotfixID Value
    Describe what this call does

    .NOTES
    Place additional notes here.

    .LINK
    URLs to related sites
    The first link is opened by Get-Help -Online Uninstall-Hotfix

    .INPUTS
    List of input types that are accepted by this function.

    .OUTPUTS
    List of output types produced by this function.
  #>


[cmdletbinding()]
param(
[Object]$computername = $env:computername,
[Parameter(Mandatory,HelpMessage='Add help message for user')][string] $HotfixID
)            

$hotfixes = Get-WmiObject -ComputerName $computername -Class Win32_QuickFixEngineering | Select-Object -ExpandProperty hotfixid            

if($hotfixes -match $hotfixID) {
    $hotfixID = $HotfixID.Replace('KB','')
    Write-Verbose -Message 'Found the hotfix KB'
    Write-Verbose -Message 'Uninstalling the hotfix'
    $UninstallString = ('cmd.exe /c wusa.exe /uninstall /KB:{0} /quiet /norestart' -f $hotfixID)
    $null = ([WMICLASS]('\\{0}\ROOT\CIMV2:win32_process' -f $computername)).Create($UninstallString)            

    while (@(Get-Process -Name wusa -ComputerName $computername -ErrorAction SilentlyContinue).Count -ne 0) {
        Start-Sleep -Seconds 3
        Write-Verbose -Message 'Waiting for update removal to finish ...'
    }
Write-Verbose -Message ('Completed the uninstallation of {0}' -f $hotfixID)
}
else {            

Write-Verbose -Message ('Given hotfix({0}) not found' -f $hotfixID)
return
}            

}

#requires -Version 2
function Show-InputBox
{
  <#
    .SYNOPSIS
    Describe purpose of "Show-InputBox" in 1-2 sentences.

    .DESCRIPTION
    Add a more complete description of what the function does.

    .PARAMETER Prompt
    Describe parameter -Prompt.

    .PARAMETER DefaultValue
    Describe parameter -DefaultValue.

    .PARAMETER Title
    Describe parameter -Title.

    .PARAMETER a
    Describe parameter -a.

    .EXAMPLE
    Show-InputBox -Prompt Value -DefaultValue Value -Title Value -a Value
    Describe what this call does

    .NOTES
    Place additional notes here.

    .LINK
    URLs to related sites
    The first link is opened by Get-Help -Online Show-InputBox

    .INPUTS
    List of input types that are accepted by this function.

    .OUTPUTS
    List of output types produced by this function.
  #>


    param
    (
        [Parameter(Mandatory,HelpMessage='Add help message for user')]
        [string]
        $Prompt,
        
        [string]
        $DefaultValue='',
        
        [string]
        $Title = 'Windows PowerShell',

        [string]
        $a = ''
    )
    
    
    Add-Type -AssemblyName Microsoft.VisualBasic
    [Microsoft.VisualBasic.Interaction]::InputBox($Prompt,$Title, $DefaultValue)
}

Show-InputBox -Prompt 'Enter KB' | Uninstall-Hotfix -computername 'D114067'
