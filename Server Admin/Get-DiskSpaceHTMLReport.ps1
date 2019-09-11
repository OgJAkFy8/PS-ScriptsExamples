Function Get-DiskspaceHTMLReport 
{ 
[cmdletBinding(SupportsShouldProcess=$True)] 
Param 
( 
    [Parameter( 
        Position = 0, 
        ValuefromPipeline = $true, 
        ValueFromPipelineByPropertyName = $true 
        ) 
    ] 
    [String[]]$ComputerName=$Env:COMPUTERNAME, 
    [Parameter(Position = 1)    ] 
    [String]$OutputFile="DiskSpaceReport_$(get-date -format ddMMyyyy).html", 
    [Parameter(Position = 2)] 
    [String]$FreePercentWarningThreshold=20, 
    [Parameter(Position = 3)] 
    [String]$FreePercentCriticalThreshold=10     
) 
 
BEGIN 
{     
    Write-Host "Starting to Generate HTML Diskspace Report...." -ForegroundColor DarkGray 
    Write-Output "" 
    Write-Host "Freespace % Warning Threshold --> $FreePercentWarningThreshold" -ForegroundColor Yellow 
    Write-Host "Freespace % Critical Threshold --> $FreePercentCriticalThreshold" -ForegroundColor DarkRed         
    New-Item -ItemType File -Name $OutputFile -Path $PWD.Path -Force| Out-Null     
    Function writeHtmlHeader 
{ 
    param($fileName) 
    $date = ( get-date ).ToString('yyyy/MM/dd') 
    $header = @" 
        <html> 
        <head> 
        <meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'> 
        <title>DiskSpace Report</title> 
        <STYLE TYPE="text/css"> 
        <!-- 
        td { 
            font-family: Tahoma; 
            font-size: 11px; 
            border-top: 1px solid #999999; 
            border-right: 1px solid #999999; 
            border-bottom: 1px solid #999999; 
            border-left: 1px solid #999999; 
            padding-top: 0px; 
            padding-right: 0px; 
            padding-bottom: 0px; 
            padding-left: 0px; 
        } 
        body { 
            margin-left: 5px; 
            margin-top: 5px; 
            margin-right: 0px; 
            margin-bottom: 10px; 
            table { 
            border: thin solid #000000; 
        } 
        --> 
        </style> 
        </head> 
        <body> 
        <table width='100%'> 
        <tr bgcolor='#CCCCCC'> 
        <td colspan='7' height='25' align='center'> 
        <font face='tahoma' color='#003399' size='4'><strong>DiskSpace Report - $date</strong></font> 
        </td> 
        </tr> 
        </table> 
"@ 
 Add-Content $filename $header 
} 
    writeHtmlHeader "$pwd\$OutputFile"     
} 
PROCESS 
{ 
    $tableHeader = @" 
    <tr bgcolor=#CCCCCC> 
    <td width='10%' align='center'>Drive</td> 
    <td width='50%' align='center'>Drive Label</td> 
    <td width='10%' align='center'>Total Capacity(GB)</td> 
    <td width='10%' align='center'>Used Capacity(GB)</td> 
    <td width='10%' align='center'>Free Space(GB)</td> 
    <td width='10%' align='center'>Freespace %</td> 
    </tr> 
"@ 
Function WriteDiskInfo( 
[string]$fileName, 
[string]$devId, 
[string]$volName, 
[double]$frSpace, 
[double]$totSpace 
) 
{ 
 
    $redColor = "#FF0000" 
    $orangeColor = "#FBB917" 
    $whiteColor = "#FFFFFF" 
     
    $totSpace=[math]::Round(($totSpace/1073741824),2)     
    $frSpace=[Math]::Round(($frSpace/1073741824),2)     
    $usedSpace = $totSpace - $frspace 
    $usedSpace=[Math]::Round($usedSpace,2) 
    $freePercent = ($frspace/$totSpace)*100 
    $freePercent = [Math]::Round($freePercent,0) 
     
    if ($freePercent -gt $FreePercentWarningThreshold) 
     { 
         $color = $whiteColor 
            $dataRow = @" 
        <tr> 
        <td>$devid</td> 
        <td>$volName</td> 
        <td>$totSpace</td> 
        <td>$usedSpace</td> 
        <td>$frSpace</td> 
        <td bgcolor=`'$color`' align=center>$freePercent</td> 
        </tr> 
"@ 
        Add-Content $fileName $dataRow 
    } 
    elseif ($freePercent -le $FreePercentCriticalThreshold) 
     { 
         $color = $redColor 
            $dataRow = @" 
        <tr> 
        <td>$devid</td> 
        <td>$volName</td> 
        <td>$totSpace</td> 
        <td>$usedSpace</td> 
        <td>$frSpace</td> 
        <td bgcolor=`'$color`' align=center>$freePercent</td> 
        </tr> 
"@ 
        Add-Content $fileName $dataRow 
     }     
    else 
     {     
         $color = $orangeColor 
            $dataRow = @" 
        <tr> 
        <td>$devid</td> 
        <td>$volName</td> 
        <td>$totSpace</td> 
        <td>$usedSpace</td> 
        <td>$frSpace</td> 
        <td bgcolor=`'$color`' align=center>$freePercent</td> 
        </tr> 
"@ 
        Add-Content $fileName $dataRow 
     } 
} 
 
foreach ($computer in $ComputerName) 
    { 
    if (Test-Connection -ComputerName $computer -Quiet -Count 1) 
            { 
                $compHeader = @" 
                <table width='100%'><tbody> 
                <tr bgcolor='#CCCCCC'> 
                <td width='100%' align='center' colSpan=6><font face='tahoma' color='#003399' size='2'><strong> $Computer </strong></font></td> 
                </tr> 
"@ 
                Add-Content "$PWD\$OutputFile" $compHeader 
                Add-Content "$pwd\$outputFile" $tableHeader 
                $dp = Get-WmiObject win32_logicaldisk -ComputerName $computer |  Where-Object {$_.drivetype -eq 3} 
                foreach ($item in $dp) 
                {                      
                     WriteDiskInfo "$pwd\$outputFile" $item.DeviceID $item.VolumeName $item.FreeSpace $item.Size 
                } 
                Add-Content "$pwd\$outputFile" "</table>"     
            } 
        else 
            { 
                $compHeader = @" 
                <table width='100%'><tbody> 
                <tr bgcolor='#B43104'> 
                <td width='100%' align='center' colSpan=6><font face='tahoma' color='#000000' size='2'><strong> Connection to $Computer failed. Make sure the machine is up and you have Administrator rights and try again.</strong></font></td> 
                </tr> 
"@ 
                Add-Content "$PWD\$OutputFile" $compHeader                 
                Add-Content "$pwd\$outputFile" "</table>" 
            } 
         
    Write-Output "$computer processed." 
    } 
} 
END 
{ 
 Add-Content "$pwd\$outputFile" "</body></html>" 
 Write-Host "DiskSpace HTML Report File Path --> $pwd\$OutputFile" -ForegroundColor DarkGreen         
} 
 
<# 
.Synopsis 
    Generates HTML Diskspace Report for a list of Computers. 
.Description 
    Generates HTML Diskspace Report for a list of Computers. 
    Highlights the disks/volumes which has less free space based on configured thresholds. 
    Connects using WMI and Win32_LogicalDisk class. 
.Example 
    PS C:\>Get-DiskSpaceHTMLReport -computername "localhost" 
    Starting to Generate HTML Diskspace Report.... 
 
    Freespace % Warning Threshold --> 20 
    Freespace % Critical Threshold --> 10 
    locahost processed. 
    DiskSpace HTML Report File Path --> C:\DiskSpaceReport_05072011.html 
.Example 
    Get-DiskSpaceHTMLReport -computername "localhost","remoteserver" 
     
    Gets diskspace info for both the servers. 
.Example 
    Import-Csv Computers.csv | Get-DiskSpaceHTMLReport 
     
    Contents of Computers.csv 
    computername 
    server1 
    server2 
    server3 
    This collects diskspace info for all the 3 servers in the .csv file. 
.Example 
    Get-DiskSpaceHTMLReport -computername "localhost" -FreePercentWarningThreshold 30 -FreePercentCriticalThreshold 20 
     
    Gets diskspace info for localhost. 
    Set the parameter FreePercentWarningThreshold to 30, if any disk has less than 30% free space , it will show up as orange in the report. 
    Set the parameter FreePercentCriticalThreshold to 20, if any disk has less than 20% free space , it will show up as red in the report. 
.Example 
    Get-DiskSpaceHTMLReport -computername "localhost" -OutputFile "diskreport.html" 
     
    Diskspace info is gathered and wrote to "diskreport.html" 
.Link 
www.mc.mil 
 
#> 
#Requires -Version 2.0 
}