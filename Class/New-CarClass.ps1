Class Car {
  [String]$Color
  [datetime]$ModelYear
  static [int]$WheelCount = 4
  [int]$DoorCount

}


$Chevy = [Car]::new()

$Chevy.DoorCount = 2
    
$Chevy.ModelYear= "5/1/2015"

$Chevy.Color = 'Red'

$Ford = New-Object Car

$Ford.Color = 'Blue'
$Ford.DoorCount = 3






