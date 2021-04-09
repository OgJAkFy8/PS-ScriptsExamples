<#


Script Name: DFSR_Service_Test-and-Restart.ps1
Author Name: Erik Arnesen
Version : 1.0 
Contact : 5276
Check to see if DFSR service is running on the FS02 server and stops it for restarting the server.
Great for rebooting the server without having to log into the server to stop the service.
 
NOTE ** 
#>
 
# Requirements
# VMware PowerCLI 4.1
 
#Get-Service -ComputerName COMPNAMENGMFS02 -Name "DFSR" -dependentservices | Where-Object {$_.Status -eq "Running"} |Select -Property Name




$DFSRservice = Get-Service -ComputerName iorunc-filesvr -Name "DFSR" #-DependentServices
$UserAnswer = "N"
if ($DFSRservice.Status -eq "Stopped"){
    Write-Host "DFS Replication Service is Off.... "
    $UserAnswer = Read-Host "Do you want to start it? [N]"
        if($UserAnswer -eq "Y"){
            Write-Host "Starting Service..." -BackgroundColor Green
            Set-Service -ComputerName iorunc-filesvr -Name "DFSR"-Status Running -StartupType Automatic
 
            }}
 
if ($DFSRservice.Status -eq "Running"){
    Write-Host "DFS Replication Service is On...."
        $UserAnswer = Read-Host "Do you want to stop it? [N]"
        if($UserAnswer -eq "Y"){
            Write-Host "Stopping Service..." -BackgroundColor Red
            Get-Service -ComputerName iorunc-filesvr -Name "DFSR" | Stop-Service -Force 
            
            }}
Get-Service -ComputerName iorunc-filesvr -Name "DFSR" | Format-Table Status,Name -AutoSize
