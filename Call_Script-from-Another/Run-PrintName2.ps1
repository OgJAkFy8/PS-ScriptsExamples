# This calls the "printname" script and passes the name to be printed.  
# This script does not have any write outputs

function Set-Name{
    Param(
        [Parameter( Mandatory = $false)]
        $name = "JoBommo"    
    )
    Return $name
}

& ((Split-Path $MyInvocation.InvocationName) + "\PrintName.ps1") -printName $(Set-Name -name Billy)