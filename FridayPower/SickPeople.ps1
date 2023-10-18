$People = @{
  Larry   = @{
    COVID = $true
    Mask  = $false
  }
  Mike    = @{
    COVID = $false
    Mask  = $true
  }
  Steve   = @{
    COVID = $true
    Mask  = $true
  }
  Stewie  = @{
    COVID = $false
    Mask  = $false
  }
  John    = @{
    COVID = $true
    Mask  = $false
  }
  Stacy   = @{
    COVID = $true
    Mask  = $true
  }
  Karen   = @{
    COVID = $true
    Mask  = $false
  }
  Maranda = @{
    COVID = $false
    Mask  = $false
  }
  Nicky   = @{
    COVID = $true
    Mask  = $true
  }
  Kelly   = @{
    COVID = $false
    Mask  = $true
  }
}

Class Sick {
  [Bool]$COVID
  [Bool]$Mask
  [String]$Name
}

$AllPeople = @()
foreach($key in $People.Keys){
  $SickPeople = [Sick]::new()
  $SickPeople.Name = $key
  $SickPeople.COVID = $People.$key.COVID
  $SickPeople.Mask = $People.$key.Mask
  $AllPeople += $SickPeople
}

$AllPeople



