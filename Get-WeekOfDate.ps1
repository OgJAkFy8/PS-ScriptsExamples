function Get-WeekOfDate
{
  <#
    .SYNOPSIS
    Get the "week of" date starting on Monday.  

    Great for the "Week Of August-03 Report"

  #>
  [CmdletBinding()]
  param
  (
    [Parameter(Mandatory=$false, Position=0)]
    [System.String]
    $dateFormat = 'MMMM-dd'
  )
  
  $CurrentDay = Get-Date -UFormat %A
  Switch ($CurrentDay){
    Monday 
    {    $CurrentWeek = (Get-Date).AddDays(0).ToString($dateFormat)  }
    Tuesday 
    {    $CurrentWeek = (Get-Date).AddDays(-1).ToString($dateFormat)  }
    Wednesday 
    {    $CurrentWeek  = (Get-Date).AddDays(-2).ToString($dateFormat)  }
    Thursday 
    {    $CurrentWeek = (Get-Date).AddDays(-3).ToString($dateFormat)  }
    Friday 
    {    $CurrentWeek = (Get-Date).AddDays(-4).ToString($dateFormat)  }
    Saturday 
    {    $CurrentWeek = (Get-Date).AddDays(-5).ToString($dateFormat)  }
    Sunday 
    {    $CurrentWeek = (Get-Date).AddDays(-6).ToString($dateFormat)  }
  }
  $CurrentWeek
}

