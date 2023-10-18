$EmptySeats = $TotalSeats = 25
$buspeople = $BusStop = 0


while($EmptySeats -gt 0)
{
  $BusStop += 1

  if($BusStop -gt 1)
  {
    $getoff = Read-Host -Prompt 'Enter the amount of people getting off'
  }
  $buspeople = $buspeople - $getoff

  $geton = Read-Host -Prompt 'Enter the amount of people getting on'
  $buspeople = $buspeople + $geton
  if($buspeople -gt $TotalSeats)
  {
    Write-Host -Object ('Bus is full {0} need to get off.' -f ($TotalSeats - $buspeople))
  }
  $EmptySeats = $EmptySeats - $buspeople

  if($EmptySeats -lt 1)
  {
    Write-Output -InputObject ('The bus is full, {0} need to stay behind' -f $($EmptySeats-$TotalSeats))
    $EmptySeats = $EmptySeats  -$TotalSeats
  }

  Write-Host -Object ('Empty Seats: {0} after {1} bus stop.' -f $EmptySeats, $BusStop)
}

#requires -Version 1.0
[int]$TotalSeats = 20
[int]$Seats = 0
[int]$BusStop = 0
[int]$Passengers = 0

while($Seats -lt ($TotalSeats-1))
{
  $BusStop += 1

  if($BusStop -gt 1)
  {
    [int]$Passengers = Read-Host -Prompt 'Enter the amount of people getting off'
    $Seats = $Seats - $Passengers
  }
  [int]$Passengers = Read-Host -Prompt 'Enter the amount of people getting on'
  $Seats = $Seats + $Passengers
  if($Seats -gt $TotalSeats)
  {
    Write-Host -Object ('Bus is full {0} need to stay behind.' -f ($Seats - $TotalSeats))
    $Seats = $Seats - $($Seats - $TotalSeats)
  }

  Write-Host -Object ('Empty Seats: {0} after {1} bus stop.' -f $($TotalSeats - $Seats), $BusStop)
}