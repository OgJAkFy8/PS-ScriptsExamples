Param(
[string]$url,
[string]$file,
[switch]$force
)
Function Get-WebPage
{
Param(
$url,
$file,
[switch]$force
)
if($force)
{ 
[Net.ServicePointManager]::ServerCertificateValidationCallback = {$true} 
}
$webclient = New-Object system.net.webclient
$webclient.DownloadFile($url,$file)
} #end function Get-WebPage
# *** Entry Point to Script ***
Get-WebPage -url $url -file $file -force