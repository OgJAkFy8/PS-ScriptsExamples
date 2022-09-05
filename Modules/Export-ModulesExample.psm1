function Set-Name{
    Param(
        [Parameter( Mandatory = $false)]
        $name = "JoBommo"    
    )
    Return $name
}

function Write-Name {

Set-Name (Read-Host "Name")
Write-Host $name
}

Export-ModuleMember Write-Name