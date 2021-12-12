<#
.SYNOPSIS
Get all the properties for CIM (Common Information Model) or WMI (Windows Management Instrumentation) class.
.DESCRIPTION
Get all the properties for CIM (Common Information Model) or WMI (Windows Management Instrumentation) class. This is usefull when one wants to know what can be output from CIM or WMI class.
Which properties might be usefull and which are not.
.PARAMETER classname
CIM or WMI class name e.g. Win32_OperatingSystem
.EXAMPLE
Get-CIMClassProperty -classname "Win32_OperatingSystem"
.EXAMPLE 
Get-CIMClassProperty -classname "CIM_Processor"
.NOTES
    FunctionName : Get-CIMClassProperty
    Created by   : Dejan Mladenovic
    Date Coded   : 01/18/2020 04:34:41
    More info    : https://improvescripting.com/
.LINK 
https://improvescripting.com/how-to-list-cim-or-wmi-class-all-properties-and-their-datatypes-with-powershell
.OUTPUT
Output GridView
#>
Function Get-CIMClassProperty {
[CmdletBinding()]
param (
    [Parameter(HelpMessage="CMI class name.")]
    [string]$classname,
    $SelectedText = $psISE.CurrentFile.Editor.SelectedText,
    [Switch]$InstallMenu,
    $ComputerName = 'localhost'
)

BEGIN { 

        if ($InstallMenu)
        {
            Write-Verbose "Try to install the menu item, and error out if there's an issue."
            try
            {
                $psISE.CurrentPowerShellTab.AddOnsMenu.SubMenus.Add("Get CMI Class Properties",{Get-CIMClassProperty},"Ctrl+Alt+P") | Out-Null
            }
            catch
            {
                Return $Error[0].Exception
            }
        }
}
PROCESS {               
        
        if (!$InstallMenu)
        {
            Write-Verbose "Don't run a function if we're installing the menu"
            try
            {
                Write-Verbose "Return all the properties for CMI Class."                    
                 
                if ($SelectedText )
                {
                    $class = "$SelectedText"
                } else {
                    $class = "$classname"
                }

                Get-CimInstance -Class $class -ComputerName $ComputerName | Get-Member -MemberType Property | Select-Object name, definition | Out-GridView

                }
            catch
            {
                Return $Error[0].Exception
            }
        }        
}
END { }
}
#region Execution examples
    
    Get-CIMClassProperty -InstallMenu $true
    #Get-CIMClassProperty -classname "CIM_Processor"

#endregion