$sites = 'yahoo.com', 'google.com', 'bing.com'
$Jobs = @()
$job = {Start-Job -ScriptBlock {
  param ($site) Test-Connection -ComputerName "$site" -Count 1
}}
        
for ($i = 0; $i -lt $sites.Count; $i++)
{
  $site = [string]$sites[$i]
  & $job -site $site
}
        



$job = Test-Connection ('yahoo.com', 'google.com', 'bing.com') -AsJob -Count 1
for ($i = 0; $i -lt $sites.Count; $i++)
{
  Start-Sleep -Seconds 2
  Write-Host $sites[$i]
}
$Results = Receive-Job $job -Wait
$Results[1].Address



