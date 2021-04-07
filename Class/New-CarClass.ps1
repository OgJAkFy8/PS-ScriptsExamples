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



class Animal {
[int] $numOfLegs = 0;
Static[int] $numOfEyes = 2;

  Animal(){} #<- Constructor         
 }


class Dog : Animal { 
        Static[int] $numOfLegs = 4;
        [String]$color = '';
        [String]$fur = ''



  Dog(){} #<- Constructor of dogs
        [int] getLegs(){ return $this.numOfLegs; }
        [int] getEyes(){ return $this.numOfEyes; }
    }

 New-Object Dog

