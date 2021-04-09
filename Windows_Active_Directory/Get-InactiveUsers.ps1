#Requires -version 3.0 
#Requires -Module ActiveDirectory


$ADSearchBase = 'OU=SOUTH,DC=knarrstudio,DC=com'
$ReportFolder = '\\FileServer\Reports\DisabledUsers'
$DiabledCount = 0
$DateNow = Get-Date -UFormat %Y%m%d-%H%M
$ReportFile = (('{0}\{1}-Report.csv' -f $ReportFolder, $DateNow))
$AdUserSiteList = (('{0}\{1}-DormetUserList.csv' -f $ReportFolder, $DateNow))
$i = 1

function Get-InactiveUsers
{
  param
  (
    [Object]
    [Parameter(Mandatory=$true, HelpMessage='Days since last logon')]
    $DaysBack, $ADSearchBase
    
  )
  begin
  {
  $ReferenceDate = $((Get-Date).AddDays(-$DaysBack))
  }
  process
  {
    
    $Users = Search-ADAccount -AccountInactive -DateTime $ReferenceDate -UsersOnly | Select-Object -Property @{
  Name       = 'Username'
  Expression = {
    $_.SamAccountName
  }
}, Name, LastLogonDate, DistinguishedName
return $users
#Get-AdUser -filter * -SearchBase $ADSearchBase | lastlogondate -lt $ReferenceDate
  }
}



if(!(Test-Path -Path $ReportFolder))
{
  New-Item -Path $ReportFolder -ItemType Directory
}

Search-ADAccount -AccountDisabled -UsersOnly -SearchBase $ADSearchBase | 
Select-Object -Property Name, LastLogonDate, SamAccountName  |
Sort-Object -Property LastLogonDate -Descending |
Export-Csv -Path $AdUserSiteList -NoTypeInformation

$AdUserList = Import-Csv -Path $AdUserSiteList 
$TotalAdUsers = $AdUserList.count

if($TotalAdUsers -gt 0)
{
  foreach($OneAdUser in $AdUserList)
  {
    #$AdUserName = $OneAdUser.Name
    #if ($AdUserName -ne 'Name')
    #{
    Write-Progress -Activity ('Testing {0}' -f $AdUserName) -PercentComplete ($i / $TotalAdUsers*100)
    $i++



     Get-InactiveUsers -DaysBack 30
 
    <#      if($Ping -ne 'True')
        {
        $DiabledCount ++
        $AdUserProperties = Get-ADComputer -Identity $AdUserName -Properties * | Select-Object -Property Name, LastLogonDate, Description
        if($DiabledCount -eq 1)
        {
        $AdUserProperties | Export-Csv -Path $ReportFile -NoClobber -NoTypeInformation
        }
        else
        {
        $AdUserProperties | Export-Csv -Path $ReportFile -NoTypeInformation -Append
        }
    }#>
  }
}
#}


Write-Host -Object ('Total workstations found in AD: {0}' -f $TotalAdUsers) -ForegroundColor Green
Write-Host -Object ('Total workstations not responding: {0}' -f $DiabledCount) -ForegroundColor Red
Write-Host -Object "This test was run by $env:USERNAME from $env:COMPUTERNAME"
Write-Host -Object ('You can find the full report at: {0}' -f $ReportFile)

<#


# Set the number of days since last logon
$DaysInactive = 90
$InactiveDate = (Get-Date).Adddays(-($DaysInactive))
  
#-------------------------------
# FIND INACTIVE USERS
#-------------------------------
# Below are four options to find inactive users. Select the one that is most appropriate for your requirements:

# Get AD Users that haven't logged on in xx days
$Users = Get-ADUser -Filter {
  LastLogonDate -lt $InactiveDate -and Enabled -eq $true 
} -Properties LastLogonDate | Select-Object -Property @{
  Name       = 'Username'
  Expression = {
    $_.SamAccountName
  }
}, Name, LastLogonDate, DistinguishedName

# Get AD Users that haven't logged on in xx days and are not Service Accounts
$Users = Get-ADUser -Filter {
  LastLogonDate -lt $InactiveDate -and Enabled -eq $true -and SamAccountName -notlike '*svc*' 
} -Properties LastLogonDate | Select-Object -Property @{
  Name       = 'Username'
  Expression = {
    $_.SamAccountName
  }
}, Name, LastLogonDate, DistinguishedName

# Get AD Users that have never logged on
$Users = Get-ADUser -Filter {
  LastLogonDate -notlike '*' -and Enabled -eq $true 
} -Properties LastLogonDate | Select-Object -Property @{
  Name       = 'Username'
  Expression = {
    $_.SamAccountName
  }
}, Name, LastLogonDate, DistinguishedName

# Automated way (includes never logged on users)
$Users = Search-ADAccount -AccountInactive -DateTime $InactiveDate -UsersOnly | Select-Object -Property @{
  Name       = 'Username'
  Expression = {
    $_.SamAccountName
  }
}, Name, LastLogonDate, DistinguishedName

#-------------------------------
# REPORTING
#-------------------------------
# Export results to CSV
$Users | Export-Csv -Path C:\Temp\InactiveUsers.csv -NoTypeInformation

#-------------------------------
# INACTIVE USER MANAGEMENT
#-------------------------------
# Below are two options to manage the inactive users that have been found. Either disable them, or delete them. Select the option that is most appropriate for your requirements:

# Disable Inactive Users
ForEach ($Item in $Users)
{
  $DistName = $Item.DistinguishedName
  Disable-ADAccount -Identity $DistName
  Get-ADUser -Filter {
    DistinguishedName -eq $DistName 
  } | Select-Object -Property @{
    Name       = 'Username'
    Expression = {
      $_.SamAccountName
    }
  }, Name, Enabled
}

# Delete Inactive Users
ForEach ($Item in $Users)
{
  Remove-ADUser -Identity $Item.DistinguishedName -Confirm:$false
  Write-Output -InputObject "$($Item.Username) - Deleted"
}

___________________________


# Get all users, computers, and service accounts that are disabled
Search-ADAccount -SearchBase $ADSearchBase -AccountDisabled | Format-Table -Property Name, ObjectClass -AutoSize

# Get all users that are disabled
Search-ADAccount -SearchBase $ADSearchBase -AccountDisabled -UsersOnly | Format-Table -Property Name, ObjectClass -AutoSize

# Get all users, computers, and service accounts that are expired
Search-ADAccount -SearchBase $ADSearchBase -AccountExpired | Format-Table -Property Name, ObjectClass -AutoSize

# Get all users, computers, and service accounts that will expire in a specified time
Search-ADAccount -SearchBase $ADSearchBase -AccountExpiring -TimeSpan 180.00:00:00 | Format-Table -Property Name, ObjectClass -AutoSize

# Get all accounts that have expired
Search-ADAccount -SearchBase $ADSearchBase -PasswordExpired | Format-Table -Property Name, ObjectClass -AutoSize

# Get all accounts that are locked out
Search-ADAccount -SearchBase $ADSearchBase -LockedOut | Format-Table -Property Name, ObjectClass -AutoSize

#>
