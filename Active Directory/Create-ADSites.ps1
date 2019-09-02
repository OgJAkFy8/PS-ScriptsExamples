[Threading.Thread]::CurrentThread.CurrentCulture = 'en-US'

$SiteListFile = 'C:\Temp\SiteList.csv'
$FilePath = (Resolve-Path -Path $SiteListFile).Path

$SiteName = 'Test'
$SitePath = 'CN=Sites,CN=Configuration,DC=iorcol,DC=net'

$SiteList = Import-Csv -Path $FilePath

foreach($Item in $SiteList)
{
  Switch($item.'Boundary Type')
  {
        
    'IP Subnet' {$Type = 0}
    'Active Directory Site' {$Type = 1}
    'IPv6' {$Type = 2}
    'Ip Address Range' {$Type = 3}

  }
    
  $Arguments = @{
    DisplayName = $Item.'Display Name'
    BoundaryType = $Type
    Value = $Item.Value
  }
  New-ADObject -type Site -name $SiteName -path $SitePath
  New-ADObject -type ServersContainer -name 'Servers' -path "CN="+$SiteName+","+$SitePath
  New-ADObject -type ntdsSiteSettings -name 'NTDS Site Settings' -path "CN="+$SiteName+","+$SitePath


    Set-WmiInstance -Namespace 'Root\SMS\Site_sitecode' -Class SMS_Boundary -Arguments $Arguments -ComputerName ServerName
}

