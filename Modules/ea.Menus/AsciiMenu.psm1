function Show-AsciiMenu
{
  <#
      .SYNOPSIS
      Describe purpose of "Show-CliGraphicMenu" in 1-2 sentences.

      .DESCRIPTION
      Add a more complete description of what the function does.

      .PARAMETER Title
      Describe parameter -Title.

      .PARAMETER MenuItems
      Describe parameter -MenuItems.

      .PARAMETER TitleColor
      Describe parameter -TitleColor.

      .PARAMETER LineColor
      Describe parameter -LineColor.

      .PARAMETER MenuItemColor
      Describe parameter -MenuItemColor.

      .EXAMPLE
      Show-CliGraphicMenu -Title Value -MenuItems Value -TitleColor Value -LineColor Value -MenuItemColor Value
      Describe what this call does

      .NOTES
      Place additional notes here.

      .LINK
      URLs to related sites
      The first link is opened by Get-Help -Online Show-CliGraphicMenu

      .INPUTS
      List of input types that are accepted by this function.

      .OUTPUTS
      List of output types produced by this function.
  #>



  [CmdletBinding()]
  param
  (
    [string]$Title = 'Title',

    [String[]]$MenuItems = 'None',

    [string]$TitleColor = 'Red',

    [string]$LineColor = 'Yellow',

    [string]$MenuItemColor = 'Cyan'
  )


  #Clear-Host
 
  $TitleCount = $Title.Length
  $LongestMenuItem = ($MenuItems | Measure-Object -Maximum -Property Length).Maximum
  
  if  ($TitleCount -lt $LongestMenuItem)
  {
    if($LongestMenuItem % 2 -eq 1){
      $LongestMenuItem = $LongestMenuItem + 1
      }
      $reference = $LongestMenuItem 

  }
  else
    {
    $reference = $TitleCount
  }

  #$reference = $reference + 10
  $TotalLineCount = $reference + 8
  $Line = '═'*$TotalLineCount
  
  $RemaniningCountForTitleLine = $reference - $TitleCount
  #$RemaniningCountForTitleLineForEach = $RemaniningCountForTitleLine / 2
  $RemaniningCountForTitleLineForEach = [math]::Ceiling($RemaniningCountForTitleLine / 2)



  $LineForTitleLine = "`0"*$RemaniningCountForTitleLineForEach
  $Tab = "`t"

  Write-Host '╔' -NoNewline -f $LineColor
  Write-Host $Line -NoNewline -f $LineColor
  Write-Host '╗' -f $LineColor
  if($RemaniningCountForTitleLine % 2 -eq 1)
  {
    $RemaniningCountForTitleLineForEach = $RemaniningCountForTitleLineForEach - 1
    $LineForTitleLine2 = "`0"*$RemaniningCountForTitleLineForEach
    Write-Host '║' -f $LineColor -nonewline
    Write-Host $LineForTitleLine -nonewline -f $LineColor
    Write-Host $Title -f $TitleColor -nonewline
    Write-Host $LineForTitleLine2 -f $LineColor -nonewline
    Write-Host '║' -f $LineColor
  }
  else
  {
    Write-Host '║' -nonewline -f $LineColor
    Write-Host $LineForTitleLine -nonewline -f $LineColor
    Write-Host $Title -f $TitleColor -nonewline
    Write-Host $LineForTitleLine -nonewline -f $LineColor
    Write-Host '║' -f $LineColor
  }
  Write-Host '╠' -NoNewline -f $LineColor
  Write-Host $Line -NoNewline -f $LineColor
  Write-Host '╣' -f $LineColor
  $i = 1
  foreach($menuItem in $MenuItems)
  {
    $number = $i++
    $RemainingCountForItemLine = $TotalLineCount - $menuItem.Length - 5
    $LineForItems = "`0"*$RemainingCountForItemLine
    Write-Host '║' -nonewline -f $LineColor 
    Write-Host $Tab -nonewline
    Write-Host $number"." -nonewline -f $MenuItemColor
    Write-Host $menuItem -nonewline -f $MenuItemColor
    Write-Host $LineForItems -nonewline -f $LineColor
    Write-Host '║' -f $LineColor
  }
  Write-Host '╚' -NoNewline -f $LineColor
  Write-Host $Line -NoNewline -f $LineColor
  Write-Host '╝' -f $LineColor
}


Show-AsciiMenu -Title 'THIS IS TITLE' -MenuItems 'Exchange Server','Active Directory','Sytem Center Configuration Manager','Lync Server','Microsoft Azure' -TitleColor Red -LineColor Cyan -MenuItemColor Yellow
