#requires -Version 5.0

class Animal {
  [int] $numOfLegs = 0
  Static[int] $numOfEyes = 2

  Animal()
  {

  } #<- Constructor         
}

class Mammal : Animal { 
  [int] $numOfLegs = 0
  [String]$fur = $true
  [String]$gestation = ''
  Mammal()
  {

  }  #<- Constructor of Mammals
  [int] getLegs()
  {
    return $this.numOfLegs
  }
}

  
class Dog : Mammal { 
  Static[int] $numOfLegs = 4
  [String]$color = ''


  Dog()
  {

  } #<- Constructor of dogs

  [int] getColor()
  {
    return $this.color
  }
  [int] getEyes()
  {
    return $this.numOfEyes
  }
   
}
    

$fido = New-Object -TypeName Dog
$fido.color = 'brown'
$fido.gestation = 4
$fido.getEyes()
 
