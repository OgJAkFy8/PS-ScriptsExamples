class Human
{
    [Guid]
    hidden $ID = (New-Guid).Guid

    [ValidatePattern('^[a-z]')]
    [ValidateLength(3,15)]
    [string]
    $Name
    
    [ValidateRange(0,100)]
    [int]
    $Height
    
    [ValidateRange(0,1000)]
    [int]
    $Weight
    
    
    [void]Jump()
    {
        Write-Output -Message "You won't see this message"
        Return
    }

    [string]SayHello()
    {
        Return "Hello, nice to meet you"
        
     }
     
      [string]SayHello([string]$Name)
    {
            
        Return "Hey $Name. Its nice to meet you"
    }
}

$mark = New-Object -TypeName Human 











